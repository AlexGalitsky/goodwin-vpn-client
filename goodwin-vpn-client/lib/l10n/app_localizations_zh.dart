// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => '首页';

  @override
  String get navProfiles => '配置';

  @override
  String get navRules => '规则';

  @override
  String get navLogs => '日志';

  @override
  String get navSettings => '设置';

  @override
  String get connectVpn => '连接 VPN';

  @override
  String get disconnectVpn => '断开 VPN';

  @override
  String get noProfile => '没有配置';

  @override
  String get addProfileToConnect => '添加配置后再连接';

  @override
  String get addProfileToConnectHint => '在「配置」中导入分享链接，然后在此点击连接。';

  @override
  String get addProfile => '添加配置';

  @override
  String get networkStatus => '网络状态';

  @override
  String get tapToDisconnect => '点按断开';

  @override
  String get tapToConnect => '点按连接';

  @override
  String get statNode => '节点';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => '时长';

  @override
  String get sessionLogs => '会话日志';

  @override
  String get noLinesYet => '暂无记录';

  @override
  String logLinesCount(int count) {
    return '$count 行';
  }

  @override
  String get uacDeclined => '已拒绝 UAC 提示';

  @override
  String get statusOffline => '已断开';

  @override
  String get statusConnecting => '正在连接';

  @override
  String get statusConnected => '已连接';

  @override
  String get statusDisconnecting => '正在断开';

  @override
  String get statusError => '错误';

  @override
  String get switchProfile => '切换配置';

  @override
  String get manageProfiles => '管理配置';

  @override
  String get routing => '路由';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · 在规则中更改';
  }

  @override
  String get routingModeGlobal => '全局';

  @override
  String get routingModeRules => '规则';

  @override
  String get routingModeDirect => '直连';

  @override
  String get homeReadyTitle => '已断开';

  @override
  String get homeReadyTunnel => '连接将在此设备上启动系统 VPN';

  @override
  String get homeReadySocks => '此系统尚无系统 VPN — 连接为本地 SOCKS 代理';

  @override
  String get homeBusyTitle => '正在连接';

  @override
  String get homeBusyTunnel => '正在向系统申请 VPN 隧道';

  @override
  String get homeBusySocks => '正在启动本地 SOCKS 代理';

  @override
  String get homeConnectedTunnelTitle => '系统 VPN';

  @override
  String get homeConnectedTunnelSubtitle => '设备流量经过隧道，而非家庭 IP';

  @override
  String get homeConnectedSocksTitle => '本地 SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      '此系统没有系统隧道。应用需使用 127.0.0.1:10808 — 你的 IP 未被隐藏';

  @override
  String get revokedTitle => '订阅链接已被撤销';

  @override
  String get revokedBody => '请在「配置」中粘贴新 URL。旧节点会保留，直到你导入替换项。';

  @override
  String get openProfiles => '打开配置';

  @override
  String get elevationTitle => '需要管理员权限';

  @override
  String get runAsAdministrator => '以管理员身份运行';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '已用 $used · VLESS+Hy2';
  }

  @override
  String get quotaExpired => '已过期';

  @override
  String quotaDaysLeft(int days) {
    return '剩余 $days 天';
  }

  @override
  String get quotaScopeNote => 'VLESS+Hy2 流量 — TrustTunnel 不计入';

  @override
  String get profilesEyebrow => '你的网络';

  @override
  String get profilesTitle => '服务器配置';

  @override
  String get tooltipPinging => '正在 Ping…';

  @override
  String get tooltipCheckPing => '检测 Ping';

  @override
  String get noProfilesToPing => '没有可 Ping 的配置';

  @override
  String get tooltipImportLink => '导入链接或订阅';

  @override
  String get searchServersHint => '搜索服务器或协议';

  @override
  String get smartConnect => '智能连接';

  @override
  String get smartConnectSubtitle => '首页连接会选用当前订阅中 Ping 最低的节点';

  @override
  String get emptyProfiles => '还没有已保存的配置。\n请导入分享链接或 https:// 订阅 URL。';

  @override
  String get noMatches => '无匹配项';

  @override
  String get pinging => '正在 Ping';

  @override
  String get fastest => '最快';

  @override
  String get delete => '删除';

  @override
  String get deleteProfileConfirm => '删除此配置？';

  @override
  String get deleteSubscriptionConfirm => '移除此订阅及其已保存的节点？';

  @override
  String updatedSubscription(String name) {
    return '已更新 $name';
  }

  @override
  String get importProfile => '导入配置';

  @override
  String get nameOptional => '名称（可选）';

  @override
  String get importLinkLabel => '分享链接或 https:// 订阅 URL';

  @override
  String get paste => '粘贴';

  @override
  String get scanQr => '扫描二维码';

  @override
  String get cancel => '取消';

  @override
  String get import => '导入';

  @override
  String get unrecognizedShareLink => '无法识别的分享链接';

  @override
  String get editProfile => '编辑配置';

  @override
  String get name => '名称';

  @override
  String get shareLink => '分享链接';

  @override
  String get apply => '应用';

  @override
  String get importedManual => '已导入';

  @override
  String get subscriptionFallback => '订阅';

  @override
  String get revokedKeepNodes => '链接已撤销 — 请粘贴新 URL。节点未被清除。';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count 个节点';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个节点',
      one: '1 个节点',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => '刷新订阅';

  @override
  String get removeSubscription => '移除订阅';

  @override
  String get nothingToImport => '没有可导入的内容';

  @override
  String get subscriptionImported => '订阅已导入';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '已导入 $name（$count 个节点）';
  }

  @override
  String get profileImported => '配置已导入';

  @override
  String get settingsEyebrow => '应用';

  @override
  String get settingsTitle => '设置';

  @override
  String get appearance => '外观';

  @override
  String get colorTheme => '颜色主题';

  @override
  String get colorThemeSubtitle => '纸白浅色与海军深蓝。系统跟随手机。';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '系统';

  @override
  String get language => '语言';

  @override
  String get languageSubtitle => '英语和俄语。系统跟随手机。';

  @override
  String get localeSystem => '系统';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => '通用';

  @override
  String get advancedMode => '高级模式';

  @override
  String get advancedModeSubtitle => '日志标签页与进阶选项';

  @override
  String get reconnectOnLaunch => '启动时重连';

  @override
  String get reconnectOnLaunchSubtitle => '若系统 VPN 未连接，则启动上次配置';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => '系统';

  @override
  String get dnsCustom => '自定义';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS 服务器 / DoH URL';

  @override
  String get dnsSaved => 'DNS 偏好已保存';

  @override
  String get saveDns => '保存 DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Android 设置中的 Always-on VPN。此处开关本身并不能完全防泄漏。';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      '下次 TrustTunnel 连接时启用插件防泄漏。重启后仍需 Always-on。';

  @override
  String get killSwitchSubtitleIos => '隧道中断时会重连。推送、Watch 和 iMessage 仍可到达。';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      '此次 TrustTunnel 会话的插件防泄漏。断开连接会先将其关闭，然后才能启动 SOCKS VPN。';

  @override
  String get killSwitchAndroidEnableTitle => '开启系统防泄漏保护';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. 在下一屏点按 Goodwin VPN（SOCKS 或 TrustTunnel）。\n2. 打开 Always-on VPN。\n3. 打开「阻止不使用 VPN 的连接」。\n4. 返回此处并点按连接。\n\n应用无法自行切换这些 Android 开关。TrustTunnel 也会在下次连接时使用插件防泄漏。';

  @override
  String get killSwitchAndroidDisableTitle => '请先关闭 Always-on';

  @override
  String get killSwitchAndroidDisableBody =>
      '在 Android VPN 设置中，关闭 Goodwin 的 Always-on VPN 和「阻止不使用 VPN 的连接」。否则断开后隧道会重新连上。';

  @override
  String get killSwitchOpenSettings => '打开 VPN 设置';

  @override
  String get killSwitchDisconnectTitle => 'Always-on 可能会重连';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN 可能在断开后重新拉起隧道。若希望网络完全开放，请在系统 VPN 设置中关闭 Always-on。';

  @override
  String get killSwitchDisconnectConfirm => '断开';

  @override
  String get coreTuning => '核心调优';

  @override
  String get advancedDangerTooltip => '高级 — 可能导致无法联网';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Vision 下跳过 — 典型 VLESS 仍可启动';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'REALITY 下跳过 — 仅 TLS hello';

  @override
  String get dnsHintWithTuning =>
      '连接时 DNS IP 应用于系统 TUN。DoH 写入 Xray JSON；TUN 仍使用引导 IP。Mux / Fragment：仅限 Xray。';

  @override
  String get dnsHintSimple => '连接时 DNS IP 应用于系统 TUN。';

  @override
  String get backup => '备份';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => '导出备份文件';

  @override
  String get exportBackupSubtitle => '配置与订阅。可选密码会加密文件';

  @override
  String get importBackup => '导入备份文件';

  @override
  String get importBackupSubtitle => '合并到当前目录';

  @override
  String get copyJsonClipboard => '复制 JSON 到剪贴板';

  @override
  String get copyJsonClipboardSubtitle => '未加密 — 能读取剪贴板的人都能看到链接';

  @override
  String get copiedEmptyProfiles => '已复制空配置列表';

  @override
  String copiedProfilesJson(int count) {
    return '已将 $count 个配置复制为未加密 JSON';
  }

  @override
  String get exportBackupTitle => '导出备份';

  @override
  String get exportBackupPasswordHint => '留空则为普通 JSON 文件。填写密码将使用 AES-256-GCM。';

  @override
  String get backupFileSaved => '备份文件已保存';

  @override
  String get encryptedBackupSaved => '加密备份文件已保存';

  @override
  String get encryptedBackupTitle => '加密备份';

  @override
  String get encryptedBackupHint => '输入导出时使用的密码。';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '已导入 $profiles 个配置和 $subs 个订阅';
  }

  @override
  String get passwordOptional => '密码（可选）';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get passwordsDoNotMatch => '两次密码不一致';

  @override
  String get continueAction => '继续';

  @override
  String get about => '关于';

  @override
  String get aboutSubtitle => '用于自有服务器的 VPN 客户端';

  @override
  String get aboutHubSubtitle => 'Version, privacy, support';

  @override
  String get subscriptionAbout => 'About subscription';

  @override
  String get subscriptionAccount => 'Account';

  @override
  String get subscriptionHost => 'Host';

  @override
  String get subscriptionLastFetched => 'Last updated';

  @override
  String get subscriptionNeverFetched => 'Not updated yet';

  @override
  String subscriptionUpdateInterval(int hours) {
    return 'Update every ${hours}h';
  }

  @override
  String get subscriptionQuota => 'Traffic';

  @override
  String get subscriptionExpires => 'Expires';

  @override
  String get subscriptionNoUserinfo => 'No quota or expiry from the panel yet';

  @override
  String get subscriptionDevices => 'Devices';

  @override
  String subscriptionDevicesUsedOfLimit(int used, int limit) {
    return '$used / $limit devices';
  }

  @override
  String subscriptionDeviceLimitOnly(int limit) {
    return 'Up to $limit devices';
  }

  @override
  String subscriptionDeviceCountOnly(int count) {
    return '$count devices reported';
  }

  @override
  String expireWarningSoon(int days) {
    return 'Subscription ends in ${days}d';
  }

  @override
  String get expireWarningExpired => 'Subscription expired';

  @override
  String get privacy => '隐私';

  @override
  String get privacySubtitle => '相机、VPN、设备上的密钥、剪贴板备份';

  @override
  String get privacyWhatTitle => '本应用使用的内容';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN 是本地客户端。此构建没有 Goodwin 账号服务器，也没有分析 SDK。';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      '在具备系统隧道的平台上，设备流量会发往你导入的分享链接中的节点。本应用不运营 Goodwin 代理。若此系统没有系统隧道，连接仅会在 127.0.0.1:10808 启动本地 SOCKS 代理。';

  @override
  String get privacySecretsTitle => '配置与密钥';

  @override
  String get privacySecretsBody =>
      '分享链接、已保存配置和订阅 URL 存储在本设备上，使用 AES-256-GCM 加密。加密密钥位于系统 keystore / keychain 中，不与密文放在一起。若平台 keystore 不可用，应用无法加密保存这些值。';

  @override
  String get privacyCameraTitle => '相机';

  @override
  String get privacyCameraBody => '相机仅用于扫描包含分享链接或订阅 URL 的二维码。画面不会上传。';

  @override
  String get privacyClipboardTitle => '剪贴板与备份';

  @override
  String get privacyClipboardBody =>
      '复制 JSON 到剪贴板会写入未加密备份。能读取剪贴板的人都能看到这些链接。文件导出可使用可选密码（AES-256-GCM）。';

  @override
  String get privacyAppsTitle => '已安装应用（Android）';

  @override
  String get privacyAppsBody => '按应用分流会读取设备上的启动器应用列表，以便将应用排除出 VPN。该列表留在设备上。';

  @override
  String get privacyOpenWeb => '打开隐私政策';

  @override
  String get privacyOpenFailed => '无法打开隐私政策 URL';

  @override
  String get rulesEyebrow => '流量策略';

  @override
  String get rulesTitle => '路由规则';

  @override
  String get reset => '重置';

  @override
  String get resetRulesConfirm => '将路由重置为默认值？';

  @override
  String get mode => '模式';

  @override
  String get modeHintGlobalRich => '所有匹配流量 → 代理（Xray 默认）。';

  @override
  String get modeHintGlobalSimple => '推荐用于 Hysteria2。';

  @override
  String get modeHintGlobalTrustTunnel => '除 Always-exclude 外，全部流量走隧道。';

  @override
  String get modeHintRules => '预设 + 自定义规则；未匹配 → 代理（Xray）。';

  @override
  String get modeHintRulesTrustTunnel =>
      '直连域名/CIDR 会成为 TrustTunnel 排除项。Block 会被跳过。未匹配流量仍留在隧道中。';

  @override
  String get modeHintDirect => '全部 → freedom。TUN 保持开启（仅 Xray）。';

  @override
  String get presets => '预设';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => '拦截广告（有限）';

  @override
  String get presetBlockAdsPack => '拦截广告';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle => '内置少量主机列表 → block（Xray；非 geosite）';

  @override
  String get presetBlockAdsPackXray => '服务广告包 → block（非 geosite）';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      '服务广告包 → TrustTunnel 排除（无插件 block）';

  @override
  String get presetBypassLan => '绕过局域网 / 私网';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / 链路本地 CIDR → TUN 排除（非地区/geoip）';

  @override
  String get presetBypassLanAndroid13 => '绕过局域网需要 Android 13+。此版本上 CIDR 排除无效。';

  @override
  String get presetProtectBanking => '保护银行应用';

  @override
  String get presetProtectBankingSubtitle => '已安装的银行应用跳过 TUN（Android 按应用）';

  @override
  String get appsSkipVpn => '跳过 VPN 的应用';

  @override
  String get appsSkipVpnEmpty => '「保护银行应用」之外的可选项';

  @override
  String appsSkipVpnSelected(int count) {
    return '已选 $count 个 · 下次连接时生效';
  }

  @override
  String get switchToRulesForPresets => '切换到规则模式以使用预设。';

  @override
  String get alwaysExcludeMerged =>
      'Always-exclude CIDR 会在连接时与 IP 直连规则合并，适用于每个后端。请在下方高级中编辑。';

  @override
  String get alwaysExcludeCidr => '始终排除（CIDR）';

  @override
  String get alwaysExcludeHint => '每行一个 IP 或 CIDR。下次连接时生效。';

  @override
  String get cidrHint => '每行一个 IP 或 CIDR\n例如 10.0.0.0/8';

  @override
  String get customRules => '自定义规则';

  @override
  String get customRulesHint =>
      '域名后缀、IP 或 CIDR → proxy / direct / block。连接时应用于 Xray。IP 直连也会写入系统排除。';

  @override
  String get customRulesHintTrustTunnel =>
      '域名或 CIDR → proxy（留在隧道）或 direct（排除）。不提供 Block。无 geosite。';

  @override
  String get matcher => '匹配项';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => '添加规则';

  @override
  String get noCustomRules => '还没有自定义规则';

  @override
  String osExclude(String action) {
    return '$action · 系统排除';
  }

  @override
  String get routingRuleBlockSkipped => 'block · 在 TrustTunnel 上跳过（无插件 block）';

  @override
  String get enableAdvancedForRouting => '在设置中启用高级模式以获得更多路由控件。';

  @override
  String get searchApps => '搜索应用';

  @override
  String get save => '保存';

  @override
  String get routingBannerXray => 'Xray 配置：全局 / 规则 / 直连以及域名规则在连接时生效。';

  @override
  String get routingBannerHysteria =>
      'Hysteria2 配置：域名/block 规则和 Xray 直连不会应用。请使用全局；Always-exclude CIDR 和 IP 直连仍会合并进 TUN。';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel：规则中的直连域名/CIDR 会成为排除项。Block 会被跳过（无插件 block）。直连模式不会应用。Always-exclude 仍会合并。按应用分流仅限 SOCKS。Kill Switch 在下次 TrustTunnel 连接时生效。';

  @override
  String get routingBannerUnknown => '选择或连接配置以查看适用的路由功能。';

  @override
  String get logsEyebrow => '诊断';

  @override
  String get logsTitle => '日志';

  @override
  String get copyFiltered => '复制筛选结果';

  @override
  String get clear => '清除';

  @override
  String get logCopied => '日志已复制';

  @override
  String get logsHint => '核心控制台。颜色按启发式（error/warn 关键词）。';

  @override
  String get filterHint => '筛选…';

  @override
  String get logsAll => '全部';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => '还没有日志行';

  @override
  String get noMatchesForFilter => '筛选无匹配';

  @override
  String get vpnConsole => 'VPN 控制台';

  @override
  String get logsSheetEmpty => '暂无记录。正在等待数据流…';

  @override
  String get copy => '复制';

  @override
  String get openLogs => '打开日志';

  @override
  String get tapToRetry => '点按重试';

  @override
  String get homeErrorTitle => '无法连接';

  @override
  String get homeErrorTunnel => '隧道失败 — 点按重试';

  @override
  String get homeErrorSocks => '本地 SOCKS 失败 — 点按重试';

  @override
  String get activeProfile => '当前配置';

  @override
  String get socksInbound => '本地 SOCKS';

  @override
  String get socksInboundSubtitle =>
      '将用户名和密码留空，每次连接会生成随机凭据。其他应用：127.0.0.1 加上这些凭据。';

  @override
  String get socksPort => '端口';

  @override
  String get socksUsername => '用户名';

  @override
  String get socksPassword => '密码';

  @override
  String get saveSocks => '保存 SOCKS';

  @override
  String get socksSaved => 'SOCKS 已保存';

  @override
  String get killSwitchAndroidConfirmTitle => '已打开 Always-on 了吗？';

  @override
  String get killSwitchAndroidConfirmBody =>
      '应用无法切换 Android VPN 开关。仅在为 GoodWin VPN 启用 Always-on 和「阻止不使用 VPN 的连接」之后，再在此处打开 Kill Switch。';

  @override
  String get killSwitchAndroidConfirmYes => '是，已打开';

  @override
  String get killSwitchAndroidConfirmNo => '还没有';

  @override
  String get killSwitchIosDisconnectFailed => '无法关闭按需连接。断开可能不会保持，请重试。';

  @override
  String get support => '支持';

  @override
  String get supportSubtitle => '打开运营商支持页面';

  @override
  String get supportUnavailable => '此订阅中没有支持 URL';

  @override
  String get licenses => '开源许可证';

  @override
  String get licensesSubtitle => '本应用捆绑的核心与库';

  @override
  String get licensesBody =>
      '本应用捆绑 Xray-core、Hysteria 2、hev-socks5-tunnel、TrustTunnel、Flutter 和 Inter（SIL OFL）。源码与许可证见各项目仓库。';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingDone => '开始使用';

  @override
  String get onboardingServerTitle => '你的服务器';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN 是导入节点所用的客户端。没有 Goodwin 云代理。请在「配置」中添加分享链接或 https 订阅 URL。';

  @override
  String get onboardingVpnTitle => '系统 VPN';

  @override
  String get onboardingVpnBody =>
      '连接会请求系统添加 VPN 配置。该对话框来自 Android 或 iOS，而非本应用。随后流量会发往你所选配置中的节点。';

  @override
  String get onboardingCameraTitle => '用相机扫二维码';

  @override
  String get onboardingCameraBody => '相机为可选项，仅扫描含分享链接或订阅 URL 的二维码。画面留在设备上。';

  @override
  String get vpnExplainerTitle => '系统 VPN 权限';

  @override
  String get vpnExplainerBody => '下一屏是系统 VPN 对话框。仅在你希望此设备经导入节点发送流量时再允许。';

  @override
  String get vpnExplainerContinue => '继续';

  @override
  String get cameraExplainerTitle => '相机权限';

  @override
  String get cameraExplainerBody => '下一屏可能会请求相机。仅用于扫描配置二维码。画面不会上传。';

  @override
  String get cameraExplainerContinue => '扫描二维码';

  @override
  String get importLinkHint => '粘贴分享链接或 https:// 订阅 URL。本应用不托管代理。';
}
