import Cocoa
import FlutterMacOS

/// Relaunch a clean app instance so a different Go c-shared (xray ↔ hysteria)
/// can load. Must not reuse `ProcessInfo.arguments` — under `flutter run` those
/// flags make the child exit immediately ("Lost connection to device").
private func restartProcess() {
  // exit(_:) skips applicationShouldTerminate — drop SOCKS TUN explicitly.
  let sem = DispatchSemaphore(value: 0)
  SocksVpnManager.shared.stopVpn { _ in
    sem.signal()
  }
  _ = sem.wait(timeout: .now() + 2.0)

  let appURL = Bundle.main.bundleURL
  let config = NSWorkspace.OpenConfiguration()
  config.createsNewApplicationInstance = true
  NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in
    exit(0)
  }
  // If the open callback never fires, still quit to unload Go runtimes.
  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    exit(0)
  }
}

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let messenger = flutterViewController.engine.binaryMessenger
    SocksVpnManager.shared.attach(messenger: messenger)

    let channel = FlutterMethodChannel(
      name: "website.goodwin.vpn/macos",
      binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "restartProcess":
        restartProcess()
        result(nil)

      case "prepare":
        SocksVpnManager.shared.prepare { ok in
          result(ok)
        }

      case "requestElevation":
        // macOS Packet Tunnel uses system VPN consent, not UAC.
        result(false)

      case "startVpn":
        let args = call.arguments as? [String: Any] ?? [:]
        let socksHost = (args["socksHost"] as? String) ?? "127.0.0.1"
        let socksPort = (args["socksPort"] as? NSNumber)?.intValue
          ?? (args["socksPort"] as? Int)
          ?? 10808
        let bypassHost = args["bypassHost"] as? String
        let bypassHosts = args["bypassHosts"] as? [String] ?? []
        let excludeRoutes = args["excludeRoutes"] as? [String] ?? []
        let dnsServers = args["dnsServers"] as? [String] ?? []
        SocksVpnManager.shared.startVpn(
          socksHost: socksHost,
          socksPort: socksPort,
          bypassHost: bypassHost,
          bypassHosts: bypassHosts,
          excludeRoutes: excludeRoutes,
          dnsServers: dnsServers
        ) { error in
          if let error {
            result(FlutterError(
              code: "startVpn",
              message: error.localizedDescription,
              details: nil))
          } else {
            result(nil)
          }
        }

      case "stopVpn":
        SocksVpnManager.shared.stopVpn { error in
          if let error {
            result(FlutterError(
              code: "stopVpn",
              message: error.localizedDescription,
              details: nil))
          } else {
            result(nil)
          }
        }

      case "isEstablished":
        SocksVpnManager.shared.isEstablished { ok in
          result(ok)
        }

      case "nativeLibraryDir":
        let dir = Bundle.main.bundleURL
          .appendingPathComponent("Contents/MacOS", isDirectory: true)
          .path
        result(dir)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    super.awakeFromNib()
  }
}
