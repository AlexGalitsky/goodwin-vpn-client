// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Beranda';

  @override
  String get navProfiles => 'Profil';

  @override
  String get navRules => 'Aturan';

  @override
  String get navLogs => 'Log';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get connectVpn => 'Hubungkan VPN';

  @override
  String get disconnectVpn => 'Putuskan VPN';

  @override
  String get noProfile => 'Tidak ada profil';

  @override
  String get addProfileToConnect => 'Tambahkan profil untuk terhubung';

  @override
  String get addProfileToConnectHint =>
      'Impor tautan berbagi di Profil, lalu ketuk Hubungkan di sini.';

  @override
  String get addProfile => 'Tambah profil';

  @override
  String get networkStatus => 'STATUS JARINGAN';

  @override
  String get tapToDisconnect => 'Ketuk untuk memutus';

  @override
  String get tapToConnect => 'Ketuk untuk terhubung';

  @override
  String get statNode => 'Node';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Waktu aktif';

  @override
  String get sessionLogs => 'Log sesi';

  @override
  String get noLinesYet => 'Belum ada baris';

  @override
  String logLinesCount(int count) {
    return '$count baris';
  }

  @override
  String get uacDeclined => 'Permintaan UAC ditolak';

  @override
  String get statusOffline => 'terputus';

  @override
  String get statusConnecting => 'menghubungkan';

  @override
  String get statusConnected => 'terhubung';

  @override
  String get statusDisconnecting => 'memutus';

  @override
  String get statusError => 'kesalahan';

  @override
  String get switchProfile => 'Ganti profil';

  @override
  String get manageProfiles => 'Kelola profil';

  @override
  String get routing => 'Perutean';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · ubah di Aturan';
  }

  @override
  String get routingModeGlobal => 'Global';

  @override
  String get routingModeRules => 'Aturan';

  @override
  String get routingModeDirect => 'Langsung';

  @override
  String get homeReadyTitle => 'Terputus';

  @override
  String get homeReadyTunnel => 'Hubungkan memulai VPN sistem di perangkat ini';

  @override
  String get homeReadySocks =>
      'OS ini belum punya VPN sistem — Hubungkan adalah proksi SOCKS lokal';

  @override
  String get homeBusyTitle => 'Menghubungkan';

  @override
  String get homeBusyTunnel => 'Meminta terowongan VPN ke OS';

  @override
  String get homeBusySocks => 'Menjalankan proksi SOCKS lokal';

  @override
  String get homeConnectedTunnelTitle => 'VPN sistem';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Lalu lintas perangkat lewat terowongan, bukan IP rumah Anda';

  @override
  String get homeConnectedSocksTitle => 'SOCKS lokal';

  @override
  String get homeConnectedSocksSubtitle =>
      'Tidak ada terowongan sistem di OS ini. Aplikasi harus memakai 127.0.0.1:10808 — IP Anda tidak disembunyikan';

  @override
  String get revokedTitle => 'Tautan langganan dicabut';

  @override
  String get revokedBody =>
      'Tempel URL baru di Profil. Node lama tetap ada sampai Anda mengimpor pengganti.';

  @override
  String get openProfiles => 'Buka Profil';

  @override
  String get elevationTitle => 'Hak administrator diperlukan';

  @override
  String get runAsAdministrator => 'Jalankan sebagai administrator';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used terpakai · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'kedaluwarsa';

  @override
  String quotaDaysLeft(int days) {
    return 'sisa ${days}h';
  }

  @override
  String get quotaScopeNote =>
      'Lalu lintas VLESS+Hy2 — TrustTunnel tidak dihitung';

  @override
  String get profilesEyebrow => 'Jaringan Anda';

  @override
  String get profilesTitle => 'Profil server';

  @override
  String get tooltipPinging => 'Sedang Ping…';

  @override
  String get tooltipCheckPing => 'Periksa Ping';

  @override
  String get noProfilesToPing => 'Tidak ada profil untuk di-Ping';

  @override
  String get tooltipImportLink => 'Impor tautan atau langganan';

  @override
  String get searchServersHint => 'Cari server atau protokol';

  @override
  String get smartConnect => 'Hubungkan cerdas';

  @override
  String get smartConnectSubtitle =>
      'Hubungkan di Beranda memakai node dengan Ping terendah di langganan saat ini';

  @override
  String get emptyProfiles =>
      'Belum ada profil tersimpan.\nImpor tautan berbagi atau URL langganan https://.';

  @override
  String get noMatches => 'Tidak ada yang cocok';

  @override
  String get pinging => 'sedang Ping';

  @override
  String get fastest => 'tercepat';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteProfileConfirm => 'Hapus profil ini?';

  @override
  String get deleteSubscriptionConfirm =>
      'Hapus langganan ini beserta node tersimpannya?';

  @override
  String updatedSubscription(String name) {
    return '$name diperbarui';
  }

  @override
  String get importProfile => 'Impor profil';

  @override
  String get nameOptional => 'Nama (opsional)';

  @override
  String get importLinkLabel => 'Tautan berbagi atau URL langganan https://';

  @override
  String get paste => 'Tempel';

  @override
  String get scanQr => 'Pindai QR';

  @override
  String get cancel => 'Batal';

  @override
  String get import => 'Impor';

  @override
  String get unrecognizedShareLink => 'Tautan berbagi tidak dikenali';

  @override
  String get editProfile => 'Edit profil';

  @override
  String get name => 'Nama';

  @override
  String get shareLink => 'Tautan berbagi';

  @override
  String get apply => 'Terapkan';

  @override
  String get importedManual => 'Diimpor';

  @override
  String get subscriptionFallback => 'Langganan';

  @override
  String get revokedKeepNodes =>
      'Tautan dicabut — tempel URL baru. Node tidak dihapus.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count node';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count node',
      one: '1 node',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Segarkan langganan';

  @override
  String get removeSubscription => 'Hapus langganan';

  @override
  String get nothingToImport => 'Tidak ada yang diimpor';

  @override
  String get subscriptionImported => 'Langganan diimpor';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name diimpor ($count node)';
  }

  @override
  String get profileImported => 'Profil diimpor';

  @override
  String get settingsEyebrow => 'Aplikasi';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get appearance => 'Tampilan';

  @override
  String get colorTheme => 'Tema warna';

  @override
  String get colorThemeSubtitle =>
      'Kertas terang dan navy gelap. Sistem mengikuti ponsel.';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSubtitle => 'Inggris dan Rusia. Sistem mengikuti ponsel.';

  @override
  String get localeSystem => 'Sistem';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Umum';

  @override
  String get advancedMode => 'Mode lanjutan';

  @override
  String get advancedModeSubtitle => 'Tab log dan opsi untuk pengguna mahir';

  @override
  String get reconnectOnLaunch => 'Hubungkan lagi saat diluncurkan';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Jalankan profil terakhir jika VPN OS mati';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'Sistem';

  @override
  String get dnsCustom => 'Kustom';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'Server DNS / URL DoH';

  @override
  String get dnsSaved => 'Preferensi DNS disimpan';

  @override
  String get saveDns => 'Simpan DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Always-on VPN di pengaturan Android. Sakelar di sini sendiri tidak anti-bocor.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Kunci kebocoran plugin pada Hubungkan TrustTunnel berikutnya. Always-on tetap diperlukan setelah reboot.';

  @override
  String get killSwitchSubtitleIos =>
      'Menghubungkan lagi jika terowongan terputus. Push, Watch, dan iMessage tetap dapat dijangkau.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Kunci kebocoran plugin untuk sesi TrustTunnel ini. Putuskan mematikannya sebelum VPN SOCKS dapat dimulai.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Nyalakan perlindungan kebocoran sistem';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. Di layar berikutnya, ketuk Goodwin VPN (SOCKS atau TrustTunnel).\n2. Nyalakan Always-on VPN.\n3. Nyalakan Blokir koneksi tanpa VPN.\n4. Kembali ke sini dan ketuk Hubungkan.\n\nAplikasi tidak dapat memindah sakelar Android itu sendiri. TrustTunnel juga memakai perlindungan kebocoran plugin pada Hubungkan berikutnya.';

  @override
  String get killSwitchAndroidDisableTitle => 'Matikan Always-on dulu';

  @override
  String get killSwitchAndroidDisableBody =>
      'Di pengaturan VPN Android, matikan Always-on VPN dan Blokir koneksi tanpa VPN untuk Goodwin. Jika tidak, Putuskan akan mengembalikan terowongan.';

  @override
  String get killSwitchOpenSettings => 'Buka pengaturan VPN';

  @override
  String get killSwitchDisconnectTitle =>
      'Always-on mungkin menghubungkan lagi';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN dapat mengembalikan terowongan setelah Putuskan. Matikan Always-on di pengaturan VPN sistem jika Anda ingin jaringan sepenuhnya terbuka.';

  @override
  String get killSwitchDisconnectConfirm => 'Putuskan';

  @override
  String get coreTuning => 'Penyetelan inti';

  @override
  String get advancedDangerTooltip => 'Lanjutan — dapat memutus konektivitas';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Dilewati dengan Vision — VLESS biasa tetap start';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Dilewati di REALITY — hanya TLS hello';

  @override
  String get dnsHintWithTuning =>
      'IP DNS diterapkan ke TUN OS saat terhubung. DoH masuk ke JSON Xray; TUN tetap memakai IP bootstrap. Mux / Fragment: hanya Xray.';

  @override
  String get dnsHintSimple => 'IP DNS diterapkan ke TUN OS saat terhubung.';

  @override
  String get backup => 'Cadangan';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Ekspor berkas cadangan';

  @override
  String get exportBackupSubtitle =>
      'Profil dan langganan. Kata sandi opsional mengenkripsi berkas';

  @override
  String get importBackup => 'Impor berkas cadangan';

  @override
  String get importBackupSubtitle => 'Digabung ke katalog saat ini';

  @override
  String get copyJsonClipboard => 'Salin JSON ke papan klip';

  @override
  String get copyJsonClipboardSubtitle =>
      'Tidak terenkripsi — siapa pun yang membaca papan klip dapat melihat tautan';

  @override
  String get copiedEmptyProfiles => 'Daftar profil kosong disalin';

  @override
  String copiedProfilesJson(int count) {
    return '$count profil disalin sebagai JSON tidak terenkripsi';
  }

  @override
  String get exportBackupTitle => 'Ekspor cadangan';

  @override
  String get exportBackupPasswordHint =>
      'Kosongkan untuk berkas JSON biasa. Kata sandi memakai AES-256-GCM.';

  @override
  String get backupFileSaved => 'Berkas cadangan disimpan';

  @override
  String get encryptedBackupSaved => 'Berkas cadangan terenkripsi disimpan';

  @override
  String get encryptedBackupTitle => 'Cadangan terenkripsi';

  @override
  String get encryptedBackupHint =>
      'Masukkan kata sandi yang dipakai saat mengekspor.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles profil dan $subs langganan diimpor';
  }

  @override
  String get passwordOptional => 'Kata sandi (opsional)';

  @override
  String get password => 'Kata sandi';

  @override
  String get confirmPassword => 'Konfirmasi kata sandi';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get continueAction => 'Lanjutkan';

  @override
  String get about => 'Tentang';

  @override
  String get aboutSubtitle => 'Klien VPN untuk server Anda sendiri';

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
  String get privacy => 'Privasi';

  @override
  String get privacySubtitle =>
      'Kamera, VPN, rahasia di perangkat, cadangan papan klip';

  @override
  String get privacyWhatTitle => 'Apa yang dipakai aplikasi ini';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN adalah klien lokal. Tidak ada server akun Goodwin dan tidak ada SDK analitik dalam build ini.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'Pada platform dengan terowongan sistem, lalu lintas perangkat dikirim ke node di tautan berbagi yang Anda impor. Aplikasi tidak mengoperasikan proksi Goodwin. Jika OS ini tidak punya terowongan sistem, Hubungkan hanya memulai proksi SOCKS lokal di 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Konfigurasi dan rahasia';

  @override
  String get privacySecretsBody =>
      'Tautan berbagi, profil tersimpan, dan URL langganan disimpan di perangkat ini, dienkripsi dengan AES-256-GCM. Kunci enkripsi ada di keystore / keychain OS, bukan di samping ciphertext. Jika keystore platform tidak tersedia, aplikasi tidak dapat menyimpan nilai itu terenkripsi.';

  @override
  String get privacyCameraTitle => 'Kamera';

  @override
  String get privacyCameraBody =>
      'Kamera hanya dipakai untuk memindai kode QR yang berisi tautan berbagi atau URL langganan. Bingkai tidak diunggah.';

  @override
  String get privacyClipboardTitle => 'Papan klip dan cadangan';

  @override
  String get privacyClipboardBody =>
      'Salin JSON ke papan klip menulis cadangan tidak terenkripsi. Siapa pun yang dapat membaca papan klip dapat membaca tautan itu. Ekspor berkas dapat memakai kata sandi opsional (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Aplikasi terpasang (Android)';

  @override
  String get privacyAppsBody =>
      'Split tunneling per aplikasi membaca daftar aplikasi peluncur di perangkat agar Anda dapat mengecualikan aplikasi dari VPN. Daftar itu tetap di perangkat.';

  @override
  String get privacyOpenWeb => 'Buka kebijakan privasi';

  @override
  String get privacyOpenFailed => 'Tidak dapat membuka URL kebijakan privasi';

  @override
  String get rulesEyebrow => 'Kebijakan lalu lintas';

  @override
  String get rulesTitle => 'Aturan perutean';

  @override
  String get reset => 'Reset';

  @override
  String get resetRulesConfirm => 'Reset perutean ke bawaan?';

  @override
  String get mode => 'Mode';

  @override
  String get modeHintGlobalRich =>
      'Semua lalu lintas yang cocok → proksi (bawaan Xray).';

  @override
  String get modeHintGlobalSimple => 'Disarankan untuk Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Semua lalu lintas lewat terowongan kecuali Always-exclude.';

  @override
  String get modeHintRules =>
      'Preset + aturan kustom; yang tidak cocok → proksi (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Domain/CIDR langsung menjadi pengecualian TrustTunnel. Block dilewati. Yang tidak cocok tetap di terowongan.';

  @override
  String get modeHintDirect => 'Semua → freedom. TUN tetap aktif (hanya Xray).';

  @override
  String get presets => 'Preset';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Blokir iklan (terbatas)';

  @override
  String get presetBlockAdsPack => 'Blokir iklan';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Daftar host bawaan kecil → block (Xray; bukan geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'Paket iklan layanan → block (bukan geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Paket iklan layanan → pengecualian TrustTunnel (tidak ada block plugin)';

  @override
  String get presetBypassLan => 'Lewati LAN / privat';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / CIDR tautan-lokal → pengecualian TUN (bukan wilayah/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Lewati LAN membutuhkan Android 13+. Pengecualian CIDR tidak berfungsi di versi ini.';

  @override
  String get presetProtectBanking => 'Lindungi perbankan';

  @override
  String get presetProtectBankingSubtitle =>
      'Aplikasi bank terpasang melewati TUN (per aplikasi Android)';

  @override
  String get appsSkipVpn => 'Aplikasi yang melewati VPN';

  @override
  String get appsSkipVpnEmpty => 'Tambahan opsional di luar Lindungi perbankan';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count dipilih · diterapkan pada sambungan berikutnya';
  }

  @override
  String get switchToRulesForPresets =>
      'Beralih ke mode Aturan untuk memakai preset.';

  @override
  String get alwaysExcludeMerged =>
      'CIDR Always-exclude digabung dengan aturan IP-langsung saat terhubung untuk setiap backend. Edit di Lanjutan di bawah.';

  @override
  String get alwaysExcludeCidr => 'Selalu kecualikan (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Satu IP atau CIDR per baris. Diterapkan pada sambungan berikutnya.';

  @override
  String get cidrHint => 'Satu IP atau CIDR per baris\nmis. 10.0.0.0/8';

  @override
  String get customRules => 'Aturan kustom';

  @override
  String get customRulesHint =>
      'Akhiran domain, IP, atau CIDR → proxy / direct / block. Diterapkan ke Xray saat terhubung. IP langsung juga masuk ke pengecualian OS.';

  @override
  String get customRulesHintTrustTunnel =>
      'Domain atau CIDR → proxy (tetap di terowongan) atau direct (kecualikan). Block tidak tersedia. Tanpa geosite.';

  @override
  String get matcher => 'Pencocok';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Tambah aturan';

  @override
  String get noCustomRules => 'Belum ada aturan kustom';

  @override
  String osExclude(String action) {
    return '$action · pengecualian OS';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · dilewati di TrustTunnel (tidak ada block plugin)';

  @override
  String get enableAdvancedForRouting =>
      'Aktifkan mode Lanjutan di Pengaturan untuk kontrol perutean tambahan.';

  @override
  String get searchApps => 'Cari aplikasi';

  @override
  String get save => 'Simpan';

  @override
  String get routingBannerXray =>
      'Profil Xray: Global / Aturan / Langsung dan aturan domain diterapkan saat terhubung.';

  @override
  String get routingBannerHysteria =>
      'Profil Hysteria2: aturan domain/block dan Direct Xray tidak diterapkan. Gunakan Global; CIDR Always-exclude dan IP-langsung tetap digabung ke TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: domain/CIDR langsung di Aturan menjadi pengecualian. Block dilewati (tidak ada block plugin). Mode Langsung tidak diterapkan. Always-exclude tetap digabung. Split per aplikasi hanya SOCKS. Kill Switch diterapkan pada sambungan TrustTunnel berikutnya.';

  @override
  String get routingBannerUnknown =>
      'Pilih atau hubungkan profil untuk melihat fitur perutean yang berlaku.';

  @override
  String get logsEyebrow => 'Diagnostik';

  @override
  String get logsTitle => 'Log';

  @override
  String get copyFiltered => 'Salin yang tersaring';

  @override
  String get clear => 'Hapus';

  @override
  String get logCopied => 'Log disalin';

  @override
  String get logsHint =>
      'Konsol inti. Warna bersifat heuristik (kata kunci error/warn).';

  @override
  String get filterHint => 'Filter…';

  @override
  String get logsAll => 'Semua';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'Belum ada baris log';

  @override
  String get noMatchesForFilter => 'Tidak ada yang cocok untuk filter';

  @override
  String get vpnConsole => 'Konsol VPN';

  @override
  String get logsSheetEmpty => 'Belum ada baris. Menunggu aliran…';

  @override
  String get copy => 'Salin';

  @override
  String get openLogs => 'Buka log';

  @override
  String get tapToRetry => 'Ketuk untuk mencoba lagi';

  @override
  String get homeErrorTitle => 'Tidak dapat terhubung';

  @override
  String get homeErrorTunnel => 'Terowongan gagal — ketuk untuk mencoba lagi';

  @override
  String get homeErrorSocks => 'SOCKS lokal gagal — ketuk untuk mencoba lagi';

  @override
  String get activeProfile => 'PROFIL AKTIF';

  @override
  String get socksInbound => 'SOCKS lokal';

  @override
  String get socksInboundSubtitle =>
      'Kosongkan pengguna dan kata sandi untuk menghasilkan kredensial acak setiap sambungan. Aplikasi lain: 127.0.0.1 plus kredensial ini.';

  @override
  String get socksPort => 'Port';

  @override
  String get socksUsername => 'Nama pengguna';

  @override
  String get socksPassword => 'Kata sandi';

  @override
  String get saveSocks => 'Simpan SOCKS';

  @override
  String get socksSaved => 'SOCKS disimpan';

  @override
  String get killSwitchAndroidConfirmTitle => 'Sudah menyalakan Always-on?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'Aplikasi tidak dapat memindah sakelar VPN Android. Nyalakan Kill Switch di sini hanya setelah Always-on dan Blokir koneksi tanpa VPN diaktifkan untuk GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Ya, sudah aktif';

  @override
  String get killSwitchAndroidConfirmNo => 'Belum';

  @override
  String get killSwitchIosDisconnectFailed =>
      'Tidak dapat mematikan on-demand. Putuskan mungkin tidak bertahan sampai Anda mencoba lagi.';

  @override
  String get support => 'Dukungan';

  @override
  String get supportSubtitle => 'Buka halaman dukungan operator';

  @override
  String get supportUnavailable => 'Tidak ada URL dukungan di langganan ini';

  @override
  String get licenses => 'Lisensi sumber terbuka';

  @override
  String get licensesSubtitle =>
      'Inti dan pustaka yang dibundel di aplikasi ini';

  @override
  String get licensesBody =>
      'Aplikasi ini membundel Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter, dan Inter (SIL OFL). Sumber dan lisensi ada di repositori proyek.';

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get onboardingNext => 'Berikutnya';

  @override
  String get onboardingDone => 'Mulai';

  @override
  String get onboardingServerTitle => 'Server Anda';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN adalah klien untuk node yang Anda impor. Tidak ada proksi awan Goodwin. Tambahkan tautan berbagi atau URL langganan https di Profil.';

  @override
  String get onboardingVpnTitle => 'VPN sistem';

  @override
  String get onboardingVpnBody =>
      'Hubungkan meminta OS menambahkan konfigurasi VPN. Dialog itu dari Android atau iOS, bukan dari aplikasi ini. Lalu lintas kemudian menuju node di profil yang Anda pilih.';

  @override
  String get onboardingCameraTitle => 'Kamera untuk QR';

  @override
  String get onboardingCameraBody =>
      'Kamera bersifat opsional dan hanya memindai QR berisi tautan berbagi atau URL langganan. Bingkai tetap di perangkat.';

  @override
  String get vpnExplainerTitle => 'Izin VPN sistem';

  @override
  String get vpnExplainerBody =>
      'Layar berikutnya adalah dialog VPN OS. Izinkan hanya jika Anda ingin perangkat ini mengirim lalu lintas lewat node yang diimpor.';

  @override
  String get vpnExplainerContinue => 'Lanjutkan';

  @override
  String get cameraExplainerTitle => 'Izin kamera';

  @override
  String get cameraExplainerBody =>
      'Layar berikutnya mungkin meminta kamera. Hanya dipakai untuk memindai QR konfigurasi. Bingkai tidak diunggah.';

  @override
  String get cameraExplainerContinue => 'Pindai QR';

  @override
  String get importLinkHint =>
      'Tempel tautan berbagi atau URL langganan https://. Aplikasi tidak menyelenggarakan proksi.';
}
