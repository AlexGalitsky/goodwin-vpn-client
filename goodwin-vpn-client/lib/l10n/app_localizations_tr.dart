// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navProfiles => 'Profiller';

  @override
  String get navRules => 'Kurallar';

  @override
  String get navLogs => 'Günlükler';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get connectVpn => 'VPN bağla';

  @override
  String get disconnectVpn => 'VPN kes';

  @override
  String get noProfile => 'Profil yok';

  @override
  String get addProfileToConnect => 'Bağlanmak için profil ekleyin';

  @override
  String get addProfileToConnectHint =>
      'Profiller’de bir paylaşım bağlantısı içe aktarın, sonra burada Bağla’ya dokunun.';

  @override
  String get addProfile => 'Profil ekle';

  @override
  String get networkStatus => 'AĞ DURUMU';

  @override
  String get tapToDisconnect => 'Kesmek için dokunun';

  @override
  String get tapToConnect => 'Bağlanmak için dokunun';

  @override
  String get statNode => 'Düğüm';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Süre';

  @override
  String get sessionLogs => 'Oturum günlükleri';

  @override
  String get noLinesYet => 'Henüz satır yok';

  @override
  String logLinesCount(int count) {
    return '$count satır';
  }

  @override
  String get uacDeclined => 'UAC istemi reddedildi';

  @override
  String get statusOffline => 'bağlı değil';

  @override
  String get statusConnecting => 'bağlanıyor';

  @override
  String get statusConnected => 'bağlı';

  @override
  String get statusDisconnecting => 'kesiliyor';

  @override
  String get statusError => 'hata';

  @override
  String get switchProfile => 'Profil değiştir';

  @override
  String get manageProfiles => 'Profilleri yönet';

  @override
  String get routing => 'Yönlendirme';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · Kurallar’da değiştir';
  }

  @override
  String get routingModeGlobal => 'Küresel';

  @override
  String get routingModeRules => 'Kurallar';

  @override
  String get routingModeDirect => 'Doğrudan';

  @override
  String get homeReadyTitle => 'Bağlı değil';

  @override
  String get homeReadyTunnel => 'Bağla bu cihazda sistem VPN’i başlatır';

  @override
  String get homeReadySocks =>
      'Bu işletim sisteminde henüz sistem VPN’i yok — Bağla yerel bir SOCKS vekilidir';

  @override
  String get homeBusyTitle => 'Bağlanıyor';

  @override
  String get homeBusyTunnel => 'İşletim sisteminden VPN tüneli isteniyor';

  @override
  String get homeBusySocks => 'Yerel SOCKS vekili başlatılıyor';

  @override
  String get homeConnectedTunnelTitle => 'Sistem VPN';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Cihaz trafiği ev IP’nizden değil tünelden gider';

  @override
  String get homeConnectedSocksTitle => 'Yerel SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      'Bu işletim sisteminde sistem tüneli yok. Uygulamalar 127.0.0.1:10808 kullanmalı — IP’niz gizlenmez';

  @override
  String get revokedTitle => 'Abonelik bağlantısı iptal edildi';

  @override
  String get revokedBody =>
      'Profiller’de yeni bir URL yapıştırın. Eski düğümler yedek içe aktarana kadar kalır.';

  @override
  String get openProfiles => 'Profilleri aç';

  @override
  String get elevationTitle => 'Yönetici hakları gerekli';

  @override
  String get runAsAdministrator => 'Yönetici olarak çalıştır';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used kullanıldı · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'süresi doldu';

  @override
  String quotaDaysLeft(int days) {
    return '${days}g kaldı';
  }

  @override
  String get quotaScopeNote => 'VLESS+Hy2 trafiği — TrustTunnel sayılmaz';

  @override
  String get profilesEyebrow => 'Ağınız';

  @override
  String get profilesTitle => 'Sunucu profilleri';

  @override
  String get tooltipPinging => 'Ping atılıyor…';

  @override
  String get tooltipCheckPing => 'Ping denetle';

  @override
  String get noProfilesToPing => 'Ping atılacak profil yok';

  @override
  String get tooltipImportLink => 'Bağlantı veya abonelik içe aktar';

  @override
  String get searchServersHint => 'Sunucu veya protokol ara';

  @override
  String get smartConnect => 'Akıllı bağlan';

  @override
  String get smartConnectSubtitle =>
      'Ana sayfa Bağla, geçerli abonelikteki en düşük Ping düğümünü kullanır';

  @override
  String get emptyProfiles =>
      'Henüz kayıtlı profil yok.\nBir paylaşım bağlantısı veya https:// abonelik URL’si içe aktarın.';

  @override
  String get noMatches => 'Eşleşme yok';

  @override
  String get pinging => 'ping atılıyor';

  @override
  String get fastest => 'en hızlı';

  @override
  String get delete => 'Sil';

  @override
  String get deleteProfileConfirm => 'Bu profil silinsin mi?';

  @override
  String get deleteSubscriptionConfirm =>
      'Bu abonelik ve kayıtlı düğümleri kaldırılsın mı?';

  @override
  String updatedSubscription(String name) {
    return '$name güncellendi';
  }

  @override
  String get importProfile => 'Profil içe aktar';

  @override
  String get nameOptional => 'Ad (isteğe bağlı)';

  @override
  String get importLinkLabel =>
      'Paylaşım bağlantısı veya https:// abonelik URL’si';

  @override
  String get paste => 'Yapıştır';

  @override
  String get scanQr => 'QR tara';

  @override
  String get cancel => 'İptal';

  @override
  String get import => 'İçe aktar';

  @override
  String get unrecognizedShareLink => 'Tanınmayan paylaşım bağlantısı';

  @override
  String get editProfile => 'Profili düzenle';

  @override
  String get name => 'Ad';

  @override
  String get shareLink => 'Paylaşım bağlantısı';

  @override
  String get apply => 'Uygula';

  @override
  String get importedManual => 'İçe aktarıldı';

  @override
  String get subscriptionFallback => 'Abonelik';

  @override
  String get revokedKeepNodes =>
      'Bağlantı iptal edildi — yeni bir URL yapıştırın. Düğümler temizlenmedi.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count düğüm';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count düğüm',
      one: '1 düğüm',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Aboneliği yenile';

  @override
  String get removeSubscription => 'Aboneliği kaldır';

  @override
  String get nothingToImport => 'İçe aktarılacak bir şey yok';

  @override
  String get subscriptionImported => 'Abonelik içe aktarıldı';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name içe aktarıldı ($count düğüm)';
  }

  @override
  String get profileImported => 'Profil içe aktarıldı';

  @override
  String get settingsEyebrow => 'Uygulama';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get colorTheme => 'Renk teması';

  @override
  String get colorThemeSubtitle =>
      'Kağıt açık ve lacivert koyu. Sistem telefonu izler.';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get language => 'Dil';

  @override
  String get languageSubtitle => 'İngilizce ve Rusça. Sistem telefonu izler.';

  @override
  String get localeSystem => 'Sistem';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Genel';

  @override
  String get advancedMode => 'Gelişmiş mod';

  @override
  String get advancedModeSubtitle =>
      'Günlükler sekmesi ve ileri düzey seçenekler';

  @override
  String get reconnectOnLaunch => 'Açılışta yeniden bağlan';

  @override
  String get reconnectOnLaunchSubtitle =>
      'İşletim sistemi VPN’i kapalıysa son profili başlat';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'Sistem';

  @override
  String get dnsCustom => 'Özel';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS sunucusu / DoH URL’si';

  @override
  String get dnsSaved => 'DNS tercihi kaydedildi';

  @override
  String get saveDns => 'DNS’i kaydet';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Android ayarlarındaki Always-on VPN. Buradaki anahtar tek başına sızıntıyı önlemez.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Sonraki TrustTunnel Bağla’da eklenti sızıntı kilidi. Yeniden başlatmadan sonra yine Always-on gerekir.';

  @override
  String get killSwitchSubtitleIos =>
      'Tünel düşerse yeniden bağlanır. Anlık bildirim, Watch ve iMessage erişilebilir kalır.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Bu TrustTunnel oturumu için eklenti sızıntı kilidi. Kes, SOCKS VPN başlamadan önce onu kapatır.';

  @override
  String get killSwitchAndroidEnableTitle => 'Sistem sızıntı korumasını aç';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. Sonraki ekranda Goodwin VPN’e (SOCKS veya TrustTunnel) dokunun.\n2. Always-on VPN’i açın.\n3. VPN olmadan bağlantıları engelle’yi açın.\n4. Buraya dönüp Bağla’ya dokunun.\n\nUygulama bu Android anahtarlarını kendi başına değiştiremez. TrustTunnel sonraki Bağla’da eklenti sızıntı korumasını da kullanır.';

  @override
  String get killSwitchAndroidDisableTitle => 'Önce Always-on’u kapatın';

  @override
  String get killSwitchAndroidDisableBody =>
      'Android VPN ayarlarında Goodwin için Always-on VPN ve VPN olmadan bağlantıları engelle’yi kapatın. Yoksa Kes tüneli geri getirir.';

  @override
  String get killSwitchOpenSettings => 'VPN ayarlarını aç';

  @override
  String get killSwitchDisconnectTitle => 'Always-on yeniden bağlayabilir';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN, Kes’ten sonra tüneli geri getirebilir. Ağı tamamen açık istiyorsanız sistem VPN ayarlarında Always-on’u kapatın.';

  @override
  String get killSwitchDisconnectConfirm => 'Kes';

  @override
  String get coreTuning => 'Çekirdek ayarı';

  @override
  String get advancedDangerTooltip => 'Gelişmiş — bağlantıyı bozabilir';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Vision ile uygulanmaz — tipik VLESS ayağa kalkar';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle =>
      'REALITY üzerinde uygulanmaz — yalnızca TLS hello';

  @override
  String get dnsHintWithTuning =>
      'DNS IP’leri bağlantıda işletim sistemi TUN’una uygulanır. DoH, Xray JSON’una girer; TUN yine önyükleme IP’lerini kullanır. Mux / Fragment: yalnızca Xray.';

  @override
  String get dnsHintSimple =>
      'DNS IP’leri bağlantıda işletim sistemi TUN’una uygulanır.';

  @override
  String get backup => 'Yedek';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Yedek dosyasını dışa aktar';

  @override
  String get exportBackupSubtitle =>
      'Profiller ve abonelikler. İsteğe bağlı parola dosyayı şifreler';

  @override
  String get importBackup => 'Yedek dosyasını içe aktar';

  @override
  String get importBackupSubtitle => 'Geçerli kataloğa birleştirilir';

  @override
  String get copyJsonClipboard => 'JSON’u panoya kopyala';

  @override
  String get copyJsonClipboardSubtitle =>
      'Şifresiz — panoyu okuyan herkes bağlantıları görür';

  @override
  String get copiedEmptyProfiles => 'Boş profil listesi kopyalandı';

  @override
  String copiedProfilesJson(int count) {
    return '$count profil şifresiz JSON olarak kopyalandı';
  }

  @override
  String get exportBackupTitle => 'Yedeği dışa aktar';

  @override
  String get exportBackupPasswordHint =>
      'Düz JSON dosyası için boş bırakın. Parola AES-256-GCM kullanır.';

  @override
  String get backupFileSaved => 'Yedek dosyası kaydedildi';

  @override
  String get encryptedBackupSaved => 'Şifreli yedek dosyası kaydedildi';

  @override
  String get encryptedBackupTitle => 'Şifreli yedek';

  @override
  String get encryptedBackupHint =>
      'Dışa aktarırken kullanılan parolayı girin.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles profil ve $subs abonelik içe aktarıldı';
  }

  @override
  String get passwordOptional => 'Parola (isteğe bağlı)';

  @override
  String get password => 'Parola';

  @override
  String get confirmPassword => 'Parolayı doğrula';

  @override
  String get passwordsDoNotMatch => 'Parolalar eşleşmiyor';

  @override
  String get continueAction => 'Devam';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutSubtitle => 'Kendi sunucunuz için VPN istemcisi';

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
  String get privacy => 'Gizlilik';

  @override
  String get privacySubtitle => 'Kamera, VPN, cihazdaki sırlar, pano yedekleri';

  @override
  String get privacyWhatTitle => 'Bu uygulama ne kullanır';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN yerel bir istemcidir. Bu sürümde Goodwin hesap sunucusu ve analitik SDK yoktur.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'Sistem tüneli olan platformlarda cihaz trafiği içe aktardığınız paylaşım bağlantısındaki düğüme gönderilir. Uygulama bir Goodwin vekili işletmez. Bu işletim sisteminde sistem tüneli yoksa Bağla yalnızca 127.0.0.1:10808 adresinde yerel bir SOCKS vekili başlatır.';

  @override
  String get privacySecretsTitle => 'Yapılandırmalar ve sırlar';

  @override
  String get privacySecretsBody =>
      'Paylaşım bağlantıları, kayıtlı profiller ve abonelik URL’leri bu cihazda AES-256-GCM ile şifrelenerek saklanır. Şifreleme anahtarı işletim sistemi keystore / keychain’inde durur, şifreli metnin yanında değil. Platform keystore kullanılamıyorsa uygulama bu değerleri şifreli tutamaz.';

  @override
  String get privacyCameraTitle => 'Kamera';

  @override
  String get privacyCameraBody =>
      'Kamera yalnızca paylaşım bağlantısı veya abonelik URL’si içeren bir QR kodunu taramak için kullanılır. Kareler yüklenmez.';

  @override
  String get privacyClipboardTitle => 'Pano ve yedekler';

  @override
  String get privacyClipboardBody =>
      'JSON’u panoya kopyala şifresiz bir yedek yazar. Panoyu okuyabilen herkes bu bağlantıları okuyabilir. Dosya dışa aktarma isteğe bağlı parola kullanabilir (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Yüklü uygulamalar (Android)';

  @override
  String get privacyAppsBody =>
      'Uygulama başına bölünmüş tünel, VPN’den hariç tutabilmeniz için cihazdaki başlatıcı uygulama listesini okur. Liste cihazda kalır.';

  @override
  String get privacyOpenWeb => 'Gizlilik politikasını aç';

  @override
  String get privacyOpenFailed => 'Gizlilik politikası URL’si açılamadı';

  @override
  String get rulesEyebrow => 'Trafik politikası';

  @override
  String get rulesTitle => 'Yönlendirme kuralları';

  @override
  String get reset => 'Sıfırla';

  @override
  String get resetRulesConfirm => 'Yönlendirme varsayılana sıfırlansın mı?';

  @override
  String get mode => 'Mod';

  @override
  String get modeHintGlobalRich =>
      'Eşleşen tüm trafik → vekil (Xray varsayılanı).';

  @override
  String get modeHintGlobalSimple => 'Hysteria2 için önerilir.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Always-exclude dışında tüm trafik tünelden.';

  @override
  String get modeHintRules =>
      'Ön ayarlar + özel kurallar; eşleşmeyen → vekil (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Doğrudan etki alanları/CIDR’ler TrustTunnel dışlamaları olur. Block atlanır. Eşleşmeyen tünelde kalır.';

  @override
  String get modeHintDirect =>
      'Hepsi → freedom. TUN açık kalır (yalnızca Xray).';

  @override
  String get presets => 'Ön ayarlar';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Reklamları engelle (sınırlı)';

  @override
  String get presetBlockAdsPack => 'Reklamları engelle';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Küçük yerleşik ana bilgisayar listesi → block (Xray; geosite değil)';

  @override
  String get presetBlockAdsPackXray =>
      'Hizmet reklam paketi → block (geosite değil)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Hizmet reklam paketi → TrustTunnel dışlamaları (eklentide block yok)';

  @override
  String get presetBypassLan => 'LAN / özel ağı atla';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / bağlantı-yerel CIDR’ler → TUN dışlamaları (bölge/geoip değil)';

  @override
  String get presetBypassLanAndroid13 =>
      'LAN atlama Android 13+ ister. Bu sürümde CIDR dışlamaları işe yaramaz.';

  @override
  String get presetProtectBanking => 'Bankacılığı koru';

  @override
  String get presetProtectBankingSubtitle =>
      'Yüklü banka uygulamaları TUN’u atlar (Android uygulama başına)';

  @override
  String get appsSkipVpn => 'VPN’i atlayan uygulamalar';

  @override
  String get appsSkipVpnEmpty =>
      'Bankacılığı koru dışındaki isteğe bağlı ekler';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count seçildi · sonraki bağlantıda uygulanır';
  }

  @override
  String get switchToRulesForPresets =>
      'Ön ayarları kullanmak için Kurallar moduna geçin.';

  @override
  String get alwaysExcludeMerged =>
      'Always-exclude CIDR’leri bağlantıda her arka uç için IP-doğrudan kurallarıyla birleştirilir. Bunları aşağıdaki Gelişmiş’te düzenleyin.';

  @override
  String get alwaysExcludeCidr => 'Her zaman hariç tut (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Satır başına bir IP veya CIDR. Sonraki bağlantıda uygulanır.';

  @override
  String get cidrHint => 'Satır başına bir IP veya CIDR\nör. 10.0.0.0/8';

  @override
  String get customRules => 'Özel kurallar';

  @override
  String get customRulesHint =>
      'Etki alanı soneki, IP veya CIDR → proxy / direct / block. Bağlantıda Xray’e uygulanır. IP doğrudan ayrıca işletim sistemi dışlamalarına gider.';

  @override
  String get customRulesHintTrustTunnel =>
      'Etki alanı veya CIDR → proxy (tünelde kal) veya direct (hariç tut). Block yok. geosite yok.';

  @override
  String get matcher => 'Eşleştirici';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Kural ekle';

  @override
  String get noCustomRules => 'Henüz özel kural yok';

  @override
  String osExclude(String action) {
    return '$action · işletim sistemi dışlaması';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · TrustTunnel’da atlanır (eklentide block yok)';

  @override
  String get enableAdvancedForRouting =>
      'Ek yönlendirme denetimleri için Ayarlar’da Gelişmiş modu açın.';

  @override
  String get searchApps => 'Uygulama ara';

  @override
  String get save => 'Kaydet';

  @override
  String get routingBannerXray =>
      'Xray profili: Küresel / Kurallar / Doğrudan ve etki alanı kuralları bağlantıda uygulanır.';

  @override
  String get routingBannerHysteria =>
      'Hysteria2 profili: etki alanı/block kuralları ve Xray Direct uygulanmaz. Küresel kullanın; Always-exclude CIDR’leri ve IP-doğrudan yine TUN’a birleşir.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: Kurallar’daki doğrudan etki alanları/CIDR’ler dışlama olur. Block atlanır (eklentide block yok). Doğrudan mod uygulanmaz. Always-exclude yine birleşir. Uygulama başına bölme yalnızca SOCKS. Kill Switch sonraki TrustTunnel bağlantısında uygulanır.';

  @override
  String get routingBannerUnknown =>
      'Hangi yönlendirme özelliklerinin uygulanacağını görmek için bir profil seçin veya bağlayın.';

  @override
  String get logsEyebrow => 'Tanılama';

  @override
  String get logsTitle => 'Günlükler';

  @override
  String get copyFiltered => 'Süzüleni kopyala';

  @override
  String get clear => 'Temizle';

  @override
  String get logCopied => 'Günlük kopyalandı';

  @override
  String get logsHint =>
      'Çekirdek konsolu. Renkler sezgiseldir (error/warn anahtar sözcükleri).';

  @override
  String get filterHint => 'Süz…';

  @override
  String get logsAll => 'Tümü';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'Henüz günlük satırı yok';

  @override
  String get noMatchesForFilter => 'Süzgeç için eşleşme yok';

  @override
  String get vpnConsole => 'VPN konsolu';

  @override
  String get logsSheetEmpty => 'Henüz satır yok. Akış bekleniyor…';

  @override
  String get copy => 'Kopyala';

  @override
  String get openLogs => 'Günlükleri aç';

  @override
  String get tapToRetry => 'Yeniden denemek için dokunun';

  @override
  String get homeErrorTitle => 'Bağlanılamadı';

  @override
  String get homeErrorTunnel =>
      'Tünel başarısız — yeniden denemek için dokunun';

  @override
  String get homeErrorSocks =>
      'Yerel SOCKS başarısız — yeniden denemek için dokunun';

  @override
  String get activeProfile => 'ETKİN PROFİL';

  @override
  String get socksInbound => 'Yerel SOCKS';

  @override
  String get socksInboundSubtitle =>
      'Her bağlantıda rastgele kimlik bilgisi üretmek için kullanıcı ve parolayı boş bırakın. Diğer uygulamalar: 127.0.0.1 ve bu kimlik bilgileri.';

  @override
  String get socksPort => 'Bağlantı noktası';

  @override
  String get socksUsername => 'Kullanıcı adı';

  @override
  String get socksPassword => 'Parola';

  @override
  String get saveSocks => 'SOCKS’u kaydet';

  @override
  String get socksSaved => 'SOCKS kaydedildi';

  @override
  String get killSwitchAndroidConfirmTitle => 'Always-on’u açtınız mı?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'Uygulama Android VPN anahtarlarını değiştiremez. Kill Switch’i burada yalnızca GoodWin VPN için Always-on ve VPN olmadan bağlantıları engelle açık olduktan sonra açın.';

  @override
  String get killSwitchAndroidConfirmYes => 'Evet, açıklar';

  @override
  String get killSwitchAndroidConfirmNo => 'Henüz değil';

  @override
  String get killSwitchIosDisconnectFailed =>
      'İstek üzerine kapatılamadı. Kes, yeniden deneyene kadar kalıcı olmayabilir.';

  @override
  String get support => 'Destek';

  @override
  String get supportSubtitle => 'İşletmeci destek sayfasını aç';

  @override
  String get supportUnavailable => 'Bu abonelikte destek URL’si yok';

  @override
  String get licenses => 'Açık kaynak lisansları';

  @override
  String get licensesSubtitle =>
      'Bu uygulamada paketlenmiş çekirdekler ve kitaplıklar';

  @override
  String get licensesBody =>
      'Bu uygulama Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter ve Inter (SIL OFL) paketler. Kaynak ve lisanslar proje depolarındadır.';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingDone => 'Başla';

  @override
  String get onboardingServerTitle => 'Sunucunuz';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN, içe aktardığınız bir düğüm için istemcidir. Goodwin bulut vekili yoktur. Profiller’de bir paylaşım bağlantısı veya https abonelik URL’si ekleyin.';

  @override
  String get onboardingVpnTitle => 'Sistem VPN';

  @override
  String get onboardingVpnBody =>
      'Bağla, işletim sisteminden bir VPN yapılandırması eklemesini ister. Bu iletişim kutusu Android veya iOS’tandır, bu uygulamadan değil. Trafik ardından seçtiğiniz profildeki düğüme gider.';

  @override
  String get onboardingCameraTitle => 'QR için kamera';

  @override
  String get onboardingCameraBody =>
      'Kamera isteğe bağlıdır ve yalnızca paylaşım bağlantısı veya abonelik URL’si içeren bir QR tarar. Kareler cihazda kalır.';

  @override
  String get vpnExplainerTitle => 'Sistem VPN izni';

  @override
  String get vpnExplainerBody =>
      'Sonraki ekran işletim sistemi VPN iletişim kutusudur. Yalnızca bu cihazın trafiği içe aktarılan düğüm üzerinden göndermesini istiyorsanız izin verin.';

  @override
  String get vpnExplainerContinue => 'Devam';

  @override
  String get cameraExplainerTitle => 'Kamera izni';

  @override
  String get cameraExplainerBody =>
      'Sonraki ekran kamerayı isteyebilir. Yalnızca bir yapılandırma QR’sini taramak için kullanılır. Kareler yüklenmez.';

  @override
  String get cameraExplainerContinue => 'QR tara';

  @override
  String get importLinkHint =>
      'Bir paylaşım bağlantısı veya https:// abonelik URL’si yapıştırın. Uygulama bir vekil barındırmaz.';
}
