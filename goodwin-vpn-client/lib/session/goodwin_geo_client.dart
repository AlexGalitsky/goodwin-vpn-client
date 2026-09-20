import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'goodwin_geo.dart';
import 'goodwin_service.dart';
import 'subscription_client.dart';

abstract class GoodwinGeoClient {
  Future<GeoManifest?> fetchManifest(String serviceBase);

  Future<Uint8List?> fetchPackBytes({
    required String serviceBase,
    required GeoPackMeta meta,
  });
}

class HttpGoodwinGeoClient implements GoodwinGeoClient {
  HttpGoodwinGeoClient({
    HttpClient Function()? openClient,
    this.manifestMaxBytes = kGoodwinGeoManifestMaxBytes,
    this.packMaxBytes = kGoodwinGeoPackMaxBytes,
    this.userAgent = kSubscriptionUserAgent,
  }) : _openClient = openClient ?? HttpClient.new;

  final HttpClient Function() _openClient;
  final int manifestMaxBytes;
  final int packMaxBytes;
  final String userAgent;

  @override
  Future<GeoManifest?> fetchManifest(String serviceBase) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return null;
    final bytes = await _getHttps(
      Uri.parse('$origin$kGoodwinGeoManifestPath'),
      maxBytes: manifestMaxBytes,
    );
    if (bytes == null) return null;
    return parseGeoManifest(
      utf8.decode(bytes, allowMalformed: true),
      serviceBase: origin,
    );
  }

  @override
  Future<Uint8List?> fetchPackBytes({
    required String serviceBase,
    required GeoPackMeta meta,
  }) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return null;
    final url = Uri.tryParse(meta.url);
    if (url == null) return null;
    final urlOrigin = httpsOrigin(url);
    if (urlOrigin == null || urlOrigin.toLowerCase() != origin.toLowerCase()) {
      return null;
    }
    final cap = meta.bytes < packMaxBytes ? meta.bytes : packMaxBytes;
    return _getHttps(url, maxBytes: cap);
  }

  Future<Uint8List?> _getHttps(Uri url, {required int maxBytes}) async {
    if (httpsOrigin(url) == null) return null;
    final client = _openClient();
    try {
      client.userAgent = userAgent;
      client.connectionTimeout = const Duration(seconds: 15);
      final request = await client.getUrl(url);
      request.followRedirects = true;
      request.maxRedirects = 5;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close().timeout(
        const Duration(seconds: 20),
      );
      if (response.redirects.any(
        (r) => r.location.scheme.toLowerCase() != 'https',
      )) {
        return null;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      final declared = response.headers.contentLength;
      if (declared > maxBytes) return null;
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response) {
        if (bytes.length + chunk.length > maxBytes) return null;
        bytes.add(chunk);
      }
      return bytes.takeBytes();
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
