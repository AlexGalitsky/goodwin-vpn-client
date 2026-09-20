import 'dart:io';

/// Locates a c-shared VPN core library (`libxray` / `libhysteria`).
class NativeLibraryLocator {
  const NativeLibraryLocator({
    this.androidNativeLibraryDir,
    this.stem = 'xray',
  });

  /// From `ApplicationInfo.nativeLibraryDir` when running under Flutter Android.
  final String? androidNativeLibraryDir;

  /// Library stem without `lib` prefix / extension: `xray` or `hysteria`.
  final String stem;

  String get envVar => switch (stem) {
        'hysteria' => 'GOODWIN_LIBHYSTERIA',
        _ => 'GOODWIN_LIBXRAY',
      };

  String _libraryFileName() {
    if (Platform.isWindows) return 'lib$stem.dll';
    if (Platform.isMacOS) return 'lib$stem.dylib';
    if (Platform.isAndroid || Platform.isLinux) return 'lib$stem.so';
    if (Platform.isIOS) {
      throw UnsupportedError(
        'iOS does not load SOCKS cores via dart:ffi in the UI process. '
        'Packet Tunnel (P-I2) or official TrustTunnel plugin (P-I4) — '
        'docs/platforms/ios.md',
      );
    }
    throw UnsupportedError('unsupported platform: ${Platform.operatingSystem}');
  }

  List<List<String>> _relativeCandidates(String name) => [
        [name],
        ['..', 'Frameworks', name],
        ['lib', name],
        ['native', name],
        ['linux', 'libs', name],
        ['macos', 'libs', name],
        ['windows', 'libs', name],
        ['libs', name],
        ['refs', 'xray-cshare', 'build', name],
        ['refs', 'xray-cshare', 'build', 'android', 'arm64-v8a', name],
        ['refs', 'xray-cshare', 'build', 'android', 'x86_64', name],
        ['cores', stem, 'build', name],
        ['cores', stem, 'build', 'android', 'arm64-v8a', name],
        ['cores', stem, 'build', 'android', 'x86_64', name],
        ['..', 'cores', stem, 'build', name],
        ['..', '..', 'cores', stem, 'build', name],
        ['..', 'refs', 'xray-cshare', 'build', name],
        ['..', '..', 'refs', 'xray-cshare', 'build', name],
      ];

  String resolve() {
    final fromEnv = Platform.environment[envVar];
    if (fromEnv != null && fromEnv.isNotEmpty && File(fromEnv).existsSync()) {
      return fromEnv;
    }

    final name = _libraryFileName();
    if (Platform.isAndroid) {
      final dir = androidNativeLibraryDir;
      if (dir != null && dir.isNotEmpty) {
        final full = '$dir${Platform.pathSeparator}$name';
        if (File(full).existsSync()) return full;
      }
      return name;
    }

    for (final root in _searchRoots()) {
      for (final segments in _relativeCandidates(name)) {
        final path = ([root.path, ...segments]).join(Platform.pathSeparator);
        if (File(path).existsSync()) return path;
      }
    }

    throw StateError(
      'lib$stem not found ($name). Build cores/$stem or set $envVar. '
      'Windows: copy to app/windows/libs/$name. '
      'Linux: node tools/build_linux_native.mjs → app/linux/libs/$name. '
      'macOS: node tools/build_apple_native.mjs → app/macos/libs/$name. '
      'Android: node tools/build_android_native.mjs',
    );
  }

  Iterable<Directory> _searchRoots() sync* {
    yield Directory.current;
    try {
      yield File(Platform.resolvedExecutable).parent;
    } catch (_) {}

    var dir = Directory.current;
    for (var i = 0; i < 8; i++) {
      yield dir;
      if (File('${dir.path}${Platform.pathSeparator}development-plan.md').existsSync()) {
        break;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
  }
}
