package website.goodwin.vpnclient

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.VpnService
import android.os.Build
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "website.goodwin.vpn/android"
    private var pendingPrepareResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "prepare" -> prepareVpn(result)
                    "startVpn" -> {
                        try {
                            val host = call.argument<String>("socksHost") ?: "127.0.0.1"
                            val port = call.argument<Int>("socksPort") ?: 10808
                            val socksUser = call.argument<String>("socksUsername").orEmpty()
                            val socksPass = call.argument<String>("socksPassword").orEmpty()
                            val bypassHost = call.argument<String>("bypassHost")
                            val excludeRoutes = call.argument<List<String>>("excludeRoutes")
                                ?: emptyList()
                            val dnsServers = call.argument<List<String>>("dnsServers")
                                ?: emptyList()
                            val disallowedPackages = call.argument<List<String>>("disallowedPackages")
                                ?: emptyList()
                            HevTunnelBridge.ensureLoaded()
                            startVpnService(
                                host,
                                port,
                                socksUser,
                                socksPass,
                                bypassHost,
                                excludeRoutes,
                                dnsServers,
                                disallowedPackages,
                            )
                            result.success(true)
                        } catch (t: Throwable) {
                            val msg = t.message.orEmpty()
                            val hint = if (msg.contains("JNI_OnLoad failed on a previous attempt") ||
                                msg.contains("UnsatisfiedLinkError")
                            ) {
                                "hev JNI load failed. Uninstall the app completely, then install this build " +
                                    "(HevTunnelBridge Java JNI). Do not hot-restart after a native crash."
                            } else {
                                t.message
                            }
                            result.error("startVpn", hint, t.toString())
                        }
                    }
                    "stopVpn" -> {
                        stopVpnService()
                        result.success(true)
                    }
                    "nativeLibraryDir" -> {
                        result.success(applicationInfo.nativeLibraryDir)
                    }
                    "isEstablished" -> {
                        result.success(GoodwinVpnService.established)
                    }
                    "sdkInt" -> {
                        result.success(Build.VERSION.SDK_INT)
                    }
                    "listLaunchableApps" -> {
                        result.success(listLaunchableApps())
                    }
                    "openVpnSettings" -> {
                        openVpnSettings()
                        result.success(true)
                    }
                    "restartProcess" -> {
                        restartProcess()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, VpnTunnelEvents.CHANNEL)
            .setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                        VpnTunnelEvents.sink = events
                    }

                    override fun onCancel(arguments: Any?) {
                        VpnTunnelEvents.sink = null
                    }
                },
            )
    }

    private fun prepareVpn(result: MethodChannel.Result) {
        val intent = VpnService.prepare(this)
        if (intent == null) {
            result.success(true)
            return
        }
        pendingPrepareResult = result
        @Suppress("DEPRECATION")
        startActivityForResult(intent, REQ_PREPARE)
    }

    private fun startVpnService(
        host: String,
        port: Int,
        socksUser: String,
        socksPass: String,
        bypassHost: String?,
        excludeRoutes: List<String>,
        dnsServers: List<String>,
        disallowedPackages: List<String>,
    ) {
        requestNotificationsIfNeeded()
        val intent = Intent(this, GoodwinVpnService::class.java).apply {
            action = GoodwinVpnService.ACTION_CONNECT
            putExtra(GoodwinVpnService.EXTRA_SOCKS_HOST, host)
            putExtra(GoodwinVpnService.EXTRA_SOCKS_PORT, port)
            putExtra(GoodwinVpnService.EXTRA_SOCKS_USER, socksUser)
            putExtra(GoodwinVpnService.EXTRA_SOCKS_PASS, socksPass)
            if (!bypassHost.isNullOrBlank()) {
                putExtra(GoodwinVpnService.EXTRA_BYPASS_HOST, bypassHost.trim())
            }
            if (excludeRoutes.isNotEmpty()) {
                putStringArrayListExtra(
                    GoodwinVpnService.EXTRA_EXCLUDE_ROUTES,
                    ArrayList(excludeRoutes.map { it.trim() }.filter { it.isNotEmpty() }),
                )
            }
            if (dnsServers.isNotEmpty()) {
                putStringArrayListExtra(
                    GoodwinVpnService.EXTRA_DNS_SERVERS,
                    ArrayList(dnsServers.map { it.trim() }.filter { it.isNotEmpty() }),
                )
            }
            if (disallowedPackages.isNotEmpty()) {
                putStringArrayListExtra(
                    GoodwinVpnService.EXTRA_DISALLOWED_PACKAGES,
                    ArrayList(disallowedPackages.map { it.trim() }.filter { it.isNotEmpty() }),
                )
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopVpnService() {
        val intent = Intent(this, GoodwinVpnService::class.java).apply {
            action = GoodwinVpnService.ACTION_DISCONNECT
        }
        startService(intent)
    }

    private fun listLaunchableApps(): List<Map<String, String>> {
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val flags = PackageManager.MATCH_DEFAULT_ONLY
        val resolved = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.queryIntentActivities(
                launcher,
                PackageManager.ResolveInfoFlags.of(flags.toLong()),
            )
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentActivities(launcher, flags)
        }
        val seen = HashSet<String>()
        val apps = ArrayList<Map<String, String>>()
        for (info in resolved) {
            val pkg = info.activityInfo?.applicationInfo?.packageName ?: continue
            if (pkg == packageName || !seen.add(pkg)) continue
            val label = try {
                packageManager.getApplicationLabel(info.activityInfo.applicationInfo).toString()
            } catch (_: Exception) {
                pkg
            }
            apps.add(mapOf("packageName" to pkg, "label" to label))
        }
        apps.sortBy { it["label"]?.lowercase() }
        return apps
    }

    private fun openVpnSettings() {
        startActivity(Intent(Settings.ACTION_VPN_SETTINGS))
    }

    /// Clear Go c-shared runtimes (libxray vs libhysteria) by relaunching the process.
    private fun restartProcess() {
        val launch = packageManager.getLaunchIntentForPackage(packageName) ?: return
        val restart = Intent.makeRestartActivityTask(launch.component)
        startActivity(restart)
        Runtime.getRuntime().exit(0)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQ_PREPARE) {
            pendingPrepareResult?.success(resultCode == Activity.RESULT_OK)
            pendingPrepareResult = null
        }
    }

    private fun requestNotificationsIfNeeded() {
        if (Build.VERSION.SDK_INT < 33) return
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            REQ_NOTIFY,
        )
    }

    companion object {
        private const val REQ_PREPARE = 1001
        private const val REQ_NOTIFY = 1002
    }
}
