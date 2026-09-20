import 'routing_matcher.dart';
import 'models/routing_models.dart';

/// Operator geo pack (`GET /gw/v1/geo/packs/{id}`). Not geosite.dat.
class GeoPack {
  const GeoPack({
    required this.id,
    this.domains = const [],
    this.suffixes = const [],
    this.cidrs = const [],
  });

  final String id;
  final List<String> domains;
  final List<String> suffixes;
  final List<String> cidrs;

  int get matcherCount => domains.length + suffixes.length + cidrs.length;

  /// Xray: [RoutingAction.block]. TrustTunnel: [RoutingAction.direct] (exclude).
  List<({ParsedRoutingMatcher matcher, RoutingAction action})> expand(
    RoutingAction action,
  ) {
    final out = <({ParsedRoutingMatcher matcher, RoutingAction action})>[];
    void add(String raw) {
      final parsed = parseRoutingMatcher(raw);
      if (parsed == null) return;
      out.add((matcher: parsed, action: action));
    }

    for (final host in domains) {
      add(host);
    }
    for (final suffix in suffixes) {
      add(suffix.startsWith('.') ? suffix : '.$suffix');
    }
    for (final cidr in cidrs) {
      add(cidr);
    }
    return out;
  }
}
