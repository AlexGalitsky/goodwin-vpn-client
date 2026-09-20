import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import 'saved_profile.dart';
import 'session_store.dart';
import 'subscription.dart';

const kBackupKind = 'goodwin.vpn.backup';
const kBackupVersion = 1;
const kBackupKdf = 'pbkdf2-sha256';
const kBackupIterations = 100000;

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BackupPasswordException extends BackupException {
  const BackupPasswordException(super.message);
}

class ProfileBackup {
  const ProfileBackup({
    required this.profiles,
    required this.subscriptions,
    this.exportedAt,
  });

  final List<SavedProfile> profiles;
  final List<VpnSubscription> subscriptions;
  final DateTime? exportedAt;

  Map<String, dynamic> toPlainJson() => {
        'kind': kBackupKind,
        'version': kBackupVersion,
        'encrypted': false,
        'exportedAt': (exportedAt ?? DateTime.now().toUtc()).toIso8601String(),
        'profiles': [for (final p in profiles) p.toJson()],
        'subscriptions': [for (final s in subscriptions) s.toJson()],
      };

  factory ProfileBackup.fromPlainJson(Map<String, dynamic> json) {
    final profilesRaw = json['profiles'];
    final subsRaw = json['subscriptions'];
    return ProfileBackup(
      exportedAt: DateTime.tryParse('${json['exportedAt'] ?? ''}'),
      profiles: profilesRaw is List
          ? [
              for (final item in profilesRaw)
                if (item is Map)
                  SavedProfile.fromJson(Map<String, dynamic>.from(item)),
            ].where((p) => p.link.isNotEmpty).toList()
          : const [],
      subscriptions: subsRaw is List
          ? [
              for (final item in subsRaw)
                if (item is Map)
                  VpnSubscription.fromJson(Map<String, dynamic>.from(item)),
            ].where((s) => s.url.isNotEmpty).toList()
          : const [],
    );
  }
}

class BackupMergeResult {
  const BackupMergeResult({
    required this.subscriptions,
    required this.profiles,
    required this.addedSubscriptions,
    required this.addedProfiles,
  });

  final List<VpnSubscription> subscriptions;
  final List<SavedProfile> profiles;
  final int addedSubscriptions;
  final int addedProfiles;
}

String encodeBackup(ProfileBackup backup, {String? password}) {
  final secret = password?.trim() ?? '';
  if (secret.isEmpty) {
    return const JsonEncoder.withIndent('  ').convert(backup.toPlainJson());
  }
  return const JsonEncoder.withIndent('  ').convert(
    _encryptEnvelope(utf8.encode(jsonEncode(backup.toPlainJson())), secret),
  );
}

ProfileBackup decodeBackup(String raw, {String? password}) {
  final decoded = jsonDecode(raw.trim());
  if (decoded is! Map) {
    throw const BackupException('Backup is not a JSON object');
  }
  final json = Map<String, dynamic>.from(decoded);
  final encrypted = json['encrypted'] == true;
  if (encrypted) {
    final secret = password?.trim() ?? '';
    if (secret.isEmpty) {
      throw const BackupPasswordException('Password required');
    }
    final inner = _decryptEnvelope(json, secret);
    final innerDecoded = jsonDecode(utf8.decode(inner));
    if (innerDecoded is! Map) {
      throw const BackupException('Decrypted backup is not a JSON object');
    }
    return ProfileBackup.fromPlainJson(Map<String, dynamic>.from(innerDecoded));
  }
  final kind = json['kind'] as String?;
  if (kind != null && kind != kBackupKind) {
    throw BackupException('Unknown backup kind: $kind');
  }
  if (json['profiles'] is! List && json['subscriptions'] is! List) {
    throw const BackupException('No profiles or subscriptions in backup');
  }
  return ProfileBackup.fromPlainJson(json);
}

BackupMergeResult mergeProfileBackup({
  required List<VpnSubscription> currentSubscriptions,
  required List<SavedProfile> currentProfiles,
  required ProfileBackup backup,
  int maxSaved = MemorySessionStore.maxSaved,
}) {
  final subs = [...currentSubscriptions];
  final idMap = <String, String>{};
  var addedSubs = 0;

  for (final incoming in backup.subscriptions) {
    if (incoming.url.isEmpty) continue;
    final byUrl = subs.indexWhere((s) => s.url == incoming.url);
    if (byUrl >= 0) {
      idMap[incoming.id] = subs[byUrl].id;
      subs[byUrl] = _subscriptionFromBackup(subs[byUrl], incoming);
      continue;
    }
    final byId = incoming.id.isEmpty
        ? -1
        : subs.indexWhere((s) => s.id == incoming.id);
    if (byId >= 0) {
      idMap[incoming.id] = subs[byId].id;
      subs[byId] = _subscriptionFromBackup(subs[byId], incoming);
      continue;
    }
    var id = incoming.id;
    if (id.isEmpty || subs.any((s) => s.id == id)) {
      id = VpnSubscription.newId();
    }
    idMap[incoming.id] = id;
    subs.add(
      VpnSubscription(
        id: id,
        name: incoming.name,
        url: incoming.url,
        accountLabel: incoming.accountLabel,
        lastFetched: incoming.lastFetched,
        intervalHours: incoming.intervalHours,
        userinfo: incoming.userinfo,
        revoked: incoming.revoked,
        serviceBase: incoming.serviceBase,
        protocolVersion: incoming.protocolVersion,
        serviceName: incoming.serviceName,
        privacyUrl: incoming.privacyUrl,
        supportUrl: incoming.supportUrl,
        features: incoming.features,
      ),
    );
    addedSubs++;
  }

  final links = {for (final p in currentProfiles) p.link};
  final ids = {for (final p in currentProfiles) p.id};
  final incomingNew = <SavedProfile>[];

  for (final incoming in backup.profiles) {
    if (incoming.link.isEmpty || !links.add(incoming.link)) continue;
    final mappedSub = incoming.subscriptionId == null
        ? null
        : (idMap[incoming.subscriptionId] ?? incoming.subscriptionId);
    final next = ids.add(incoming.id)
        ? SavedProfile(
            id: incoming.id,
            name: incoming.name,
            link: incoming.link,
            subscriptionId: mappedSub,
          )
        : SavedProfile.fromLink(
            incoming.link,
            name: incoming.name,
            subscriptionId: mappedSub,
          );
    incomingNew.add(next);
  }

  final merged = [...incomingNew, ...currentProfiles];
  final capped = merged.length > maxSaved
      ? merged.sublist(0, maxSaved)
      : merged;
  final keptIds = {for (final p in capped) p.id};
  return BackupMergeResult(
    subscriptions: subs,
    profiles: capped,
    addedSubscriptions: addedSubs,
    addedProfiles: incomingNew.where((p) => keptIds.contains(p.id)).length,
  );
}

VpnSubscription _subscriptionFromBackup(
  VpnSubscription local,
  VpnSubscription incoming,
) {
  final name = incoming.name.trim();
  return VpnSubscription(
    id: local.id,
    name: name.isNotEmpty ? name : local.name,
    url: incoming.url,
    accountLabel: incoming.accountLabel ?? local.accountLabel,
    lastFetched: incoming.lastFetched ?? local.lastFetched,
    intervalHours: incoming.intervalHours,
    userinfo: incoming.userinfo ?? local.userinfo,
    revoked: incoming.revoked,
    serviceBase: incoming.serviceBase ?? local.serviceBase,
    protocolVersion: incoming.protocolVersion ?? local.protocolVersion,
    serviceName: incoming.serviceName ?? local.serviceName,
    privacyUrl: incoming.privacyUrl ?? local.privacyUrl,
    supportUrl: incoming.supportUrl ?? local.supportUrl,
    features: incoming.features.isNotEmpty ? incoming.features : local.features,
  );
}

Map<String, dynamic> _encryptEnvelope(List<int> plaintext, String password) {
  final salt = _randomBytes(16);
  final nonce = _randomBytes(12);
  final key = _deriveKey(password, salt, kBackupIterations);
  final cipher = GCMBlockCipher(AESEngine())
    ..init(
      true,
      AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
    );
  final ciphertext = cipher.process(Uint8List.fromList(plaintext));
  return {
    'kind': kBackupKind,
    'version': kBackupVersion,
    'encrypted': true,
    'kdf': kBackupKdf,
    'iterations': kBackupIterations,
    'salt': base64Encode(salt),
    'nonce': base64Encode(nonce),
    'ciphertext': base64Encode(ciphertext),
  };
}

Uint8List _decryptEnvelope(Map<String, dynamic> json, String password) {
  if (json['kdf'] != kBackupKdf) {
    throw BackupException('Unsupported KDF: ${json['kdf']}');
  }
  final iterations = (json['iterations'] as num?)?.toInt() ?? kBackupIterations;
  if (iterations < 10000 || iterations > 2000000) {
    throw const BackupException('Invalid KDF iterations');
  }
  final salt = _b64(json['salt']);
  final nonce = _b64(json['nonce']);
  final ciphertext = _b64(json['ciphertext']);
  final key = _deriveKey(password, salt, iterations);
  try {
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
      );
    return cipher.process(ciphertext);
  } catch (_) {
    throw const BackupPasswordException('Wrong password or damaged backup');
  }
}

Uint8List _deriveKey(String password, Uint8List salt, int iterations) {
  final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
    ..init(Pbkdf2Parameters(salt, iterations, 32));
  return derivator.process(Uint8List.fromList(utf8.encode(password)));
}

Uint8List _b64(Object? raw) {
  if (raw is! String || raw.isEmpty) {
    throw const BackupException('Backup is missing ciphertext fields');
  }
  try {
    return Uint8List.fromList(base64Decode(raw));
  } catch (_) {
    throw const BackupException('Backup ciphertext is not valid base64');
  }
}

Uint8List _randomBytes(int length) {
  final random = Random.secure();
  return Uint8List.fromList([for (var i = 0; i < length; i++) random.nextInt(256)]);
}
