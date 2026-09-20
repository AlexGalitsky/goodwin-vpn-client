# hev-socks5-tunnel JNI_OnLoad does FindClass("website/goodwin/vpnclient/HevTunnelBridge")
# Keep the Java bridge + VPN service entry points for R8.
-keep class website.goodwin.vpnclient.HevTunnelBridge {
    *;
}
-keepclassmembers class website.goodwin.vpnclient.HevTunnelBridge {
    public static *;
    public static native *;
}

-keep class website.goodwin.vpnclient.GoodwinVpnService { *; }
-keep class website.goodwin.vpnclient.MainActivity { *; }
