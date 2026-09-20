import 'package:equatable/equatable.dart';

import 'routing_models.dart';

/// Output of [RoutingPolicyCompiler] — ready for Xray builder / TUN excludes.
class CompiledRoutingPolicy extends Equatable {
  const CompiledRoutingPolicy({
    required this.mode,
    required this.defaultOutbound,
    this.xrayRules = const [],
    this.excludeRoutesExtra = const [],
    this.capabilityNotes = const [],
  });

  final RoutingMode mode;

  /// Xray outbound tag for unmatched / catch-all: `proxy` or `direct`.
  final String defaultOutbound;

  /// Extra `routing.rules` entries (type=field), before the inbound catch-all.
  final List<Map<String, dynamic>> xrayRules;

  /// IP/CIDR from direct rules — union into OS excludes (D6).
  final List<String> excludeRoutesExtra;

  final List<String> capabilityNotes;

  @override
  List<Object?> get props => [
        mode,
        defaultOutbound,
        xrayRules,
        excludeRoutesExtra,
        capabilityNotes,
      ];
}
