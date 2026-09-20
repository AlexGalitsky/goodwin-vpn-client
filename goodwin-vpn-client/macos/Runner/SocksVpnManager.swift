import Foundation
import NetworkExtension
import FlutterMacOS

/// Host-side manager for the SOCKS Packet Tunnel (….socks), separate from TrustTunnel (….tunnel).
final class SocksVpnManager: NSObject, FlutterStreamHandler {
  static let shared = SocksVpnManager()

  static let providerBundleId = "website.goodwin.goodwinVpnClient.socks"
  static let localizedDescription = "Goodwin SOCKS"

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
      name: "website.goodwin.vpn/macos/events",
      binaryMessenger: messenger)
    events.setStreamHandler(self)
  }

  // MARK: - FlutterStreamHandler

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  // MARK: - MethodChannel API

  func prepare(completion: @escaping (Bool) -> Void) {
    // Tear down a stale SOCKS tunnel first. If the main app was killed while
    // Connected, the appex can keep the default route and blackhole the Mac.
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
        existing.connection.stopVPNTunnel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
          clearStale()
        }
      } else {
        clearStale()
      }
    }
  }

  func startVpn(
    socksHost: String,
    socksPort: Int,
    bypassHost: String?,
    bypassHosts: [String],
    excludeRoutes: [String],
    dnsServers: [String],
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
        "socksHost": socksHost,
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
        self.awaitingStop = false
        self.emit(kind: "stopped", message: nil)
        completion(nil)
        return
      }
      mgr.connection.stopVPNTunnel()
      completion(nil)
    }
  }

  func isEstablished(completion: @escaping (Bool) -> Void) {
    loadSocksManager { mgr in
      completion(mgr?.connection.status == .connected)
    }
  }

  // MARK: - Internals

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
      } else if awaitingStop {
        awaitingStop = false
        emit(kind: "stopped", message: nil)
      } else {
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
    proto.serverAddress = "Goodwin SOCKS"
    if proto.providerConfiguration == nil {
      proto.providerConfiguration = [:]
    }
    mgr.protocolConfiguration = proto
    mgr.localizedDescription = Self.localizedDescription
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
      if let existing {
        completion(existing, nil)
        return
      }
      let created = NETunnelProviderManager()
      completion(created, nil)
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
