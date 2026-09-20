import 'dns_mode.dart';

/// Defaults when Settings DNS mode is [DnsMode.system] or empty custom.
const kDefaultTunDnsServers = <String>['1.1.1.1', '8.8.8.8'];

/// IPv4/IPv6 literals suitable for OS TUN (`addDnsServer` / `NEDNSSettings` / netsh).
/// DoH URLs are **not** included — those belong in Xray `dns` only.
List<String> tunDnsServersFromSettings({
  required DnsMode mode,
  String? custom,
}) {
  switch (mode) {
    case DnsMode.system:
      return List<String>.from(kDefaultTunDnsServers);
    case DnsMode.custom:
      final ips = _ipOnlyServers(custom);
      return ips.isEmpty ? List<String>.from(kDefaultTunDnsServers) : ips;
    case DnsMode.doh:
      // TUN still needs bootstrap IPs; DoH is applied in Xray JSON.
      final ips = _ipOnlyServers(custom);
      return ips.isEmpty ? List<String>.from(kDefaultTunDnsServers) : ips;
  }
}

List<String> _ipOnlyServers(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];
  final out = <String>[];
  for (final part in raw.split(RegExp(r'[\s,;]+'))) {
    final t = part.trim();
    if (t.isEmpty) continue;
    if (t.startsWith('https://') || t.startsWith('http://')) continue;
    if (_looksLikeIp(t)) out.add(t);
  }
  return out;
}

bool _looksLikeIp(String value) {
  if (value.contains('/')) return false;
  final v4 = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
  if (v4.hasMatch(value)) {
    return value.split('.').every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }
  return value.contains(':');
}
