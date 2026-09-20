import 'dart:convert';

import 'package:equatable/equatable.dart';

/// How traffic is steered at connect (applied to Xray in Phase 6.3+).
enum RoutingMode {
  global,
  rules,
  direct;

  static RoutingMode parse(String? raw) {
    return switch (raw) {
      'rules' => RoutingMode.rules,
      'direct' => RoutingMode.direct,
      _ => RoutingMode.global,
    };
  }

  String get storageValue => name;
}

/// Split-tunnel / routing preferences (UI + engine until core wiring).
enum RoutingPresetId {
  blockAds,
  bypassRegion,
  protectBanking;

  static RoutingPresetId? tryParse(String? raw) {
    for (final id in values) {
      if (id.name == raw) return id;
    }
    return null;
  }
}

enum RoutingAction {
  proxy,
  direct,
  block;

  static RoutingAction parse(String? raw) {
    return switch (raw) {
      'direct' => RoutingAction.direct,
      'block' => RoutingAction.block,
      _ => RoutingAction.proxy,
    };
  }
}

class RoutingRule extends Equatable {
  const RoutingRule({
    required this.id,
    required this.matcher,
    required this.action,
  });

  final String id;

  /// Domain suffix, IP, or CIDR as free text for the Advanced scaffold.
  final String matcher;
  final RoutingAction action;

  RoutingRule copyWith({
    String? id,
    String? matcher,
    RoutingAction? action,
  }) {
    return RoutingRule(
      id: id ?? this.id,
      matcher: matcher ?? this.matcher,
      action: action ?? this.action,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'matcher': matcher,
        'action': action.name,
      };

  factory RoutingRule.fromJson(Map<String, dynamic> json) {
    return RoutingRule(
      id: json['id']?.toString() ?? '',
      matcher: json['matcher']?.toString() ?? '',
      action: RoutingAction.parse(json['action']?.toString()),
    );
  }

  @override
  List<Object?> get props => [id, matcher, action];
}

class RoutingSnapshot extends Equatable {
  const RoutingSnapshot({
    this.mode = RoutingMode.global,
    this.enabledPresets = const {},
    this.customRules = const [],
  });

  final RoutingMode mode;
  final Set<RoutingPresetId> enabledPresets;
  final List<RoutingRule> customRules;

  bool isPresetEnabled(RoutingPresetId id) => enabledPresets.contains(id);

  RoutingSnapshot copyWith({
    RoutingMode? mode,
    Set<RoutingPresetId>? enabledPresets,
    List<RoutingRule>? customRules,
  }) {
    return RoutingSnapshot(
      mode: mode ?? this.mode,
      enabledPresets: enabledPresets ?? this.enabledPresets,
      customRules: customRules ?? this.customRules,
    );
  }

  Map<String, dynamic> toJson() => {
        'mode': mode.storageValue,
        'presets': enabledPresets.map((e) => e.name).toList(),
        'rules': customRules.map((e) => e.toJson()).toList(),
      };

  factory RoutingSnapshot.fromJson(Map<String, dynamic> json) {
    final presetsRaw = json['presets'];
    final presets = <RoutingPresetId>{};
    if (presetsRaw is List) {
      for (final item in presetsRaw) {
        final id = RoutingPresetId.tryParse(item?.toString());
        if (id != null) presets.add(id);
      }
    }

    final rulesRaw = json['rules'];
    final rules = <RoutingRule>[];
    if (rulesRaw is List) {
      for (final item in rulesRaw) {
        if (item is Map<String, dynamic>) {
          final rule = RoutingRule.fromJson(item);
          if (rule.id.isNotEmpty && rule.matcher.isNotEmpty) {
            rules.add(rule);
          }
        } else if (item is Map) {
          final rule = RoutingRule.fromJson(Map<String, dynamic>.from(item));
          if (rule.id.isNotEmpty && rule.matcher.isNotEmpty) {
            rules.add(rule);
          }
        }
      }
    }

    return RoutingSnapshot(
      mode: RoutingMode.parse(json['mode']?.toString()),
      enabledPresets: presets,
      customRules: rules,
    );
  }

  String encode() => jsonEncode(toJson());

  static RoutingSnapshot decode(String? raw) {
    if (raw == null || raw.isEmpty) return const RoutingSnapshot();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return RoutingSnapshot.fromJson(decoded);
      }
      if (decoded is Map) {
        return RoutingSnapshot.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return const RoutingSnapshot();
  }

  @override
  List<Object?> get props => [mode, enabledPresets, customRules];
}
