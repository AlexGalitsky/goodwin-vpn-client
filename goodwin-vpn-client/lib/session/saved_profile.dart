import 'dart:convert';

/// User-saved share link with a display name (P-U1).
class SavedProfile {
  const SavedProfile({
    required this.id,
    required this.name,
    required this.link,
    this.subscriptionId,
  });

  final String id;
  final String name;
  final String link;
  final String? subscriptionId;

  SavedProfile copyWith({
    String? name,
    String? link,
    String? subscriptionId,
    bool clearSubscriptionId = false,
  }) {
    return SavedProfile(
      id: id,
      name: name ?? this.name,
      link: link ?? this.link,
      subscriptionId: clearSubscriptionId
          ? null
          : (subscriptionId ?? this.subscriptionId),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'link': link,
        if (subscriptionId != null) 'subscriptionId': subscriptionId,
      };

  static SavedProfile fromJson(Map<String, dynamic> json) {
    return SavedProfile(
      id: (json['id'] as String?)?.trim().isNotEmpty == true
          ? json['id'] as String
          : _newId(),
      name: (json['name'] as String?)?.trim() ?? '',
      link: (json['link'] as String?)?.trim() ?? '',
      subscriptionId: (json['subscriptionId'] as String?)?.trim().isNotEmpty == true
          ? json['subscriptionId'] as String
          : null,
    );
  }

  static SavedProfile fromLink(
    String link, {
    String? name,
    String? subscriptionId,
  }) {
    final trimmed = link.trim();
    return SavedProfile(
      id: _newId(),
      name: (name ?? '').trim(),
      link: trimmed,
      subscriptionId: subscriptionId,
    );
  }

  static String encodeList(List<SavedProfile> profiles) =>
      jsonEncode(profiles.map((p) => p.toJson()).toList());

  static List<SavedProfile> decodeList(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => SavedProfile.fromJson(Map<String, dynamic>.from(e)))
        .where((p) => p.link.isNotEmpty)
        .toList();
  }

  static String _newId() =>
      'p_${DateTime.now().microsecondsSinceEpoch}_${Object().hashCode.abs()}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedProfile &&
          other.id == id &&
          other.name == name &&
          other.link == link &&
          other.subscriptionId == subscriptionId;

  @override
  int get hashCode => Object.hash(id, name, link, subscriptionId);
}
