import '../../session/subscription.dart';

/// Public privacy policy for Play / App Store (client site).
const kPrivacyPolicyUrl = 'https://vpnclient.goodwin.website/privacy';

/// Prefer a Goodwin catalog URL from imported subscriptions, else the client site.
String privacyPolicyUrlFor(List<VpnSubscription> subscriptions) {
  for (final sub in subscriptions) {
    final url = sub.privacyUrl?.trim() ?? '';
    if (url.isEmpty) continue;
    final uri = Uri.tryParse(url);
    if (uri != null &&
        uri.scheme.toLowerCase() == 'https' &&
        uri.host.isNotEmpty) {
      return url;
    }
  }
  return kPrivacyPolicyUrl;
}
