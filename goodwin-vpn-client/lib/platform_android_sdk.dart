import 'dart:io';

import 'package:flutter/services.dart';

/// Cached `Build.VERSION.SDK_INT`. Null on non-Android or if the channel fails.
int? cachedAndroidSdkInt;

Future<void> loadAndroidSdkInt({
  MethodChannel channel = const MethodChannel('website.goodwin.vpn/android'),
}) async {
  if (!Platform.isAndroid) {
    cachedAndroidSdkInt = null;
    return;
  }
  try {
    cachedAndroidSdkInt = await channel.invokeMethod<int>('sdkInt');
  } catch (_) {
    cachedAndroidSdkInt = null;
  }
}
