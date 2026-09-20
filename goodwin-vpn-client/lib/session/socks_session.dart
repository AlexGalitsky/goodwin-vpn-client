import 'dart:convert';
import 'dart:io';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../vpn/system_tunnel.dart';
import '../vpn/vpn_slot.dart';
import 'socks_core_resolver.dart';
import 'socks_inbound.dart';
import 'tunnel_elevation.dart';
import 'vpn_session.dart';

/// SOCKS core (Xray / Hysteria) + optional system TUN.
class SocksSession implements VpnSession {
  SocksSession({
    required this.bundle,
    required this.slot,
    required this.tunnel,
    required this.instanceId,
    required this.socks,
    required this.log,
    this.excludeRoutes = const [],
    this.dnsServers = const [],
    this.disallowedPackages = const [],
    this.killSwitch = false,
  });

  final SocksEngineBundle bundle;
  final VpnSlot slot;
  final SystemTunnel tunnel;
  final String instanceId;
  final SocksInbound socks;
  final void Function(String line) log;

  int get socksPort => socks.port;
  final List<String> excludeRoutes;
  final List<String> dnsServers;
  final List<String> disallowedPackages;
  final bool killSwitch;

  VpnCore get core => bundle.core;

  @override
  String? get engineVersion => core.engineVersion;

  @override
  String get connectedMessage => tunnel.isSupported
      ? 'VPN TUN · ${bundle.profileName}'
      : 'SOCKS 127.0.0.1:$socksPort · ${bundle.profileName}';

  @override
  Future<void> start() async {
    if (tunnel.isSupported) {
      log('request system VPN permission');
      final granted = await tunnel.prepare();
      if (!granted) {
        throw tunnel.needsElevationOnPrepare
            ? const TunnelElevationRequired()
            : StateError('VPN permission denied');
      }
    }

    // Pin VPS before TUN so Xray/Hy2 don't need DNS through the tunnel,
    // and so NE excludedRoutes can match the dialed address (v4 + v6).
    var configJson = bundle.configJson;
    String? bypassHost = bundle.serverHost;
    var extraExcludes = List<String>.from(excludeRoutes);
    if (tunnel.isSupported) {
      final pins = await resolveTunnelPins(bundle.serverHost);
      if (pins.isEmpty) {
        throw StateError(
          'could not resolve ${bundle.serverHost} — refusing Connected with a blackhole TUN',
        );
      }
      final pin = selectDialPin(pins);
      if (pin == null) {
        throw StateError(
          'could not resolve ${bundle.serverHost} — refusing Connected with a blackhole TUN',
        );
      }
      if (isIpv6Only(pins) && !tunnel.supportsIpv6RouteExclude) {
        throw StateError(
          'IPv6-only ${bundle.serverHost} cannot exclude the VPS from ::/0 on this OS — refusing Connected with a blackhole TUN',
        );
      }
      bypassHost = pin;
      configJson = _pinProxyHost(configJson, bundle.serverHost, pin);
      for (final ip in pins) {
        if (ip == pin) continue;
        final cidr = pinCidr(ip);
        if (!extraExcludes.contains(ip) && !extraExcludes.contains(cidr)) {
          extraExcludes.add(cidr);
        }
      }
      log('anti-loop pin ${bundle.serverHost} → $pin (${pins.join(', ')})');
    }

    // iOS: core runs inside SocksTunnel.appex (one Go runtime with tun2socks).
    final extensionHosted = Platform.isIOS && tunnel.isSupported;
    if (!extensionHosted) {
      core.start(instanceId: instanceId, configJson: configJson);
    }
    try {
      if (tunnel.isSupported) {
        log('start TUN → SOCKS $socksPort');
        await tunnel.start(
          socksPort: socks.port,
          socksUsername: socks.username,
          socksPassword: socks.password,
          bypassHost: bypassHost,
          excludeRoutes: extraExcludes,
          dnsServers: dnsServers,
          disallowedPackages: disallowedPackages,
          engineId: extensionHosted ? core.id : null,
          configJson: extensionHosted ? configJson : null,
          killSwitch: killSwitch,
        );
        if (!extensionHosted) {
          // NE route swap breaks the pre-TUN VLESS/gRPC socket. Reconnect now that
          // VPS /32 is excluded from the tunnel.
          log('reconnect SOCKS core after TUN routes');
          try {
            core.stop(instanceId);
          } catch (_) {}
          await Future<void>.delayed(const Duration(milliseconds: 150));
          core.start(instanceId: instanceId, configJson: configJson);
        } else {
          core.adopt(instanceId);
          log('extension-hosted core ready after TUN');
        }
        slot.mark(VpnSlotOwner.socksTun);
        log('connected — system VPN via SOCKS $socksPort');
      } else {
        slot.mark(VpnSlotOwner.none);
        log('connected — SOCKS5 127.0.0.1:$socksPort (desktop, no TUN)');
      }
    } catch (_) {
      try {
        if (tunnel.isSupported) {
          await tunnel.stop();
        }
      } catch (_) {}
      stopEngine();
      rethrow;
    }
  }

  /// Flutter restarted; TUN + native SOCKS are already up.
  void attachExisting() {
    core.adopt(instanceId);
    slot.mark(VpnSlotOwner.socksTun);
    log('reattached SOCKS engine ${core.id}');
  }

  @override
  Future<void> stop() async {
    // Tear down TUN first. Stopping the core first blacks out the tunnel if
    // iOS on-demand save fails and Disconnect must keep the session.
    await slot.release();
    stopEngine();
  }

  @override
  void stopEngine() {
    try {
      core.stop(instanceId);
    } catch (_) {}
  }

  static final _ipv4 = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');

  static bool isIpv4Literal(String host) => _ipv4.hasMatch(host.trim());

  static bool isIpv6Literal(String host) {
    final parsed = InternetAddress.tryParse(host.trim());
    return parsed?.type == InternetAddressType.IPv6;
  }

  /// Dial the VPS on IPv4 when both families exist so older Android can
  /// exclude a /32. IPv6-only hosts keep the AAAA pin.
  static String? selectDialPin(List<String> pins) {
    for (final pin in pins) {
      if (isIpv4Literal(pin)) return pin;
    }
    return pins.isEmpty ? null : pins.first;
  }

  static bool isIpv6Only(List<String> pins) =>
      pins.isNotEmpty && !pins.any(isIpv4Literal);

  static String pinCidr(String ip) =>
      isIpv6Literal(ip) ? '${ip.trim()}/128' : '${ip.trim()}/32';

  /// Host literals plus DNS A/AAAA. Empty means "do not establish TUN".
  static Future<List<String>> resolveTunnelPins(String host) async {
    final trimmed = host.trim();
    if (trimmed.isEmpty) return const [];
    if (_ipv4.hasMatch(trimmed)) return [trimmed];
    final parsed = InternetAddress.tryParse(trimmed);
    if (parsed != null) return [parsed.address];
    final out = <String>[];
    out.addAll(await _lookup(trimmed, InternetAddressType.IPv4));
    out.addAll(await _lookup(trimmed, InternetAddressType.IPv6));
    return out;
  }

  static Future<List<String>> _lookup(
    String host,
    InternetAddressType type,
  ) async {
    try {
      final addrs = await InternetAddress.lookup(host, type: type);
      return [
        for (final a in addrs)
          if (a.type == type) a.address,
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Replace proxy server host with a literal IPv4 inside Xray/Hy2 JSON.
  static String _pinProxyHost(String configJson, String host, String ip) {
    if (host == ip) return configJson;
    final root = jsonDecode(configJson);
    _pinNode(root, host, ip);
    return const JsonEncoder.withIndent('  ').convert(root);
  }

  static void _pinNode(dynamic node, String host, String ip) {
    if (node is Map) {
      final address = node['address'];
      if (address is String && address == host) {
        node['address'] = ip;
      }
      final server = node['server'];
      if (server is String) {
        if (server == host) {
          node['server'] = ip;
        } else if (server.startsWith('$host:')) {
          node['server'] = '$ip${server.substring(host.length)}';
        }
      }
      for (final value in node.values) {
        _pinNode(value, host, ip);
      }
    } else if (node is List) {
      for (final value in node) {
        _pinNode(value, host, ip);
      }
    }
  }
}
