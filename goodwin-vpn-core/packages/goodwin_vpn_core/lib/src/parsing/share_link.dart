import 'dart:convert';

import '../models/profiles.dart';
import '../protocol_type.dart';
import 'hysteria_parser.dart';
import 'trojan_parser.dart';
import 'trusttunnel_parser.dart';
import 'vless_parser.dart';
import 'vmess_parser.dart';

class ShareLinkParseException implements Exception {
  ShareLinkParseException(this.message);
  final String message;

  @override
  String toString() => 'ShareLinkParseException: $message';
}

/// Parses share links into [VpnProfile] values.
class ShareLinkParser {
  const ShareLinkParser();

  VpnProfile parse(String raw) {
    final uri = raw.trim();
    if (uri.isEmpty) {
      throw ShareLinkParseException('empty link');
    }

    final scheme = uri.contains('://') ? uri.split('://').first.toLowerCase() : '';
    return switch (scheme) {
      'vless' => parseVless(uri),
      'vmess' => parseVmess(uri),
      'trojan' => parseTrojan(uri),
      'hysteria2' || 'hy2' => parseHysteria2(uri),
      'tt' => parseTrustTunnel(uri),
      'ss' => throw ShareLinkParseException(
          'Shadowsocks (ss://) is not supported yet',
        ),
      _ => throw ShareLinkParseException('unsupported scheme: $scheme'),
    };
  }

  ProtocolType? detectType(String raw) {
    final uri = raw.trim();
    if (!uri.contains('://')) return null;
    final scheme = uri.split('://').first.toLowerCase();
    return switch (scheme) {
      'vless' => ProtocolType.vless,
      'vmess' => ProtocolType.vmess,
      'trojan' => ProtocolType.trojan,
      'ss' => ProtocolType.shadowsocks,
      'hysteria2' || 'hy2' => ProtocolType.hysteria2,
      'tt' => ProtocolType.trusttunnel,
      _ => null,
    };
  }

  /// Pretty-print profile for logs: type, name, host:port — never UUID/password.
  String describe(VpnProfile profile) => jsonEncode({
        'type': profile.protocolType.name,
        'name': switch (profile) {
          XrayProfile(:final name) => name,
          HysteriaProfile(:final name) => name,
          TrustTunnelProfile(:final name) => name,
        },
        'endpoint': switch (profile) {
          XrayProfile(:final address, :final port) => '$address:$port',
          HysteriaProfile(:final address, :final port) => '$address:$port',
          TrustTunnelProfile(:final endpoint) => endpoint,
        },
      });
}
