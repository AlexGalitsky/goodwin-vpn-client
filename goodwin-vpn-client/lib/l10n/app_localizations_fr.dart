// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Accueil';

  @override
  String get navProfiles => 'Profils';

  @override
  String get navRules => 'Règles';

  @override
  String get navLogs => 'Journaux';

  @override
  String get navSettings => 'Réglages';

  @override
  String get connectVpn => 'Connecter le VPN';

  @override
  String get disconnectVpn => 'Déconnecter le VPN';

  @override
  String get noProfile => 'Aucun profil';

  @override
  String get addProfileToConnect => 'Ajoutez un profil pour vous connecter';

  @override
  String get addProfileToConnectHint =>
      'Importez un lien de partage dans Profils, puis appuyez ici sur Connecter.';

  @override
  String get addProfile => 'Ajouter un profil';

  @override
  String get networkStatus => 'ÉTAT DU RÉSEAU';

  @override
  String get tapToDisconnect => 'Appuyez pour déconnecter';

  @override
  String get tapToConnect => 'Appuyez pour connecter';

  @override
  String get statNode => 'Nœud';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Durée';

  @override
  String get sessionLogs => 'Journaux de session';

  @override
  String get noLinesYet => 'Aucune ligne pour l’instant';

  @override
  String logLinesCount(int count) {
    return '$count lignes';
  }

  @override
  String get uacDeclined => 'L’invite UAC a été refusée';

  @override
  String get statusOffline => 'déconnecté';

  @override
  String get statusConnecting => 'connexion';

  @override
  String get statusConnected => 'connecté';

  @override
  String get statusDisconnecting => 'déconnexion';

  @override
  String get statusError => 'erreur';

  @override
  String get switchProfile => 'Changer de profil';

  @override
  String get manageProfiles => 'Gérer les profils';

  @override
  String get routing => 'Routage';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · modifier dans Règles';
  }

  @override
  String get routingModeGlobal => 'Global';

  @override
  String get routingModeRules => 'Règles';

  @override
  String get routingModeDirect => 'Direct';

  @override
  String get homeReadyTitle => 'Déconnecté';

  @override
  String get homeReadyTunnel =>
      'Connecter démarre un VPN système sur cet appareil';

  @override
  String get homeReadySocks =>
      'Cet OS n’a pas encore de VPN système — Connecter est un proxy SOCKS local';

  @override
  String get homeBusyTitle => 'Connexion';

  @override
  String get homeBusyTunnel => 'Demande d’un tunnel VPN à l’OS';

  @override
  String get homeBusySocks => 'Démarrage d’un proxy SOCKS local';

  @override
  String get homeConnectedTunnelTitle => 'VPN système';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Le trafic de l’appareil passe par le tunnel, pas par votre IP domicile';

  @override
  String get homeConnectedSocksTitle => 'SOCKS local';

  @override
  String get homeConnectedSocksSubtitle =>
      'Pas de tunnel système sur cet OS. Les apps doivent utiliser 127.0.0.1:10808 — votre IP n’est pas masquée';

  @override
  String get revokedTitle => 'Le lien d’abonnement a été révoqué';

  @override
  String get revokedBody =>
      'Collez une nouvelle URL dans Profils. Les anciens nœuds restent jusqu’à l’import d’un remplacement.';

  @override
  String get openProfiles => 'Ouvrir Profils';

  @override
  String get elevationTitle => 'Droits d’administrateur requis';

  @override
  String get runAsAdministrator => 'Exécuter en tant qu’administrateur';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used utilisé · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'expiré';

  @override
  String quotaDaysLeft(int days) {
    return '$days j restants';
  }

  @override
  String get quotaScopeNote => 'Trafic VLESS+Hy2 — TrustTunnel non compté';

  @override
  String get profilesEyebrow => 'Votre réseau';

  @override
  String get profilesTitle => 'Profils de serveur';

  @override
  String get tooltipPinging => 'Mesure du Ping…';

  @override
  String get tooltipCheckPing => 'Vérifier le Ping';

  @override
  String get noProfilesToPing => 'Aucun profil à pinger';

  @override
  String get tooltipImportLink => 'Importer un lien ou un abonnement';

  @override
  String get searchServersHint => 'Rechercher des serveurs ou des protocoles';

  @override
  String get smartConnect => 'Connexion intelligente';

  @override
  String get smartConnectSubtitle =>
      'Connecter depuis l’accueil utilise le nœud au Ping le plus bas de l’abonnement actuel';

  @override
  String get emptyProfiles =>
      'Aucun profil enregistré pour l’instant.\nImportez un lien de partage ou une URL d’abonnement https://.';

  @override
  String get noMatches => 'Aucun résultat';

  @override
  String get pinging => 'Ping en cours';

  @override
  String get fastest => 'le plus rapide';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteProfileConfirm => 'Supprimer ce profil ?';

  @override
  String get deleteSubscriptionConfirm =>
      'Retirer cet abonnement et ses nœuds enregistrés ?';

  @override
  String updatedSubscription(String name) {
    return '$name mis à jour';
  }

  @override
  String get importProfile => 'Importer un profil';

  @override
  String get nameOptional => 'Nom (facultatif)';

  @override
  String get importLinkLabel => 'Lien de partage ou URL d’abonnement https://';

  @override
  String get paste => 'Coller';

  @override
  String get scanQr => 'Scanner le QR';

  @override
  String get cancel => 'Annuler';

  @override
  String get import => 'Importer';

  @override
  String get unrecognizedShareLink => 'Lien de partage non reconnu';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get name => 'Nom';

  @override
  String get shareLink => 'Lien de partage';

  @override
  String get apply => 'Appliquer';

  @override
  String get importedManual => 'Importé';

  @override
  String get subscriptionFallback => 'Abonnement';

  @override
  String get revokedKeepNodes =>
      'Lien révoqué — collez une nouvelle URL. Les nœuds n’ont pas été effacés.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count nœuds';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nœuds',
      one: '1 nœud',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Actualiser l’abonnement';

  @override
  String get removeSubscription => 'Retirer l’abonnement';

  @override
  String get nothingToImport => 'Rien à importer';

  @override
  String get subscriptionImported => 'Abonnement importé';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name importé ($count nœuds)';
  }

  @override
  String get profileImported => 'Profil importé';

  @override
  String get settingsEyebrow => 'Application';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get appearance => 'Apparence';

  @override
  String get colorTheme => 'Thème de couleurs';

  @override
  String get colorThemeSubtitle =>
      'Papier clair et marine sombre. Système suit le téléphone.';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get language => 'Langue';

  @override
  String get languageSubtitle => 'Anglais et russe. Système suit le téléphone.';

  @override
  String get localeSystem => 'Système';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Général';

  @override
  String get advancedMode => 'Mode avancé';

  @override
  String get advancedModeSubtitle =>
      'Onglet Journaux et options pour utilisateurs avancés';

  @override
  String get reconnectOnLaunch => 'Reconnecter au lancement';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Démarrer le dernier profil si le VPN de l’OS est coupé';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'Système';

  @override
  String get dnsCustom => 'Personnalisé';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'Serveur DNS / URL DoH';

  @override
  String get dnsSaved => 'Préférence DNS enregistrée';

  @override
  String get saveDns => 'Enregistrer le DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'VPN toujours actif dans les réglages Android. Ce commutateur seul n’est pas étanche aux fuites.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Verrou anti-fuite du plugin au prochain Connect TrustTunnel. Toujours actif reste nécessaire après un redémarrage.';

  @override
  String get killSwitchSubtitleIos =>
      'Se reconnecte si le tunnel tombe. Push, Watch et iMessage restent joignables.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Verrou anti-fuite du plugin pour cette session TrustTunnel. Déconnecter l’éteint avant qu’un VPN SOCKS puisse démarrer.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Activer la protection système contre les fuites';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. Sur l’écran suivant, appuyez sur Goodwin VPN (SOCKS ou TrustTunnel).\n2. Activez VPN toujours actif.\n3. Activez Bloquer les connexions sans VPN.\n4. Revenez ici et appuyez sur Connecter.\n\nL’app ne peut pas basculer ces interrupteurs Android elle-même. TrustTunnel utilise aussi la protection anti-fuite du plugin au prochain Connecter.';

  @override
  String get killSwitchAndroidDisableTitle =>
      'Désactivez d’abord Toujours actif';

  @override
  String get killSwitchAndroidDisableBody =>
      'Dans les réglages VPN d’Android, désactivez VPN toujours actif et Bloquer les connexions sans VPN pour Goodwin. Sinon, Déconnecter ramènera le tunnel.';

  @override
  String get killSwitchOpenSettings => 'Ouvrir les réglages VPN';

  @override
  String get killSwitchDisconnectTitle => 'Toujours actif peut reconnecter';

  @override
  String get killSwitchDisconnectBody =>
      'Le VPN toujours actif d’Android peut ramener le tunnel après Déconnecter. Désactivez Toujours actif dans les réglages VPN système si vous voulez le réseau entièrement ouvert.';

  @override
  String get killSwitchDisconnectConfirm => 'Déconnecter';

  @override
  String get coreTuning => 'Réglage du cœur';

  @override
  String get advancedDangerTooltip => 'Avancé — peut couper la connectivité';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Ignoré avec Vision — le VLESS habituel démarre';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Ignoré sur REALITY — hello TLS uniquement';

  @override
  String get dnsHintWithTuning =>
      'Les IP DNS s’appliquent au TUN de l’OS à la connexion. DoH va dans le JSON Xray ; le TUN utilise toujours les IP de bootstrap. Mux / Fragment : Xray uniquement.';

  @override
  String get dnsHintSimple =>
      'Les IP DNS s’appliquent au TUN de l’OS à la connexion.';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Exporter un fichier de sauvegarde';

  @override
  String get exportBackupSubtitle =>
      'Profils et abonnements. Un mot de passe facultatif chiffre le fichier';

  @override
  String get importBackup => 'Importer un fichier de sauvegarde';

  @override
  String get importBackupSubtitle => 'Fusionne dans le catalogue actuel';

  @override
  String get copyJsonClipboard => 'Copier le JSON dans le presse-papiers';

  @override
  String get copyJsonClipboardSubtitle =>
      'Non chiffré — quiconque lit le presse-papiers peut lire les liens';

  @override
  String get copiedEmptyProfiles => 'Liste de profils vide copiée';

  @override
  String copiedProfilesJson(int count) {
    return '$count profil(s) copié(s) en JSON non chiffré';
  }

  @override
  String get exportBackupTitle => 'Exporter la sauvegarde';

  @override
  String get exportBackupPasswordHint =>
      'Laissez vide pour un fichier JSON brut. Un mot de passe utilise AES-256-GCM.';

  @override
  String get backupFileSaved => 'Fichier de sauvegarde enregistré';

  @override
  String get encryptedBackupSaved => 'Fichier de sauvegarde chiffré enregistré';

  @override
  String get encryptedBackupTitle => 'Sauvegarde chiffrée';

  @override
  String get encryptedBackupHint =>
      'Saisissez le mot de passe utilisé à l’export.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles profil(s) et $subs abonnement(s) importés';
  }

  @override
  String get passwordOptional => 'Mot de passe (facultatif)';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get continueAction => 'Continuer';

  @override
  String get about => 'À propos';

  @override
  String get aboutSubtitle => 'Client VPN pour votre propre serveur';

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
  String get privacy => 'Confidentialité';

  @override
  String get privacySubtitle =>
      'Caméra, VPN, secrets sur l’appareil, sauvegardes du presse-papiers';

  @override
  String get privacyWhatTitle => 'Ce que cette app utilise';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN est un client local. Il n’y a pas de serveur de compte Goodwin ni de SDK d’analyse dans cette version.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'Sur les plateformes avec tunnel système, le trafic de l’appareil est envoyé au nœud du lien de partage importé. L’app n’exploite pas de proxy Goodwin. Si cet OS n’a pas de tunnel système, Connecter démarre seulement un proxy SOCKS local à 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Configs et secrets';

  @override
  String get privacySecretsBody =>
      'Les liens de partage, profils enregistrés et URL d’abonnement sont stockés sur cet appareil, chiffrés avec AES-256-GCM. La clé vit dans le keystore / trousseau de l’OS, pas à côté du texte chiffré. Si le keystore de la plateforme est indisponible, l’app ne peut pas garder ces valeurs chiffrées.';

  @override
  String get privacyCameraTitle => 'Caméra';

  @override
  String get privacyCameraBody =>
      'La caméra sert uniquement à scanner un QR contenant un lien de partage ou une URL d’abonnement. Les images ne sont pas envoyées.';

  @override
  String get privacyClipboardTitle => 'Presse-papiers et sauvegardes';

  @override
  String get privacyClipboardBody =>
      'Copier le JSON dans le presse-papiers écrit une sauvegarde non chiffrée. Quiconque peut lire le presse-papiers peut lire ces liens. L’export fichier peut utiliser un mot de passe facultatif (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Apps installées (Android)';

  @override
  String get privacyAppsBody =>
      'Le split tunneling par app lit la liste des apps du lanceur sur l’appareil pour que vous puissiez exclure des apps du VPN. Cette liste reste sur l’appareil.';

  @override
  String get privacyOpenWeb => 'Ouvrir la politique de confidentialité';

  @override
  String get privacyOpenFailed =>
      'Impossible d’ouvrir l’URL de la politique de confidentialité';

  @override
  String get rulesEyebrow => 'Politique de trafic';

  @override
  String get rulesTitle => 'Règles de routage';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetRulesConfirm =>
      'Réinitialiser le routage aux valeurs par défaut ?';

  @override
  String get mode => 'Mode';

  @override
  String get modeHintGlobalRich =>
      'Tout le trafic correspondant → proxy (défaut Xray).';

  @override
  String get modeHintGlobalSimple => 'Recommandé pour Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Tout le trafic par le tunnel sauf Toujours exclure.';

  @override
  String get modeHintRules =>
      'Préréglages + règles perso ; le reste → proxy (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Les domaines/CIDR directs deviennent des exclusions TrustTunnel. Block est ignoré. Le reste reste dans le tunnel.';

  @override
  String get modeHintDirect =>
      'Tout → freedom. Le TUN reste actif (Xray uniquement).';

  @override
  String get presets => 'Préréglages';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Bloquer les pubs (limité)';

  @override
  String get presetBlockAdsPack => 'Bloquer les pubs';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Petite liste d’hôtes intégrée → block (Xray ; pas geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'Pack pubs service → block (pas geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Pack pubs service → exclusions TrustTunnel (pas de block plugin)';

  @override
  String get presetBypassLan => 'Contourner LAN / privé';

  @override
  String get presetBypassLanSubtitle =>
      'CIDR RFC1918 / link-local → exclusions TUN (pas une région/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Contourner le LAN nécessite Android 13+. Les exclusions CIDR ne font rien sur cette version.';

  @override
  String get presetProtectBanking => 'Protéger la banque';

  @override
  String get presetProtectBankingSubtitle =>
      'Les apps bancaires installées contournent le TUN (Android par app)';

  @override
  String get appsSkipVpn => 'Apps qui contournent le VPN';

  @override
  String get appsSkipVpnEmpty =>
      'Extras facultatifs au-delà de Protéger la banque';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count sélectionné(s) · appliqué à la prochaine connexion';
  }

  @override
  String get switchToRulesForPresets =>
      'Passez en mode Règles pour utiliser les préréglages.';

  @override
  String get alwaysExcludeMerged =>
      'Les CIDR Toujours exclure sont fusionnés avec les règles IP-direct à la connexion pour chaque backend. Modifiez-les dans Avancé ci-dessous.';

  @override
  String get alwaysExcludeCidr => 'Toujours exclure (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Une IP ou un CIDR par ligne. Appliqué à la prochaine connexion.';

  @override
  String get cidrHint => 'Une IP ou un CIDR par ligne\nex. 10.0.0.0/8';

  @override
  String get customRules => 'Règles personnalisées';

  @override
  String get customRulesHint =>
      'Suffixe de domaine, IP ou CIDR → proxy / direct / block. Appliqué à Xray à la connexion. IP direct alimente aussi les exclusions OS.';

  @override
  String get customRulesHintTrustTunnel =>
      'Domaine ou CIDR → proxy (rester dans le tunnel) ou direct (exclure). Block n’est pas disponible. Pas de geosite.';

  @override
  String get matcher => 'Matcher';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Ajouter une règle';

  @override
  String get noCustomRules => 'Aucune règle personnalisée pour l’instant';

  @override
  String osExclude(String action) {
    return '$action · exclusion OS';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · ignoré sur TrustTunnel (pas de block plugin)';

  @override
  String get enableAdvancedForRouting =>
      'Activez le mode avancé dans Réglages pour des contrôles de routage supplémentaires.';

  @override
  String get searchApps => 'Rechercher des apps';

  @override
  String get save => 'Enregistrer';

  @override
  String get routingBannerXray =>
      'Profil Xray : Global / Règles / Direct et les règles de domaine s’appliquent à la connexion.';

  @override
  String get routingBannerHysteria =>
      'Profil Hysteria2 : les règles domaine/block et Xray Direct ne s’appliquent pas. Utilisez Global ; les CIDR Toujours exclure et IP-direct fusionnent toujours dans le TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel : les domaines/CIDR directs des Règles deviennent des exclusions. Block est ignoré (pas de block plugin). Le mode Direct n’est pas appliqué. Toujours exclure fusionne toujours. Le split par app est SOCKS uniquement. Kill Switch s’applique à la prochaine connexion TrustTunnel.';

  @override
  String get routingBannerUnknown =>
      'Sélectionnez ou connectez un profil pour voir quelles fonctions de routage s’appliquent.';

  @override
  String get logsEyebrow => 'Diagnostic';

  @override
  String get logsTitle => 'Journaux';

  @override
  String get copyFiltered => 'Copier le filtré';

  @override
  String get clear => 'Effacer';

  @override
  String get logCopied => 'Journal copié';

  @override
  String get logsHint =>
      'Console du cœur. Les couleurs sont heuristiques (mots-clés error/warn).';

  @override
  String get filterHint => 'Filtrer…';

  @override
  String get logsAll => 'Tous';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Erreur';

  @override
  String get noLogLinesYet => 'Aucune ligne de journal pour l’instant';

  @override
  String get noMatchesForFilter => 'Aucun résultat pour le filtre';

  @override
  String get vpnConsole => 'Console VPN';

  @override
  String get logsSheetEmpty =>
      'Aucune ligne pour l’instant. En attente du flux…';

  @override
  String get copy => 'Copier';

  @override
  String get openLogs => 'Ouvrir les journaux';

  @override
  String get tapToRetry => 'Appuyez pour réessayer';

  @override
  String get homeErrorTitle => 'Impossible de se connecter';

  @override
  String get homeErrorTunnel => 'Échec du tunnel — appuyez pour réessayer';

  @override
  String get homeErrorSocks => 'Échec du SOCKS local — appuyez pour réessayer';

  @override
  String get activeProfile => 'PROFIL ACTIF';

  @override
  String get socksInbound => 'SOCKS local';

  @override
  String get socksInboundSubtitle =>
      'Laissez l’utilisateur et le mot de passe vides pour générer des identifiants aléatoires à chaque connexion. Autres apps : 127.0.0.1 plus ces identifiants.';

  @override
  String get socksPort => 'Port';

  @override
  String get socksUsername => 'Nom d’utilisateur';

  @override
  String get socksPassword => 'Mot de passe';

  @override
  String get saveSocks => 'Enregistrer SOCKS';

  @override
  String get socksSaved => 'SOCKS enregistré';

  @override
  String get killSwitchAndroidConfirmTitle =>
      'Avez-vous activé Toujours actif ?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'L’app ne peut pas basculer les interrupteurs VPN Android. Activez le Kill Switch ici seulement après que VPN toujours actif et Bloquer les connexions sans VPN sont activés pour GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Oui, ils sont activés';

  @override
  String get killSwitchAndroidConfirmNo => 'Pas encore';

  @override
  String get killSwitchIosDisconnectFailed =>
      'Impossible de désactiver le mode à la demande. La déconnexion peut ne pas tenir tant que vous n’aurez pas réessayé.';

  @override
  String get support => 'Support';

  @override
  String get supportSubtitle => 'Ouvrir la page de support de l’opérateur';

  @override
  String get supportUnavailable => 'Aucune URL de support dans cet abonnement';

  @override
  String get licenses => 'Licences open source';

  @override
  String get licensesSubtitle => 'Cœurs et bibliothèques inclus dans cette app';

  @override
  String get licensesBody =>
      'Cette app inclut Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter et Inter (SIL OFL). Sources et licences se trouvent dans les dépôts du projet.';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingDone => 'Commencer';

  @override
  String get onboardingServerTitle => 'Votre serveur';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN est un client pour un nœud que vous importez. Il n’y a pas de proxy cloud Goodwin. Ajoutez un lien de partage ou une URL d’abonnement https dans Profils.';

  @override
  String get onboardingVpnTitle => 'VPN système';

  @override
  String get onboardingVpnBody =>
      'Connecter demande à l’OS d’ajouter une configuration VPN. Cette boîte de dialogue vient d’Android ou d’iOS, pas de cette app. Le trafic va ensuite au nœud du profil sélectionné.';

  @override
  String get onboardingCameraTitle => 'Caméra pour QR';

  @override
  String get onboardingCameraBody =>
      'La caméra est facultative et ne scanne qu’un QR avec un lien de partage ou une URL d’abonnement. Les images restent sur l’appareil.';

  @override
  String get vpnExplainerTitle => 'Autorisation VPN système';

  @override
  String get vpnExplainerBody =>
      'L’écran suivant est le dialogue VPN de l’OS. Autorisez-le seulement si vous voulez que cet appareil envoie le trafic via le nœud importé.';

  @override
  String get vpnExplainerContinue => 'Continuer';

  @override
  String get cameraExplainerTitle => 'Autorisation caméra';

  @override
  String get cameraExplainerBody =>
      'L’écran suivant peut demander la caméra. Elle sert uniquement à scanner un QR de configuration. Les images ne sont pas envoyées.';

  @override
  String get cameraExplainerContinue => 'Scanner le QR';

  @override
  String get importLinkHint =>
      'Collez un lien de partage ou une URL d’abonnement https://. L’app n’héberge pas de proxy.';
}
