import '../../session/subscription.dart';

const kSupportUrl = 'https://vpnclient.goodwin.website/support';

String? supportUrlFor(List<VpnSubscription> subscriptions) {
  for (final sub in subscriptions) {
    final url = sub.supportUrl?.trim() ?? '';
    if (url.isEmpty) continue;
    final uri = Uri.tryParse(url);
    if (uri != null &&
        uri.scheme.toLowerCase() == 'https' &&
        uri.host.isNotEmpty) {
      return url;
    }
  }
  return kSupportUrl;
}
