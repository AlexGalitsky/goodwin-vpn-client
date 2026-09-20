import 'package:freezed_annotation/freezed_annotation.dart';

import '../protocol_type.dart';

part 'profiles.freezed.dart';

/// Secrets (UUID, passwords, `tt://`) must never appear in [toString] / logs.
@Freezed(toStringOverride: false)
sealed class VpnProfile with _$VpnProfile {
  const VpnProfile._();

  const factory VpnProfile.xray({
    required String name,
    required XrayProtocol protocol,
    required String address,
    required int port,
    required String id,
    @Default('none') String encryption,
    String? flow,
    @Default('tcp') String network,
    @Default('none') String security,
    String? sni,
    String? fingerprint,
    String? publicKey,
    String? shortId,
    String? spiderX,
    String? serviceName,
    /// gRPC: gun | multi
    String? grpcMode,
    String? wsPath,
    String? wsHost,
    String? alpn,
    /// Trojan password uses [id]; VMess alterId if needed.
    @Default(0) int alterId,
    String? vmessSecurity,
  }) = XrayProfile;

  const factory VpnProfile.hysteria({
    required String name,
    required String address,
    required int port,
    required String password,
    String? sni,
    @Default(false) bool insecure,
    String? obfs,
    String? obfsPassword,
  }) = HysteriaProfile;

  const factory VpnProfile.trusttunnel({
    required String name,
    required String endpoint,
    String? hostname,
    @Default([]) List<String> addresses,
    String? username,
    String? password,
    String? customSni,
    @Default(true) bool hasIpv6,
    @Default(false) bool skipVerification,
    String? upstreamProtocol,
    @Default(false) bool antiDpi,
    @Default([]) List<String> dnsUpstreams,
    @Default(0) int deepLinkVersion,
    String? rawDeepLink,
  }) = TrustTunnelProfile;

  ProtocolType get protocolType => switch (this) {
        XrayProfile(:final protocol) => switch (protocol) {
            XrayProtocol.vless => ProtocolType.vless,
            XrayProtocol.vmess => ProtocolType.vmess,
            XrayProtocol.trojan => ProtocolType.trojan,
            XrayProtocol.shadowsocks => ProtocolType.shadowsocks,
          },
        HysteriaProfile() => ProtocolType.hysteria2,
        TrustTunnelProfile() => ProtocolType.trusttunnel,
      };

  @override
  String toString() => switch (this) {
        XrayProfile(:final name, :final protocol, :final address, :final port) =>
          'VpnProfile.xray(name: $name, protocol: $protocol, endpoint: $address:$port)',
        HysteriaProfile(:final name, :final address, :final port) =>
          'VpnProfile.hysteria(name: $name, endpoint: $address:$port)',
        TrustTunnelProfile(:final name, :final endpoint) =>
          'VpnProfile.trusttunnel(name: $name, endpoint: $endpoint)',
      };
}

enum XrayProtocol { vless, vmess, trojan, shadowsocks }
