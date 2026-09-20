// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Home';

  @override
  String get navProfiles => 'Profili';

  @override
  String get navRules => 'Regole';

  @override
  String get navLogs => 'Log';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get connectVpn => 'Connetti VPN';

  @override
  String get disconnectVpn => 'Disconnetti VPN';

  @override
  String get noProfile => 'Nessun profilo';

  @override
  String get addProfileToConnect => 'Aggiungi un profilo per connetterti';

  @override
  String get addProfileToConnectHint =>
      'Importa un link di condivisione in Profili, poi tocca Connetti qui.';

  @override
  String get addProfile => 'Aggiungi profilo';

  @override
  String get networkStatus => 'STATO DELLA RETE';

  @override
  String get tapToDisconnect => 'Tocca per disconnettere';

  @override
  String get tapToConnect => 'Tocca per connettere';

  @override
  String get statNode => 'Nodo';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Tempo di attività';

  @override
  String get sessionLogs => 'Log della sessione';

  @override
  String get noLinesYet => 'Ancora nessuna riga';

  @override
  String logLinesCount(int count) {
    return '$count righe';
  }

  @override
  String get uacDeclined => 'Prompt UAC rifiutato';

  @override
  String get statusOffline => 'disconnesso';

  @override
  String get statusConnecting => 'connessione in corso';

  @override
  String get statusConnected => 'connesso';

  @override
  String get statusDisconnecting => 'disconnessione in corso';

  @override
  String get statusError => 'errore';

  @override
  String get switchProfile => 'Cambia profilo';

  @override
  String get manageProfiles => 'Gestisci profili';

  @override
  String get routing => 'Routing';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · modifica in Regole';
  }

  @override
  String get routingModeGlobal => 'Globale';

  @override
  String get routingModeRules => 'Regole';

  @override
  String get routingModeDirect => 'Diretto';

  @override
  String get homeReadyTitle => 'Disconnesso';

  @override
  String get homeReadyTunnel =>
      'Connetti avvia un VPN di sistema su questo dispositivo';

  @override
  String get homeReadySocks =>
      'Questo SO non ha ancora un VPN di sistema — Connetti è un proxy SOCKS locale';

  @override
  String get homeBusyTitle => 'Connessione';

  @override
  String get homeBusyTunnel => 'Richiesta di un tunnel VPN al SO';

  @override
  String get homeBusySocks => 'Avvio di un proxy SOCKS locale';

  @override
  String get homeConnectedTunnelTitle => 'VPN di sistema';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Il traffico del dispositivo passa nel tunnel, non dal tuo IP di casa';

  @override
  String get homeConnectedSocksTitle => 'SOCKS locale';

  @override
  String get homeConnectedSocksSubtitle =>
      'Nessun tunnel di sistema su questo SO. Le app devono usare 127.0.0.1:10808 — il tuo IP non è nascosto';

  @override
  String get revokedTitle => 'Il link di abbonamento è stato revocato';

  @override
  String get revokedBody =>
      'Incolla un nuovo URL in Profili. I nodi vecchi restano finché non importi un sostituto.';

  @override
  String get openProfiles => 'Apri Profili';

  @override
  String get elevationTitle => 'Diritti di amministratore richiesti';

  @override
  String get runAsAdministrator => 'Esegui come amministratore';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used usati · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'scaduto';

  @override
  String quotaDaysLeft(int days) {
    return '${days}g rimanenti';
  }

  @override
  String get quotaScopeNote =>
      'Traffico VLESS+Hy2 — TrustTunnel non conteggiato';

  @override
  String get profilesEyebrow => 'La tua rete';

  @override
  String get profilesTitle => 'Profili server';

  @override
  String get tooltipPinging => 'Ping in corso…';

  @override
  String get tooltipCheckPing => 'Controlla Ping';

  @override
  String get noProfilesToPing => 'Nessun profilo da pingare';

  @override
  String get tooltipImportLink => 'Importa link o abbonamento';

  @override
  String get searchServersHint => 'Cerca server o protocolli';

  @override
  String get smartConnect => 'Connessione intelligente';

  @override
  String get smartConnectSubtitle =>
      'Connetti in Home usa il nodo con Ping più basso nell\'abbonamento corrente';

  @override
  String get emptyProfiles =>
      'Nessun profilo salvato.\nImporta un link di condivisione o un URL di abbonamento https://.';

  @override
  String get noMatches => 'Nessuna corrispondenza';

  @override
  String get pinging => 'ping in corso';

  @override
  String get fastest => 'più veloce';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteProfileConfirm => 'Eliminare questo profilo?';

  @override
  String get deleteSubscriptionConfirm =>
      'Rimuovere questo abbonamento e i nodi salvati?';

  @override
  String updatedSubscription(String name) {
    return 'Aggiornato $name';
  }

  @override
  String get importProfile => 'Importa profilo';

  @override
  String get nameOptional => 'Nome (facoltativo)';

  @override
  String get importLinkLabel =>
      'Link di condivisione o URL di abbonamento https://';

  @override
  String get paste => 'Incolla';

  @override
  String get scanQr => 'Scansiona QR';

  @override
  String get cancel => 'Annulla';

  @override
  String get import => 'Importa';

  @override
  String get unrecognizedShareLink => 'Link di condivisione non riconosciuto';

  @override
  String get editProfile => 'Modifica profilo';

  @override
  String get name => 'Nome';

  @override
  String get shareLink => 'Link di condivisione';

  @override
  String get apply => 'Applica';

  @override
  String get importedManual => 'Importato';

  @override
  String get subscriptionFallback => 'Abbonamento';

  @override
  String get revokedKeepNodes =>
      'Link revocato — incolla un nuovo URL. I nodi non sono stati cancellati.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count nodi';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nodi',
      one: '1 nodo',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Aggiorna abbonamento';

  @override
  String get removeSubscription => 'Rimuovi abbonamento';

  @override
  String get nothingToImport => 'Niente da importare';

  @override
  String get subscriptionImported => 'Abbonamento importato';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return 'Importato $name ($count nodi)';
  }

  @override
  String get profileImported => 'Profilo importato';

  @override
  String get settingsEyebrow => 'Applicazione';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get appearance => 'Aspetto';

  @override
  String get colorTheme => 'Tema colore';

  @override
  String get colorThemeSubtitle =>
      'Carta chiara e navy scuro. Il sistema segue il telefono.';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get language => 'Lingua';

  @override
  String get languageSubtitle =>
      'Inglese e russo. Il sistema segue il telefono.';

  @override
  String get localeSystem => 'Sistema';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Generale';

  @override
  String get advancedMode => 'Modalità avanzata';

  @override
  String get advancedModeSubtitle => 'Scheda Log e opzioni per utenti esperti';

  @override
  String get reconnectOnLaunch => 'Riconnetti all\'avvio';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Avvia l\'ultimo profilo se il VPN di sistema è spento';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'Sistema';

  @override
  String get dnsCustom => 'Personalizzato';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'Server DNS / URL DoH';

  @override
  String get dnsSaved => 'Preferenza DNS salvata';

  @override
  String get saveDns => 'Salva DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'VPN sempre attiva nelle impostazioni Android. L\'interruttore qui da solo non è a prova di perdita.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Blocco perdite del plugin al prossimo Connect TrustTunnel. Dopo il riavvio serve ancora Always-on.';

  @override
  String get killSwitchSubtitleIos =>
      'Riconnette se il tunnel cade. Push, Watch e iMessage restano raggiungibili.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Blocco perdite del plugin per questa sessione TrustTunnel. Disconnetti lo spegne prima che possa partire un VPN SOCKS.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Attiva la protezione perdite di sistema';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. Nella schermata successiva, tocca GoodWin VPN (SOCKS o TrustTunnel).\n2. Attiva Always-on VPN.\n3. Attiva Blocca connessioni senza VPN.\n4. Torna qui e tocca Connetti.\n\nL\'app non può cambiare da sola questi interruttori Android. TrustTunnel usa anche la protezione perdite del plugin al prossimo Connect.';

  @override
  String get killSwitchAndroidDisableTitle => 'Prima disattiva Always-on';

  @override
  String get killSwitchAndroidDisableBody =>
      'Nelle impostazioni VPN di Android, disattiva Always-on VPN e Blocca connessioni senza VPN per GoodWin. Altrimenti Disconnetti riporterà il tunnel.';

  @override
  String get killSwitchOpenSettings => 'Apri impostazioni VPN';

  @override
  String get killSwitchDisconnectTitle => 'Always-on potrebbe riconnettere';

  @override
  String get killSwitchDisconnectBody =>
      'Always-on VPN di Android può riportare il tunnel dopo Disconnetti. Disattiva Always-on nelle impostazioni VPN di sistema se vuoi la rete completamente aperta.';

  @override
  String get killSwitchDisconnectConfirm => 'Disconnetti';

  @override
  String get coreTuning => 'Regolazione del core';

  @override
  String get advancedDangerTooltip =>
      'Avanzato — può interrompere la connettività';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Non usato con Vision — il VLESS tipico si avvia';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Non usato su REALITY — solo TLS hello';

  @override
  String get dnsHintWithTuning =>
      'Gli IP DNS si applicano al TUN del SO alla connessione. DoH va nel JSON Xray; il TUN usa comunque IP di bootstrap. Mux / Fragment: solo Xray.';

  @override
  String get dnsHintSimple =>
      'Gli IP DNS si applicano al TUN del SO alla connessione.';

  @override
  String get backup => 'Backup';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Esporta file di backup';

  @override
  String get exportBackupSubtitle =>
      'Profili e abbonamenti. Una password facoltativa cifra il file';

  @override
  String get importBackup => 'Importa file di backup';

  @override
  String get importBackupSubtitle => 'Si unisce al catalogo corrente';

  @override
  String get copyJsonClipboard => 'Copia JSON negli appunti';

  @override
  String get copyJsonClipboardSubtitle =>
      'Non cifrato — chiunque abbia gli appunti può leggere i link';

  @override
  String get copiedEmptyProfiles => 'Elenco profili vuoto copiato';

  @override
  String copiedProfilesJson(int count) {
    return 'Copiati $count profilo/i come JSON non cifrato';
  }

  @override
  String get exportBackupTitle => 'Esporta backup';

  @override
  String get exportBackupPasswordHint =>
      'Lascia vuoto per un file JSON in chiaro. Una password usa AES-256-GCM.';

  @override
  String get backupFileSaved => 'File di backup salvato';

  @override
  String get encryptedBackupSaved => 'File di backup cifrato salvato';

  @override
  String get encryptedBackupTitle => 'Backup cifrato';

  @override
  String get encryptedBackupHint =>
      'Inserisci la password usata in esportazione.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return 'Importati $profiles profilo/i e $subs abbonamento/i';
  }

  @override
  String get passwordOptional => 'Password (facoltativa)';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono';

  @override
  String get continueAction => 'Continua';

  @override
  String get about => 'Informazioni';

  @override
  String get aboutSubtitle => 'Client VPN per il tuo server';

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
      'Fotocamera, VPN, segreti sul dispositivo, backup dagli appunti';

  @override
  String get privacyWhatTitle => 'Cosa usa questa app';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN è un client locale. In questa build non c\'è un server account GoodWin né un SDK di analitica.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'Sulle piattaforme con tunnel di sistema, il traffico del dispositivo viene inviato al nodo nel link di condivisione importato. L\'app non gestisce un proxy GoodWin. Se questo SO non ha un tunnel di sistema, Connetti avvia solo un proxy SOCKS locale su 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Configurazioni e segreti';

  @override
  String get privacySecretsBody =>
      'Link di condivisione, profili salvati e URL di abbonamento sono conservati su questo dispositivo, cifrati con AES-256-GCM. La chiave di cifratura sta nel keystore / keychain del SO, non accanto al testo cifrato. Se il keystore della piattaforma non è disponibile, l\'app non può tenere quei valori cifrati.';

  @override
  String get privacyCameraTitle => 'Fotocamera';

  @override
  String get privacyCameraBody =>
      'La fotocamera serve solo a scansionare un QR che contiene un link di condivisione o un URL di abbonamento. I fotogrammi non vengono caricati.';

  @override
  String get privacyClipboardTitle => 'Appunti e backup';

  @override
  String get privacyClipboardBody =>
      'Copia JSON negli appunti scrive un backup non cifrato. Chi può leggere gli appunti può leggere quei link. L\'esportazione su file può usare una password facoltativa (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'App installate (Android)';

  @override
  String get privacyAppsBody =>
      'Lo split tunneling per app legge l\'elenco delle app con icona sul dispositivo così puoi escluderle dal VPN. Quell\'elenco resta sul dispositivo.';

  @override
  String get privacyOpenWeb => 'Apri informativa sulla privacy';

  @override
  String get privacyOpenFailed =>
      'Impossibile aprire l\'URL dell\'informativa sulla privacy';

  @override
  String get rulesEyebrow => 'Policy del traffico';

  @override
  String get rulesTitle => 'Regole di routing';

  @override
  String get reset => 'Reimposta';

  @override
  String get resetRulesConfirm =>
      'Reimpostare il routing ai valori predefiniti?';

  @override
  String get mode => 'Modalità';

  @override
  String get modeHintGlobalRich =>
      'Tutto il traffico corrispondente → proxy (predefinito Xray).';

  @override
  String get modeHintGlobalSimple => 'Consigliato per Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Tutto il traffico nel tunnel tranne Always-exclude.';

  @override
  String get modeHintRules =>
      'Preset + regole personalizzate; non corrispondente → proxy (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Domini/CIDR diretti diventano esclusioni TrustTunnel. Block viene saltato. Il non corrispondente resta nel tunnel.';

  @override
  String get modeHintDirect =>
      'Tutto → freedom. Il TUN resta attivo (solo Xray).';

  @override
  String get presets => 'Preset';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Blocca annunci (limitato)';

  @override
  String get presetBlockAdsPack => 'Blocca annunci';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Piccola lista host integrata → block (Xray; non geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'Pacchetto annunci di servizio → block (non geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Pacchetto annunci di servizio → esclusioni TrustTunnel (nessun block del plugin)';

  @override
  String get presetBypassLan => 'Bypass LAN / privato';

  @override
  String get presetBypassLanSubtitle =>
      'CIDR RFC1918 / link-local → esclusioni TUN (non una regione/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Il bypass LAN richiede Android 13+. Le esclusioni CIDR non fanno nulla su questa versione.';

  @override
  String get presetProtectBanking => 'Proteggi home banking';

  @override
  String get presetProtectBankingSubtitle =>
      'Le app bancarie installate saltano il TUN (per-app Android)';

  @override
  String get appsSkipVpn => 'App che saltano il VPN';

  @override
  String get appsSkipVpnEmpty =>
      'Extra facoltativi oltre a Proteggi home banking';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count selezionate · applicato alla prossima connessione';
  }

  @override
  String get switchToRulesForPresets =>
      'Passa alla modalità Regole per usare i preset.';

  @override
  String get alwaysExcludeMerged =>
      'I CIDR Always-exclude vengono uniti alle regole IP-direct alla connessione per ogni backend. Modificali in Avanzate sotto.';

  @override
  String get alwaysExcludeCidr => 'Always exclude (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Un IP o CIDR per riga. Applicato alla prossima connessione.';

  @override
  String get cidrHint => 'Un IP o CIDR per riga\nes. 10.0.0.0/8';

  @override
  String get customRules => 'Regole personalizzate';

  @override
  String get customRulesHint =>
      'Suffisso di dominio, IP o CIDR → proxy / direct / block. Applicato a Xray alla connessione. IP direct alimenta anche le esclusioni del SO.';

  @override
  String get customRulesHintTrustTunnel =>
      'Dominio o CIDR → proxy (resta nel tunnel) o direct (escludi). Block non è disponibile. Nessun geosite.';

  @override
  String get matcher => 'Matcher';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Aggiungi regola';

  @override
  String get noCustomRules => 'Ancora nessuna regola personalizzata';

  @override
  String osExclude(String action) {
    return '$action · esclusione SO';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · saltato su TrustTunnel (nessun block del plugin)';

  @override
  String get enableAdvancedForRouting =>
      'Attiva la modalità avanzata in Impostazioni per altri controlli di routing.';

  @override
  String get searchApps => 'Cerca app';

  @override
  String get save => 'Salva';

  @override
  String get routingBannerXray =>
      'Profilo Xray: Globale / Regole / Diretto e le regole di dominio si applicano alla connessione.';

  @override
  String get routingBannerHysteria =>
      'Profilo Hysteria2: le regole dominio/block e Diretto Xray non si applicano. Usa Globale; i CIDR Always-exclude e IP-direct si uniscono comunque al TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: i domini/CIDR direct in Regole diventano esclusioni. Block viene saltato (nessun block del plugin). La modalità Diretto non si applica. Always-exclude si unisce comunque. Lo split per-app è solo SOCKS. Kill Switch si applica al prossimo connect TrustTunnel.';

  @override
  String get routingBannerUnknown =>
      'Seleziona o connetti un profilo per vedere quali funzioni di routing si applicano.';

  @override
  String get logsEyebrow => 'Diagnostica';

  @override
  String get logsTitle => 'Log';

  @override
  String get copyFiltered => 'Copia filtrati';

  @override
  String get clear => 'Cancella';

  @override
  String get logCopied => 'Log copiato';

  @override
  String get logsHint =>
      'Console del core. I colori sono euristici (parole chiave error/warn).';

  @override
  String get filterHint => 'Filtro…';

  @override
  String get logsAll => 'Tutti';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Errore';

  @override
  String get noLogLinesYet => 'Ancora nessuna riga di log';

  @override
  String get noMatchesForFilter => 'Nessuna corrispondenza per il filtro';

  @override
  String get vpnConsole => 'Console VPN';

  @override
  String get logsSheetEmpty => 'Ancora nessuna riga. In attesa dello stream…';

  @override
  String get copy => 'Copia';

  @override
  String get openLogs => 'Apri log';

  @override
  String get tapToRetry => 'Tocca per riprovare';

  @override
  String get homeErrorTitle => 'Impossibile connettersi';

  @override
  String get homeErrorTunnel => 'Tunnel non riuscito — tocca per riprovare';

  @override
  String get homeErrorSocks =>
      'SOCKS locale non riuscito — tocca per riprovare';

  @override
  String get activeProfile => 'PROFILO ATTIVO';

  @override
  String get socksInbound => 'SOCKS locale';

  @override
  String get socksInboundSubtitle =>
      'Lascia utente e password vuoti per generare credenziali casuali a ogni connessione. Altre app: 127.0.0.1 più queste credenziali.';

  @override
  String get socksPort => 'Porta';

  @override
  String get socksUsername => 'Nome utente';

  @override
  String get socksPassword => 'Password';

  @override
  String get saveSocks => 'Salva SOCKS';

  @override
  String get socksSaved => 'SOCKS salvato';

  @override
  String get killSwitchAndroidConfirmTitle => 'Hai attivato Always-on?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'L\'app non può cambiare gli interruttori VPN di Android. Attiva qui il Kill Switch solo dopo che Always-on e Blocca connessioni senza VPN sono abilitati per GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Sì, sono attivi';

  @override
  String get killSwitchAndroidConfirmNo => 'Non ancora';

  @override
  String get killSwitchIosDisconnectFailed =>
      'Impossibile disattivare on-demand. La disconnessione potrebbe non restare finché non riprovi.';

  @override
  String get support => 'Supporto';

  @override
  String get supportSubtitle => 'Apri la pagina di supporto dell\'operatore';

  @override
  String get supportUnavailable =>
      'Nessun URL di supporto in questo abbonamento';

  @override
  String get licenses => 'Licenze open source';

  @override
  String get licensesSubtitle => 'Core e librerie inclusi in questa app';

  @override
  String get licensesBody =>
      'Questa app include Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter e Inter (SIL OFL). Sorgenti e licenze sono nei repository del progetto.';

  @override
  String get onboardingSkip => 'Salta';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get onboardingDone => 'Inizia';

  @override
  String get onboardingServerTitle => 'Il tuo server';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN è un client per un nodo che importi. Non c\'è un proxy cloud GoodWin. Aggiungi un link di condivisione o un URL di abbonamento https in Profili.';

  @override
  String get onboardingVpnTitle => 'VPN di sistema';

  @override
  String get onboardingVpnBody =>
      'Connetti chiede al SO di aggiungere una configurazione VPN. Quel dialogo è di Android o iOS, non di questa app. Il traffico va poi al nodo nel profilo selezionato.';

  @override
  String get onboardingCameraTitle => 'Fotocamera per QR';

  @override
  String get onboardingCameraBody =>
      'La fotocamera è facoltativa e scansiona solo un QR con un link di condivisione o un URL di abbonamento. I fotogrammi restano sul dispositivo.';

  @override
  String get vpnExplainerTitle => 'Autorizzazione VPN di sistema';

  @override
  String get vpnExplainerBody =>
      'La schermata successiva è il dialogo VPN del SO. Consenti solo se vuoi che questo dispositivo invii il traffico attraverso il nodo importato.';

  @override
  String get vpnExplainerContinue => 'Continua';

  @override
  String get cameraExplainerTitle => 'Autorizzazione fotocamera';

  @override
  String get cameraExplainerBody =>
      'La schermata successiva potrebbe chiedere la fotocamera. Serve solo a scansionare un QR di configurazione. I fotogrammi non vengono caricati.';

  @override
  String get cameraExplainerContinue => 'Scansiona QR';

  @override
  String get importLinkHint =>
      'Incolla un link di condivisione o un URL di abbonamento https://. L\'app non ospita un proxy.';
}
