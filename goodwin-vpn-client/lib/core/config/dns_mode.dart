/// DNS resolution mode applied on connect (TUN IPs + Xray DoH when set).
enum DnsMode {
  system,
  custom,
  doh;

  String get storageValue => name;

  static DnsMode parse(String? raw) {
    return switch (raw) {
      'custom' => DnsMode.custom,
      'doh' => DnsMode.doh,
      _ => DnsMode.system,
    };
  }
}
