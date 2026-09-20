import Foundation
import NetworkExtension
import Flutter

/// Host-side manager for the SOCKS Packet Tunnel (….socks), separate from TrustTunnel (….tunnel).
final class SocksVpnManager: NSObject, FlutterStreamHandler {
  static let shared = SocksVpnManager()

  static let providerBundleId = "website.goodwin.goodwinVpnClient.socks"
  static let localizedDescription = "GoodWin VPN"

  private var eventSink: FlutterEventSink?
  private var statusObserver: NSObjectProtocol?
  private var manager: NETunnelProviderManager?
  private var awaitingConnect = false
  private var awaitingStop = false

  private override init() {
    super.init()
  }

  func attach(messenger: FlutterBinaryMessenger) {
    let events = FlutterEventChannel(
      name: "website.goodwin.vpn/ios/events",
      binaryMessenger: messenger)
    events.setStreamHandler(self)

    let methods = FlutterMethodChannel(
      name: "website.goodwin.vpn/ios",
      binaryMessenger: messenger)
    methods.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "prepare":
      prepare { result($0) }
    case "startVpn":
      let args = call.arguments as? [String: Any] ?? [:]
      let core = args["core"] as? String ?? "xray"
      let configJson = args["configJson"] as? String ?? ""
      let socksPort = (args["socksPort"] as? NSNumber)?.intValue ?? 10808
      let bypassHost = args["bypassHost"] as? String
      let bypassHosts = args["bypassHosts"] as? [String] ?? []
      let excludeRoutes = args["excludeRoutes"] as? [String] ?? []
      let dnsServers = args["dnsServers"] as? [String] ?? []
      let killSwitch: Bool = {
        if let b = args["killSwitch"] as? Bool { return b }
        if let n = args["killSwitch"] as? NSNumber { return n.boolValue }
        return false
      }()
      startVpn(
        core: core,
        configJson: configJson,
        socksPort: socksPort,
        bypassHost: bypassHost,
        bypassHosts: bypassHosts,
        excludeRoutes: excludeRoutes,
        dnsServers: dnsServers,
        killSwitch: killSwitch
      ) { error in
        if let error {
          result(FlutterError(code: "startVpn", message: error.localizedDescription, details: nil))
        } else {
          result(nil)
        }
      }
    case "stopVpn":
      stopVpn { error in
        if let error {
          result(FlutterError(code: "stopVpn", message: error.localizedDescription, details: nil))
        } else {
          result(nil)
        }
      }
    case "isEstablished":
      isEstablished { result($0) }
    case "requestElevation":
      result(false)
    case "nativeLibraryDir":
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  func prepare(completion: @escaping (Bool) -> Void) {
    loadSocksManager { [weak self] existing in
      guard let self else {
        completion(false)
        return
      }
      let clearStale: () -> Void = {
        self.loadOrCreateManager { mgr, error in
          guard let mgr, error == nil else {
            completion(false)
            return
          }
          self.ensureProtocol(on: mgr)
          mgr.isEnabled = true
          mgr.saveToPreferences { err in
            if err != nil {
              completion(false)
              return
            }
            mgr.loadFromPreferences { _ in
              completion(true)
            }
          }
        }
      }
      if let existing, existing.connection.status != .disconnected {
        self.awaitingConnect = false
        self.awaitingStop = true
        self.observe(existing, emitCurrent: false)
        self.clearKillSwitch(on: existing) { _ in
          existing.connection.stopVPNTunnel()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            clearStale()
          }
        }
      } else {
        clearStale()
      }
    }
  }

  func startVpn(
    core: String,
    configJson: String,
    socksPort: Int,
    bypassHost: String?,
    bypassHosts: [String],
    excludeRoutes: [String],
    dnsServers: [String],
    killSwitch: Bool,
    completion: @escaping (Error?) -> Void
  ) {
    loadOrCreateManager { [weak self] mgr, error in
      guard let self else {
        completion(NSError(domain: "website.goodwin.socksVpn", code: -1))
        return
      }
      if let error {
        self.emit(kind: "failed", message: error.localizedDescription)
        completion(error)
        return
      }
      guard let mgr else {
        let err = NSError(
          domain: "website.goodwin.socksVpn",
          code: -2,
          userInfo: [NSLocalizedDescriptionKey: "NETunnelProviderManager unavailable"])
        self.emit(kind: "failed", message: err.localizedDescription)
        completion(err)
        return
      }

      self.ensureProtocol(on: mgr)
      guard let proto = mgr.protocolConfiguration as? NETunnelProviderProtocol else {
        let err = NSError(
          domain: "website.goodwin.socksVpn",
          code: -3,
          userInfo: [NSLocalizedDescriptionKey: "Missing NETunnelProviderProtocol"])
        self.emit(kind: "failed", message: err.localizedDescription)
        completion(err)
        return
      }

      var conf: [String: Any] = [
        "core": core,
        "configJson": configJson,
        "socksPort": socksPort,
      ]
      if let bypassHost, !bypassHost.isEmpty {
        conf["bypassHost"] = bypassHost
      }
      if !bypassHosts.isEmpty {
        conf["bypassHosts"] = bypassHosts
      }
      if !excludeRoutes.isEmpty {
        conf["excludeRoutes"] = excludeRoutes
      }
      if !dnsServers.isEmpty {
        conf["dnsServers"] = dnsServers
      }
      proto.providerConfiguration = conf
      mgr.protocolConfiguration = proto
      mgr.isEnabled = true
      mgr.localizedDescription = Self.localizedDescription
      Self.applyKillSwitch(killSwitch, on: mgr, proto: proto)
      mgr.protocolConfiguration = proto

      mgr.saveToPreferences { saveErr in
        if let saveErr {
          self.emit(kind: "failed", message: saveErr.localizedDescription)
          completion(saveErr)
          return
        }
        mgr.loadFromPreferences { loadErr in
          if let loadErr {
            self.emit(kind: "failed", message: loadErr.localizedDescription)
            completion(loadErr)
            return
          }
          self.awaitingStop = false
          self.awaitingConnect = true
          self.observe(mgr, emitCurrent: false)
          do {
            try mgr.connection.startVPNTunnel()
            completion(nil)
          } catch {
            self.awaitingConnect = false
            self.emit(kind: "failed", message: error.localizedDescription)
            completion(error)
          }
        }
      }
    }
  }

  func stopVpn(completion: @escaping (Error?) -> Void) {
    loadSocksManager { [weak self] mgr in
      guard let self else {
        completion(nil)
        return
      }
      guard let mgr else {
        self.emit(kind: "stopped", message: nil)
        completion(nil)
        return
      }
      self.awaitingConnect = false
      self.awaitingStop = true
      self.observe(mgr, emitCurrent: false)
      if mgr.connection.status == .disconnected {
        self.clearKillSwitch(on: mgr) { err in
          self.awaitingStop = false
          if let err {
            self.emit(kind: "failed", message: "Could not turn off on-demand: \(err.localizedDescription)")
            completion(err)
            return
          }
          self.emit(kind: "stopped", message: nil)
          completion(nil)
        }
        return
      }
      self.clearKillSwitch(on: mgr) { err in
        if let err {
          self.awaitingStop = false
          self.emit(kind: "failed", message: "Could not turn off on-demand: \(err.localizedDescription)")
          completion(err)
          return
        }
        mgr.connection.stopVPNTunnel()
        completion(nil)
      }
    }
  }

  func isEstablished(completion: @escaping (Bool) -> Void) {
    loadSocksManager { mgr in
      completion(mgr?.connection.status == .connected)
    }
  }

  private func emit(kind: String, message: String?) {
    var payload: [String: Any] = ["kind": kind]
    if let message {
      payload["message"] = message
    }
    DispatchQueue.main.async {
      self.eventSink?(payload)
    }
  }

  private func observe(_ mgr: NETunnelProviderManager, emitCurrent: Bool) {
    manager = mgr
    if let statusObserver {
      NotificationCenter.default.removeObserver(statusObserver)
    }
    statusObserver = NotificationCenter.default.addObserver(
      forName: .NEVPNStatusDidChange,
      object: mgr.connection,
      queue: .main
    ) { [weak self] _ in
      self?.handleStatus(mgr.connection.status)
    }
    if emitCurrent {
      handleStatus(mgr.connection.status)
    }
  }

  private func handleStatus(_ status: NEVPNStatus) {
    switch status {
    case .connected:
      awaitingConnect = false
      emit(kind: "established", message: nil)
    case .disconnected:
      if awaitingConnect {
        awaitingConnect = false
        emit(kind: "failed", message: "VPN tunnel disconnected while connecting")
      } else {
        awaitingStop = false
        emit(kind: "stopped", message: nil)
      }
    case .invalid:
      awaitingConnect = false
      emit(kind: "failed", message: "VPN configuration invalid")
    case .connecting, .reasserting, .disconnecting:
      break
    @unknown default:
      break
    }
  }

  private func ensureProtocol(on mgr: NETunnelProviderManager) {
    let proto = (mgr.protocolConfiguration as? NETunnelProviderProtocol) ?? NETunnelProviderProtocol()
    proto.providerBundleIdentifier = Self.providerBundleId
    proto.serverAddress = "GoodWin VPN"
    if proto.providerConfiguration == nil {
      proto.providerConfiguration = [:]
    }
    mgr.protocolConfiguration = proto
    mgr.localizedDescription = Self.localizedDescription
  }

  /// Leak protection while connected. Cleared on user Disconnect so on-demand
  /// does not immediately bring the tunnel back.
  private static func applyKillSwitch(
    _ enabled: Bool,
    on mgr: NETunnelProviderManager,
    proto: NETunnelProviderProtocol
  ) {
    proto.includeAllNetworks = enabled
    proto.excludeLocalNetworks = true
    if #available(iOS 16.4, *) {
      proto.excludeAPNs = enabled
      proto.excludeCellularServices = enabled
    }
    if #available(iOS 17.4, *) {
      proto.excludeDeviceCommunication = enabled
    }
    if enabled {
      let rule = NEOnDemandRuleConnect()
      rule.interfaceTypeMatch = .any
      mgr.onDemandRules = [rule]
      mgr.isOnDemandEnabled = true
    } else {
      mgr.isOnDemandEnabled = false
      mgr.onDemandRules = []
    }
  }

  private func clearKillSwitch(on mgr: NETunnelProviderManager, then: @escaping (Error?) -> Void) {
    mgr.isOnDemandEnabled = false
    mgr.onDemandRules = []
    if let proto = mgr.protocolConfiguration as? NETunnelProviderProtocol {
      proto.includeAllNetworks = false
      if #available(iOS 16.4, *) {
        proto.excludeAPNs = false
        proto.excludeCellularServices = false
      }
      if #available(iOS 17.4, *) {
        proto.excludeDeviceCommunication = false
      }
      mgr.protocolConfiguration = proto
    }
    mgr.saveToPreferences { err in
      if let err {
        then(err)
        return
      }
      mgr.loadFromPreferences { loadErr in
        then(loadErr)
      }
    }
  }

  private func loadOrCreateManager(
    completion: @escaping (NETunnelProviderManager?, Error?) -> Void
  ) {
    NETunnelProviderManager.loadAllFromPreferences { managers, error in
      if let error {
        completion(nil, error)
        return
      }
      let existing = managers?.first {
        ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier
          == Self.providerBundleId
      }
      completion(existing ?? NETunnelProviderManager(), nil)
    }
  }

  private func loadSocksManager(completion: @escaping (NETunnelProviderManager?) -> Void) {
    NETunnelProviderManager.loadAllFromPreferences { managers, _ in
      let existing = managers?.first {
        ($0.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier
          == Self.providerBundleId
      }
      completion(existing)
    }
  }
}
