package website.goodwin.vpnclient;

import androidx.annotation.Keep;

/**
 * Pure Java JNI surface for hev-socks5-tunnel.
 * Must stay in sync with ndk-build flags:
 * -DPKGNAME=website/goodwin/vpnclient -DCLSNAME=HevTunnelBridge
 *
 * {@link Keep} + proguard-rules.pro: R8 must not rename this class (release JNI_OnLoad).
 */
@Keep
public final class HevTunnelBridge {
    private static boolean loaded = false;

    private HevTunnelBridge() {}

    public static synchronized void ensureLoaded() {
        if (loaded) {
            return;
        }
        System.loadLibrary("hev-socks5-tunnel");
        loaded = true;
    }

    public static native boolean TProxyStartService(String configPath, int fd);

    public static native boolean TProxyStopService();

    public static native boolean TProxyIsRunning();

    public static native long[] TProxyGetStats();
}
