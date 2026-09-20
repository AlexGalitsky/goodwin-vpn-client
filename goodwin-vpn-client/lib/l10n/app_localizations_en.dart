// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Home';

  @override
  String get navProfiles => 'Profiles';

  @override
  String get navRules => 'Rules';

  @override
  String get navLogs => 'Logs';

  @override
  String get navSettings => 'Settings';

  @override
  String get connectVpn => 'Connect VPN';

  @override
  String get disconnectVpn => 'Disconnect VPN';

  @override
  String get noProfile => 'No profile';

  @override
  String get addProfileToConnect => 'Add a profile to connect';

  @override
  String get addProfileToConnectHint =>
      'Import a share link on Profiles, then tap Connect here.';

  @override
  String get addProfile => 'Add profile';

  @override
  String get networkStatus => 'NETWORK STATUS';

  @override
  String get tapToDisconnect => 'Tap to disconnect';

  @override
  String get tapToConnect => 'Tap to connect';

  @override
  String get statNode => 'Node';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Uptime';

  @override
  String get sessionLogs => 'Session logs';

  @override
  String get noLinesYet => 'No lines yet';

  @override
  String logLinesCount(int count) {
    return '$count lines';
  }

  @override
  String get uacDeclined => 'UAC prompt was declined';

  @override
  String get statusOffline => 'disconnected';

  @override
  String get statusConnecting => 'connecting';

  @override
  String get statusConnected => 'connected';

  @override
  String get statusDisconnecting => 'disconnecting';

  @override
  String get statusError => 'error';

  @override
  String get switchProfile => 'Switch profile';

  @override
  String get manageProfiles => 'Manage profiles';

  @override
  String get routing => 'Routing';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · change in Rules';
  }

  @override
  String get routingModeGlobal => 'Global';

  @override
  String get routingModeRules => 'Rules';

  @override
  String get routingModeDirect => 'Direct';

  @override
  String get homeReadyTitle => 'Disconnected';

  @override
  String get homeReadyTunnel => 'Connect starts a system VPN on this device';

  @override
  String get homeReadySocks =>
      'This OS has no system VPN yet — Connect is a local SOCKS proxy';

  @override
  String get homeBusyTitle => 'Connecting';

  @override
  String get homeBusyTunnel => 'Asking the OS for a VPN tunnel';

  @override
  String get homeBusySocks => 'Starting a local SOCKS proxy';

  @override
  String get homeConnectedTunnelTitle => 'System VPN';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Device traffic goes through the tunnel, not your home IP';

  @override
  String get homeConnectedSocksTitle => 'Local SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      'No system tunnel on this OS. Apps must use 127.0.0.1:10808 — your IP is not hidden';

  @override
  String get revokedTitle => 'Subscription link was revoked';

  @override
  String get revokedBody =>
      'Paste a new URL on Profiles. Old nodes stay until you import a replacement.';

  @override
  String get openProfiles => 'Open Profiles';

  @override
  String get elevationTitle => 'Administrator rights required';

  @override
  String get runAsAdministrator => 'Run as administrator';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used used · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'expired';

  @override
  String quotaDaysLeft(int days) {
    return '${days}d left';
  }

  @override
  String get quotaScopeNote => 'VLESS+Hy2 traffic — TrustTunnel uncounted';

  @override
  String get profilesEyebrow => 'Your network';

  @override
  String get profilesTitle => 'Server profiles';

  @override
  String get tooltipPinging => 'Pinging…';

  @override
  String get tooltipCheckPing => 'Check ping';

  @override
  String get noProfilesToPing => 'No profiles to ping';

  @override
  String get tooltipImportLink => 'Import link or subscription';

  @override
  String get searchServersHint => 'Search servers or protocols';

  @override
  String get smartConnect => 'Smart connect';

  @override
  String get smartConnectSubtitle =>
      'Home Connect uses the lowest-ping node in the current subscription';

  @override
  String get emptyProfiles =>
      'No saved profiles yet.\nImport a share link or an https:// subscription URL.';

  @override
  String get noMatches => 'No matches';

  @override
  String get pinging => 'pinging';

  @override
  String get fastest => 'fastest';

  @override
  String get delete => 'Delete';

  @override
  String get deleteProfileConfirm => 'Delete this profile?';

  @override
  String get deleteSubscriptionConfirm =>
      'Remove this subscription and its saved nodes?';

  @override
  String updatedSubscription(String name) {
    return 'Updated $name';
  }

  @override
  String get importProfile => 'Import profile';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get importLinkLabel => 'Share link or https:// subscription URL';

  @override
  String get paste => 'Paste';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get cancel => 'Cancel';

  @override
  String get import => 'Import';

  @override
  String get unrecognizedShareLink => 'Unrecognized share link';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get name => 'Name';

  @override
  String get shareLink => 'Share link';

  @override
  String get apply => 'Apply';

  @override
  String get importedManual => 'Imported';

  @override
  String get subscriptionFallback => 'Subscription';

  @override
  String get revokedKeepNodes =>
      'Link revoked — paste a new URL. Nodes were not cleared.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count nodes';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nodes',
      one: '1 node',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Refresh subscription';

  @override
  String get removeSubscription => 'Remove subscription';

  @override
  String get nothingToImport => 'Nothing to import';

  @override
  String get subscriptionImported => 'Subscription imported';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return 'Imported $name ($count nodes)';
  }

  @override
  String get profileImported => 'Profile imported';

  @override
  String get settingsEyebrow => 'Application';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get colorTheme => 'Color theme';

  @override
  String get colorThemeSubtitle =>
      'Paper light and navy dark. System follows the phone.';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle =>
      'English and Russian. System follows the phone.';

  @override
  String get localeSystem => 'System';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'General';

  @override
  String get advancedMode => 'Advanced mode';

  @override
  String get advancedModeSubtitle => 'Logs tab and power-user depth';

  @override
  String get reconnectOnLaunch => 'Reconnect on launch';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Start the last profile if the OS VPN is down';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'System';

  @override
  String get dnsCustom => 'Custom';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS server / DoH URL';

  @override
  String get dnsSaved => 'DNS preference saved';

  @override
  String get saveDns => 'Save DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Always-on VPN in Android settings. The toggle here is not leak-proof by itself.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Leak-lock on the next connect. Always-on still needed after reboot.';

  @override
  String get killSwitchSubtitleIos =>
      'Reconnects if the tunnel drops. Push, Watch and iMessage stay reachable.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Leak-lock for this session. Disconnect turns it off before another VPN can start.';

  @override
  String get killSwitchAndroidEnableTitle => 'Turn on system leak protection';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. In the next screen, tap GoodWin VPN.\n2. Turn on Always-on VPN.\n3. Turn on Block connections without VPN.\n4. Return here and tap Connect.\n\nThe app cannot flip those Android switches itself.';

  @override
  String get killSwitchAndroidDisableTitle => 'Turn off Always-on first';

  @override
  String get killSwitchAndroidDisableBody =>
      'In Android VPN settings, turn off Always-on VPN and Block connections without VPN for Goodwin. Otherwise Disconnect will bring the tunnel back.';

  @override
  String get killSwitchOpenSettings => 'Open VPN settings';

  @override
  String get killSwitchDisconnectTitle => 'Always-on may reconnect';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN can bring the tunnel back after Disconnect. Turn Always-on off in system VPN settings if you want the network fully open.';

  @override
  String get killSwitchDisconnectConfirm => 'Disconnect';

  @override
  String get coreTuning => 'Core tuning';

  @override
  String get advancedDangerTooltip => 'Advanced — can break connectivity';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Skipped with Vision so typical VLESS can start';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Skipped on REALITY — TLS hello only';

  @override
  String get dnsHintWithTuning =>
      'DNS IPs apply to the OS TUN on connect. DoH goes into Xray JSON; TUN still uses bootstrap IPs. Mux / Fragment: Xray only.';

  @override
  String get dnsHintSimple => 'DNS IPs apply to the OS TUN on connect.';

  @override
  String get backup => 'Backup';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Export backup file';

  @override
  String get exportBackupSubtitle =>
      'Profiles and subscriptions. Optional password encrypts the file';

  @override
  String get importBackup => 'Import backup file';

  @override
  String get importBackupSubtitle => 'Merges into the current catalog';

  @override
  String get copyJsonClipboard => 'Copy JSON to clipboard';

  @override
  String get copyJsonClipboardSubtitle =>
      'Unencrypted — anyone with the clipboard can read links';

  @override
  String get copiedEmptyProfiles => 'Copied empty profile list';

  @override
  String copiedProfilesJson(int count) {
    return 'Copied $count profile(s) as unencrypted JSON';
  }

  @override
  String get exportBackupTitle => 'Export backup';

  @override
  String get exportBackupPasswordHint =>
      'Leave empty for a plain JSON file. A password uses AES-256-GCM.';

  @override
  String get backupFileSaved => 'Backup file saved';

  @override
  String get encryptedBackupSaved => 'Encrypted backup file saved';

  @override
  String get encryptedBackupTitle => 'Encrypted backup';

  @override
  String get encryptedBackupHint => 'Enter the password used when exporting.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return 'Imported $profiles profile(s) and $subs subscription(s)';
  }

  @override
  String get passwordOptional => 'Password (optional)';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get continueAction => 'Continue';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'VPN client for your own server';

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
  String get privacy => 'Privacy';

  @override
  String get privacySubtitle =>
      'Camera, VPN, on-device secrets, clipboard backups';

  @override
  String get privacyWhatTitle => 'What this app uses';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN is a local client. There is no Goodwin account server and no analytics SDK in this build.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'On platforms with a system tunnel, device traffic is sent to the node in the share link you imported. The app does not operate a Goodwin proxy. If this OS has no system tunnel, Connect only starts a local SOCKS proxy at 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Configs and secrets';

  @override
  String get privacySecretsBody =>
      'Share links, saved profiles, and subscription URLs are stored on this device, encrypted with AES-256-GCM. The encryption key lives in the OS keystore / keychain, not next to the ciphertext. If the platform keystore is unavailable, the app cannot keep those values encrypted.';

  @override
  String get privacyCameraTitle => 'Camera';

  @override
  String get privacyCameraBody =>
      'The camera is used only to scan a QR code that contains a share link or a subscription URL. Frames are not uploaded.';

  @override
  String get privacyClipboardTitle => 'Clipboard and backups';

  @override
  String get privacyClipboardBody =>
      'Copy JSON to clipboard writes an unencrypted backup. Anyone who can read the clipboard can read those links. File export can use an optional password (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Installed apps (Android)';

  @override
  String get privacyAppsBody =>
      'Per-app split tunneling reads the launcher app list on the device so you can exclude apps from the VPN. That list stays on the device.';

  @override
  String get privacyOpenWeb => 'Open privacy policy';

  @override
  String get privacyOpenFailed => 'Could not open the privacy policy URL';

  @override
  String get rulesEyebrow => 'Traffic policy';

  @override
  String get rulesTitle => 'Routing rules';

  @override
  String get reset => 'Reset';

  @override
  String get resetRulesConfirm => 'Reset routing to defaults?';

  @override
  String get mode => 'Mode';

  @override
  String get modeHintGlobalRich =>
      'All matched traffic → proxy (Xray default).';

  @override
  String get modeHintGlobalSimple => 'Recommended for Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'All traffic through the tunnel except Always-exclude.';

  @override
  String get modeHintRules =>
      'Presets + custom rules; unmatched → proxy (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Direct domains/CIDRs become TrustTunnel exclusions. Block is skipped. Unmatched stays in the tunnel.';

  @override
  String get modeHintDirect => 'All → freedom. TUN stays up (Xray only).';

  @override
  String get presets => 'Presets';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Block ads (limited)';

  @override
  String get presetBlockAdsPack => 'Block ads';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Tiny built-in host list → block (Xray; not geosite)';

  @override
  String get presetBlockAdsPackXray => 'Service ads pack → block (not geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Service ads pack → exclusions (no plugin block)';

  @override
  String get presetBypassLan => 'Bypass LAN / private';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / link-local CIDRs → TUN excludes (not a region/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Bypass LAN needs Android 13+. CIDR excludes do nothing on this version.';

  @override
  String get presetProtectBanking => 'Protect banking';

  @override
  String get presetProtectBankingSubtitle =>
      'Installed bank apps skip the TUN (Android per-app)';

  @override
  String get appsSkipVpn => 'Apps that skip VPN';

  @override
  String get appsSkipVpnEmpty => 'Optional extras beyond Protect banking';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count selected · applied on next connect';
  }

  @override
  String get switchToRulesForPresets => 'Switch to Rules mode to use presets.';

  @override
  String get alwaysExcludeMerged =>
      'Always-exclude CIDRs are merged with IP-direct rules at connect for every backend. Edit them in Advanced below.';

  @override
  String get alwaysExcludeCidr => 'Always exclude (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'One IP or CIDR per line. Applied on the next connect.';

  @override
  String get cidrHint => 'One IP or CIDR per line\ne.g. 10.0.0.0/8';

  @override
  String get customRules => 'Custom rules';

  @override
  String get customRulesHint =>
      'Domain suffix, IP or CIDR → proxy / direct / block. Applied to Xray on connect. IP direct also feeds OS excludes.';

  @override
  String get customRulesHintTrustTunnel =>
      'Domain or CIDR → proxy (stay in tunnel) or direct (exclude). Block is not available. No geosite.';

  @override
  String get matcher => 'Matcher';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Add rule';

  @override
  String get noCustomRules => 'No custom rules yet';

  @override
  String osExclude(String action) {
    return '$action · OS exclude';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · skipped on TrustTunnel (no plugin block)';

  @override
  String get enableAdvancedForRouting =>
      'Enable Advanced mode in Settings for extra routing controls.';

  @override
  String get searchApps => 'Search apps';

  @override
  String get save => 'Save';

  @override
  String get routingBannerXray =>
      'Xray profile: Global / Rules / Direct and domain rules apply on connect.';

  @override
  String get routingBannerHysteria =>
      'Hysteria2 profile: domain/block rules and Xray Direct are not applied. Use Global; Always-exclude CIDRs and IP-direct still merge into the TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: Rules direct domains/CIDRs become exclusions. Block is skipped (no plugin block). Direct mode is not applied. Always-exclude still merges. Per-app split is SOCKS-only. Kill Switch applies on the next TrustTunnel connect.';

  @override
  String get routingBannerUnknown =>
      'Select or connect a profile to see which routing features apply.';

  @override
  String get logsEyebrow => 'Diagnostics';

  @override
  String get logsTitle => 'Logs';

  @override
  String get copyFiltered => 'Copy filtered';

  @override
  String get clear => 'Clear';

  @override
  String get logCopied => 'Log copied';

  @override
  String get logsHint =>
      'Core console. Colors are heuristic (error/warn keywords).';

  @override
  String get filterHint => 'Filter…';

  @override
  String get logsAll => 'All';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'No log lines yet';

  @override
  String get noMatchesForFilter => 'No matches for filter';

  @override
  String get vpnConsole => 'VPN console';

  @override
  String get logsSheetEmpty => 'No lines yet. Waiting for stream…';

  @override
  String get copy => 'Copy';

  @override
  String get openLogs => 'Open logs';

  @override
  String get tapToRetry => 'Tap to retry';

  @override
  String get homeErrorTitle => 'Could not connect';

  @override
  String get homeErrorTunnel => 'Tunnel failed — tap to retry';

  @override
  String get homeErrorSocks => 'Local SOCKS failed — tap to retry';

  @override
  String get activeProfile => 'ACTIVE PROFILE';

  @override
  String get socksInbound => 'Local SOCKS';

  @override
  String get socksInboundSubtitle =>
      'Leave user and password empty to generate random credentials each connect. Other apps: 127.0.0.1 plus these credentials.';

  @override
  String get socksPort => 'Port';

  @override
  String get socksUsername => 'Username';

  @override
  String get socksPassword => 'Password';

  @override
  String get saveSocks => 'Save SOCKS';

  @override
  String get socksSaved => 'SOCKS saved';

  @override
  String get killSwitchAndroidConfirmTitle => 'Did you turn on Always-on?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'The app cannot flip Android VPN switches. Turn the Kill Switch on here only after Always-on and Block connections without VPN are enabled for GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Yes, they are on';

  @override
  String get killSwitchAndroidConfirmNo => 'Not yet';

  @override
  String get killSwitchIosDisconnectFailed =>
      'Could not turn off on-demand. Disconnect may not stick until you retry.';

  @override
  String get support => 'Support';

  @override
  String get supportSubtitle => 'Open the operator support page';

  @override
  String get supportUnavailable => 'No support URL in this subscription';

  @override
  String get licenses => 'Open-source licenses';

  @override
  String get licensesSubtitle => 'Open-source components in this app';

  @override
  String get licensesBody =>
      'Networking libraries, Flutter, and Inter (SIL OFL) are bundled. Source and licenses are listed below and in the project repositories.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingDone => 'Get started';

  @override
  String get onboardingServerTitle => 'Your server';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN is a client for a node you import. There is no Goodwin cloud proxy. Add a share link or an https subscription URL on Profiles.';

  @override
  String get onboardingVpnTitle => 'System VPN';

  @override
  String get onboardingVpnBody =>
      'Connect asks the OS to add a VPN configuration. That dialog is from Android or iOS, not from this app. Traffic then goes to the node in the profile you selected.';

  @override
  String get onboardingCameraTitle => 'Camera for QR';

  @override
  String get onboardingCameraBody =>
      'The camera is optional and only scans a QR with a share link or subscription URL. Frames stay on the device.';

  @override
  String get vpnExplainerTitle => 'System VPN permission';

  @override
  String get vpnExplainerBody =>
      'The next screen is the OS VPN dialog. Allow it only if you want this device to send traffic through the imported node.';

  @override
  String get vpnExplainerContinue => 'Continue';

  @override
  String get cameraExplainerTitle => 'Camera permission';

  @override
  String get cameraExplainerBody =>
      'The next screen may ask for the camera. It is used only to scan a configuration QR. Frames are not uploaded.';

  @override
  String get cameraExplainerContinue => 'Scan QR';

  @override
  String get importLinkHint =>
      'Paste a share link or an https:// subscription URL. The app does not host a proxy.';
}
