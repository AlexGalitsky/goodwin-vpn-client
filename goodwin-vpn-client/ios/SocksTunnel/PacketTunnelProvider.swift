import Foundation
import NetworkExtension

/// Goodwin SOCKS Packet Tunnel (P-I2): core (Xray/Hy2) + tun2socks in one Go runtime.
/// Separate from TrustTunnel Extension (….tunnel). No hev.
final class PacketTunnelProvider: NEPacketTunnelProvider {
  private var reading = false
  private let outQueue = DispatchQueue(label: "website.goodwin.socksTun.out")

  override func startTunnel(
    options: [String: NSObject]?,
    completionHandler: @escaping (Error?) -> Void
  ) {
    let proto = protocolConfiguration as? NETunnelProviderProtocol
    let conf = proto?.providerConfiguration ?? [:]
    let core = (conf["core"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "xray"
    let configJson = (conf["configJson"] as? String) ?? ""
    let socksPort = (conf["socksPort"] as? NSNumber)?.intValue ?? 10808
    let bypassHost = conf["bypassHost"] as? String
    let bypassHosts = conf["bypassHosts"] as? [String] ?? []
    let excludeRoutes = conf["excludeRoutes"] as? [String] ?? []
    let dnsServersRaw = conf["dnsServers"] as? [String] ?? []
    let dnsList: [String] = {
      let cleaned = dnsServersRaw
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
      // Hy2 SOCKS UDP ASSOCIATE is IPv4 loopback; an IPv6 DNS server in
      // NEDNSSettings makes iOS probe v6 first, fail, and look "offline".
      if core == "hysteria2" || core == "hysteria" {
        let v4 = cleaned.filter { !$0.contains(":") }
        return v4.isEmpty ? ["1.1.1.1", "8.8.8.8"] : v4
      }
      if !cleaned.isEmpty { return cleaned }
      return ["1.1.1.1", "8.8.8.8", "2606:4700:4700::1111"]
    }()

    if configJson.isEmpty {
      completionHandler(
        NSError(
          domain: "website.goodwin.socksTun",
          code: -1,
          userInfo: [NSLocalizedDescriptionKey: "Missing configJson"]))
      return
    }

    let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
    let ipv4 = NEIPv4Settings(addresses: ["10.7.0.2"], subnetMasks: ["255.255.255.0"])
    ipv4.includedRoutes = [NEIPv4Route.default()]
    var excluded: [NEIPv4Route] = [
      NEIPv4Route(destinationAddress: "127.0.0.0", subnetMask: "255.0.0.0"),
      NEIPv4Route(destinationAddress: "10.7.0.0", subnetMask: "255.255.255.0"),
      NEIPv4Route(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
      NEIPv4Route(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
      NEIPv4Route(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
      NEIPv4Route(destinationAddress: "169.254.0.0", subnetMask: "255.255.0.0"),
    ]
    var bypassSeen = Set<String>()
    for host in ([bypassHost].compactMap { $0 } + bypassHosts) {
      if let ip = Self.resolveIPv4(host), bypassSeen.insert(ip).inserted {
        excluded.append(NEIPv4Route(destinationAddress: ip, subnetMask: "255.255.255.255"))
        NSLog("SocksTunnel: anti-loop exclude %@", ip)
      }
    }
    for raw in excludeRoutes {
      if let route = Self.parseExcludeRoute(raw) {
        excluded.append(route)
      }
    }
    ipv4.excludedRoutes = excluded
    settings.ipv4Settings = ipv4
    let ipv6 = NEIPv6Settings(
      addresses: ["fd00:10:7::2"],
      networkPrefixLengths: [NSNumber(value: 64)])
    ipv6.includedRoutes = [NEIPv6Route.default()]
    var excludedV6: [NEIPv6Route] = [
      NEIPv6Route(destinationAddress: "fe80::", networkPrefixLength: 10),
      NEIPv6Route(destinationAddress: "fc00::", networkPrefixLength: 7),
      NEIPv6Route(destinationAddress: "fd00:10:7::", networkPrefixLength: 64),
    ]
    var bypassV6Seen = Set<String>()
    for host in ([bypassHost].compactMap { $0 } + bypassHosts) {
      if let ip = Self.resolveIPv6(host), bypassV6Seen.insert(ip).inserted {
        excludedV6.append(NEIPv6Route(destinationAddress: ip, networkPrefixLength: 128))
        NSLog("SocksTunnel: anti-loop exclude v6 %@", ip)
      }
    }
    for raw in excludeRoutes {
      if let route = Self.parseExcludeRouteV6(raw) {
        excludedV6.append(route)
      }
    }
    ipv6.excludedRoutes = excludedV6
    settings.ipv6Settings = ipv6
    let dns = NEDNSSettings(servers: dnsList)
    dns.matchDomains = [""]
    settings.dnsSettings = dns
    settings.mtu = 1500

    // Hy2 QUIC must bind UDP on the physical path *before* the TUN default
    // route exists. iOS often still captures UDP to an excluded /32 after
    // setTunnelNetworkSettings — VLESS TCP is fine; Hy2 then handshake-loops.
    if core == "hysteria2" || core == "hysteria" {
      let pre = startCoreOnly(core: core, configJson: configJson, socksPort: socksPort)
      if pre != 0 {
        completionHandler(
          NSError(
            domain: "website.goodwin.socksTun",
            code: Int(pre),
            userInfo: [NSLocalizedDescriptionKey: "GoodwinVpnStartCore failed (\(pre))"]))
        return
      }
    }

    setTunnelNetworkSettings(settings) { [weak self] error in
      guard let self else {
        completionHandler(error)
        return
      }
      if let error {
        completionHandler(error)
        return
      }
      // Xray: start after VPS /32 is excluded. Hy2 already handshook above so
      // QUIC stays on the physical UDP socket.
      let result = self.startStack(core: core, configJson: configJson, socksPort: socksPort)
      if result != 0 {
        completionHandler(
          NSError(
            domain: "website.goodwin.socksTun",
            code: Int(result),
            userInfo: [NSLocalizedDescriptionKey: "GoodwinVpnStart failed (\(result))"]))
        return
      }
      NSLog("SocksTunnel: stack up core=%@ socks=%d", core, socksPort)
      self.reading = true
      self.readLoop()
      completionHandler(nil)
    }
  }

  private func startCoreOnly(core: String, configJson: String, socksPort: Int) -> Int32 {
    core.withCString { cCore in
      configJson.withCString { cJson in
        GoodwinVpnStartCore(cCore, cJson, Int32(socksPort))
      }
    }
  }

  private func startStack(core: String, configJson: String, socksPort: Int) -> Int32 {
    core.withCString { cCore in
      configJson.withCString { cJson in
        GoodwinVpnStart(
          cCore,
          cJson,
          Int32(socksPort),
          { data, len, ctx in
            guard let data, len > 0, let ctx else { return }
            let provider = Unmanaged<PacketTunnelProvider>.fromOpaque(ctx).takeUnretainedValue()
            let packet = Data(bytes: data, count: Int(len))
            provider.outQueue.async {
              guard !packet.isEmpty else { return }
              let version = packet[0] >> 4
              let proto: NSNumber =
                version == 6 ? NSNumber(value: AF_INET6) : NSNumber(value: AF_INET)
              provider.packetFlow.writePackets([packet], withProtocols: [proto])
            }
          },
          Unmanaged.passUnretained(self).toOpaque()
        )
      }
    }
  }

  override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
    reading = false
    GoodwinVpnStop()
    completionHandler()
  }

  private func readLoop() {
    packetFlow.readPackets { [weak self] packets, _ in
      guard let self, self.reading else { return }
      for packet in packets {
        packet.withUnsafeBytes { raw in
          guard let base = raw.bindMemory(to: UInt8.self).baseAddress, !raw.isEmpty else { return }
          GoodwinVpnInput(base, Int32(raw.count))
        }
      }
      self.readLoop()
    }
  }

  private static func resolveIPv4(_ host: String) -> String? {
    if host.split(separator: ".").count == 4, host.allSatisfy({ $0.isNumber || $0 == "." }) {
      return host
    }
    var hints = addrinfo(
      ai_flags: AI_ADDRCONFIG,
      ai_family: AF_INET,
      ai_socktype: SOCK_STREAM,
      ai_protocol: 0,
      ai_addrlen: 0,
      ai_canonname: nil,
      ai_addr: nil,
      ai_next: nil
    )
    var info: UnsafeMutablePointer<addrinfo>?
    guard getaddrinfo(host, nil, &hints, &info) == 0, let info else { return nil }
    defer { freeaddrinfo(info) }
    var addr = info.pointee.ai_addr.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee }
    var buf = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
    inet_ntop(AF_INET, &addr.sin_addr, &buf, socklen_t(INET_ADDRSTRLEN))
    return String(cString: buf)
  }

  private static func resolveIPv6(_ host: String) -> String? {
    var literal = in6_addr()
    if inet_pton(AF_INET6, host, &literal) == 1 {
      return host
    }
    var hints = addrinfo(
      ai_flags: AI_ADDRCONFIG,
      ai_family: AF_INET6,
      ai_socktype: SOCK_STREAM,
      ai_protocol: 0,
      ai_addrlen: 0,
      ai_canonname: nil,
      ai_addr: nil,
      ai_next: nil
    )
    var info: UnsafeMutablePointer<addrinfo>?
    guard getaddrinfo(host, nil, &hints, &info) == 0, let info else { return nil }
    defer { freeaddrinfo(info) }
    var addr = info.pointee.ai_addr.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) { $0.pointee }
    var buf = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
    inet_ntop(AF_INET6, &addr.sin6_addr, &buf, socklen_t(INET6_ADDRSTRLEN))
    return String(cString: buf)
  }

  private static func parseExcludeRouteV6(_ raw: String) -> NEIPv6Route? {
    let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty || !trimmed.contains(":") { return nil }
    let parts = trimmed.split(separator: "/", maxSplits: 1).map(String.init)
    let ip = parts[0]
    let prefix = parts.count > 1 ? (Int(parts[1]) ?? 128) : 128
    guard prefix >= 0, prefix <= 128 else { return nil }
    var addr = in6_addr()
    guard inet_pton(AF_INET6, ip, &addr) == 1 else { return nil }
    return NEIPv6Route(destinationAddress: ip, networkPrefixLength: NSNumber(value: prefix))
  }

  private static func parseExcludeRoute(_ raw: String) -> NEIPv4Route? {
    let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty { return nil }
    let parts = trimmed.split(separator: "/", maxSplits: 1).map(String.init)
    let ip = parts[0]
    let prefix = parts.count > 1 ? (Int(parts[1]) ?? 32) : 32
    guard prefix >= 0, prefix <= 32 else { return nil }
    return NEIPv4Route(destinationAddress: ip, subnetMask: Self.subnetMask(prefix: prefix))
  }

  private static func subnetMask(prefix: Int) -> String {
    if prefix == 0 { return "0.0.0.0" }
    let mask: UInt32 = prefix == 32 ? 0xffff_ffff : ~((1 << (32 - prefix)) - 1)
    return String(
      format: "%u.%u.%u.%u",
      (mask >> 24) & 0xff,
      (mask >> 16) & 0xff,
      (mask >> 8) & 0xff,
      mask & 0xff)
  }
}
