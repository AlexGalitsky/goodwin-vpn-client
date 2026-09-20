import '../session/subscription.dart';
import 'app_localizations.dart';

String quotaDisplayLine(AppLocalizations l10n, SubscriptionUserinfo info) {
  final bits = <String>[];
  if (info.hasQuota) {
    bits.add(
      l10n.quotaUsedOfTotal(
        SubscriptionUserinfo.fmtBytes(info.used),
        SubscriptionUserinfo.fmtBytes(info.total),
      ),
    );
  } else if (info.used > 0) {
    bits.add(l10n.quotaUsedOnly(SubscriptionUserinfo.fmtBytes(info.used)));
  }
  if (info.expire != null) {
    final days = info.expire!.toUtc().difference(DateTime.now().toUtc()).inDays;
    if (days < 0) {
      bits.add(l10n.quotaExpired);
    } else {
      bits.add(l10n.quotaDaysLeft(days));
    }
  }
  final devices = deviceDisplayLine(l10n, info);
  if (devices != null) bits.add(devices);
  return bits.join(' · ');
}

/// Device limit / count from the panel — null when neither field is present.
String? deviceDisplayLine(AppLocalizations l10n, SubscriptionUserinfo info) {
  final limit = info.deviceLimit;
  final count = info.deviceCount;
  if (limit != null && limit > 0 && count != null && count >= 0) {
    return l10n.subscriptionDevicesUsedOfLimit(count, limit);
  }
  if (limit != null && limit > 0) {
    return l10n.subscriptionDeviceLimitOnly(limit);
  }
  if (count != null && count >= 0) {
    return l10n.subscriptionDeviceCountOnly(count);
  }
  return null;
}

/// Days until [expire] (negative = already expired). Null if unknown.
int? expireDaysLeft(DateTime? expire) {
  if (expire == null) return null;
  return expire.toUtc().difference(DateTime.now().toUtc()).inDays;
}

/// Warn when expired or fewer than 3 full days remain.
bool shouldWarnExpire(SubscriptionUserinfo? info) {
  final days = expireDaysLeft(info?.expire);
  if (days == null) return false;
  return days < 3;
}

String? expireWarningLabel(AppLocalizations l10n, SubscriptionUserinfo? info) {
  final days = expireDaysLeft(info?.expire);
  if (days == null) return null;
  if (days < 0) return l10n.expireWarningExpired;
  if (days < 3) return l10n.expireWarningSoon(days);
  return null;
}

/// Origin only — never path/query (often carries the access token).
String subscriptionHostDisplay(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || uri.host.isEmpty) return url.trim();
  final port = uri.hasPort ? ':${uri.port}' : '';
  final scheme = uri.scheme.isEmpty ? 'https' : uri.scheme;
  return '$scheme://${uri.host}$port';
}
