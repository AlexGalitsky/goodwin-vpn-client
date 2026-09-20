package website.goodwin.vpnclient

import android.net.IpPrefix
import android.os.Build
import android.util.Log
import java.net.InetAddress

/**
 * Parses CIDR / host strings for [android.net.VpnService.Builder.excludeRoute] (API 33+).
 */
internal object VpnExcludeRoutes {
    private const val TAG = "VpnExcludeRoutes"

    fun parseAll(raw: List<String>): List<IpPrefix> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            if (raw.isNotEmpty()) {
                Log.w(
                    TAG,
                    "excludeRoute requires API 33+; skipping ${raw.size} prefix(es) on API ${Build.VERSION.SDK_INT}",
                )
            }
            return emptyList()
        }
        val out = ArrayList<IpPrefix>(raw.size)
        for (item in raw) {
            val prefix = parse(item) ?: continue
            out.add(prefix)
        }
        return out
    }

    fun parse(raw: String): IpPrefix? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return null
        val trimmed = raw.trim()
        if (trimmed.isEmpty()) return null
        return try {
            val slash = trimmed.indexOf('/')
            val hostPart = if (slash >= 0) trimmed.substring(0, slash) else trimmed
            val host = InetAddress.getByName(hostPart.trim())
            val maxBits = if (host.address.size == 16) 128 else 32
            val prefixLength = if (slash >= 0) {
                trimmed.substring(slash + 1).trim().toInt()
            } else {
                maxBits
            }
            if (prefixLength < 0 || prefixLength > maxBits) {
                Log.w(TAG, "invalid prefix length in '$trimmed'")
                return null
            }
            IpPrefix(host, prefixLength)
        } catch (t: Throwable) {
            Log.w(TAG, "skip unparsable exclude '$trimmed'", t)
            null
        }
    }
}
