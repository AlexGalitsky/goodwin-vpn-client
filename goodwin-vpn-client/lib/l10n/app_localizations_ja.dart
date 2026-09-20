// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'ホーム';

  @override
  String get navProfiles => 'プロファイル';

  @override
  String get navRules => 'ルール';

  @override
  String get navLogs => 'ログ';

  @override
  String get navSettings => '設定';

  @override
  String get connectVpn => 'VPN に接続';

  @override
  String get disconnectVpn => 'VPN を切断';

  @override
  String get noProfile => 'プロファイルなし';

  @override
  String get addProfileToConnect => '接続するにはプロファイルを追加';

  @override
  String get addProfileToConnectHint => 'プロファイルで共有リンクをインポートし、ここで接続をタップします。';

  @override
  String get addProfile => 'プロファイルを追加';

  @override
  String get networkStatus => 'ネットワーク状態';

  @override
  String get tapToDisconnect => 'タップして切断';

  @override
  String get tapToConnect => 'タップして接続';

  @override
  String get statNode => 'ノード';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => '稼働時間';

  @override
  String get sessionLogs => 'セッションログ';

  @override
  String get noLinesYet => 'まだ行がありません';

  @override
  String logLinesCount(int count) {
    return '$count 行';
  }

  @override
  String get uacDeclined => 'UAC プロンプトが拒否されました';

  @override
  String get statusOffline => '切断済み';

  @override
  String get statusConnecting => '接続中';

  @override
  String get statusConnected => '接続済み';

  @override
  String get statusDisconnecting => '切断中';

  @override
  String get statusError => 'エラー';

  @override
  String get switchProfile => 'プロファイルを切り替え';

  @override
  String get manageProfiles => 'プロファイルを管理';

  @override
  String get routing => 'ルーティング';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · ルールで変更';
  }

  @override
  String get routingModeGlobal => 'グローバル';

  @override
  String get routingModeRules => 'ルール';

  @override
  String get routingModeDirect => 'ダイレクト';

  @override
  String get homeReadyTitle => '切断済み';

  @override
  String get homeReadyTunnel => '接続するとこの端末でシステム VPN が開始されます';

  @override
  String get homeReadySocks =>
      'この OS にはまだシステム VPN がありません — 接続はローカル SOCKS プロキシです';

  @override
  String get homeBusyTitle => '接続中';

  @override
  String get homeBusyTunnel => 'OS に VPN トンネルを要求しています';

  @override
  String get homeBusySocks => 'ローカル SOCKS プロキシを起動しています';

  @override
  String get homeConnectedTunnelTitle => 'システム VPN';

  @override
  String get homeConnectedTunnelSubtitle => '端末のトラフィックはトンネル経由で、自宅 IP ではありません';

  @override
  String get homeConnectedSocksTitle => 'ローカル SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      'この OS にシステムトンネルはありません。アプリは 127.0.0.1:10808 を使う必要があります — IP は隠されません';

  @override
  String get revokedTitle => 'サブスクリプションリンクが取り消されました';

  @override
  String get revokedBody =>
      'プロファイルに新しい URL を貼り付けてください。置き換えをインポートするまで古いノードは残ります。';

  @override
  String get openProfiles => 'プロファイルを開く';

  @override
  String get elevationTitle => '管理者権限が必要です';

  @override
  String get runAsAdministrator => '管理者として実行';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used 使用 · VLESS+Hy2';
  }

  @override
  String get quotaExpired => '期限切れ';

  @override
  String quotaDaysLeft(int days) {
    return '残り $days 日';
  }

  @override
  String get quotaScopeNote => 'VLESS+Hy2 トラフィック — TrustTunnel はカウントされません';

  @override
  String get profilesEyebrow => 'あなたのネットワーク';

  @override
  String get profilesTitle => 'サーバープロファイル';

  @override
  String get tooltipPinging => 'Ping 中…';

  @override
  String get tooltipCheckPing => 'Ping を確認';

  @override
  String get noProfilesToPing => 'Ping するプロファイルがありません';

  @override
  String get tooltipImportLink => 'リンクまたはサブスクリプションをインポート';

  @override
  String get searchServersHint => 'サーバーまたはプロトコルを検索';

  @override
  String get smartConnect => 'スマート接続';

  @override
  String get smartConnectSubtitle => 'ホームの接続は、現在のサブスクリプションで Ping が最も低いノードを使います';

  @override
  String get emptyProfiles =>
      '保存済みプロファイルはまだありません。\n共有リンクまたは https:// サブスクリプション URL をインポートしてください。';

  @override
  String get noMatches => '一致なし';

  @override
  String get pinging => 'Ping 中';

  @override
  String get fastest => '最速';

  @override
  String get delete => '削除';

  @override
  String get deleteProfileConfirm => 'このプロファイルを削除しますか？';

  @override
  String get deleteSubscriptionConfirm => 'このサブスクリプションと保存済みノードを削除しますか？';

  @override
  String updatedSubscription(String name) {
    return '$name を更新しました';
  }

  @override
  String get importProfile => 'プロファイルをインポート';

  @override
  String get nameOptional => '名前（任意）';

  @override
  String get importLinkLabel => '共有リンクまたは https:// サブスクリプション URL';

  @override
  String get paste => '貼り付け';

  @override
  String get scanQr => 'QR をスキャン';

  @override
  String get cancel => 'キャンセル';

  @override
  String get import => 'インポート';

  @override
  String get unrecognizedShareLink => '認識できない共有リンク';

  @override
  String get editProfile => 'プロファイルを編集';

  @override
  String get name => '名前';

  @override
  String get shareLink => '共有リンク';

  @override
  String get apply => '適用';

  @override
  String get importedManual => 'インポート済み';

  @override
  String get subscriptionFallback => 'サブスクリプション';

  @override
  String get revokedKeepNodes =>
      'リンクが取り消されました — 新しい URL を貼り付けてください。ノードは削除されていません。';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count ノード';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ノード',
      one: '1 ノード',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'サブスクリプションを更新';

  @override
  String get removeSubscription => 'サブスクリプションを削除';

  @override
  String get nothingToImport => 'インポートするものがありません';

  @override
  String get subscriptionImported => 'サブスクリプションをインポートしました';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name をインポートしました（$count ノード）';
  }

  @override
  String get profileImported => 'プロファイルをインポートしました';

  @override
  String get settingsEyebrow => 'アプリケーション';

  @override
  String get settingsTitle => '設定';

  @override
  String get appearance => '外観';

  @override
  String get colorTheme => 'カラーテーマ';

  @override
  String get colorThemeSubtitle => 'ペーパーライトとネイビーダーク。システムは端末に従います。';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeSystem => 'システム';

  @override
  String get language => '言語';

  @override
  String get languageSubtitle => '英語とロシア語。システムは端末に従います。';

  @override
  String get localeSystem => 'システム';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => '一般';

  @override
  String get advancedMode => '詳細モード';

  @override
  String get advancedModeSubtitle => 'ログタブと上級者向けの深さ';

  @override
  String get reconnectOnLaunch => '起動時に再接続';

  @override
  String get reconnectOnLaunchSubtitle => 'OS の VPN が切れている場合、最後のプロファイルを開始';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'システム';

  @override
  String get dnsCustom => 'カスタム';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS サーバー / DoH URL';

  @override
  String get dnsSaved => 'DNS の設定を保存しました';

  @override
  String get saveDns => 'DNS を保存';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Android 設定の Always-on VPN。ここのトグルだけではリーク防止になりません。';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      '次の TrustTunnel 接続でプラグインのリークロック。再起動後も Always-on が必要です。';

  @override
  String get killSwitchSubtitleIos =>
      'トンネルが落ちると再接続します。Push、Watch、iMessage は到達可能のままです。';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'この TrustTunnel セッションのプラグインリークロック。切断すると SOCKS VPN が始まる前にオフになります。';

  @override
  String get killSwitchAndroidEnableTitle => 'システムのリーク保護をオンにする';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. 次の画面で GoodWin VPN（SOCKS または TrustTunnel）をタップします。\n2. Always-on VPN をオンにします。\n3. VPN なしの接続をブロックをオンにします。\n4. ここに戻り、接続をタップします。\n\nアプリはこれらの Android スイッチを自分では切り替えられません。TrustTunnel は次の接続でもプラグインのリーク保護を使います。';

  @override
  String get killSwitchAndroidDisableTitle => '先に Always-on をオフにしてください';

  @override
  String get killSwitchAndroidDisableBody =>
      'Android の VPN 設定で、GoodWin の Always-on VPN と VPN なしの接続をブロックをオフにしてください。そうしないと切断してもトンネルが戻ります。';

  @override
  String get killSwitchOpenSettings => 'VPN 設定を開く';

  @override
  String get killSwitchDisconnectTitle => 'Always-on が再接続することがあります';

  @override
  String get killSwitchDisconnectBody =>
      'Android の Always-on VPN は切断後にトンネルを戻すことがあります。ネットワークを完全に開く場合は、システムの VPN 設定で Always-on をオフにしてください。';

  @override
  String get killSwitchDisconnectConfirm => '切断';

  @override
  String get coreTuning => 'コア調整';

  @override
  String get advancedDangerTooltip => '詳細 — 接続が切れることがあります';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Vision では未使用。通常の VLESS は起動します';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'REALITY では未使用。TLS hello のみ';

  @override
  String get dnsHintWithTuning =>
      'DNS IP は接続時に OS の TUN に適用されます。DoH は Xray JSON に入ります。TUN は引き続きブートストラップ IP を使います。Mux / Fragment: Xray のみ。';

  @override
  String get dnsHintSimple => 'DNS IP は接続時に OS の TUN に適用されます。';

  @override
  String get backup => 'バックアップ';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'バックアップファイルを書き出す';

  @override
  String get exportBackupSubtitle => 'プロファイルとサブスクリプション。任意のパスワードでファイルを暗号化';

  @override
  String get importBackup => 'バックアップファイルを取り込む';

  @override
  String get importBackupSubtitle => '現在のカタログにマージします';

  @override
  String get copyJsonClipboard => 'JSON をクリップボードにコピー';

  @override
  String get copyJsonClipboardSubtitle => '非暗号化 — クリップボードを読める人はリンクを読めます';

  @override
  String get copiedEmptyProfiles => '空のプロファイル一覧をコピーしました';

  @override
  String copiedProfilesJson(int count) {
    return '$count 件のプロファイルを非暗号化 JSON としてコピーしました';
  }

  @override
  String get exportBackupTitle => 'バックアップを書き出す';

  @override
  String get exportBackupPasswordHint =>
      '平文 JSON ファイルにする場合は空のままにします。パスワードは AES-256-GCM を使います。';

  @override
  String get backupFileSaved => 'バックアップファイルを保存しました';

  @override
  String get encryptedBackupSaved => '暗号化バックアップファイルを保存しました';

  @override
  String get encryptedBackupTitle => '暗号化バックアップ';

  @override
  String get encryptedBackupHint => '書き出し時に使ったパスワードを入力してください。';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles 件のプロファイルと $subs 件のサブスクリプションをインポートしました';
  }

  @override
  String get passwordOptional => 'パスワード（任意）';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワードの確認';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get continueAction => '続ける';

  @override
  String get about => 'このアプリについて';

  @override
  String get aboutSubtitle => '自分のサーバー向け VPN クライアント';

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
  String get privacy => 'プライバシー';

  @override
  String get privacySubtitle => 'カメラ、VPN、端末上のシークレット、クリップボードのバックアップ';

  @override
  String get privacyWhatTitle => 'このアプリが使うもの';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN はローカルクライアントです。このビルドに GoodWin アカウントサーバーも分析 SDK もありません。';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'システムトンネルがあるプラットフォームでは、端末のトラフィックはインポートした共有リンクのノードへ送られます。このアプリは GoodWin プロキシを運用しません。この OS にシステムトンネルがない場合、接続は 127.0.0.1:10808 のローカル SOCKS プロキシだけを開始します。';

  @override
  String get privacySecretsTitle => '設定とシークレット';

  @override
  String get privacySecretsBody =>
      '共有リンク、保存済みプロファイル、サブスクリプション URL はこの端末に AES-256-GCM で暗号化して保存されます。暗号鍵は暗号文の隣ではなく、OS のキーストア / キーチェーンにあります。プラットフォームのキーストアが使えない場合、アプリはそれらの値を暗号化して保持できません。';

  @override
  String get privacyCameraTitle => 'カメラ';

  @override
  String get privacyCameraBody =>
      'カメラは共有リンクまたはサブスクリプション URL を含む QR のスキャンにだけ使います。フレームはアップロードされません。';

  @override
  String get privacyClipboardTitle => 'クリップボードとバックアップ';

  @override
  String get privacyClipboardBody =>
      'JSON をクリップボードにコピーすると非暗号化バックアップを書き込みます。クリップボードを読める人はそれらのリンクを読めます。ファイル書き出しでは任意のパスワード（AES-256-GCM）を使えます。';

  @override
  String get privacyAppsTitle => 'インストール済みアプリ（Android）';

  @override
  String get privacyAppsBody =>
      'アプリ単位のスプリットトンネリングは、VPN から除外できるよう端末のランチャーアプリ一覧を読みます。その一覧は端末に留まります。';

  @override
  String get privacyOpenWeb => 'プライバシーポリシーを開く';

  @override
  String get privacyOpenFailed => 'プライバシーポリシーの URL を開けませんでした';

  @override
  String get rulesEyebrow => 'トラフィックポリシー';

  @override
  String get rulesTitle => 'ルーティングルール';

  @override
  String get reset => 'リセット';

  @override
  String get resetRulesConfirm => 'ルーティングをデフォルトに戻しますか？';

  @override
  String get mode => 'モード';

  @override
  String get modeHintGlobalRich => '一致したすべてのトラフィック → プロキシ（Xray のデフォルト）。';

  @override
  String get modeHintGlobalSimple => 'Hysteria2 に推奨。';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Always-exclude 以外のすべてのトラフィックがトンネルを通ります。';

  @override
  String get modeHintRules => 'プリセット + カスタムルール。不一致 → プロキシ（Xray）。';

  @override
  String get modeHintRulesTrustTunnel =>
      'ダイレクトのドメイン/CIDR は TrustTunnel の除外になります。Block はスキップされます。不一致はトンネルに残ります。';

  @override
  String get modeHintDirect => 'すべて → freedom。TUN は維持（Xray のみ）。';

  @override
  String get presets => 'プリセット';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => '広告をブロック（限定）';

  @override
  String get presetBlockAdsPack => '広告をブロック';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      '内蔵の小さなホスト一覧 → block（Xray。geosite ではありません）';

  @override
  String get presetBlockAdsPackXray => 'サービス広告パック → block（geosite ではありません）';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'サービス広告パック → TrustTunnel 除外（プラグインの block なし）';

  @override
  String get presetBypassLan => 'LAN / プライベートをバイパス';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / リンクローカル CIDR → TUN 除外（リージョン/geoip ではありません）';

  @override
  String get presetBypassLanAndroid13 =>
      'LAN バイパスには Android 13+ が必要です。このバージョンでは CIDR 除外は無効です。';

  @override
  String get presetProtectBanking => '銀行アプリを保護';

  @override
  String get presetProtectBankingSubtitle =>
      'インストール済みの銀行アプリは TUN をスキップ（Android のアプリ単位）';

  @override
  String get appsSkipVpn => 'VPN をスキップするアプリ';

  @override
  String get appsSkipVpnEmpty => '銀行アプリの保護以外の任意の追加';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count 件選択 · 次回接続時に適用';
  }

  @override
  String get switchToRulesForPresets => 'プリセットを使うにはルールモードに切り替えてください。';

  @override
  String get alwaysExcludeMerged =>
      'Always-exclude CIDR は接続時にすべてのバックエンドで IP-direct ルールとマージされます。下の詳細で編集します。';

  @override
  String get alwaysExcludeCidr => 'Always exclude（CIDR）';

  @override
  String get alwaysExcludeHint => '1 行に 1 つの IP または CIDR。次回接続時に適用されます。';

  @override
  String get cidrHint => '1 行に 1 つの IP または CIDR\n例: 10.0.0.0/8';

  @override
  String get customRules => 'カスタムルール';

  @override
  String get customRulesHint =>
      'ドメインサフィックス、IP または CIDR → proxy / direct / block。接続時に Xray に適用。IP direct は OS 除外にも入ります。';

  @override
  String get customRulesHintTrustTunnel =>
      'ドメインまたは CIDR → proxy（トンネルに残す）または direct（除外）。Block は使えません。geosite はありません。';

  @override
  String get matcher => 'マッチャー';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'ルールを追加';

  @override
  String get noCustomRules => 'カスタムルールはまだありません';

  @override
  String osExclude(String action) {
    return '$action · OS 除外';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · TrustTunnel ではスキップ（プラグインの block なし）';

  @override
  String get enableAdvancedForRouting => '追加のルーティング操作には設定で詳細モードを有効にしてください。';

  @override
  String get searchApps => 'アプリを検索';

  @override
  String get save => '保存';

  @override
  String get routingBannerXray =>
      'Xray プロファイル: グローバル / ルール / ダイレクトとドメインルールは接続時に適用されます。';

  @override
  String get routingBannerHysteria =>
      'Hysteria2 プロファイル: ドメイン/block ルールと Xray ダイレクトは適用されません。グローバルを使ってください。Always-exclude CIDR と IP-direct は引き続き TUN にマージされます。';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: ルールのダイレクトドメイン/CIDR は除外になります。Block はスキップされます（プラグインの block なし）。ダイレクトモードは適用されません。Always-exclude は引き続きマージされます。アプリ単位スプリットは SOCKS のみです。Kill Switch は次の TrustTunnel 接続で適用されます。';

  @override
  String get routingBannerUnknown =>
      'どのルーティング機能が適用されるかは、プロファイルを選択または接続すると表示されます。';

  @override
  String get logsEyebrow => '診断';

  @override
  String get logsTitle => 'ログ';

  @override
  String get copyFiltered => 'フィルター済みをコピー';

  @override
  String get clear => 'クリア';

  @override
  String get logCopied => 'ログをコピーしました';

  @override
  String get logsHint => 'コアコンソール。色はヒューリスティックです（error/warn キーワード）。';

  @override
  String get filterHint => 'フィルター…';

  @override
  String get logsAll => 'すべて';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'エラー';

  @override
  String get noLogLinesYet => 'まだログ行がありません';

  @override
  String get noMatchesForFilter => 'フィルターに一致するものがありません';

  @override
  String get vpnConsole => 'VPN コンソール';

  @override
  String get logsSheetEmpty => 'まだ行がありません。ストリームを待っています…';

  @override
  String get copy => 'コピー';

  @override
  String get openLogs => 'ログを開く';

  @override
  String get tapToRetry => 'タップして再試行';

  @override
  String get homeErrorTitle => '接続できませんでした';

  @override
  String get homeErrorTunnel => 'トンネル失敗 — タップして再試行';

  @override
  String get homeErrorSocks => 'ローカル SOCKS 失敗 — タップして再試行';

  @override
  String get activeProfile => 'アクティブなプロファイル';

  @override
  String get socksInbound => 'ローカル SOCKS';

  @override
  String get socksInboundSubtitle =>
      'ユーザー名とパスワードを空にすると、接続のたびにランダムな認証情報が生成されます。他のアプリ: 127.0.0.1 とこれらの認証情報。';

  @override
  String get socksPort => 'ポート';

  @override
  String get socksUsername => 'ユーザー名';

  @override
  String get socksPassword => 'パスワード';

  @override
  String get saveSocks => 'SOCKS を保存';

  @override
  String get socksSaved => 'SOCKS を保存しました';

  @override
  String get killSwitchAndroidConfirmTitle => 'Always-on をオンにしましたか？';

  @override
  String get killSwitchAndroidConfirmBody =>
      'アプリは Android の VPN スイッチを切り替えられません。GoodWin VPN で Always-on と VPN なしの接続をブロックを有効にした後にだけ、ここで Kill Switch をオンにしてください。';

  @override
  String get killSwitchAndroidConfirmYes => 'はい、オンです';

  @override
  String get killSwitchAndroidConfirmNo => 'まだです';

  @override
  String get killSwitchIosDisconnectFailed =>
      'オンデマンドをオフにできませんでした。再試行するまで切断が定着しないことがあります。';

  @override
  String get support => 'サポート';

  @override
  String get supportSubtitle => 'オペレーターのサポートページを開く';

  @override
  String get supportUnavailable => 'このサブスクリプションにサポート URL がありません';

  @override
  String get licenses => 'オープンソースライセンス';

  @override
  String get licensesSubtitle => 'このアプリに同梱されているコアとライブラリ';

  @override
  String get licensesBody =>
      'このアプリは Xray-core、Hysteria 2、hev-socks5-tunnel、TrustTunnel、Flutter、Inter（SIL OFL）を同梱しています。ソースとライセンスはプロジェクトのリポジトリにあります。';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingDone => '始める';

  @override
  String get onboardingServerTitle => 'あなたのサーバー';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN はインポートしたノード向けのクライアントです。GoodWin クラウドプロキシはありません。プロファイルで共有リンクまたは https サブスクリプション URL を追加してください。';

  @override
  String get onboardingVpnTitle => 'システム VPN';

  @override
  String get onboardingVpnBody =>
      '接続すると OS に VPN 構成の追加を求めます。そのダイアログは Android または iOS のもので、このアプリではありません。その後トラフィックは選択したプロファイルのノードへ行きます。';

  @override
  String get onboardingCameraTitle => 'QR 用カメラ';

  @override
  String get onboardingCameraBody =>
      'カメラは任意で、共有リンクまたはサブスクリプション URL の QR をスキャンするだけです。フレームは端末に留まります。';

  @override
  String get vpnExplainerTitle => 'システム VPN の許可';

  @override
  String get vpnExplainerBody =>
      '次の画面は OS の VPN ダイアログです。この端末がインポートしたノード経由でトラフィックを送る場合にだけ許可してください。';

  @override
  String get vpnExplainerContinue => '続ける';

  @override
  String get cameraExplainerTitle => 'カメラの許可';

  @override
  String get cameraExplainerBody =>
      '次の画面でカメラが求められることがあります。構成 QR のスキャンにだけ使います。フレームはアップロードされません。';

  @override
  String get cameraExplainerContinue => 'QR をスキャン';

  @override
  String get importLinkHint =>
      '共有リンクまたは https:// サブスクリプション URL を貼り付けてください。このアプリはプロキシをホストしません。';
}
