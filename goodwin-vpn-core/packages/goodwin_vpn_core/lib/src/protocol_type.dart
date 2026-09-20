enum ProtocolType {
  vless,
  vmess,
  trojan,
  shadowsocks,
  hysteria2,
  trusttunnel,
}

extension ProtocolTypeX on ProtocolType {
  String get scheme => switch (this) {
        ProtocolType.vless => 'vless',
        ProtocolType.vmess => 'vmess',
        ProtocolType.trojan => 'trojan',
        ProtocolType.shadowsocks => 'ss',
        ProtocolType.hysteria2 => 'hysteria2',
        ProtocolType.trusttunnel => 'tt',
      };
}
