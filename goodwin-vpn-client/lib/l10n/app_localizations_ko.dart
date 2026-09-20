// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => '홈';

  @override
  String get navProfiles => '프로필';

  @override
  String get navRules => '규칙';

  @override
  String get navLogs => '로그';

  @override
  String get navSettings => '설정';

  @override
  String get connectVpn => 'VPN 연결';

  @override
  String get disconnectVpn => 'VPN 연결 해제';

  @override
  String get noProfile => '프로필 없음';

  @override
  String get addProfileToConnect => '연결하려면 프로필을 추가하세요';

  @override
  String get addProfileToConnectHint => '프로필에서 공유 링크를 가져온 다음 여기에서 연결을 탭하세요.';

  @override
  String get addProfile => '프로필 추가';

  @override
  String get networkStatus => '네트워크 상태';

  @override
  String get tapToDisconnect => '탭하여 연결 해제';

  @override
  String get tapToConnect => '탭하여 연결';

  @override
  String get statNode => '노드';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => '가동 시간';

  @override
  String get sessionLogs => '세션 로그';

  @override
  String get noLinesYet => '아직 줄이 없습니다';

  @override
  String logLinesCount(int count) {
    return '$count줄';
  }

  @override
  String get uacDeclined => 'UAC 프롬프트가 거부되었습니다';

  @override
  String get statusOffline => '연결 해제됨';

  @override
  String get statusConnecting => '연결 중';

  @override
  String get statusConnected => '연결됨';

  @override
  String get statusDisconnecting => '연결 해제 중';

  @override
  String get statusError => '오류';

  @override
  String get switchProfile => '프로필 전환';

  @override
  String get manageProfiles => '프로필 관리';

  @override
  String get routing => '라우팅';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · 규칙에서 변경';
  }

  @override
  String get routingModeGlobal => '글로벌';

  @override
  String get routingModeRules => '규칙';

  @override
  String get routingModeDirect => '다이렉트';

  @override
  String get homeReadyTitle => '연결 해제됨';

  @override
  String get homeReadyTunnel => '연결하면 이 기기에서 시스템 VPN이 시작됩니다';

  @override
  String get homeReadySocks => '이 OS에는 아직 시스템 VPN이 없습니다 — 연결은 로컬 SOCKS 프록시입니다';

  @override
  String get homeBusyTitle => '연결 중';

  @override
  String get homeBusyTunnel => 'OS에 VPN 터널을 요청하는 중';

  @override
  String get homeBusySocks => '로컬 SOCKS 프록시를 시작하는 중';

  @override
  String get homeConnectedTunnelTitle => '시스템 VPN';

  @override
  String get homeConnectedTunnelSubtitle => '기기 트래픽은 터널을 통과하며 집 IP를 쓰지 않습니다';

  @override
  String get homeConnectedSocksTitle => '로컬 SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      '이 OS에는 시스템 터널이 없습니다. 앱은 127.0.0.1:10808을 사용해야 합니다 — IP가 숨겨지지 않습니다';

  @override
  String get revokedTitle => '구독 링크가 취소되었습니다';

  @override
  String get revokedBody => '프로필에 새 URL을 붙여넣으세요. 대체 항목을 가져올 때까지 이전 노드는 유지됩니다.';

  @override
  String get openProfiles => '프로필 열기';

  @override
  String get elevationTitle => '관리자 권한이 필요합니다';

  @override
  String get runAsAdministrator => '관리자 권한으로 실행';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used 사용 · VLESS+Hy2';
  }

  @override
  String get quotaExpired => '만료됨';

  @override
  String quotaDaysLeft(int days) {
    return '$days일 남음';
  }

  @override
  String get quotaScopeNote => 'VLESS+Hy2 트래픽 — TrustTunnel은 집계되지 않음';

  @override
  String get profilesEyebrow => '내 네트워크';

  @override
  String get profilesTitle => '서버 프로필';

  @override
  String get tooltipPinging => 'Ping 중…';

  @override
  String get tooltipCheckPing => 'Ping 확인';

  @override
  String get noProfilesToPing => 'Ping할 프로필이 없습니다';

  @override
  String get tooltipImportLink => '링크 또는 구독 가져오기';

  @override
  String get searchServersHint => '서버 또는 프로토콜 검색';

  @override
  String get smartConnect => '스마트 연결';

  @override
  String get smartConnectSubtitle => '홈의 연결은 현재 구독에서 Ping이 가장 낮은 노드를 사용합니다';

  @override
  String get emptyProfiles =>
      '저장된 프로필이 아직 없습니다.\n공유 링크 또는 https:// 구독 URL을 가져오세요.';

  @override
  String get noMatches => '일치 항목 없음';

  @override
  String get pinging => 'Ping 중';

  @override
  String get fastest => '가장 빠름';

  @override
  String get delete => '삭제';

  @override
  String get deleteProfileConfirm => '이 프로필을 삭제할까요?';

  @override
  String get deleteSubscriptionConfirm => '이 구독과 저장된 노드를 제거할까요?';

  @override
  String updatedSubscription(String name) {
    return '$name을(를) 업데이트했습니다';
  }

  @override
  String get importProfile => '프로필 가져오기';

  @override
  String get nameOptional => '이름(선택)';

  @override
  String get importLinkLabel => '공유 링크 또는 https:// 구독 URL';

  @override
  String get paste => '붙여넣기';

  @override
  String get scanQr => 'QR 스캔';

  @override
  String get cancel => '취소';

  @override
  String get import => '가져오기';

  @override
  String get unrecognizedShareLink => '인식할 수 없는 공유 링크';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get name => '이름';

  @override
  String get shareLink => '공유 링크';

  @override
  String get apply => '적용';

  @override
  String get importedManual => '가져옴';

  @override
  String get subscriptionFallback => '구독';

  @override
  String get revokedKeepNodes => '링크가 취소됨 — 새 URL을 붙여넣으세요. 노드는 지워지지 않았습니다.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · 노드 $count개';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '노드 $count개',
      one: '노드 1개',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => '구독 새로고침';

  @override
  String get removeSubscription => '구독 제거';

  @override
  String get nothingToImport => '가져올 항목이 없습니다';

  @override
  String get subscriptionImported => '구독을 가져왔습니다';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name을(를) 가져왔습니다(노드 $count개)';
  }

  @override
  String get profileImported => '프로필을 가져왔습니다';

  @override
  String get settingsEyebrow => '애플리케이션';

  @override
  String get settingsTitle => '설정';

  @override
  String get appearance => '모양';

  @override
  String get colorTheme => '색상 테마';

  @override
  String get colorThemeSubtitle => '페이퍼 라이트와 네이비 다크. 시스템은 휴대전화를 따릅니다.';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeSystem => '시스템';

  @override
  String get language => '언어';

  @override
  String get languageSubtitle => '영어와 러시아어. 시스템은 휴대전화를 따릅니다.';

  @override
  String get localeSystem => '시스템';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => '일반';

  @override
  String get advancedMode => '고급 모드';

  @override
  String get advancedModeSubtitle => '로그 탭과 고급 사용자 옵션';

  @override
  String get reconnectOnLaunch => '실행 시 다시 연결';

  @override
  String get reconnectOnLaunchSubtitle => 'OS VPN이 꺼져 있으면 마지막 프로필을 시작합니다';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => '시스템';

  @override
  String get dnsCustom => '사용자 지정';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS 서버 / DoH URL';

  @override
  String get dnsSaved => 'DNS 설정이 저장되었습니다';

  @override
  String get saveDns => 'DNS 저장';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Android 설정의 Always-on VPN. 여기 토글만으로는 누출을 막지 못합니다.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      '다음 TrustTunnel 연결에서 플러그인 누출 잠금. 재부팅 후에도 Always-on이 필요합니다.';

  @override
  String get killSwitchSubtitleIos =>
      '터널이 끊기면 다시 연결합니다. Push, Watch, iMessage는 계속 도달 가능합니다.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      '이 TrustTunnel 세션의 플러그인 누출 잠금. 연결 해제는 SOCKS VPN이 시작되기 전에 끕니다.';

  @override
  String get killSwitchAndroidEnableTitle => '시스템 누출 보호 켜기';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. 다음 화면에서 GoodWin VPN(SOCKS 또는 TrustTunnel)을 탭합니다.\n2. Always-on VPN을 켭니다.\n3. VPN 없이 연결 차단을 켭니다.\n4. 여기로 돌아와 연결을 탭합니다.\n\n앱은 해당 Android 스위치를 직접 바꿀 수 없습니다. TrustTunnel은 다음 연결에서도 플러그인 누출 보호를 사용합니다.';

  @override
  String get killSwitchAndroidDisableTitle => '먼저 Always-on을 끄세요';

  @override
  String get killSwitchAndroidDisableBody =>
      'Android VPN 설정에서 GoodWin의 Always-on VPN과 VPN 없이 연결 차단을 끄세요. 그렇지 않으면 연결 해제가 터널을 다시 가져옵니다.';

  @override
  String get killSwitchOpenSettings => 'VPN 설정 열기';

  @override
  String get killSwitchDisconnectTitle => 'Always-on이 다시 연결할 수 있음';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN은 연결 해제 후 터널을 다시 가져올 수 있습니다. 네트워크를 완전히 열려면 시스템 VPN 설정에서 Always-on을 끄세요.';

  @override
  String get killSwitchDisconnectConfirm => '연결 해제';

  @override
  String get coreTuning => '코어 조정';

  @override
  String get advancedDangerTooltip => '고급 — 연결이 끊길 수 있음';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Vision에서는 사용하지 않음. 일반 VLESS는 시작됩니다';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'REALITY에서는 사용하지 않음. TLS hello만';

  @override
  String get dnsHintWithTuning =>
      'DNS IP는 연결 시 OS TUN에 적용됩니다. DoH는 Xray JSON으로 들어갑니다. TUN은 계속 부트스트랩 IP를 사용합니다. Mux / Fragment: Xray만.';

  @override
  String get dnsHintSimple => 'DNS IP는 연결 시 OS TUN에 적용됩니다.';

  @override
  String get backup => '백업';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => '백업 파일 내보내기';

  @override
  String get exportBackupSubtitle => '프로필과 구독. 선택 비밀번호로 파일을 암호화합니다';

  @override
  String get importBackup => '백업 파일 가져오기';

  @override
  String get importBackupSubtitle => '현재 목록에 병합됩니다';

  @override
  String get copyJsonClipboard => '클립보드에 JSON 복사';

  @override
  String get copyJsonClipboardSubtitle =>
      '암호화되지 않음 — 클립보드를 읽을 수 있는 사람은 링크를 볼 수 있습니다';

  @override
  String get copiedEmptyProfiles => '빈 프로필 목록을 복사했습니다';

  @override
  String copiedProfilesJson(int count) {
    return '암호화되지 않은 JSON으로 프로필 $count개를 복사했습니다';
  }

  @override
  String get exportBackupTitle => '백업 내보내기';

  @override
  String get exportBackupPasswordHint =>
      '일반 JSON 파일은 비워 두세요. 비밀번호는 AES-256-GCM을 사용합니다.';

  @override
  String get backupFileSaved => '백업 파일을 저장했습니다';

  @override
  String get encryptedBackupSaved => '암호화된 백업 파일을 저장했습니다';

  @override
  String get encryptedBackupTitle => '암호화된 백업';

  @override
  String get encryptedBackupHint => '내보낼 때 사용한 비밀번호를 입력하세요.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '프로필 $profiles개와 구독 $subs개를 가져왔습니다';
  }

  @override
  String get passwordOptional => '비밀번호(선택)';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get continueAction => '계속';

  @override
  String get about => '정보';

  @override
  String get aboutSubtitle => '내 서버용 VPN 클라이언트';

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
  String get privacy => '개인정보';

  @override
  String get privacySubtitle => '카메라, VPN, 기기 내 비밀, 클립보드 백업';

  @override
  String get privacyWhatTitle => '이 앱이 사용하는 것';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN은 로컬 클라이언트입니다. 이 빌드에는 GoodWin 계정 서버와 분석 SDK가 없습니다.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      '시스템 터널이 있는 플랫폼에서는 기기 트래픽이 가져온 공유 링크의 노드로 전송됩니다. 이 앱은 GoodWin 프록시를 운영하지 않습니다. 이 OS에 시스템 터널이 없으면 연결은 127.0.0.1:10808의 로컬 SOCKS 프록시만 시작합니다.';

  @override
  String get privacySecretsTitle => '구성과 비밀';

  @override
  String get privacySecretsBody =>
      '공유 링크, 저장된 프로필, 구독 URL은 이 기기에 AES-256-GCM으로 암호화되어 저장됩니다. 암호화 키는 암호문 옆이 아니라 OS 키스토어 / 키체인이 보관합니다. 플랫폼 키스토어를 사용할 수 없으면 앱은 해당 값을 암호화된 상태로 유지할 수 없습니다.';

  @override
  String get privacyCameraTitle => '카메라';

  @override
  String get privacyCameraBody =>
      '카메라는 공유 링크 또는 구독 URL이 담긴 QR을 스캔할 때만 사용됩니다. 프레임은 업로드되지 않습니다.';

  @override
  String get privacyClipboardTitle => '클립보드와 백업';

  @override
  String get privacyClipboardBody =>
      '클립보드에 JSON 복사는 암호화되지 않은 백업을 씁니다. 클립보드를 읽을 수 있는 사람은 해당 링크를 볼 수 있습니다. 파일 내보내기는 선택 비밀번호(AES-256-GCM)를 사용할 수 있습니다.';

  @override
  String get privacyAppsTitle => '설치된 앱(Android)';

  @override
  String get privacyAppsBody =>
      '앱별 스플릿 터널링은 VPN에서 앱을 제외할 수 있도록 기기의 런처 앱 목록을 읽습니다. 그 목록은 기기에 남습니다.';

  @override
  String get privacyOpenWeb => '개인정보 처리방침 열기';

  @override
  String get privacyOpenFailed => '개인정보 처리방침 URL을 열 수 없습니다';

  @override
  String get rulesEyebrow => '트래픽 정책';

  @override
  String get rulesTitle => '라우팅 규칙';

  @override
  String get reset => '재설정';

  @override
  String get resetRulesConfirm => '라우팅을 기본값으로 재설정할까요?';

  @override
  String get mode => '모드';

  @override
  String get modeHintGlobalRich => '일치하는 모든 트래픽 → 프록시(Xray 기본값).';

  @override
  String get modeHintGlobalSimple => 'Hysteria2에 권장.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Always-exclude를 제외한 모든 트래픽이 터널을 통과합니다.';

  @override
  String get modeHintRules => '프리셋 + 사용자 규칙. 불일치 → 프록시(Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      '다이렉트 도메인/CIDR은 TrustTunnel 제외가 됩니다. Block은 건너뜁니다. 불일치는 터널에 남습니다.';

  @override
  String get modeHintDirect => '모두 → freedom. TUN은 유지(Xray만).';

  @override
  String get presets => '프리셋';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => '광고 차단(제한적)';

  @override
  String get presetBlockAdsPack => '광고 차단';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      '내장된 작은 호스트 목록 → block(Xray, geosite 아님)';

  @override
  String get presetBlockAdsPackXray => '서비스 광고 팩 → block(geosite 아님)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      '서비스 광고 팩 → TrustTunnel 제외(플러그인 block 없음)';

  @override
  String get presetBypassLan => 'LAN / 사설 우회';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / 링크 로컬 CIDR → TUN 제외(지역/geoip 아님)';

  @override
  String get presetBypassLanAndroid13 =>
      'LAN 우회에는 Android 13+가 필요합니다. 이 버전에서는 CIDR 제외가 동작하지 않습니다.';

  @override
  String get presetProtectBanking => '뱅킹 보호';

  @override
  String get presetProtectBankingSubtitle => '설치된 은행 앱은 TUN을 건너뜁니다(Android 앱별)';

  @override
  String get appsSkipVpn => 'VPN을 건너뛰는 앱';

  @override
  String get appsSkipVpnEmpty => '뱅킹 보호 외 선택적 추가';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count개 선택 · 다음 연결 시 적용';
  }

  @override
  String get switchToRulesForPresets => '프리셋을 쓰려면 규칙 모드로 전환하세요.';

  @override
  String get alwaysExcludeMerged =>
      'Always-exclude CIDR은 연결 시 모든 백엔드에서 IP-direct 규칙과 병합됩니다. 아래 고급에서 편집하세요.';

  @override
  String get alwaysExcludeCidr => 'Always exclude(CIDR)';

  @override
  String get alwaysExcludeHint => '한 줄에 IP 또는 CIDR 하나. 다음 연결 시 적용됩니다.';

  @override
  String get cidrHint => '한 줄에 IP 또는 CIDR 하나\n예: 10.0.0.0/8';

  @override
  String get customRules => '사용자 규칙';

  @override
  String get customRulesHint =>
      '도메인 접미사, IP 또는 CIDR → proxy / direct / block. 연결 시 Xray에 적용됩니다. IP direct는 OS 제외에도 들어갑니다.';

  @override
  String get customRulesHintTrustTunnel =>
      '도메인 또는 CIDR → proxy(터널에 유지) 또는 direct(제외). Block은 사용할 수 없습니다. geosite 없음.';

  @override
  String get matcher => '매처';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => '규칙 추가';

  @override
  String get noCustomRules => '아직 사용자 규칙이 없습니다';

  @override
  String osExclude(String action) {
    return '$action · OS 제외';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · TrustTunnel에서 건너뜀(플러그인 block 없음)';

  @override
  String get enableAdvancedForRouting => '추가 라우팅 제어를 위해 설정에서 고급 모드를 켜세요.';

  @override
  String get searchApps => '앱 검색';

  @override
  String get save => '저장';

  @override
  String get routingBannerXray =>
      'Xray 프로필: 글로벌 / 규칙 / 다이렉트와 도메인 규칙은 연결 시 적용됩니다.';

  @override
  String get routingBannerHysteria =>
      'Hysteria2 프로필: 도메인/block 규칙과 Xray 다이렉트는 적용되지 않습니다. 글로벌을 사용하세요. Always-exclude CIDR과 IP-direct는 계속 TUN에 병합됩니다.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: 규칙의 다이렉트 도메인/CIDR은 제외가 됩니다. Block은 건너뜁니다(플러그인 block 없음). 다이렉트 모드는 적용되지 않습니다. Always-exclude는 계속 병합됩니다. 앱별 스플릿은 SOCKS만입니다. Kill Switch는 다음 TrustTunnel 연결에 적용됩니다.';

  @override
  String get routingBannerUnknown =>
      '어떤 라우팅 기능이 적용되는지는 프로필을 선택하거나 연결하면 볼 수 있습니다.';

  @override
  String get logsEyebrow => '진단';

  @override
  String get logsTitle => '로그';

  @override
  String get copyFiltered => '필터된 항목 복사';

  @override
  String get clear => '지우기';

  @override
  String get logCopied => '로그를 복사했습니다';

  @override
  String get logsHint => '코어 콘솔. 색은 휴리스틱입니다(error/warn 키워드).';

  @override
  String get filterHint => '필터…';

  @override
  String get logsAll => '전체';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => '오류';

  @override
  String get noLogLinesYet => '아직 로그 줄이 없습니다';

  @override
  String get noMatchesForFilter => '필터와 일치하는 항목이 없습니다';

  @override
  String get vpnConsole => 'VPN 콘솔';

  @override
  String get logsSheetEmpty => '아직 줄이 없습니다. 스트림을 기다리는 중…';

  @override
  String get copy => '복사';

  @override
  String get openLogs => '로그 열기';

  @override
  String get tapToRetry => '탭하여 다시 시도';

  @override
  String get homeErrorTitle => '연결할 수 없습니다';

  @override
  String get homeErrorTunnel => '터널 실패 — 탭하여 다시 시도';

  @override
  String get homeErrorSocks => '로컬 SOCKS 실패 — 탭하여 다시 시도';

  @override
  String get activeProfile => '활성 프로필';

  @override
  String get socksInbound => '로컬 SOCKS';

  @override
  String get socksInboundSubtitle =>
      '사용자 이름과 비밀번호를 비워 두면 연결할 때마다 임의의 자격 증명이 생성됩니다. 다른 앱: 127.0.0.1과 이 자격 증명.';

  @override
  String get socksPort => '포트';

  @override
  String get socksUsername => '사용자 이름';

  @override
  String get socksPassword => '비밀번호';

  @override
  String get saveSocks => 'SOCKS 저장';

  @override
  String get socksSaved => 'SOCKS가 저장되었습니다';

  @override
  String get killSwitchAndroidConfirmTitle => 'Always-on을 켰나요?';

  @override
  String get killSwitchAndroidConfirmBody =>
      '앱은 Android VPN 스위치를 바꿀 수 없습니다. GoodWin VPN에 Always-on과 VPN 없이 연결 차단이 켜진 뒤에만 여기에서 Kill Switch를 켜세요.';

  @override
  String get killSwitchAndroidConfirmYes => '네, 켜져 있습니다';

  @override
  String get killSwitchAndroidConfirmNo => '아직 아님';

  @override
  String get killSwitchIosDisconnectFailed =>
      '온디맨드를 끌 수 없습니다. 다시 시도할 때까지 연결 해제가 유지되지 않을 수 있습니다.';

  @override
  String get support => '지원';

  @override
  String get supportSubtitle => '운영자 지원 페이지 열기';

  @override
  String get supportUnavailable => '이 구독에 지원 URL이 없습니다';

  @override
  String get licenses => '오픈 소스 라이선스';

  @override
  String get licensesSubtitle => '이 앱에 포함된 코어와 라이브러리';

  @override
  String get licensesBody =>
      '이 앱은 Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter, Inter(SIL OFL)를 포함합니다. 소스와 라이선스는 프로젝트 저장소에 있습니다.';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingDone => '시작하기';

  @override
  String get onboardingServerTitle => '내 서버';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN은 가져오는 노드용 클라이언트입니다. GoodWin 클라우드 프록시는 없습니다. 프로필에서 공유 링크 또는 https 구독 URL을 추가하세요.';

  @override
  String get onboardingVpnTitle => '시스템 VPN';

  @override
  String get onboardingVpnBody =>
      '연결은 OS에 VPN 구성을 추가하도록 요청합니다. 그 대화상자는 Android 또는 iOS의 것이며 이 앱이 아닙니다. 이후 트래픽은 선택한 프로필의 노드로 갑니다.';

  @override
  String get onboardingCameraTitle => 'QR용 카메라';

  @override
  String get onboardingCameraBody =>
      '카메라는 선택 사항이며 공유 링크 또는 구독 URL이 있는 QR만 스캔합니다. 프레임은 기기에 남습니다.';

  @override
  String get vpnExplainerTitle => '시스템 VPN 권한';

  @override
  String get vpnExplainerBody =>
      '다음 화면은 OS VPN 대화상자입니다. 이 기기가 가져온 노드를 통해 트래픽을 보내려는 경우에만 허용하세요.';

  @override
  String get vpnExplainerContinue => '계속';

  @override
  String get cameraExplainerTitle => '카메라 권한';

  @override
  String get cameraExplainerBody =>
      '다음 화면에서 카메라를 요청할 수 있습니다. 구성 QR을 스캔할 때만 사용됩니다. 프레임은 업로드되지 않습니다.';

  @override
  String get cameraExplainerContinue => 'QR 스캔';

  @override
  String get importLinkHint =>
      '공유 링크 또는 https:// 구독 URL을 붙여넣으세요. 이 앱은 프록시를 호스팅하지 않습니다.';
}
