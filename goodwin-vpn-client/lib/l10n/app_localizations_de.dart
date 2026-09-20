// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Start';

  @override
  String get navProfiles => 'Profile';

  @override
  String get navRules => 'Regeln';

  @override
  String get navLogs => 'Protokolle';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get connectVpn => 'VPN verbinden';

  @override
  String get disconnectVpn => 'VPN trennen';

  @override
  String get noProfile => 'Kein Profil';

  @override
  String get addProfileToConnect => 'Profil hinzufügen, um zu verbinden';

  @override
  String get addProfileToConnectHint =>
      'Importieren Sie einen Freigabelink unter Profile und tippen Sie dann hier auf Verbinden.';

  @override
  String get addProfile => 'Profil hinzufügen';

  @override
  String get networkStatus => 'NETZWERKSTATUS';

  @override
  String get tapToDisconnect => 'Tippen zum Trennen';

  @override
  String get tapToConnect => 'Tippen zum Verbinden';

  @override
  String get statNode => 'Knoten';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Laufzeit';

  @override
  String get sessionLogs => 'Sitzungsprotokolle';

  @override
  String get noLinesYet => 'Noch keine Zeilen';

  @override
  String logLinesCount(int count) {
    return '$count Zeilen';
  }

  @override
  String get uacDeclined => 'UAC-Abfrage wurde abgelehnt';

  @override
  String get statusOffline => 'getrennt';

  @override
  String get statusConnecting => 'verbinden';

  @override
  String get statusConnected => 'verbunden';

  @override
  String get statusDisconnecting => 'trennen';

  @override
  String get statusError => 'Fehler';

  @override
  String get switchProfile => 'Profil wechseln';

  @override
  String get manageProfiles => 'Profile verwalten';

  @override
  String get routing => 'Routing';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · ändern unter Regeln';
  }

  @override
  String get routingModeGlobal => 'Global';

  @override
  String get routingModeRules => 'Regeln';

  @override
  String get routingModeDirect => 'Direkt';

  @override
  String get homeReadyTitle => 'Getrennt';

  @override
  String get homeReadyTunnel =>
      'Verbinden startet ein System-VPN auf diesem Gerät';

  @override
  String get homeReadySocks =>
      'Dieses Betriebssystem hat noch kein System-VPN — Verbinden ist ein lokaler SOCKS-Proxy';

  @override
  String get homeBusyTitle => 'Verbinden';

  @override
  String get homeBusyTunnel => 'VPN-Tunnel beim Betriebssystem anfordern';

  @override
  String get homeBusySocks => 'Lokalen SOCKS-Proxy starten';

  @override
  String get homeConnectedTunnelTitle => 'System-VPN';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Der Geräteverkehr läuft durch den Tunnel, nicht über Ihre Heim-IP';

  @override
  String get homeConnectedSocksTitle => 'Lokales SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      'Kein Systemtunnel auf diesem Betriebssystem. Apps müssen 127.0.0.1:10808 nutzen — Ihre IP bleibt sichtbar';

  @override
  String get revokedTitle => 'Abonnement-Link wurde widerrufen';

  @override
  String get revokedBody =>
      'Fügen Sie unter Profile eine neue URL ein. Alte Knoten bleiben, bis Sie einen Ersatz importieren.';

  @override
  String get openProfiles => 'Profile öffnen';

  @override
  String get elevationTitle => 'Administratorrechte erforderlich';

  @override
  String get runAsAdministrator => 'Als Administrator ausführen';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used verbraucht · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'abgelaufen';

  @override
  String quotaDaysLeft(int days) {
    return 'noch $days T.';
  }

  @override
  String get quotaScopeNote => 'VLESS+Hy2-Traffic — TrustTunnel ungezählt';

  @override
  String get profilesEyebrow => 'Ihr Netzwerk';

  @override
  String get profilesTitle => 'Serverprofile';

  @override
  String get tooltipPinging => 'Ping wird gemessen…';

  @override
  String get tooltipCheckPing => 'Ping prüfen';

  @override
  String get noProfilesToPing => 'Keine Profile zum Pingen';

  @override
  String get tooltipImportLink => 'Link oder Abonnement importieren';

  @override
  String get searchServersHint => 'Server oder Protokolle suchen';

  @override
  String get smartConnect => 'Intelligentes Verbinden';

  @override
  String get smartConnectSubtitle =>
      'Start-Verbinden nutzt den Knoten mit dem niedrigsten Ping im aktuellen Abonnement';

  @override
  String get emptyProfiles =>
      'Noch keine gespeicherten Profile.\nImportieren Sie einen Freigabelink oder eine https://-Abonnement-URL.';

  @override
  String get noMatches => 'Keine Treffer';

  @override
  String get pinging => 'Ping läuft';

  @override
  String get fastest => 'schnellste';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteProfileConfirm => 'Dieses Profil löschen?';

  @override
  String get deleteSubscriptionConfirm =>
      'Dieses Abonnement und seine gespeicherten Knoten entfernen?';

  @override
  String updatedSubscription(String name) {
    return '$name aktualisiert';
  }

  @override
  String get importProfile => 'Profil importieren';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get importLinkLabel => 'Freigabelink oder https://-Abonnement-URL';

  @override
  String get paste => 'Einfügen';

  @override
  String get scanQr => 'QR scannen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get import => 'Importieren';

  @override
  String get unrecognizedShareLink => 'Unbekannter Freigabelink';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get name => 'Name';

  @override
  String get shareLink => 'Freigabelink';

  @override
  String get apply => 'Übernehmen';

  @override
  String get importedManual => 'Importiert';

  @override
  String get subscriptionFallback => 'Abonnement';

  @override
  String get revokedKeepNodes =>
      'Link widerrufen — neue URL einfügen. Knoten wurden nicht gelöscht.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count Knoten';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Knoten',
      one: '1 Knoten',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Abonnement aktualisieren';

  @override
  String get removeSubscription => 'Abonnement entfernen';

  @override
  String get nothingToImport => 'Nichts zu importieren';

  @override
  String get subscriptionImported => 'Abonnement importiert';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name importiert ($count Knoten)';
  }

  @override
  String get profileImported => 'Profil importiert';

  @override
  String get settingsEyebrow => 'Anwendung';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get colorTheme => 'Farbthema';

  @override
  String get colorThemeSubtitle =>
      'Helles Papier und dunkles Marineblau. System folgt dem Telefon.';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Sprache';

  @override
  String get languageSubtitle =>
      'Englisch und Russisch. System folgt dem Telefon.';

  @override
  String get localeSystem => 'System';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Allgemein';

  @override
  String get advancedMode => 'Erweiterter Modus';

  @override
  String get advancedModeSubtitle =>
      'Protokoll-Tab und Funktionen für Fortgeschrittene';

  @override
  String get reconnectOnLaunch => 'Beim Start neu verbinden';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Letztes Profil starten, wenn das OS-VPN getrennt ist';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'System';

  @override
  String get dnsCustom => 'Benutzerdefiniert';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS-Server / DoH-URL';

  @override
  String get dnsSaved => 'DNS-Einstellung gespeichert';

  @override
  String get saveDns => 'DNS speichern';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Immer verfügbares VPN in den Android-Einstellungen. Dieser Schalter allein ist nicht lecksicher.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Plugin-Lecksperre beim nächsten TrustTunnel-Connect. Immer verfügbar bleibt nach dem Neustart nötig.';

  @override
  String get killSwitchSubtitleIos =>
      'Verbindet erneut, wenn der Tunnel abbricht. Push, Watch und iMessage bleiben erreichbar.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Plugin-Lecksperre für diese TrustTunnel-Sitzung. Trennen schaltet sie aus, bevor ein SOCKS-VPN starten kann.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Systemschutz gegen Lecks einschalten';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. Tippen Sie auf dem nächsten Bildschirm auf Goodwin VPN (SOCKS oder TrustTunnel).\n2. Schalten Sie Immer verfügbares VPN ein.\n3. Schalten Sie Verbindungen ohne VPN blockieren ein.\n4. Kehren Sie hierher zurück und tippen Sie auf Verbinden.\n\nDie App kann diese Android-Schalter nicht selbst umlegen. TrustTunnel nutzt beim nächsten Verbinden zusätzlich den Plugin-Leckschutz.';

  @override
  String get killSwitchAndroidDisableTitle =>
      'Zuerst Immer verfügbar ausschalten';

  @override
  String get killSwitchAndroidDisableBody =>
      'Schalten Sie in den Android-VPN-Einstellungen Immer verfügbares VPN und Verbindungen ohne VPN blockieren für Goodwin aus. Sonst bringt Trennen den Tunnel zurück.';

  @override
  String get killSwitchOpenSettings => 'VPN-Einstellungen öffnen';

  @override
  String get killSwitchDisconnectTitle => 'Immer verfügbar kann neu verbinden';

  @override
  String get killSwitchDisconnectBody =>
      'Androids Immer verfügbares VPN kann den Tunnel nach dem Trennen wiederherstellen. Schalten Sie Immer verfügbar in den System-VPN-Einstellungen aus, wenn das Netzwerk vollständig offen sein soll.';

  @override
  String get killSwitchDisconnectConfirm => 'Trennen';

  @override
  String get coreTuning => 'Kern-Feinabstimmung';

  @override
  String get advancedDangerTooltip => 'Erweitert — kann die Verbindung stören';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Nicht mit Vision — typisches VLESS startet weiter';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Nicht bei REALITY — nur TLS-Hello';

  @override
  String get dnsHintWithTuning =>
      'DNS-IPs gelten beim Verbinden für das OS-TUN. DoH geht in das Xray-JSON; TUN nutzt weiter Bootstrap-IPs. Mux / Fragment: nur Xray.';

  @override
  String get dnsHintSimple => 'DNS-IPs gelten beim Verbinden für das OS-TUN.';

  @override
  String get backup => 'Sicherung';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Sicherungsdatei exportieren';

  @override
  String get exportBackupSubtitle =>
      'Profile und Abonnements. Optionales Passwort verschlüsselt die Datei';

  @override
  String get importBackup => 'Sicherungsdatei importieren';

  @override
  String get importBackupSubtitle => 'Wird in den aktuellen Katalog eingefügt';

  @override
  String get copyJsonClipboard => 'JSON in die Zwischenablage kopieren';

  @override
  String get copyJsonClipboardSubtitle =>
      'Unverschlüsselt — jeder mit Zugriff auf die Zwischenablage kann Links lesen';

  @override
  String get copiedEmptyProfiles => 'Leere Profilliste kopiert';

  @override
  String copiedProfilesJson(int count) {
    return '$count Profil(e) als unverschlüsseltes JSON kopiert';
  }

  @override
  String get exportBackupTitle => 'Sicherung exportieren';

  @override
  String get exportBackupPasswordHint =>
      'Leer lassen für eine einfache JSON-Datei. Ein Passwort nutzt AES-256-GCM.';

  @override
  String get backupFileSaved => 'Sicherungsdatei gespeichert';

  @override
  String get encryptedBackupSaved =>
      'Verschlüsselte Sicherungsdatei gespeichert';

  @override
  String get encryptedBackupTitle => 'Verschlüsselte Sicherung';

  @override
  String get encryptedBackupHint =>
      'Geben Sie das beim Export verwendete Passwort ein.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles Profil(e) und $subs Abonnement(s) importiert';
  }

  @override
  String get passwordOptional => 'Passwort (optional)';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get continueAction => 'Weiter';

  @override
  String get about => 'Info';

  @override
  String get aboutSubtitle => 'VPN-Client für Ihren eigenen Server';

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
  String get privacy => 'Datenschutz';

  @override
  String get privacySubtitle =>
      'Kamera, VPN, Geheimnisse auf dem Gerät, Zwischenablage-Sicherungen';

  @override
  String get privacyWhatTitle => 'Was diese App verwendet';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN ist ein lokaler Client. In diesem Build gibt es keinen Goodwin-Kontoserver und kein Analytics-SDK.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'Auf Plattformen mit Systemtunnel wird der Geräteverkehr an den Knoten im importierten Freigabelink gesendet. Die App betreibt keinen Goodwin-Proxy. Hat dieses Betriebssystem keinen Systemtunnel, startet Verbinden nur einen lokalen SOCKS-Proxy unter 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Konfigurationen und Geheimnisse';

  @override
  String get privacySecretsBody =>
      'Freigabelinks, gespeicherte Profile und Abonnement-URLs werden auf diesem Gerät mit AES-256-GCM verschlüsselt gespeichert. Der Schlüssel liegt im OS-Keystore / der Keychain, nicht neben dem Chiffretext. Ist der Plattform-Keystore nicht verfügbar, kann die App diese Werte nicht verschlüsselt halten.';

  @override
  String get privacyCameraTitle => 'Kamera';

  @override
  String get privacyCameraBody =>
      'Die Kamera dient nur zum Scannen eines QR-Codes mit Freigabelink oder Abonnement-URL. Bilder werden nicht hochgeladen.';

  @override
  String get privacyClipboardTitle => 'Zwischenablage und Sicherungen';

  @override
  String get privacyClipboardBody =>
      'JSON in die Zwischenablage kopieren schreibt eine unverschlüsselte Sicherung. Jeder mit Zugriff auf die Zwischenablage kann diese Links lesen. Der Dateiexport kann ein optionales Passwort nutzen (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Installierte Apps (Android)';

  @override
  String get privacyAppsBody =>
      'Split-Tunneling pro App liest die Launcher-App-Liste auf dem Gerät, damit Sie Apps vom VPN ausschließen können. Diese Liste bleibt auf dem Gerät.';

  @override
  String get privacyOpenWeb => 'Datenschutzrichtlinie öffnen';

  @override
  String get privacyOpenFailed =>
      'URL der Datenschutzrichtlinie konnte nicht geöffnet werden';

  @override
  String get rulesEyebrow => 'Verkehrsrichtlinie';

  @override
  String get rulesTitle => 'Routingregeln';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get resetRulesConfirm => 'Routing auf Standardwerte zurücksetzen?';

  @override
  String get mode => 'Modus';

  @override
  String get modeHintGlobalRich =>
      'Gesamter zutreffender Verkehr → Proxy (Xray-Standard).';

  @override
  String get modeHintGlobalSimple => 'Empfohlen für Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Gesamter Verkehr durch den Tunnel außer Immer ausschließen.';

  @override
  String get modeHintRules =>
      'Voreinstellungen + eigene Regeln; Unzutreffendes → Proxy (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Direkt-Domains/CIDRs werden TrustTunnel-Ausschlüsse. Block wird übersprungen. Unzutreffendes bleibt im Tunnel.';

  @override
  String get modeHintDirect => 'Alles → freedom. TUN bleibt aktiv (nur Xray).';

  @override
  String get presets => 'Voreinstellungen';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Werbung blockieren (begrenzt)';

  @override
  String get presetBlockAdsPack => 'Werbung blockieren';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Kleine eingebaute Hostliste → block (Xray; kein geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'Service-Werbe-Pack → block (kein geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Service-Werbe-Pack → TrustTunnel-Ausschlüsse (kein Plugin-Block)';

  @override
  String get presetBypassLan => 'LAN / privat umgehen';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918- / Link-Local-CIDRs → TUN-Ausschlüsse (keine Region/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'LAN umgehen benötigt Android 13+. CIDR-Ausschlüsse tun auf dieser Version nichts.';

  @override
  String get presetProtectBanking => 'Banking schützen';

  @override
  String get presetProtectBankingSubtitle =>
      'Installierte Banking-Apps umgehen das TUN (Android pro App)';

  @override
  String get appsSkipVpn => 'Apps, die das VPN umgehen';

  @override
  String get appsSkipVpnEmpty => 'Optionale Ergänzungen neben Banking schützen';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count ausgewählt · gilt beim nächsten Verbinden';
  }

  @override
  String get switchToRulesForPresets =>
      'Wechseln Sie in den Regeln-Modus, um Voreinstellungen zu nutzen.';

  @override
  String get alwaysExcludeMerged =>
      'Immer-ausschließen-CIDRs werden beim Verbinden für jedes Backend mit IP-Direktregeln zusammengeführt. Bearbeiten Sie sie unten unter Erweitert.';

  @override
  String get alwaysExcludeCidr => 'Immer ausschließen (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Eine IP oder CIDR pro Zeile. Gilt beim nächsten Verbinden.';

  @override
  String get cidrHint => 'Eine IP oder CIDR pro Zeile\nz. B. 10.0.0.0/8';

  @override
  String get customRules => 'Eigene Regeln';

  @override
  String get customRulesHint =>
      'Domain-Suffix, IP oder CIDR → proxy / direct / block. Wird beim Verbinden auf Xray angewendet. IP-direct speist auch OS-Ausschlüsse.';

  @override
  String get customRulesHintTrustTunnel =>
      'Domain oder CIDR → proxy (im Tunnel bleiben) oder direct (ausschließen). Block ist nicht verfügbar. Kein geosite.';

  @override
  String get matcher => 'Matcher';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Regel hinzufügen';

  @override
  String get noCustomRules => 'Noch keine eigenen Regeln';

  @override
  String osExclude(String action) {
    return '$action · OS-Ausschluss';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · auf TrustTunnel übersprungen (kein Plugin-Block)';

  @override
  String get enableAdvancedForRouting =>
      'Aktivieren Sie den erweiterten Modus in den Einstellungen für zusätzliche Routing-Steuerung.';

  @override
  String get searchApps => 'Apps suchen';

  @override
  String get save => 'Speichern';

  @override
  String get routingBannerXray =>
      'Xray-Profil: Global / Regeln / Direkt und Domainregeln gelten beim Verbinden.';

  @override
  String get routingBannerHysteria =>
      'Hysteria2-Profil: Domain-/Blockregeln und Xray-Direkt werden nicht angewendet. Nutzen Sie Global; Immer-ausschließen-CIDRs und IP-direct fließen weiter ins TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: Regeln-Direkt-Domains/CIDRs werden Ausschlüsse. Block wird übersprungen (kein Plugin-Block). Direktmodus wird nicht angewendet. Immer ausschließen wird weiter zusammengeführt. Split pro App gilt nur für SOCKS. Kill Switch gilt beim nächsten TrustTunnel-Verbinden.';

  @override
  String get routingBannerUnknown =>
      'Wählen oder verbinden Sie ein Profil, um zu sehen, welche Routing-Funktionen gelten.';

  @override
  String get logsEyebrow => 'Diagnose';

  @override
  String get logsTitle => 'Protokolle';

  @override
  String get copyFiltered => 'Gefiltertes kopieren';

  @override
  String get clear => 'Leeren';

  @override
  String get logCopied => 'Protokoll kopiert';

  @override
  String get logsHint =>
      'Kern-Konsole. Farben sind heuristisch (error/warn-Schlüsselwörter).';

  @override
  String get filterHint => 'Filter…';

  @override
  String get logsAll => 'Alle';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Fehler';

  @override
  String get noLogLinesYet => 'Noch keine Protokollzeilen';

  @override
  String get noMatchesForFilter => 'Keine Treffer für den Filter';

  @override
  String get vpnConsole => 'VPN-Konsole';

  @override
  String get logsSheetEmpty => 'Noch keine Zeilen. Warte auf den Stream…';

  @override
  String get copy => 'Kopieren';

  @override
  String get openLogs => 'Protokolle öffnen';

  @override
  String get tapToRetry => 'Tippen zum Wiederholen';

  @override
  String get homeErrorTitle => 'Verbindung fehlgeschlagen';

  @override
  String get homeErrorTunnel =>
      'Tunnel fehlgeschlagen — tippen zum Wiederholen';

  @override
  String get homeErrorSocks =>
      'Lokales SOCKS fehlgeschlagen — tippen zum Wiederholen';

  @override
  String get activeProfile => 'AKTIVES PROFIL';

  @override
  String get socksInbound => 'Lokales SOCKS';

  @override
  String get socksInboundSubtitle =>
      'Benutzer und Passwort leer lassen, um bei jedem Verbinden zufällige Anmeldedaten zu erzeugen. Andere Apps: 127.0.0.1 plus diese Anmeldedaten.';

  @override
  String get socksPort => 'Port';

  @override
  String get socksUsername => 'Benutzername';

  @override
  String get socksPassword => 'Passwort';

  @override
  String get saveSocks => 'SOCKS speichern';

  @override
  String get socksSaved => 'SOCKS gespeichert';

  @override
  String get killSwitchAndroidConfirmTitle =>
      'Haben Sie Immer verfügbar eingeschaltet?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'Die App kann Android-VPN-Schalter nicht umlegen. Schalten Sie den Kill Switch hier erst ein, wenn Immer verfügbares VPN und Verbindungen ohne VPN blockieren für GoodWin VPN aktiv sind.';

  @override
  String get killSwitchAndroidConfirmYes => 'Ja, sie sind an';

  @override
  String get killSwitchAndroidConfirmNo => 'Noch nicht';

  @override
  String get killSwitchIosDisconnectFailed =>
      'On-Demand konnte nicht ausgeschaltet werden. Das Trennen hält möglicherweise erst nach erneutem Versuch.';

  @override
  String get support => 'Support';

  @override
  String get supportSubtitle => 'Support-Seite des Betreibers öffnen';

  @override
  String get supportUnavailable => 'Keine Support-URL in diesem Abonnement';

  @override
  String get licenses => 'Open-Source-Lizenzen';

  @override
  String get licensesSubtitle =>
      'In dieser App gebündelte Kerne und Bibliotheken';

  @override
  String get licensesBody =>
      'Diese App bündelt Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter und Inter (SIL OFL). Quellcode und Lizenzen liegen in den Projekt-Repositories.';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingDone => 'Loslegen';

  @override
  String get onboardingServerTitle => 'Ihr Server';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN ist ein Client für einen Knoten, den Sie importieren. Es gibt keinen Goodwin-Cloud-Proxy. Fügen Sie unter Profile einen Freigabelink oder eine https-Abonnement-URL hinzu.';

  @override
  String get onboardingVpnTitle => 'System-VPN';

  @override
  String get onboardingVpnBody =>
      'Verbinden bittet das Betriebssystem, eine VPN-Konfiguration hinzuzufügen. Dieser Dialog stammt von Android oder iOS, nicht von dieser App. Der Verkehr geht dann an den Knoten im gewählten Profil.';

  @override
  String get onboardingCameraTitle => 'Kamera für QR';

  @override
  String get onboardingCameraBody =>
      'Die Kamera ist optional und scannt nur einen QR mit Freigabelink oder Abonnement-URL. Bilder bleiben auf dem Gerät.';

  @override
  String get vpnExplainerTitle => 'System-VPN-Berechtigung';

  @override
  String get vpnExplainerBody =>
      'Der nächste Bildschirm ist der OS-VPN-Dialog. Erlauben Sie ihn nur, wenn dieses Gerät den Verkehr durch den importierten Knoten senden soll.';

  @override
  String get vpnExplainerContinue => 'Weiter';

  @override
  String get cameraExplainerTitle => 'Kameraberechtigung';

  @override
  String get cameraExplainerBody =>
      'Der nächste Bildschirm kann nach der Kamera fragen. Sie dient nur zum Scannen eines Konfigurations-QR. Bilder werden nicht hochgeladen.';

  @override
  String get cameraExplainerContinue => 'QR scannen';

  @override
  String get importLinkHint =>
      'Fügen Sie einen Freigabelink oder eine https://-Abonnement-URL ein. Die App betreibt keinen Proxy.';
}
