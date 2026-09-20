#ifndef RUNNER_VPN_TUNNEL_PLUGIN_H_
#define RUNNER_VPN_TUNNEL_PLUGIN_H_

namespace flutter {
class FlutterEngine;
}

void RegisterVpnTunnelPlugin(flutter::FlutterEngine* engine);

/// Tear down Wintun/tun2socks synchronously before the process exits.
/// Safe to call with or without an active tunnel.
void ShutdownVpnTunnel();

#endif  // RUNNER_VPN_TUNNEL_PLUGIN_H_
