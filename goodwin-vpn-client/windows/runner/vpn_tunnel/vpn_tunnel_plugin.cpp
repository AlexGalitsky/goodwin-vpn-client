#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>

#include "vpn_tunnel_plugin.h"

#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/flutter_engine.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter_windows.h>

#include <iphlpapi.h>
#include <netioapi.h>
#include <shellapi.h>

#include <atomic>
#include <memory>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

#pragma comment(lib, "iphlpapi.lib")
#pragma comment(lib, "ws2_32.lib")
#pragma comment(lib, "shell32.lib")
#pragma comment(lib, "advapi32.lib")

constexpr wchar_t kAdapterName[] = L"GoodWinVPN";
// Stable Wintun GUID so Windows reuses one adapter instead of "wintun N".
constexpr wchar_t kAdapterDevice[] =
    L"tun://GoodWinVPN?guid={8C4E1E2A-9B3D-4F5A-A1C2-D3E4F5060708}";
constexpr wchar_t kTun2SocksExe[] = L"tun2socks.exe";
constexpr int kPollMs = 200;
constexpr int kPollMax = 150;  // 30s
// Marshals EventChannel emits onto the Flutter platform thread.
constexpr UINT kVpnEventMsg = WM_APP + 0x4756;  // 'GV'

// Children (tun2socks) die when this process exits.
HANDLE g_kill_job = nullptr;

void EnsureKillOnCloseJob() {
  if (g_kill_job != nullptr) return;
  g_kill_job = CreateJobObjectW(nullptr, nullptr);
  if (g_kill_job == nullptr) return;
  JOBOBJECT_EXTENDED_LIMIT_INFORMATION info{};
  info.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
  if (!SetInformationJobObject(g_kill_job, JobObjectExtendedLimitInformation,
                               &info, sizeof(info))) {
    CloseHandle(g_kill_job);
    g_kill_job = nullptr;
    return;
  }
  // May fail if already in a job (debugger / packaged host) — still use job for
  // children when AssignProcessToJobObject on the child succeeds.
  AssignProcessToJobObject(g_kill_job, GetCurrentProcess());
}

// --- UTF-8 / wide helpers ---------------------------------------------------

std::string WideToUtf8(const std::wstring& wide) {
  if (wide.empty()) return {};
  const int len = WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), -1, nullptr, 0,
                                      nullptr, nullptr);
  if (len <= 0) return {};
  std::string out(static_cast<size_t>(len - 1), '\0');
  WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), -1, out.data(), len, nullptr,
                      nullptr);
  return out;
}

std::wstring Utf8ToWide(const std::string& utf8) {
  if (utf8.empty()) return {};
  const int len =
      MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), -1, nullptr, 0);
  if (len <= 0) return {};
  std::wstring out(static_cast<size_t>(len - 1), L'\0');
  MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), -1, out.data(), len);
  return out;
}

std::wstring GetExeDir() {
  wchar_t path[MAX_PATH];
  const DWORD n = GetModuleFileNameW(nullptr, path, MAX_PATH);
  std::wstring s(path, n);
  const auto pos = s.find_last_of(L"\\/");
  if (pos != std::wstring::npos) {
    s.resize(pos);
  }
  return s;
}

// --- Admin / elevation -------------------------------------------------------

bool IsRunAsAdmin() {
  BOOL admin = FALSE;
  PSID group = nullptr;
  SID_IDENTIFIER_AUTHORITY authority = SECURITY_NT_AUTHORITY;
  if (AllocateAndInitializeSid(&authority, 2, SECURITY_BUILTIN_DOMAIN_RID,
                               DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0,
                               &group)) {
    CheckTokenMembership(nullptr, group, &admin);
    FreeSid(group);
  }
  return admin == TRUE;
}

[[noreturn]] void ExitProcessNow() { ExitProcess(0); }

bool RequestElevation() {
  wchar_t exe[MAX_PATH];
  GetModuleFileNameW(nullptr, exe, MAX_PATH);
  SHELLEXECUTEINFOW sei{};
  sei.cbSize = sizeof(sei);
  sei.lpVerb = L"runas";
  sei.lpFile = exe;
  sei.nShow = SW_NORMAL;
  if (ShellExecuteExW(&sei) == FALSE) {
    return false;
  }
  // Hand off to the elevated instance (same as process restart).
  ExitProcessNow();
}

void RestartProcess() {
  wchar_t exe[MAX_PATH];
  GetModuleFileNameW(nullptr, exe, MAX_PATH);
  STARTUPINFOW si{};
  si.cb = sizeof(si);
  PROCESS_INFORMATION pi{};
  std::wstring cmd = L"\"";
  cmd += exe;
  cmd += L"\"";
  std::vector<wchar_t> mutable_cmd(cmd.begin(), cmd.end());
  mutable_cmd.push_back(L'\0');
  if (CreateProcessW(exe, mutable_cmd.data(), nullptr, nullptr, FALSE, 0,
                     nullptr, GetExeDir().c_str(), &si, &pi)) {
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
  }
  ExitProcess(0);
}

// --- Events ------------------------------------------------------------------

struct VpnPostedEvent {
  std::string kind;
  std::string message;
};

class VpnEventHub {
 public:
  void SetPlatformWindow(HWND hwnd) { hwnd_ = hwnd; }

  void SetSink(
      std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> sink) {
    std::lock_guard<std::mutex> lock(mutex_);
    sink_ = std::move(sink);
  }

  void ClearSink() {
    std::lock_guard<std::mutex> lock(mutex_);
    sink_.reset();
  }

  /// Safe from worker threads: posts to the HWND, delivers on platform thread.
  void Emit(const std::string& kind, const std::string& message = {}) {
    auto* posted = new VpnPostedEvent{kind, message};
    const HWND hwnd = hwnd_;
    if (hwnd != nullptr &&
        PostMessageW(hwnd, kVpnEventMsg, 0, reinterpret_cast<LPARAM>(posted))) {
      return;
    }
    // Window not ready — deliver inline (may warn if off-thread).
    Deliver(*posted);
    delete posted;
  }

  void HandlePosted(LPARAM lparam) {
    auto* posted = reinterpret_cast<VpnPostedEvent*>(lparam);
    if (!posted) return;
    Deliver(*posted);
    delete posted;
  }

 private:
  void Deliver(const VpnPostedEvent& posted) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!sink_) return;
    flutter::EncodableMap map;
    map[flutter::EncodableValue("kind")] =
        flutter::EncodableValue(posted.kind);
    if (!posted.message.empty()) {
      map[flutter::EncodableValue("message")] =
          flutter::EncodableValue(posted.message);
    }
    sink_->Success(flutter::EncodableValue(map));
  }

  HWND hwnd_ = nullptr;
  std::mutex mutex_;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> sink_;
};

VpnEventHub g_events;

bool VpnWindowProc(HWND /*hwnd*/, UINT message, WPARAM /*wparam*/,
                   LPARAM lparam, void* /*user_data*/, LRESULT* result) {
  if (message != kVpnEventMsg) return false;
  g_events.HandlePosted(lparam);
  *result = 0;
  return true;
}

// --- Route table snapshot ----------------------------------------------------

struct ForwardRoute {
  NET_LUID luid{};
  SOCKADDR_INET destination{};
  SOCKADDR_INET next_hop{};
  ULONG metric = 0;
  ULONG interface_index = 0;
  ULONG prefix_length = 32;
};

class RouteTable {
 public:
  void Clear() {
    std::lock_guard<std::mutex> lock(mutex_);
    added_.clear();
  }

  bool AddExcludeRoute(const SOCKADDR_INET& dest_in, ULONG prefix_len,
                       std::string& err) {
    SOCKADDR_INET dest = dest_in;
    dest.si_family = AF_INET;
    if (prefix_len > 32) prefix_len = 32;

    MIB_IPFORWARD_ROW2 best{};
    if (GetBestRoute2(nullptr, 0, nullptr, &dest, 0, &best, nullptr) != NO_ERROR) {
      err = "GetBestRoute2 failed for exclude route";
      return false;
    }

    MIB_IPFORWARD_ROW2 row{};
    row.InterfaceIndex = best.InterfaceIndex;
    row.InterfaceLuid = best.InterfaceLuid;
    row.DestinationPrefix.Prefix = dest;
    row.DestinationPrefix.Prefix.si_family = AF_INET;
    row.DestinationPrefix.PrefixLength = static_cast<UINT8>(prefix_len);
    row.NextHop = best.NextHop;
    row.Metric = 5;
    row.Protocol = MIB_IPPROTO_NETMGMT;
    row.Origin = NlroManual;

    const DWORD rc = CreateIpForwardEntry2(&row);
    if (rc != NO_ERROR && rc != ERROR_OBJECT_ALREADY_EXISTS) {
      err = "CreateIpForwardEntry2 exclude failed: " + std::to_string(rc);
      return false;
    }

    ForwardRoute saved{};
    saved.interface_index = best.InterfaceIndex;
    saved.destination = dest;
    saved.next_hop = best.NextHop;
    saved.metric = row.Metric;
    saved.prefix_length = prefix_len;

    std::lock_guard<std::mutex> lock(mutex_);
    added_.push_back(saved);
    return true;
  }

  bool AddBypassRoute(const SOCKADDR_INET& server, std::string& err) {
    return AddExcludeRoute(server, 32, err);
  }

  bool AddDefaultRouteViaInterface(NET_IFINDEX if_index, std::string& err) {
    MIB_IPFORWARD_ROW2 row{};
    row.InterfaceIndex = if_index;
    row.DestinationPrefix.Prefix.si_family = AF_INET;
    row.DestinationPrefix.Prefix.Ipv4.sin_family = AF_INET;
    row.DestinationPrefix.Prefix.Ipv4.sin_addr.S_un.S_addr = 0;
    row.DestinationPrefix.PrefixLength = 0;
    row.NextHop.si_family = AF_INET;
    row.NextHop.Ipv4.sin_family = AF_INET;
    row.NextHop.Ipv4.sin_addr.S_un.S_addr = 0;
    row.Metric = 1;
    row.Protocol = MIB_IPPROTO_NETMGMT;
    row.Origin = NlroManual;

    const DWORD rc = CreateIpForwardEntry2(&row);
    if (rc != NO_ERROR && rc != ERROR_OBJECT_ALREADY_EXISTS) {
      err = "CreateIpForwardEntry2 default route failed: " + std::to_string(rc);
      return false;
    }

    ForwardRoute saved{};
    saved.interface_index = if_index;
    saved.destination = row.DestinationPrefix.Prefix;
    saved.next_hop = row.NextHop;
    saved.metric = row.Metric;
    saved.prefix_length = 0;

    std::lock_guard<std::mutex> lock(mutex_);
    added_.push_back(saved);
    return true;
  }

  bool AddDefaultIpv6RouteViaInterface(NET_IFINDEX if_index, std::string& err) {
    MIB_IPFORWARD_ROW2 row{};
    row.InterfaceIndex = if_index;
    row.DestinationPrefix.Prefix.si_family = AF_INET6;
    row.DestinationPrefix.Prefix.Ipv6.sin6_family = AF_INET6;
    row.DestinationPrefix.PrefixLength = 0;
    row.NextHop.si_family = AF_INET6;
    row.NextHop.Ipv6.sin6_family = AF_INET6;
    row.Metric = 1;
    row.Protocol = MIB_IPPROTO_NETMGMT;
    row.Origin = NlroManual;

    const DWORD rc = CreateIpForwardEntry2(&row);
    if (rc != NO_ERROR && rc != ERROR_OBJECT_ALREADY_EXISTS) {
      err = "CreateIpForwardEntry2 IPv6 default route failed: " +
            std::to_string(rc);
      return false;
    }

    ForwardRoute saved{};
    saved.interface_index = if_index;
    saved.destination = row.DestinationPrefix.Prefix;
    saved.next_hop = row.NextHop;
    saved.metric = row.Metric;
    saved.prefix_length = 0;

    std::lock_guard<std::mutex> lock(mutex_);
    added_.push_back(saved);
    return true;
  }

  void Restore() {
    std::vector<ForwardRoute> copy;
    {
      std::lock_guard<std::mutex> lock(mutex_);
      copy = added_;
      added_.clear();
    }
    for (auto it = copy.rbegin(); it != copy.rend(); ++it) {
      MIB_IPFORWARD_ROW2 row{};
      row.InterfaceIndex = it->interface_index;
      row.DestinationPrefix.Prefix = it->destination;
      row.DestinationPrefix.PrefixLength =
          static_cast<UINT8>(it->prefix_length);
      row.NextHop = it->next_hop;
      row.Metric = it->metric;
      DeleteIpForwardEntry2(&row);
    }
  }

 private:
  std::mutex mutex_;
  std::vector<ForwardRoute> added_;
};

RouteTable g_routes;

// --- Process helpers ---------------------------------------------------------

bool RunHiddenCommand(const std::wstring& command, DWORD* exit_code) {
  STARTUPINFOW si{};
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = SW_HIDE;
  PROCESS_INFORMATION pi{};
  std::vector<wchar_t> cmd(command.begin(), command.end());
  cmd.push_back(L'\0');
  if (!CreateProcessW(nullptr, cmd.data(), nullptr, nullptr, FALSE,
                      CREATE_NO_WINDOW, nullptr, nullptr, &si, &pi)) {
    return false;
  }
  WaitForSingleObject(pi.hProcess, INFINITE);
  DWORD code = 1;
  GetExitCodeProcess(pi.hProcess, &code);
  CloseHandle(pi.hThread);
  CloseHandle(pi.hProcess);
  if (exit_code) *exit_code = code;
  return true;
}

bool SetInterfaceDns(const std::wstring& alias, const std::wstring& dns) {
  const std::wstring cmd =
      L"cmd.exe /c netsh interface ipv4 set dns name=\"" + alias +
      L"\" static " + dns + L" primary";
  return RunHiddenCommand(cmd, nullptr);
}

bool AddInterfaceDns(const std::wstring& alias, const std::wstring& dns,
                     int index) {
  const std::wstring cmd =
      L"cmd.exe /c netsh interface ipv4 add dns name=\"" + alias + L"\" " +
      dns + L" index=" + std::to_wstring(index);
  return RunHiddenCommand(cmd, nullptr);
}

bool SetInterfaceDnsList(const std::wstring& alias,
                         const std::vector<std::string>& servers) {
  if (servers.empty()) {
    return SetInterfaceDns(alias, L"1.1.1.1");
  }
  if (!SetInterfaceDns(alias, Utf8ToWide(servers.front()))) {
    return false;
  }
  for (size_t i = 1; i < servers.size(); ++i) {
    AddInterfaceDns(alias, Utf8ToWide(servers[i]), static_cast<int>(i + 1));
  }
  return true;
}

bool ClearInterfaceDns(const std::wstring& alias) {
  const std::wstring v4 =
      L"cmd.exe /c netsh interface ipv4 set dns name=\"" + alias +
      L"\" dhcp";
  const std::wstring v6 =
      L"cmd.exe /c netsh interface ipv6 set dnsservers name=\"" + alias +
      L"\" dhcp";
  RunHiddenCommand(v4, nullptr);
  return RunHiddenCommand(v6, nullptr);
}

bool AddInterfaceIpv6Address(const std::wstring& alias) {
  const std::wstring cmd =
      L"cmd.exe /c netsh interface ipv6 add address \"" + alias +
      L"\" fd00:10:10::2/64";
  return RunHiddenCommand(cmd, nullptr);
}

bool SetInterfaceIpv6Dns(const std::wstring& alias, const std::wstring& dns) {
  const std::wstring cmd =
      L"cmd.exe /c netsh interface ipv6 set dnsservers name=\"" + alias +
      L"\" static " + dns + L" validate=no";
  return RunHiddenCommand(cmd, nullptr);
}

bool LooksLikeIpv6Literal(const std::string& value) {
  return value.find(':') != std::string::npos;
}

// --- Adapter lookup ----------------------------------------------------------

bool FindAdapterByName(const std::wstring& name, NET_IFINDEX* out_index,
                       std::wstring* out_alias,
                       NET_IFINDEX* out_ipv6_index = nullptr) {
  ULONG size = 0;
  if (GetAdaptersAddresses(AF_UNSPEC, GAA_FLAG_INCLUDE_GATEWAYS, nullptr,
                           nullptr, &size) != ERROR_BUFFER_OVERFLOW) {
    return false;
  }
  std::vector<BYTE> buffer(size);
  auto* addrs = reinterpret_cast<IP_ADAPTER_ADDRESSES*>(buffer.data());
  if (GetAdaptersAddresses(AF_UNSPEC, GAA_FLAG_INCLUDE_GATEWAYS, nullptr,
                           addrs, &size) != NO_ERROR) {
    return false;
  }
  for (auto* a = addrs; a; a = a->Next) {
    if (!a->FriendlyName) continue;
    const std::wstring friendly(a->FriendlyName);
    if (friendly.find(name) != std::wstring::npos) {
      if (out_index) *out_index = a->IfIndex;
      if (out_alias) *out_alias = friendly;
      if (out_ipv6_index) {
        *out_ipv6_index =
            a->Ipv6IfIndex != 0 ? a->Ipv6IfIndex : a->IfIndex;
      }
      return true;
    }
  }
  return false;
}

bool ResolveHostToIpv4(const std::string& host, SOCKADDR_INET* out) {
  ADDRINFOW hints{};
  hints.ai_family = AF_INET;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_NUMERICHOST;
  const std::wstring whost = Utf8ToWide(host);
  ADDRINFOW* result = nullptr;
  if (GetAddrInfoW(whost.c_str(), nullptr, &hints, &result) != 0) {
    hints.ai_flags = 0;
    if (GetAddrInfoW(whost.c_str(), nullptr, &hints, &result) != 0) {
      return false;
    }
  }
  bool ok = false;
  for (ADDRINFOW* p = result; p; p = p->ai_next) {
    if (p->ai_family == AF_INET) {
      out->si_family = AF_INET;
      out->Ipv4 = *reinterpret_cast<sockaddr_in*>(p->ai_addr);
      ok = true;
      break;
    }
  }
  FreeAddrInfoW(result);
  return ok;
}

/// Parse "a.b.c.d" or "a.b.c.d/nn" into IPv4 + prefix length.
bool ParseExcludeSpec(const std::string& spec, SOCKADDR_INET* out,
                      ULONG* prefix_len) {
  std::string host = spec;
  ULONG plen = 32;
  const auto slash = spec.find('/');
  if (slash != std::string::npos) {
    host = spec.substr(0, slash);
    try {
      plen = static_cast<ULONG>(std::stoul(spec.substr(slash + 1)));
    } catch (...) {
      return false;
    }
    if (plen > 32) return false;
  }
  if (!ResolveHostToIpv4(host, out)) return false;
  *prefix_len = plen;
  return true;
}

// --- Tunnel session ----------------------------------------------------------

struct TunnelConfig {
  std::string socks_host = "127.0.0.1";
  int socks_port = 10808;
  std::string bypass_host;
  std::vector<std::string> exclude_routes;
  std::vector<std::string> dns_servers;
};

class TunnelSession {
 public:
  bool IsEstablished() const { return established_.load(); }

  void StartAsync(const TunnelConfig& cfg) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (established_.load() || starting_.load()) {
      g_events.Emit("established", "already running");
      return;
    }
    stop_requested_.store(false);
    starting_.store(true);
    std::thread([this, cfg]() { StartWorker(cfg); }).detach();
  }

  void StopAsync() {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!established_.load() && !starting_.load()) {
      g_events.Emit("stopped", "already stopped");
      return;
    }
    stop_requested_.store(true);
    std::thread([this]() { StopWorker(/*emit=*/true); }).detach();
  }

  /// Sync teardown for process exit (no Flutter EventChannel).
  void ShutdownSync() {
    stop_requested_.store(true);
    StopWorker(/*emit=*/false);
  }

 private:
  void StartWorker(TunnelConfig cfg) {
    if (!IsRunAsAdmin()) {
      Fail("Administrator privileges required for TUN");
      return;
    }

    EnsureKillOnCloseJob();

    const std::wstring exe_dir = GetExeDir();
    const std::wstring tun2socks = exe_dir + L"\\" + kTun2SocksExe;
    if (GetFileAttributesW(tun2socks.c_str()) == INVALID_FILE_ATTRIBUTES) {
      Fail("tun2socks.exe not found next to the app. Run: node tools/build_windows_tun2socks.mjs");
      return;
    }
    const std::wstring wintun = exe_dir + L"\\wintun.dll";
    if (GetFileAttributesW(wintun.c_str()) == INVALID_FILE_ATTRIBUTES) {
      Fail("wintun.dll not found next to the app. Run: node tools/setup_wintun.mjs");
      return;
    }

    // -device name becomes tun://name → Wintun friendly name.
    // Do NOT pass -interface GoodWinVPN: that flag selects the *physical* NIC
    // for outbound binds, not the TUN adapter name.
    const std::string proxy =
        "socks5://" + cfg.socks_host + ":" + std::to_string(cfg.socks_port);
    std::wstring cmd = L"\"" + tun2socks + L"\" -device " + kAdapterDevice +
                       L" -proxy " + Utf8ToWide(proxy) + L" -loglevel info";

    STARTUPINFOW si{};
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;
    PROCESS_INFORMATION pi{};
    std::vector<wchar_t> mutable_cmd(cmd.begin(), cmd.end());
    mutable_cmd.push_back(L'\0');
    if (!CreateProcessW(nullptr, mutable_cmd.data(), nullptr, nullptr, FALSE,
                        CREATE_NO_WINDOW, nullptr, exe_dir.c_str(), &si,
                        &pi)) {
      Fail("CreateProcess tun2socks failed");
      return;
    }

    if (g_kill_job != nullptr) {
      AssignProcessToJobObject(g_kill_job, pi.hProcess);
    }

    {
      std::lock_guard<std::mutex> lock(mutex_);
      tun_process_ = pi.hProcess;
      CloseHandle(pi.hThread);
    }

    NET_IFINDEX if_index = 0;
    NET_IFINDEX ipv6_if_index = 0;
    std::wstring alias;
    bool found = false;
    for (int i = 0; i < kPollMax; ++i) {
      if (stop_requested_.load()) {
        Fail("TUN start cancelled");
        StopWorker(/*emit=*/false);
        return;
      }
      if (WaitForSingleObject(pi.hProcess, 0) == WAIT_OBJECT_0) {
        Fail("tun2socks exited early");
        ClearTunProcessHandle();
        return;
      }
      if (FindAdapterByName(kAdapterName, &if_index, &alias, &ipv6_if_index)) {
        found = true;
        break;
      }
      Sleep(kPollMs);
    }
    if (!found) {
      Fail("Wintun adapter did not appear in time");
      StopWorker(/*emit=*/false);
      return;
    }

    if (!cfg.bypass_host.empty()) {
      SOCKADDR_INET server{};
      if (ResolveHostToIpv4(cfg.bypass_host, &server)) {
        server.si_family = AF_INET;
        std::string bypass_err;
        if (!g_routes.AddBypassRoute(server, bypass_err)) {
          Fail(bypass_err);
          StopWorker(/*emit=*/false);
          return;
        }
      }
    }

    for (const auto& spec : cfg.exclude_routes) {
      SOCKADDR_INET dest{};
      ULONG plen = 32;
      if (!ParseExcludeSpec(spec, &dest, &plen)) {
        Fail("invalid exclude route: " + spec);
        StopWorker(/*emit=*/false);
        return;
      }
      std::string excl_err;
      if (!g_routes.AddExcludeRoute(dest, plen, excl_err)) {
        Fail(excl_err + " (" + spec + ")");
        StopWorker(/*emit=*/false);
        return;
      }
    }

    std::string route_err;
    if (!g_routes.AddDefaultRouteViaInterface(if_index, route_err)) {
      Fail(route_err);
      StopWorker(/*emit=*/false);
      return;
    }

    AddInterfaceIpv6Address(alias);
    const NET_IFINDEX v6_index =
        ipv6_if_index != 0 ? ipv6_if_index : if_index;
    std::string ipv6_route_err;
    g_routes.AddDefaultIpv6RouteViaInterface(v6_index, ipv6_route_err);

    SetInterfaceDnsList(alias, cfg.dns_servers);
    std::string v6_dns = "2606:4700:4700::1111";
    for (const auto& server : cfg.dns_servers) {
      if (LooksLikeIpv6Literal(server)) {
        v6_dns = server;
        break;
      }
    }
    SetInterfaceIpv6Dns(alias, Utf8ToWide(v6_dns));

    starting_.store(false);
    established_.store(true);
    g_events.Emit("established");
  }

  void ClearTunProcessHandle() {
    std::lock_guard<std::mutex> lock(mutex_);
    if (tun_process_) {
      CloseHandle(tun_process_);
      tun_process_ = nullptr;
    }
  }

  void StopWorker(bool emit) {
    HANDLE proc = nullptr;
    {
      std::lock_guard<std::mutex> lock(mutex_);
      proc = tun_process_;
      tun_process_ = nullptr;
    }
    if (proc) {
      TerminateProcess(proc, 0);
      WaitForSingleObject(proc, 5000);
      CloseHandle(proc);
    }

    NET_IFINDEX if_index = 0;
    std::wstring alias;
    if (FindAdapterByName(kAdapterName, &if_index, &alias)) {
      ClearInterfaceDns(alias);
    }

    g_routes.Restore();
    starting_.store(false);
    established_.store(false);
    if (emit) {
      g_events.Emit("stopped");
    }
  }

  void Fail(const std::string& message) {
    starting_.store(false);
    established_.store(false);
    g_events.Emit("failed", message);
  }

  std::mutex mutex_;
  HANDLE tun_process_ = nullptr;
  std::atomic<bool> established_{false};
  std::atomic<bool> starting_{false};
  std::atomic<bool> stop_requested_{false};
};

TunnelSession g_session;

void ShutdownVpnTunnel() { g_session.ShutdownSync(); }

// --- Plugin registration -----------------------------------------------------

void RegisterVpnTunnelPluginImpl(flutter::BinaryMessenger* messenger) {

  auto event_channel =
      std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
          messenger, "website.goodwin.vpn/windows/events",
          &flutter::StandardMethodCodec::GetInstance());

  event_channel->SetStreamHandler(
      std::make_unique<flutter::StreamHandlerFunctions<flutter::EncodableValue>>(
          [](const flutter::EncodableValue*,
             std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&&
                 events)
              -> std::unique_ptr<
                  flutter::StreamHandlerError<flutter::EncodableValue>> {
            g_events.SetSink(std::move(events));
            return nullptr;
          },
          [](const flutter::EncodableValue*)
              -> std::unique_ptr<
                  flutter::StreamHandlerError<flutter::EncodableValue>> {
            g_events.ClearSink();
            return nullptr;
          }));

  auto method_channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          messenger, "website.goodwin.vpn/windows",
          &flutter::StandardMethodCodec::GetInstance());

  method_channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
             result) {
        const std::string& method = call.method_name();

        if (method == "prepare") {
          result->Success(flutter::EncodableValue(IsRunAsAdmin()));
          return;
        }
        if (method == "requestElevation") {
          result->Success(flutter::EncodableValue(RequestElevation()));
          return;
        }
        if (method == "isEstablished") {
          result->Success(flutter::EncodableValue(g_session.IsEstablished()));
          return;
        }
        if (method == "nativeLibraryDir") {
          result->Success(
              flutter::EncodableValue(WideToUtf8(GetExeDir())));
          return;
        }
        if (method == "restartProcess") {
          RestartProcess();
          result->Success();
          return;
        }
        if (method == "startVpn") {
          TunnelConfig cfg;
          const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
          if (args) {
            auto host_it = args->find(flutter::EncodableValue("socksHost"));
            if (host_it != args->end()) {
              if (const auto* v = std::get_if<std::string>(&host_it->second)) {
                cfg.socks_host = *v;
              }
            }
            auto port_it = args->find(flutter::EncodableValue("socksPort"));
            if (port_it != args->end()) {
              if (const auto* v = std::get_if<int32_t>(&port_it->second)) {
                cfg.socks_port = *v;
              }
            }
            auto bypass_it = args->find(flutter::EncodableValue("bypassHost"));
            if (bypass_it != args->end()) {
              if (const auto* v = std::get_if<std::string>(&bypass_it->second)) {
                cfg.bypass_host = *v;
              }
            }
            auto excl_it = args->find(flutter::EncodableValue("excludeRoutes"));
            if (excl_it != args->end()) {
              if (const auto* list =
                      std::get_if<flutter::EncodableList>(&excl_it->second)) {
                for (const auto& item : *list) {
                  if (const auto* v = std::get_if<std::string>(&item)) {
                    if (!v->empty()) cfg.exclude_routes.push_back(*v);
                  }
                }
              }
            }
            auto dns_it = args->find(flutter::EncodableValue("dnsServers"));
            if (dns_it != args->end()) {
              if (const auto* list =
                      std::get_if<flutter::EncodableList>(&dns_it->second)) {
                for (const auto& item : *list) {
                  if (const auto* v = std::get_if<std::string>(&item)) {
                    if (!v->empty()) cfg.dns_servers.push_back(*v);
                  }
                }
              }
            }
          }
          g_session.StartAsync(cfg);
          result->Success(flutter::EncodableValue(true));
          return;
        }
        if (method == "stopVpn") {
          g_session.StopAsync();
          result->Success(flutter::EncodableValue(true));
          return;
        }

        result->NotImplemented();
      });

  // Keep channels alive for app lifetime.
  static std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>>
      s_event_channel;
  static std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      s_method_channel;
  s_event_channel = std::move(event_channel);
  s_method_channel = std::move(method_channel);
}

void RegisterVpnTunnelPlugin(flutter::FlutterEngine* engine) {
  auto registrar = engine->GetRegistrarForPlugin("VpnTunnelPlugin");
  if (registrar) {
    FlutterDesktopPluginRegistrarRegisterTopLevelWindowProcDelegate(
        registrar, VpnWindowProc, nullptr);
    FlutterDesktopViewRef view =
        FlutterDesktopPluginRegistrarGetView(registrar);
    if (view) {
      // EventChannel WindowProc delegates run on the *top-level* HWND.
      // The Flutter view HWND is a child — PostMessage must target the root.
      const HWND view_hwnd = FlutterDesktopViewGetHWND(view);
      const HWND root =
          view_hwnd != nullptr ? GetAncestor(view_hwnd, GA_ROOT) : nullptr;
      g_events.SetPlatformWindow(root != nullptr ? root : view_hwnd);
    }
  }
  RegisterVpnTunnelPluginImpl(engine->messenger());
}
