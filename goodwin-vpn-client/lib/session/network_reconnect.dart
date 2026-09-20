/// Backoff delays between network-triggered reconnect attempts.
const kNetworkReconnectDelays = <Duration>[
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 4),
  Duration(seconds: 8),
  Duration(seconds: 15),
];

const kNetworkReconnectMaxAttempts = 5;

Duration networkReconnectDelay(int attemptIndex) {
  if (attemptIndex <= 0) return Duration.zero;
  final idx = attemptIndex - 1;
  if (idx >= kNetworkReconnectDelays.length) {
    return kNetworkReconnectDelays.last;
  }
  return kNetworkReconnectDelays[idx];
}
