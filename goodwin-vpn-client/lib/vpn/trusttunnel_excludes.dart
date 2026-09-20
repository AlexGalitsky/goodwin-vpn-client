/// TrustTunnel TUN / exclusion helpers for Always-exclude (Home) lists.
library;

/// Official default [listener.tun] excluded_routes (private / reserved).
///
/// Passing `Tun(excludedRoutes: [])` would wipe these and break LAN bypass.
const kTrustTunnelDefaultExcludedRoutes = <String>[
  '0.0.0.0/8',
  '10.0.0.0/8',
  '169.254.0.0/16',
  '172.16.0.0/12',
  '192.168.0.0/16',
  '224.0.0.0/3',
];

final _ipv4 = RegExp(
  r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(?:/(\d{1,2}))?$',
);
final _ipv6ish = RegExp(r'^[0-9a-fA-F:]+(?:/\d{1,3})?$');

/// True if [raw] looks like IPv4/IPv6 or CIDR (not a domain).
bool isIpOrCidrExclude(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return false;
  if (_ipv4.hasMatch(t)) return true;
  if (t.contains(':') && _ipv6ish.hasMatch(t.split('%').first)) return true;
  return false;
}

/// Normalize bare IPv4 → `/32`, bare IPv6 → `/128`; leave CIDR / domains as-is.
String normalizeExcludeSpec(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return t;
  if (t.contains('/')) return t;
  if (_ipv4.hasMatch(t)) return '$t/32';
  if (t.contains(':') && _ipv6ish.hasMatch(t)) return '$t/128';
  return t;
}

/// Split Always-exclude into TUN CIDRs vs app-level [exclusions] (domains).
({List<String> tunCidrs, List<String> domainExclusions}) splitTrustTunnelExcludes(
  List<String> raw,
) {
  final tun = <String>{...kTrustTunnelDefaultExcludedRoutes};
  final domains = <String>[];
  for (final item in raw) {
    final t = item.trim();
    if (t.isEmpty) continue;
    if (isIpOrCidrExclude(t)) {
      tun.add(normalizeExcludeSpec(t));
    } else {
      domains.add(t);
    }
  }
  final tunList = tun.toList()..sort();
  return (tunCidrs: tunList, domainExclusions: domains);
}
