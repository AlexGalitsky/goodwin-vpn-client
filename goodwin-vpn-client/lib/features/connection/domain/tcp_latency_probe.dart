import 'dart:io';

import 'node_endpoint.dart';

/// TCP connect RTT to a node. `null` means timeout / unreachable.
abstract class LatencyProbe {
  Future<int?> measure(
    NodeEndpoint endpoint, {
    Duration timeout = const Duration(seconds: 3),
  });
}

class TcpLatencyProbe implements LatencyProbe {
  const TcpLatencyProbe();

  @override
  Future<int?> measure(
    NodeEndpoint endpoint, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final watch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(
        endpoint.host,
        endpoint.port,
        timeout: timeout,
      );
      final ms = watch.elapsedMilliseconds;
      socket.destroy();
      return ms;
    } catch (_) {
      return null;
    }
  }
}
