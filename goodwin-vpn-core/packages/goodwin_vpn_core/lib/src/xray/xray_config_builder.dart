import 'dart:convert';

import '../models/profiles.dart';
import 'xray_support.dart';

/// Optional routing / DNS / core tweaks for [XrayConfigBuilder].
///
/// Defaults preserve historic behavior: all SOCKS traffic → `proxy`.
class XrayBuildOptions {
  const XrayBuildOptions({
    this.defaultOutbound = 'proxy',
    this.extraRules = const [],
    this.dnsServers,
    this.mux = false,
    this.fragment = false,
  });

  /// Catch-all outbound tag after [extraRules]: `proxy` or `direct`.
  final String defaultOutbound;

  /// Extra `routing.rules` (type=field), inserted before the inbound catch-all.
  final List<Map<String, dynamic>> extraRules;

  /// When non-null / non-empty, emits top-level Xray `dns.servers`.
  final List<String>? dnsServers;

  /// Enables mux on the `proxy` outbound.
  ///
  /// Ignored for `xtls-rprx-vision` (invalid with mux).
  final bool mux;

  /// TLS hello fragmentation via freedom `fragment` + `dialerProxy`.
  ///
  /// Ignored when the profile uses REALITY (tlshello fragment breaks handshake).
  final bool fragment;

  /// Mux is incompatible with XTLS Vision.
  bool muxEnabledFor(XrayProfile profile) {
    if (!mux) return false;
    final flow = (profile.flow ?? '').toLowerCase();
    return !flow.startsWith('xtls-rprx-vision');
  }

  /// Fragment is a TLS-hello trick; REALITY is not TLS.
  bool fragmentEnabledFor(XrayProfile profile) {
    if (!fragment) return false;
    return profile.security.toLowerCase() != 'reality';
  }

  String get resolvedDefaultOutbound {
    final tag = defaultOutbound.trim();
    if (tag == 'direct') return 'direct';
    return 'proxy';
  }
}

/// Builds an Xray-core JSON config (client) from [XrayProfile].
class XrayConfigBuilder {
  const XrayConfigBuilder({
    this.socksListen = '127.0.0.1',
    this.socksPort = 10808,
    this.socksUser = '',
    this.socksPass = '',
  });

  final String socksListen;
  final int socksPort;
  final String socksUser;
  final String socksPass;

  String buildJson(
    XrayProfile profile, {
    bool pretty = true,
    XrayBuildOptions options = const XrayBuildOptions(),
  }) {
    final map = buildMap(profile, options: options);
    return pretty ? const JsonEncoder.withIndent('  ').convert(map) : jsonEncode(map);
  }

  Map<String, dynamic> buildMap(
    XrayProfile profile, {
    XrayBuildOptions options = const XrayBuildOptions(),
  }) {
    ensureSupportedXrayProtocol(profile.protocol);
    ensureSupportedXrayNetwork(profile.network);
    final user = socksUser.trim();
    final pass = socksPass.trim();
    if (user.isEmpty || pass.isEmpty) {
      throw FormatException(
        'SOCKS username and password are required (noauth is not allowed)',
      );
    }

    final outbounds = <Map<String, dynamic>>[
      _proxyOutbound(profile, options: options),
      {'tag': 'direct', 'protocol': 'freedom'},
      {'tag': 'block', 'protocol': 'blackhole'},
    ];
    final fragment = options.fragmentEnabledFor(profile);
    if (fragment) {
      outbounds.add(_fragmentOutbound());
    }

    final rules = <Map<String, dynamic>>[
      for (final rule in options.extraRules) Map<String, dynamic>.from(rule),
      {
        'type': 'field',
        'inboundTag': ['socks-in'],
        'outboundTag': options.resolvedDefaultOutbound,
      },
    ];

    return {
      'log': {'loglevel': 'warning'},
      if (options.dnsServers != null && options.dnsServers!.isNotEmpty)
        'dns': {
          'servers': List<String>.from(options.dnsServers!),
        },
      'inbounds': [
        {
          'tag': 'socks-in',
          'listen': socksListen,
          'port': socksPort,
          'protocol': 'socks',
          'settings': {
            'udp': true,
            'auth': 'password',
            'accounts': [
              {'user': user, 'pass': pass},
            ],
          },
          'sniffing': {
            'enabled': true,
            'destOverride': ['http', 'tls', 'quic'],
            'routeOnly': true,
          },
        },
      ],
      'outbounds': outbounds,
      'routing': {
        'domainStrategy': 'AsIs',
        'rules': rules,
      },
    };
  }

  Map<String, dynamic> _proxyOutbound(
    XrayProfile p, {
    required XrayBuildOptions options,
  }) {
    final fragment = options.fragmentEnabledFor(p);
    final stream = _streamSettings(p, fragment: fragment);
    return {
      'tag': 'proxy',
      'protocol': p.protocol.name,
      'settings': _settings(p),
      'streamSettings': stream,
      if (options.muxEnabledFor(p))
        'mux': {
          'enabled': true,
          'concurrency': 8,
        },
    };
  }

  Map<String, dynamic> _fragmentOutbound() {
    return {
      'tag': 'fragment',
      'protocol': 'freedom',
      'settings': {
        'fragment': {
          'packets': 'tlshello',
          'length': '100-200',
          'interval': '10-20',
        },
      },
    };
  }

  Map<String, dynamic> _settings(XrayProfile p) {
    switch (p.protocol) {
      case XrayProtocol.vless:
        return {
          'vnext': [
            {
              'address': p.address,
              'port': p.port,
              'users': [
                {
                  'id': p.id,
                  'encryption': p.encryption,
                  'flow': p.flow ?? '',
                },
              ],
            },
          ],
        };
      case XrayProtocol.vmess:
        return {
          'vnext': [
            {
              'address': p.address,
              'port': p.port,
              'users': [
                {
                  'id': p.id,
                  'alterId': p.alterId,
                  'security': p.vmessSecurity ?? 'auto',
                },
              ],
            },
          ],
        };
      case XrayProtocol.trojan:
        return {
          'servers': [
            {
              'address': p.address,
              'port': p.port,
              'password': p.id,
            },
          ],
        };
      case XrayProtocol.shadowsocks:
        throw FormatException(
          'Shadowsocks outbound build is not supported',
        );
    }
  }

  Map<String, dynamic> _streamSettings(
    XrayProfile p, {
    required bool fragment,
  }) {
    ensureSupportedXrayNetwork(p.network);

    final stream = <String, dynamic>{
      'network': p.network,
      'security': p.security,
    };

    if (p.security == 'reality') {
      stream['realitySettings'] = {
        'serverName': p.sni ?? p.address,
        'fingerprint': p.fingerprint ?? 'chrome',
        'publicKey': p.publicKey ?? '',
        'shortId': p.shortId ?? '',
        'spiderX': p.spiderX ?? '',
      };
    } else if (p.security == 'tls') {
      stream['tlsSettings'] = {
        'serverName': p.sni ?? p.address,
        'fingerprint': p.fingerprint ?? 'chrome',
        if (p.alpn != null)
          'alpn': p.alpn!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      };
    }

    switch (p.network.toLowerCase()) {
      case 'grpc':
        final mode = (p.grpcMode ?? 'gun').toLowerCase();
        stream['grpcSettings'] = {
          'serviceName': p.serviceName ?? '',
          'multiMode': mode == 'multi' || mode == 'multimode' || mode == 'gun-multi',
        };
      case 'ws':
        stream['wsSettings'] = {
          'path': p.wsPath ?? '/',
          'headers': {'Host': p.wsHost ?? p.sni ?? p.address},
        };
      case 'tcp':
        break;
      default:
        throw FormatException(
          'unsupported Xray network "${p.network}" '
          '(supported: ${kSupportedXrayNetworks.join(", ")})',
        );
    }

    if (fragment) {
      stream['sockopt'] = {
        'dialerProxy': 'fragment',
      };
    }

    return stream;
  }
}
