import 'package:flutter/services.dart';

import '../domain/split_apps.dart';

/// Android helpers for per-app split and system Kill Switch settings.
class AndroidSplitClient {
  AndroidSplitClient({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('website.goodwin.vpn/android');

  final MethodChannel _channel;

  Future<List<InstalledApp>> listLaunchableApps() async {
    final raw = await _channel.invokeMethod<List<dynamic>>('listLaunchableApps');
    if (raw == null) return const [];
    final apps = <InstalledApp>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final packageName = item['packageName']?.toString().trim() ?? '';
      if (packageName.isEmpty) continue;
      apps.add(
        InstalledApp(
          packageName: packageName,
          label: item['label']?.toString().trim().isNotEmpty == true
              ? item['label'].toString().trim()
              : packageName,
        ),
      );
    }
    return apps;
  }

  Future<void> openVpnSettings() async {
    await _channel.invokeMethod<void>('openVpnSettings');
  }
}
