import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'goodwin_service.dart';
import 'subscription_client.dart';

const kGoodwinServiceMaxBytes = 64 * 1024;

abstract class GoodwinServiceClient {
  Future<GoodwinServiceCatalog?> fetchCatalog(String serviceBase);
}

class HttpGoodwinServiceClient implements GoodwinServiceClient {
  HttpGoodwinServiceClient({
    HttpClient Function()? openClient,
    this.maxBytes = kGoodwinServiceMaxBytes,
    this.userAgent = kSubscriptionUserAgent,
  }) : _openClient = openClient ?? HttpClient.new;

  final HttpClient Function() _openClient;
  final int maxBytes;
  final String userAgent;

  @override
  Future<GoodwinServiceCatalog?> fetchCatalog(String serviceBase) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return null;
    final url = Uri.parse('$origin$kGoodwinServicePath');
    final client = _openClient();
    try {
      client.userAgent = userAgent;
      client.connectionTimeout = const Duration(seconds: 15);
      final request = await client.getUrl(url);
      request.followRedirects = true;
      request.maxRedirects = 5;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response =
          await request.close().timeout(const Duration(seconds: 15));
      if (response.redirects
          .any((r) => r.location.scheme.toLowerCase() != 'https')) {
        return null;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      final declared = response.headers.contentLength;
      if (declared > maxBytes) return null;
      final bytes = <int>[];
      await for (final chunk in response) {
        if (bytes.length + chunk.length > maxBytes) return null;
        bytes.addAll(chunk);
      }
      final body = utf8.decode(bytes, allowMalformed: true);
      return parseGoodwinServiceCatalog(body, serviceBase: origin);
    } on HttpException {
      return null;
    } on SocketException {
      return null;
    } on HandshakeException {
      return null;
    } on TlsException {
      return null;
    } on TimeoutException {
      return null;
    } finally {
      client.close(force: true);
    }
  }
}
