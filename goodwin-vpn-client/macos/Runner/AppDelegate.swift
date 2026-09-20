import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  /// Drop the SOCKS Packet Tunnel on quit so a Connected session can't leave
  /// the Mac without a default route after the main process is gone.
  override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    let sem = DispatchSemaphore(value: 0)
    SocksVpnManager.shared.stopVpn { _ in
      sem.signal()
    }
    _ = sem.wait(timeout: .now() + 2.5)
    return .terminateNow
  }

  override func applicationWillTerminate(_ notification: Notification) {
    let sem = DispatchSemaphore(value: 0)
    SocksVpnManager.shared.stopVpn { _ in
      sem.signal()
    }
    _ = sem.wait(timeout: .now() + 1.5)
  }
}
