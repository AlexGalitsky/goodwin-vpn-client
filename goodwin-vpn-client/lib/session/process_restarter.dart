import 'package:flutter/services.dart';

/// Relaunch the app process (clears loaded Go c-shared runtimes).
abstract interface class ProcessRestarter {
  Future<void> restart();
}

class AndroidProcessRestarter implements ProcessRestarter {
  AndroidProcessRestarter();

  static const _channel = MethodChannel('website.goodwin.vpn/android');

  @override
  Future<void> restart() async {
    await _channel.invokeMethod<void>('restartProcess');
  }
}

class WindowsProcessRestarter implements ProcessRestarter {
  WindowsProcessRestarter();

  static const _channel = MethodChannel('website.goodwin.vpn/windows');

  @override
  Future<void> restart() async {
    await _channel.invokeMethod<void>('restartProcess');
  }
}

class MacOSProcessRestarter implements ProcessRestarter {
  MacOSProcessRestarter();

  static const _channel = MethodChannel('website.goodwin.vpn/macos');

  @override
  Future<void> restart() async {
    await _channel.invokeMethod<void>('restartProcess');
  }
}

/// Desktop / tests: do not kill the process; surface a clear error instead.
class MessageProcessRestarter implements ProcessRestarter {
  @override
  Future<void> restart() async {
    throw StateError(
      'Switching between Xray and Hysteria needs an app restart '
      '(two Go c-shared libraries cannot share one process).',
    );
  }
}
