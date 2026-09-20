import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'at_rest_crypto.dart';

/// 32-byte AES key for [PrefsSessionStore]. Tests inject [MemorySessionKeyStore].
abstract interface class SessionKeyStore {
  Future<Uint8List> loadOrCreate();
}

class MemorySessionKeyStore implements SessionKeyStore {
  MemorySessionKeyStore([Uint8List? key]) : _key = key;

  Uint8List? _key;

  @override
  Future<Uint8List> loadOrCreate() async {
    return _key ??= newAtRestKey();
  }
}

class FlutterSessionKeyStore implements SessionKeyStore {
  FlutterSessionKeyStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _keyName = 'vpn_at_rest_key';

  final FlutterSecureStorage _storage;

  @override
  Future<Uint8List> loadOrCreate() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null && existing.isNotEmpty) {
      return Uint8List.fromList(base64Decode(existing));
    }
    final key = newAtRestKey();
    await _storage.write(key: _keyName, value: base64Encode(key));
    return key;
  }
}
