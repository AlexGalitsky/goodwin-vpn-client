import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

class NodeEndpoint {
  const NodeEndpoint(this.host, this.port);

  final String host;
  final int port;
}

NodeEndpoint? endpointForShareLink(String link) {
  try {
    return endpointForProfile(const ShareLinkParser().parse(link.trim()));
  } catch (_) {
    return null;
  }
}

NodeEndpoint? endpointForProfile(VpnProfile profile) {
  return switch (profile) {
    XrayProfile(:final address, :final port) => NodeEndpoint(address, port),
    HysteriaProfile(:final address, :final port) => NodeEndpoint(address, port),
    TrustTunnelProfile(:final endpoint, :final hostname) =>
      parseHostPort(endpoint) ??
          (hostname == null ? null : parseHostPort(hostname)),
  };
}

/// `host:port`, `[ipv6]:port`, or a bare host (port defaults to 443).
NodeEndpoint? parseHostPort(String raw, {int defaultPort = 443}) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  if (t.startsWith('[')) {
    final close = t.indexOf(']');
    if (close <= 1) return null;
    final host = t.substring(1, close);
    var port = defaultPort;
    if (close + 1 < t.length && t[close + 1] == ':') {
      final parsed = int.tryParse(t.substring(close + 2));
      if (parsed == null || parsed <= 0) return null;
      port = parsed;
    }
    return NodeEndpoint(host, port);
  }
  final firstColon = t.indexOf(':');
  final lastColon = t.lastIndexOf(':');
  if (firstColon > 0 && firstColon == lastColon) {
    final host = t.substring(0, lastColon);
    final parsed = int.tryParse(t.substring(lastColon + 1));
    if (host.isEmpty || parsed == null || parsed <= 0) return null;
    return NodeEndpoint(host, parsed);
  }
  return NodeEndpoint(t, defaultPort);
}
