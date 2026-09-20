import 'dart:convert';
import 'dart:io';

import 'subscription_parser.dart';

const kSubscriptionUserAgent = 'goodwin-vpn/1.0';
const kSubscriptionMaxBytes = 1024 * 1024;

abstract class SubscriptionClient {
  Future<SubscriptionDocument> fetch(Uri url);
}

void requireHttpsSubscriptionUri(Uri url) {
  if (url.scheme.toLowerCase() != 'https' || url.host.isEmpty) {
    throw SubscriptionParseException('Subscription URL must be HTTPS');
  }
}

void appendSubscriptionBytes(List<int> acc, List<int> chunk, int maxBytes) {
  if (acc.length + chunk.length > maxBytes) {
    throw SubscriptionParseException(
      'Subscription body exceeds $maxBytes bytes',
    );
  }
  acc.addAll(chunk);
}

Never throwForSubscriptionStatus(int statusCode) {
  if (statusCode == 404) {
    throw SubscriptionRevokedException();
  }
  throw SubscriptionParseException('Subscription HTTP $statusCode');
}

class HttpSubscriptionClient implements SubscriptionClient {
  HttpSubscriptionClient({
    HttpClient Function()? openClient,
    this.maxBytes = kSubscriptionMaxBytes,
    this.userAgent = kSubscriptionUserAgent,
  }) : _openClient = openClient ?? HttpClient.new;

  final HttpClient Function() _openClient;
  final int maxBytes;
  final String userAgent;

  @override
  Future<SubscriptionDocument> fetch(Uri url) async {
    requireHttpsSubscriptionUri(url);
    final client = _openClient();
    try {
      client.userAgent = userAgent;
      client.connectionTimeout = const Duration(seconds: 15);
      final request = await client.getUrl(url);
      request.followRedirects = true;
      request.maxRedirects = 5;
      request.headers.set(HttpHeaders.acceptHeader, '*/*');
      final response = await request.close().timeout(const Duration(seconds: 25));
      if (response.redirects.any((r) => r.location.scheme.toLowerCase() != 'https')) {
        throw SubscriptionParseException(
          'Subscription redirect left HTTPS',
        );
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throwForSubscriptionStatus(response.statusCode);
      }
      final declared = response.headers.contentLength;
      if (declared > maxBytes) {
        throw SubscriptionParseException(
          'Subscription body exceeds $maxBytes bytes',
        );
      }
      final bytes = <int>[];
      await for (final chunk in response) {
        appendSubscriptionBytes(bytes, chunk, maxBytes);
      }
      final body = utf8.decode(bytes, allowMalformed: true);
      final headers = <String, String>{};
      response.headers.forEach((name, values) {
        if (values.isEmpty) return;
        headers[name] = values.join(',');
      });
      final disposition = headers['content-disposition'];
      if (disposition != null && !headers.containsKey('profile-title')) {
        final file = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
        if (file != null) headers['profile-title'] = file.group(1)!;
      }
      return SubscriptionDocument(body: body, headers: headers);
    } finally {
      client.close(force: true);
    }
  }
}
