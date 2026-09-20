package website.goodwin.vpnclient

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.content.Context
import android.content.pm.ServiceInfo
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.File

/**
 * System VPN: TUN → hev-socks5-tunnel → local SOCKS (127.0.0.1:10808).
 * JNI lives in [HevTunnelBridge] (Java) — Kotlin companion natives break RegisterNatives on some devices.
 *
 * Does **not** use [START_STICKY]: swipe-from-recents / FGS kill must not half-rebuild the tunnel.
 * Always-on is a different path: Android restarts us with a **null** intent. Last CONNECT
 * extras are persisted so the TUN can come back (blackhole until Flutter starts SOCKS).
 */
class GoodwinVpnService : VpnService() {
    companion object {
        private const val TAG = "GoodwinVpnService"
        const val ACTION_CONNECT = "website.goodwin.vpnclient.CONNECT"
        const val ACTION_DISCONNECT = "website.goodwin.vpnclient.DISCONNECT"
        const val EXTRA_SOCKS_HOST = "socks_host"
        const val EXTRA_SOCKS_PORT = "socks_port"
        const val EXTRA_SOCKS_USER = "socks_user"
        const val EXTRA_SOCKS_PASS = "socks_pass"
        const val EXTRA_BYPASS_HOST = "bypass_host"
        const val EXTRA_EXCLUDE_ROUTES = "exclude_routes"
        const val EXTRA_DNS_SERVERS = "dns_servers"
        const val EXTRA_DISALLOWED_PACKAGES = "disallowed_packages"
        const val CHANNEL_ID = "goodwin_vpn"
        const val NOTIFICATION_ID = 1

        /** ULA address inside the TUN (IPv6). */
        private const val TUN_IPV6 = "fd00:10:10::2"

        private const val SESSION_PREFS = "goodwin_vpn_session"
        private const val SESSION_ACTIVE = "active"
        private const val SESSION_SOCKS_HOST = "socks_host"
        private const val SESSION_SOCKS_PORT = "socks_port"
        private const val SESSION_SOCKS_USER = "socks_user"
        private const val SESSION_SOCKS_PASS = "socks_pass"
        private const val SESSION_BYPASS_HOST = "bypass_host"
        private const val SESSION_EXCLUDE_ROUTES = "exclude_routes"
        private const val SESSION_DNS_SERVERS = "dns_servers"
        private const val SESSION_DISALLOWED = "disallowed_packages"

        @Volatile
        var established: Boolean = false
            private set

        fun markEstablished() {
            established = true
        }

        fun markDown() {
            established = false
        }

        @JvmStatic
        fun ensureNativeLoaded() {
            HevTunnelBridge.ensureLoaded()
        }
    }

    private var tunFd: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return try {
            when (intent?.action) {
                ACTION_DISCONNECT -> {
                    clearPersistedSession()
                    stopTunnel()
                    START_NOT_STICKY
                }
                ACTION_CONNECT -> {
                    val host = intent.getStringExtra(EXTRA_SOCKS_HOST) ?: "127.0.0.1"
                    val port = intent.getIntExtra(EXTRA_SOCKS_PORT, 10808)
                    val socksUser = intent.getStringExtra(EXTRA_SOCKS_USER).orEmpty()
                    val socksPass = intent.getStringExtra(EXTRA_SOCKS_PASS).orEmpty()
                    val bypassHost = intent.getStringExtra(EXTRA_BYPASS_HOST)
                    val excludes = intent.getStringArrayListExtra(EXTRA_EXCLUDE_ROUTES)
                        ?: arrayListOf()
                    val dnsServers = intent.getStringArrayListExtra(EXTRA_DNS_SERVERS)
                        ?: arrayListOf()
                    val disallowed = intent.getStringArrayListExtra(EXTRA_DISALLOWED_PACKAGES)
                        ?: arrayListOf()
                    startTunnel(
                        host,
                        port,
                        socksUser,
                        socksPass,
                        bypassHost,
                        excludes,
                        dnsServers,
                        disallowed,
                    )
                    START_NOT_STICKY
                }
                else -> {
                    // Always-on boot / OS restart: restore last TUN instead of tearing it down.
                    if (restorePersistedSession()) {
                        START_NOT_STICKY
                    } else {
                        Log.w(TAG, "ignoring start without CONNECT (action=${intent?.action})")
                        if (tunFd != null || established) {
                            stopTunnel(reason = "service restarted without CONNECT")
                        } else {
                            stopSelf()
                        }
                        START_NOT_STICKY
                    }
                }
            }
        } catch (t: Throwable) {
            Log.e(TAG, "onStartCommand failed", t)
            if (intent?.action == ACTION_CONNECT) {
                clearPersistedSession()
            }
            VpnTunnelEvents.emit(VpnTunnelEvents.FAILED, t.message)
            stopTunnel()
            START_NOT_STICKY
        }
    }

    override fun onRevoke() {
        clearPersistedSession()
        VpnTunnelEvents.emit(VpnTunnelEvents.REVOKED, "VpnService.onRevoke")
        stopTunnel(emitStopped = false)
        super.onRevoke()
    }

    override fun onDestroy() {
        // Process/FGS death: ensure flag + Dart know the tunnel is gone.
        if (tunFd != null || established) {
            stopTunnel(reason = "VpnService.onDestroy")
        }
        super.onDestroy()
    }

    private fun startTunnel(
        socksHost: String,
        socksPort: Int,
        socksUser: String,
        socksPass: String,
        bypassHost: String?,
        excludeRoutes: List<String>,
        dnsServers: List<String>,
        disallowedPackages: List<String>,
        lockOnly: Boolean = false,
    ) {
        if (tunFd != null) {
            markEstablished()
            VpnTunnelEvents.emit(VpnTunnelEvents.ESTABLISHED, "already running")
            return
        }

        HevTunnelBridge.ensureLoaded()
        ensureNotificationChannel()
        val notification = buildNotification("VPN connecting…")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }

        val dns = dnsServers.map { it.trim() }.filter { it.isNotEmpty() }.ifEmpty {
            listOf("1.1.1.1", "8.8.8.8")
        }

        val builder = Builder()
            .setSession("GoodWin VPN")
            .setMtu(1400)
            .setBlocking(false)
            .addAddress("10.10.0.2", 32)
            .addRoute("0.0.0.0", 0)

        for (server in dns) {
            try {
                builder.addDnsServer(server)
            } catch (e: Exception) {
                Log.w(TAG, "addDnsServer failed for $server", e)
            }
        }

        try {
            builder
                .addAddress(TUN_IPV6, 128)
                .addRoute("::", 0)
            if (dnsServers.isEmpty()) {
                builder
                    .addDnsServer("2606:4700:4700::1111")
                    .addDnsServer("2001:4860:4860::8888")
            }
        } catch (e: Exception) {
            Log.e(TAG, "IPv6 TUN setup failed", e)
            abortEstablish("IPv6 TUN setup failed: ${e.message}")
            return
        }

        applyExcludeRoutes(builder, bypassHost, excludeRoutes)

        try {
            builder.addDisallowedApplication(packageName)
        } catch (e: Exception) {
            Log.e(TAG, "self-disallow failed — aborting establish", e)
            abortEstablish("addDisallowedApplication(self) failed: ${e.message}")
            return
        }
        for (pkg in disallowedPackages.map { it.trim() }.filter { it.isNotEmpty() }.distinct()) {
            if (pkg == packageName) continue
            try {
                builder.addDisallowedApplication(pkg)
            } catch (e: Exception) {
                Log.w(TAG, "addDisallowedApplication failed for $pkg", e)
            }
        }

        val establishedFd = builder.establish()
        if (establishedFd == null) {
            Log.e(TAG, "VpnService.Builder.establish() returned null")
            abortEstablish("VpnService.Builder.establish() returned null")
            return
        }
        tunFd = establishedFd

        val user = socksUser.trim()
        val pass = socksPass.trim()
        if (user.isEmpty() || pass.isEmpty()) {
            Log.e(TAG, "SOCKS username/password required")
            abortEstablish("SOCKS username/password required", closeFd = establishedFd)
            return
        }
        val conf = File(cacheDir, "hev-tproxy.yml")
        conf.writeText(
            """
            |misc:
            |  task-stack-size: 81920
            |tunnel:
            |  mtu: 1400
            |  ipv4: true
            |  ipv6: true
            |socks5:
            |  port: $socksPort
            |  address: '$socksHost'
            |  udp: 'udp'
            |  username: ${yamlSingleQuoted(user)}
            |  password: ${yamlSingleQuoted(pass)}
            """.trimMargin(),
        )
        Log.i(TAG, "hev config ${conf.absolutePath}, fd=${establishedFd.fd}")

        val ok = HevTunnelBridge.TProxyStartService(conf.absolutePath, establishedFd.fd)
        if (!ok) {
            Log.e(TAG, "TProxyStartService returned false")
            VpnTunnelEvents.emit(VpnTunnelEvents.FAILED, "TProxyStartService returned false")
            clearPersistedSession()
            stopTunnel()
            return
        }
        persistSession(
            socksHost,
            socksPort,
            socksUser,
            socksPass,
            bypassHost,
            excludeRoutes,
            dnsServers,
            disallowedPackages,
        )
        startForeground(
            NOTIFICATION_ID,
            buildNotification(
                if (lockOnly) {
                    "VPN lock on — open the app to restore the proxy"
                } else {
                    "VPN connected"
                },
            ),
        )
        Log.i(TAG, "tunnel started (IPv4+IPv6)")
        markEstablished()
        VpnTunnelEvents.emit(VpnTunnelEvents.ESTABLISHED)
    }

    private fun abortEstablish(message: String, closeFd: ParcelFileDescriptor? = null) {
        clearPersistedSession()
        VpnTunnelEvents.emit(VpnTunnelEvents.FAILED, message)
        if (closeFd != null) {
            try {
                closeFd.close()
            } catch (_: Exception) {
            }
            if (tunFd === closeFd) tunFd = null
        }
        try {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } catch (_: Exception) {
        }
        markDown()
        stopSelf()
        VpnTunnelEvents.emit(VpnTunnelEvents.STOPPED)
    }

    private fun applyExcludeRoutes(
        builder: Builder,
        bypassHost: String?,
        excludeRoutes: List<String>,
    ) {
        val merged = LinkedHashSet<String>()
        for (route in excludeRoutes) {
            val t = route.trim()
            if (t.isNotEmpty()) merged.add(t)
        }
        val bypass = bypassHost?.trim().orEmpty()
        if (bypass.isNotEmpty()) {
            merged.add(bypass)
        }
        if (merged.isEmpty()) return

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            Log.w(
                TAG,
                "OS exclude routes need Android 13+ (API 33); " +
                    "accepted but not applied: ${merged.joinToString()}",
            )
            return
        }

        var applied = 0
        for (prefix in VpnExcludeRoutes.parseAll(merged.toList())) {
            try {
                builder.excludeRoute(prefix)
                applied++
            } catch (t: Throwable) {
                Log.w(TAG, "excludeRoute failed for $prefix", t)
            }
        }
        Log.i(TAG, "applied $applied OS exclude route(s) (API 33+)")
    }

    /**
     * @param emitStopped false when [onRevoke] already emitted REVOKED
     * @param reason optional message on unexpected teardown (destroy / sticky null)
     */
    private fun stopTunnel(emitStopped: Boolean = true, reason: String? = null) {
        val wasUp = tunFd != null || established
        try {
            if (HevTunnelBridge.TProxyIsRunning()) {
                HevTunnelBridge.TProxyStopService()
            }
        } catch (t: Throwable) {
            Log.w(TAG, "TProxyStopService", t)
        }
        try {
            tunFd?.close()
        } catch (_: Exception) {
        }
        tunFd = null
        markDown()
        try {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } catch (_: Exception) {
        }
        // Always ack DISCONNECT waiters (Dart may still be listening). Skip only for revoke.
        if (emitStopped) {
            VpnTunnelEvents.emit(
                VpnTunnelEvents.STOPPED,
                reason ?: if (wasUp) null else "already stopped",
            )
        }
        stopSelf()
    }

    private fun ensureNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val mgr = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(
            CHANNEL_ID,
            "VPN",
            NotificationManager.IMPORTANCE_LOW,
        )
        mgr.createNotificationChannel(channel)
    }

    private fun buildNotification(text: String): Notification {
        val launch = packageManager.getLaunchIntentForPackage(packageName)
        val pi = PendingIntent.getActivity(
            this,
            0,
            launch,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("GoodWin VPN")
            .setContentText(text)
            .setSmallIcon(R.drawable.ic_stat_vpn)
            .setContentIntent(pi)
            .setOngoing(true)
            .build()
    }

    private fun sessionPrefs() =
        getSharedPreferences(SESSION_PREFS, Context.MODE_PRIVATE)

    private fun persistSession(
        host: String,
        port: Int,
        socksUser: String,
        socksPass: String,
        bypassHost: String?,
        excludes: List<String>,
        dnsServers: List<String>,
        disallowed: List<String>,
    ) {
        sessionPrefs().edit()
            .putBoolean(SESSION_ACTIVE, true)
            .putString(SESSION_SOCKS_HOST, host)
            .putInt(SESSION_SOCKS_PORT, port)
            .putString(SESSION_SOCKS_USER, socksUser)
            .putString(SESSION_SOCKS_PASS, socksPass)
            .putString(SESSION_BYPASS_HOST, bypassHost)
            .putStringSet(SESSION_EXCLUDE_ROUTES, excludes.toSet())
            .putStringSet(SESSION_DNS_SERVERS, dnsServers.toSet())
            .putStringSet(SESSION_DISALLOWED, disallowed.toSet())
            .commit()
    }

    private fun clearPersistedSession() {
        sessionPrefs().edit().clear().commit()
    }

    /** Always-on / null-intent restart: bring TUN back with last CONNECT extras. */
    private fun restorePersistedSession(): Boolean {
        val prefs = sessionPrefs()
        if (!prefs.getBoolean(SESSION_ACTIVE, false)) return false
        val host = prefs.getString(SESSION_SOCKS_HOST, "127.0.0.1") ?: "127.0.0.1"
        val port = prefs.getInt(SESSION_SOCKS_PORT, 10808)
        val socksUser = prefs.getString(SESSION_SOCKS_USER, "") ?: ""
        val socksPass = prefs.getString(SESSION_SOCKS_PASS, "") ?: ""
        val bypass = prefs.getString(SESSION_BYPASS_HOST, null)
        val excludes = ArrayList(prefs.getStringSet(SESSION_EXCLUDE_ROUTES, emptySet()) ?: emptySet())
        val dns = ArrayList(prefs.getStringSet(SESSION_DNS_SERVERS, emptySet()) ?: emptySet())
        val disallowed = ArrayList(prefs.getStringSet(SESSION_DISALLOWED, emptySet()) ?: emptySet())
        Log.i(TAG, "Always-on restore TUN → $host:$port")
        startTunnel(host, port, socksUser, socksPass, bypass, excludes, dns, disallowed, lockOnly = true)
        return true
    }

    private fun yamlSingleQuoted(value: String): String {
        return "'" + value.replace("'", "''").replace("\n", "").replace("\r", "") + "'"
    }
}
