import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

typedef _StartC = Pointer<Void> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef _StartDart = Pointer<Void> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef _StopC = Void Function(Pointer<Utf8>);
typedef _StopDart = void Function(Pointer<Utf8>);
typedef _IsStartedC = Int32 Function(Pointer<Utf8>);
typedef _IsStartedDart = int Function(Pointer<Utf8>);
typedef _FreeC = Void Function(Pointer<Void>);
typedef _FreeDart = void Function(Pointer<Void>);
typedef _VersionC = Pointer<Void> Function();
typedef _VersionDart = Pointer<Void> Function();

class XrayResponse {
  XrayResponse({required this.status, required this.contentType, required this.body});

  final int status;
  final int contentType;
  final String body;

  bool get ok => status == 0;
}

/// FFI wrapper around xray-cshare (`Start` / `Stop` / `IsStarted` / …).
class LibXray {
  LibXray._(
    this._start,
    this._stop,
    this._isStarted,
    this._free,
    this._version,
  );

  final _StartDart _start;
  final _StopDart _stop;
  final _IsStartedDart _isStarted;
  final _FreeDart _free;
  final _VersionDart _version;

  static LibXray open(String path) {
    final lib = DynamicLibrary.open(path);
    return LibXray._(
      lib.lookupFunction<_StartC, _StartDart>('Start'),
      lib.lookupFunction<_StopC, _StopDart>('Stop'),
      lib.lookupFunction<_IsStartedC, _IsStartedDart>('IsStarted'),
      lib.lookupFunction<_FreeC, _FreeDart>('FreePointer'),
      lib.lookupFunction<_VersionC, _VersionDart>('GetXrayCoreVersion'),
    );
  }

  XrayResponse start(String uuid, String jsonConfig) {
    final u = uuid.toNativeUtf8();
    final j = jsonConfig.toNativeUtf8();
    try {
      return _read(_start(u, j));
    } finally {
      calloc.free(u);
      calloc.free(j);
    }
  }

  void stop(String uuid) {
    final u = uuid.toNativeUtf8();
    try {
      _stop(u);
    } finally {
      calloc.free(u);
    }
  }

  bool isStarted(String uuid) {
    final u = uuid.toNativeUtf8();
    try {
      return _isStarted(u) == 1;
    } finally {
      calloc.free(u);
    }
  }

  String version() => _read(_version()).body;

  XrayResponse _read(Pointer<Void> ptr) {
    if (ptr == nullptr) {
      throw StateError('null response from libxray');
    }
    try {
      final header = ptr.cast<Uint8>().asTypedList(8);
      final status = ByteData.sublistView(header).getUint32(0, Endian.little);
      final contentType = ByteData.sublistView(header).getUint16(4, Endian.little);
      final body = (ptr.cast<Uint8>() + 8).cast<Utf8>().toDartString();
      return XrayResponse(status: status, contentType: contentType, body: body);
    } finally {
      _free(ptr);
    }
  }
}
