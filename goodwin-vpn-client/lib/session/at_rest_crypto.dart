import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// AES-256-GCM envelope for on-device secrets. Key lives in the platform store.
bool looksLikeAtRestEnvelope(String raw) {
  final trimmed = raw.trim();
  if (!trimmed.startsWith('{')) return false;
  try {
    final decoded = jsonDecode(trimmed);
    return decoded is Map &&
        decoded['v'] == 1 &&
        decoded['n'] is String &&
        decoded['c'] is String;
  } catch (_) {
    return false;
  }
}

String sealAtRest(Uint8List key, String plaintext) {
  if (key.length != 32) {
    throw ArgumentError('AES-256 key must be 32 bytes');
  }
  final nonce = _randomBytes(12);
  final cipher = GCMBlockCipher(AESEngine())
    ..init(
      true,
      AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
    );
  final ciphertext = cipher.process(Uint8List.fromList(utf8.encode(plaintext)));
  return jsonEncode({
    'v': 1,
    'n': base64Encode(nonce),
    'c': base64Encode(ciphertext),
  });
}

String openAtRest(Uint8List key, String envelope) {
  if (!looksLikeAtRestEnvelope(envelope)) {
    return envelope;
  }
  final decoded = jsonDecode(envelope) as Map;
  final nonce = base64Decode(decoded['n'] as String);
  final ciphertext = base64Decode(decoded['c'] as String);
  final cipher = GCMBlockCipher(AESEngine())
    ..init(
      false,
      AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
    );
  return utf8.decode(cipher.process(Uint8List.fromList(ciphertext)));
}

Uint8List newAtRestKey() => _randomBytes(32);

Uint8List _randomBytes(int length) {
  final random = Random.secure();
  return Uint8List.fromList([for (var i = 0; i < length; i++) random.nextInt(256)]);
}
