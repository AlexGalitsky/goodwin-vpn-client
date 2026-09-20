import '../models/profiles.dart';

/// Xray stream networks this client actually builds ([XrayConfigBuilder]).
const kSupportedXrayNetworks = <String>{'tcp', 'ws', 'grpc'};

bool isSupportedXrayNetwork(String network) =>
    kSupportedXrayNetworks.contains(network.trim().toLowerCase());

/// Throws [FormatException] when [network] is not tcp/ws/grpc.
void ensureSupportedXrayNetwork(String network) {
  final n = network.trim().toLowerCase();
  if (!kSupportedXrayNetworks.contains(n)) {
    throw FormatException(
      'unsupported Xray network "$network" '
      '(supported: ${kSupportedXrayNetworks.join(", ")})',
    );
  }
}

/// Throws when [protocol] cannot be built from a share link in this package.
void ensureSupportedXrayProtocol(XrayProtocol protocol) {
  if (protocol == XrayProtocol.shadowsocks) {
    throw FormatException(
      'Shadowsocks (ss://) is not supported — no parser/builder path',
    );
  }
}
