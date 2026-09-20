import 'dart:io';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../vpn/system_tunnel.dart';
import 'extension_hosted_vpn_core.dart';
import 'go_core_switch.dart';
import 'socks_inbound.dart';

class SocksEngineBundle {
  const SocksEngineBundle({
    required this.core,
    required this.configJson,
    required this.profileName,
    required this.serverHost,
  });

  final VpnCore core;
  final String configJson;
  final String profileName;

  /// Remote server hostname/IP (anti-loop route on Windows).
  final String serverHost;
}

/// Loads [XrayVpnCore] / [HysteriaVpnCore] and builds SOCKS JSON.
abstract interface class SocksCoreResolver {
  /// Which Go SOCKS `.so` is already mapped into this process, if any.
  String? get loadedGoCoreId;

  Future<SocksEngineBundle> resolve(
    VpnProfile profile, {
    required SystemTunnel tunnel,
    required SocksInbound socks,
    required void Function(String line) log,
    XrayBuildOptions xrayOptions = const XrayBuildOptions(),
  });
}

class NativeSocksCoreResolver implements SocksCoreResolver {
  XrayVpnCore? _xray;
  HysteriaVpnCore? _hysteria;
  String? _xrayPath;
  String? _hysteriaPath;
  String? _loadedGoCoreId;

  @override
  String? get loadedGoCoreId => _loadedGoCoreId;

  @override
  Future<SocksEngineBundle> resolve(
    VpnProfile profile, {
    required SystemTunnel tunnel,
    required SocksInbound socks,
    required void Function(String line) log,
    XrayBuildOptions xrayOptions = const XrayBuildOptions(),
  }) async {
    // iOS: cores live in SocksTunnel.appex — build JSON only, no dart:ffi.
    if (Platform.isIOS) {
      return _iosBundle(
        profile,
        socks: socks,
        log: log,
        xrayOptions: xrayOptions,
      );
    }
    return switch (profile) {
      XrayProfile() => _xrayBundle(
          profile,
          tunnel: tunnel,
          socks: socks,
          log: log,
          xrayOptions: xrayOptions,
        ),
      HysteriaProfile() =>
        _hysteriaBundle(profile, tunnel: tunnel, socks: socks, log: log),
      TrustTunnelProfile() =>
        throw StateError('TrustTunnel is not a SOCKS engine'),
    };
  }

  Future<SocksEngineBundle> _iosBundle(
    VpnProfile profile, {
    required SocksInbound socks,
    required void Function(String line) log,
    required XrayBuildOptions xrayOptions,
  }) async {
    return switch (profile) {
      XrayProfile() => () {
          // NE process recycles on each startTunnel — no UI Go-core conflict.
          _loadedGoCoreId = 'xray';
          log('iOS extension-hosted xray ${profile.address}:${profile.port}');
          return SocksEngineBundle(
            core: ExtensionHostedVpnCore('xray'),
            configJson: XrayConfigBuilder(
              socksPort: socks.port,
              socksUser: socks.username,
              socksPass: socks.password,
            ).buildJson(
              profile,
              options: xrayOptions,
            ),
            profileName: profile.name,
            serverHost: profile.address,
          );
        }(),
      HysteriaProfile() => () {
          _loadedGoCoreId = 'hysteria2';
          log(
            'iOS extension-hosted hysteria2 ${profile.address}:${profile.port}',
          );
          return SocksEngineBundle(
            core: ExtensionHostedVpnCore('hysteria2'),
            configJson: HysteriaConfigBuilder(
              socksPort: socks.port,
              socksUser: socks.username,
              socksPass: socks.password,
            ).buildJson(profile),
            profileName: profile.name,
            serverHost: profile.address,
          );
        }(),
      TrustTunnelProfile() =>
        throw StateError('TrustTunnel is not a SOCKS engine'),
    };
  }

  void _ensureGoCore(String id) {
    final loaded = _loadedGoCoreId;
    if (loaded != null && loaded != id) {
      throw GoCoreSwitchRequired(from: loaded, to: id);
    }
  }

  Future<SocksEngineBundle> _xrayBundle(
    XrayProfile profile, {
    required SystemTunnel tunnel,
    required SocksInbound socks,
    required void Function(String line) log,
    required XrayBuildOptions xrayOptions,
  }) async {
    _ensureGoCore('xray');
    final dir = tunnel.isSupported ? await tunnel.nativeLibraryDir() : null;
    if (dir != null) {
      log('nativeLibraryDir=$dir');
    }
    _xrayPath ??= NativeLibraryLocator(androidNativeLibraryDir: dir).resolve();
    if (_xray == null) {
      log('opening $_xrayPath');
      _xray = XrayVpnCore(LibXray.open(_xrayPath!));
      _loadedGoCoreId = 'xray';
    }
    final version = _xray!.engineVersion;
    log('libxray ready${version == null ? '' : ' (core $version)'}');
    log('start ${profile.protocol.name} ${profile.address}:${profile.port}');
    if (xrayOptions.extraRules.isNotEmpty ||
        xrayOptions.resolvedDefaultOutbound != 'proxy') {
      log(
        'xray routing default=${xrayOptions.resolvedDefaultOutbound} '
        'extraRules=${xrayOptions.extraRules.length}',
      );
    }
    return SocksEngineBundle(
      core: _xray!,
      configJson: XrayConfigBuilder(
        socksPort: socks.port,
        socksUser: socks.username,
        socksPass: socks.password,
      ).buildJson(
        profile,
        options: xrayOptions,
      ),
      profileName: profile.name,
      serverHost: profile.address,
    );
  }

  Future<SocksEngineBundle> _hysteriaBundle(
    HysteriaProfile profile, {
    required SystemTunnel tunnel,
    required SocksInbound socks,
    required void Function(String line) log,
  }) async {
    _ensureGoCore('hysteria2');
    final dir = tunnel.isSupported ? await tunnel.nativeLibraryDir() : null;
    _hysteriaPath ??= NativeLibraryLocator(
      androidNativeLibraryDir: dir,
      stem: 'hysteria',
    ).resolve();
    if (_hysteria == null) {
      log('opening $_hysteriaPath');
      _hysteria = HysteriaVpnCore(LibHysteria.open(_hysteriaPath!));
      _loadedGoCoreId = 'hysteria2';
    }
    final version = _hysteria!.engineVersion;
    log('libhysteria ready${version == null ? '' : ' ($version)'}');
    log('start hysteria2 ${profile.address}:${profile.port}');
    return SocksEngineBundle(
      core: _hysteria!,
      configJson: HysteriaConfigBuilder(
        socksPort: socks.port,
        socksUser: socks.username,
        socksPass: socks.password,
      ).buildJson(profile),
      profileName: profile.name,
      serverHost: profile.address,
    );
  }
}
