package website.goodwin.vpnclient

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

/**
 * Pushes GoodwinVpnService lifecycle to Dart (EventChannel).
 * Sink is set from [MainActivity]; emits are posted on the main thread.
 */
object VpnTunnelEvents {
    const val CHANNEL = "website.goodwin.vpn/android/events"

    const val ESTABLISHED = "established"
    const val FAILED = "failed"
    const val REVOKED = "revoked"
    const val STOPPED = "stopped"

    private val main = Handler(Looper.getMainLooper())

    @Volatile
    var sink: EventChannel.EventSink? = null

    fun emit(kind: String, message: String? = null) {
        val payload = hashMapOf<String, Any?>("kind" to kind, "message" to message)
        main.post { sink?.success(payload) }
    }
}
