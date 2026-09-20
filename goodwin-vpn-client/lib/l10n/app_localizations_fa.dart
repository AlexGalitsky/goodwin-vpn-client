// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'خانه';

  @override
  String get navProfiles => 'پروفایل‌ها';

  @override
  String get navRules => 'قوانین';

  @override
  String get navLogs => 'گزارش‌ها';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get connectVpn => 'اتصال VPN';

  @override
  String get disconnectVpn => 'قطع VPN';

  @override
  String get noProfile => 'بدون پروفایل';

  @override
  String get addProfileToConnect => 'برای اتصال یک پروفایل اضافه کنید';

  @override
  String get addProfileToConnectHint =>
      'در پروفایل‌ها یک لینک اشتراک بگذارید، سپس اینجا وصل شوید.';

  @override
  String get addProfile => 'افزودن پروفایل';

  @override
  String get networkStatus => 'وضعیت شبکه';

  @override
  String get tapToDisconnect => 'برای قطع بزنید';

  @override
  String get tapToConnect => 'برای اتصال بزنید';

  @override
  String get statNode => 'گره';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'زمان اتصال';

  @override
  String get sessionLogs => 'گزارش نشست';

  @override
  String get noLinesYet => 'هنوز خطی نیست';

  @override
  String logLinesCount(int count) {
    return '$count خط';
  }

  @override
  String get uacDeclined => 'درخواست UAC رد شد';

  @override
  String get statusOffline => 'قطع‌شده';

  @override
  String get statusConnecting => 'در حال اتصال';

  @override
  String get statusConnected => 'متصل';

  @override
  String get statusDisconnecting => 'در حال قطع';

  @override
  String get statusError => 'خطا';

  @override
  String get switchProfile => 'تعویض پروفایل';

  @override
  String get manageProfiles => 'مدیریت پروفایل‌ها';

  @override
  String get routing => 'مسیریابی';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · تغییر در قوانین';
  }

  @override
  String get routingModeGlobal => 'سراسری';

  @override
  String get routingModeRules => 'قوانین';

  @override
  String get routingModeDirect => 'مستقیم';

  @override
  String get homeReadyTitle => 'قطع‌شده';

  @override
  String get homeReadyTunnel =>
      'اتصال یک VPN سیستمی روی این دستگاه راه می‌اندازد';

  @override
  String get homeReadySocks =>
      'این سیستم هنوز VPN سیستمی ندارد — اتصال یک پروکسی SOCKS محلی است';

  @override
  String get homeBusyTitle => 'در حال اتصال';

  @override
  String get homeBusyTunnel => 'از سیستم تونل VPN خواسته می‌شود';

  @override
  String get homeBusySocks => 'در حال راه‌اندازی پروکسی SOCKS محلی';

  @override
  String get homeConnectedTunnelTitle => 'VPN سیستمی';

  @override
  String get homeConnectedTunnelSubtitle =>
      'ترافیک دستگاه از تونل می‌گذرد، نه از IP خانه';

  @override
  String get homeConnectedSocksTitle => 'SOCKS محلی';

  @override
  String get homeConnectedSocksSubtitle =>
      'روی این سیستم تونل سیستمی نیست. برنامه‌ها باید از 127.0.0.1:10808 استفاده کنند — IP شما پنهان نیست';

  @override
  String get revokedTitle => 'لینک اشتراک باطل شد';

  @override
  String get revokedBody =>
      'در پروفایل‌ها یک URL تازه بچسبانید. گره‌های قدیمی تا وقتی جایگزین وارد کنید می‌مانند.';

  @override
  String get openProfiles => 'باز کردن پروفایل‌ها';

  @override
  String get elevationTitle => 'دسترسی مدیر لازم است';

  @override
  String get runAsAdministrator => 'اجرا به‌عنوان مدیر';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used استفاده‌شده · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'منقضی';

  @override
  String quotaDaysLeft(int days) {
    return '$days روز مانده';
  }

  @override
  String get quotaScopeNote => 'ترافیک VLESS+Hy2 — TrustTunnel شمارش نمی‌شود';

  @override
  String get profilesEyebrow => 'شبکه شما';

  @override
  String get profilesTitle => 'پروفایل سرورها';

  @override
  String get tooltipPinging => 'در حال Ping…';

  @override
  String get tooltipCheckPing => 'بررسی Ping';

  @override
  String get noProfilesToPing => 'پروفایلی برای Ping نیست';

  @override
  String get tooltipImportLink => 'وارد کردن لینک یا اشتراک';

  @override
  String get searchServersHint => 'جستجوی سرور یا پروتکل';

  @override
  String get smartConnect => 'اتصال هوشمند';

  @override
  String get smartConnectSubtitle =>
      'اتصال خانه از گره با کمترین Ping در اشتراک فعلی استفاده می‌کند';

  @override
  String get emptyProfiles =>
      'هنوز پروفایل ذخیره‌شده‌ای نیست.\nیک لینک اشتراک یا URL اشتراک https:// وارد کنید.';

  @override
  String get noMatches => 'موردی نیست';

  @override
  String get pinging => 'در حال Ping';

  @override
  String get fastest => 'سریع‌ترین';

  @override
  String get delete => 'حذف';

  @override
  String get deleteProfileConfirm => 'این پروفایل حذف شود؟';

  @override
  String get deleteSubscriptionConfirm =>
      'این اشتراک و گره‌های ذخیره‌شده‌اش حذف شوند؟';

  @override
  String updatedSubscription(String name) {
    return '$name به‌روز شد';
  }

  @override
  String get importProfile => 'وارد کردن پروفایل';

  @override
  String get nameOptional => 'نام (اختیاری)';

  @override
  String get importLinkLabel => 'لینک اشتراک یا URL اشتراک https://';

  @override
  String get paste => 'چسباندن';

  @override
  String get scanQr => 'اسکن QR';

  @override
  String get cancel => 'لغو';

  @override
  String get import => 'وارد کردن';

  @override
  String get unrecognizedShareLink => 'لینک اشتراک ناشناخته';

  @override
  String get editProfile => 'ویرایش پروفایل';

  @override
  String get name => 'نام';

  @override
  String get shareLink => 'لینک اشتراک';

  @override
  String get apply => 'اعمال';

  @override
  String get importedManual => 'واردشده';

  @override
  String get subscriptionFallback => 'اشتراک';

  @override
  String get revokedKeepNodes =>
      'لینک باطل شد — URL تازه بچسبانید. گره‌ها پاک نشدند.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count گره';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گره',
      one: '۱ گره',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'تازه‌سازی اشتراک';

  @override
  String get removeSubscription => 'حذف اشتراک';

  @override
  String get nothingToImport => 'چیزی برای وارد کردن نیست';

  @override
  String get subscriptionImported => 'اشتراک وارد شد';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name وارد شد ($count گره)';
  }

  @override
  String get profileImported => 'پروفایل وارد شد';

  @override
  String get settingsEyebrow => 'برنامه';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get appearance => 'ظاهر';

  @override
  String get colorTheme => 'تم رنگی';

  @override
  String get colorThemeSubtitle =>
      'کاغذ روشن و سرمه‌ای تیره. سیستم از گوشی پیروی می‌کند.';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get language => 'زبان';

  @override
  String get languageSubtitle => 'انگلیسی و روسی. سیستم از گوشی پیروی می‌کند.';

  @override
  String get localeSystem => 'سیستم';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'عمومی';

  @override
  String get advancedMode => 'حالت پیشرفته';

  @override
  String get advancedModeSubtitle => 'زبانه گزارش‌ها و تنظیمات حرفه‌ای';

  @override
  String get reconnectOnLaunch => 'اتصال دوباره هنگام اجرا';

  @override
  String get reconnectOnLaunchSubtitle =>
      'اگر VPN سیستم قطع باشد، آخرین پروفایل را بالا بیاور';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'سیستم';

  @override
  String get dnsCustom => 'سفارشی';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'سرور DNS / URL مربوط به DoH';

  @override
  String get dnsSaved => 'ترجیح DNS ذخیره شد';

  @override
  String get saveDns => 'ذخیره DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Always-on VPN در تنظیمات Android. این کلید به‌تنهایی ضدنشت کامل نیست.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'قفل نشت افزونه در اتصال بعدی TrustTunnel. بعد از راه‌اندازی دوباره همچنان Always-on لازم است.';

  @override
  String get killSwitchSubtitleIos =>
      'اگر تونل قطع شود دوباره وصل می‌شود. پوش، Watch و iMessage در دسترس می‌مانند.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'قفل نشت افزونه برای این نشست TrustTunnel. قطع، آن را قبل از شروع SOCKS VPN خاموش می‌کند.';

  @override
  String get killSwitchAndroidEnableTitle => 'روشن کردن حفاظت سیستمی از نشت';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. در صفحه بعد، Goodwin VPN (SOCKS یا TrustTunnel) را بزنید.\n2. Always-on VPN را روشن کنید.\n3. مسدود کردن اتصال بدون VPN را روشن کنید.\n4. به اینجا برگردید و اتصال را بزنید.\n\nبرنامه خودش این کلیدهای Android را عوض نمی‌کند. TrustTunnel در اتصال بعدی از حفاظت نشت افزونه هم استفاده می‌کند.';

  @override
  String get killSwitchAndroidDisableTitle => 'اول Always-on را خاموش کنید';

  @override
  String get killSwitchAndroidDisableBody =>
      'در تنظیمات VPN اندروید، Always-on VPN و مسدود کردن اتصال بدون VPN را برای Goodwin خاموش کنید. وگرنه قطع دوباره تونل را برمی‌گرداند.';

  @override
  String get killSwitchOpenSettings => 'باز کردن تنظیمات VPN';

  @override
  String get killSwitchDisconnectTitle => 'Always-on ممکن است دوباره وصل شود';

  @override
  String get killSwitchDisconnectBody =>
      'Always-on VPN در Android می‌تواند بعد از قطع دوباره تونل را بیاورد. اگر شبکه کاملاً باز می‌خواهید، Always-on را در تنظیمات VPN سیستم خاموش کنید.';

  @override
  String get killSwitchDisconnectConfirm => 'قطع';

  @override
  String get coreTuning => 'تنظیم هسته';

  @override
  String get advancedDangerTooltip => 'پیشرفته — ممکن است اتصال را قطع کند';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle =>
      'با Vision اعمال نمی‌شود — VLESS معمولی بالا می‌آید';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'روی REALITY اعمال نمی‌شود — فقط TLS hello';

  @override
  String get dnsHintWithTuning =>
      'IPهای DNS هنگام اتصال روی TUN سیستم اعمال می‌شوند. DoH وارد JSON مربوط به Xray می‌شود؛ TUN همچنان از IPهای راه‌انداز استفاده می‌کند. Mux / Fragment: فقط Xray.';

  @override
  String get dnsHintSimple =>
      'IPهای DNS هنگام اتصال روی TUN سیستم اعمال می‌شوند.';

  @override
  String get backup => 'پشتیبان';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'خروجی فایل پشتیبان';

  @override
  String get exportBackupSubtitle =>
      'پروفایل‌ها و اشتراک‌ها. رمز اختیاری فایل را رمزنگاری می‌کند';

  @override
  String get importBackup => 'وارد کردن فایل پشتیبان';

  @override
  String get importBackupSubtitle => 'با فهرست فعلی ادغام می‌شود';

  @override
  String get copyJsonClipboard => 'کپی JSON در کلیپ‌بورد';

  @override
  String get copyJsonClipboardSubtitle =>
      'بدون رمزنگاری — هر کس کلیپ‌بورد را بخواند لینک‌ها را می‌بیند';

  @override
  String get copiedEmptyProfiles => 'فهرست پروفایل خالی کپی شد';

  @override
  String copiedProfilesJson(int count) {
    return '$count پروفایل به‌صورت JSON رمزنگاری‌نشده کپی شد';
  }

  @override
  String get exportBackupTitle => 'خروجی پشتیبان';

  @override
  String get exportBackupPasswordHint =>
      'برای فایل JSON ساده خالی بگذارید. رمز از AES-256-GCM استفاده می‌کند.';

  @override
  String get backupFileSaved => 'فایل پشتیبان ذخیره شد';

  @override
  String get encryptedBackupSaved => 'فایل پشتیبان رمزنگاری‌شده ذخیره شد';

  @override
  String get encryptedBackupTitle => 'پشتیبان رمزنگاری‌شده';

  @override
  String get encryptedBackupHint => 'رمزی را که هنگام خروجی گذاشتید وارد کنید.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles پروفایل و $subs اشتراک وارد شد';
  }

  @override
  String get passwordOptional => 'رمز (اختیاری)';

  @override
  String get password => 'رمز';

  @override
  String get confirmPassword => 'تأیید رمز';

  @override
  String get passwordsDoNotMatch => 'رمزها یکسان نیستند';

  @override
  String get continueAction => 'ادامه';

  @override
  String get about => 'درباره';

  @override
  String get aboutSubtitle => 'کلاینت VPN برای سرور خودتان';

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
  String get privacy => 'حریم خصوصی';

  @override
  String get privacySubtitle =>
      'دوربین، VPN، اسرار روی دستگاه، پشتیبان کلیپ‌بورد';

  @override
  String get privacyWhatTitle => 'این برنامه چه چیزی استفاده می‌کند';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN یک کلاینت محلی است. در این ساخت سرور حساب Goodwin و SDK تحلیلی نیست.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'روی بسترهایی با تونل سیستمی، ترافیک دستگاه به گره موجود در لینک اشتراکی که وارد کردید فرستاده می‌شود. برنامه پروکسی Goodwin راه‌اندازی نمی‌کند. اگر این سیستم تونل سیستمی ندارد، اتصال فقط یک پروکسی SOCKS محلی روی 127.0.0.1:10808 راه می‌اندازد.';

  @override
  String get privacySecretsTitle => 'پیکربندی‌ها و اسرار';

  @override
  String get privacySecretsBody =>
      'لینک‌های اشتراک، پروفایل‌های ذخیره‌شده و URL اشتراک روی این دستگاه با AES-256-GCM رمزنگاری می‌شوند. کلید رمزنگاری در keystore / keychain سیستم است، نه کنار متن رمز. اگر keystore بستر در دسترس نباشد، برنامه نمی‌تواند این مقادیر را رمزشده نگه دارد.';

  @override
  String get privacyCameraTitle => 'دوربین';

  @override
  String get privacyCameraBody =>
      'دوربین فقط برای اسکن QR حاوی لینک اشتراک یا URL اشتراک است. فریم‌ها آپلود نمی‌شوند.';

  @override
  String get privacyClipboardTitle => 'کلیپ‌بورد و پشتیبان';

  @override
  String get privacyClipboardBody =>
      'کپی JSON در کلیپ‌بورد یک پشتیبان رمزنگاری‌نشده می‌نویسد. هر کس کلیپ‌بورد را بخواند آن لینک‌ها را می‌بیند. خروجی فایل می‌تواند رمز اختیاری داشته باشد (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'برنامه‌های نصب‌شده (Android)';

  @override
  String get privacyAppsBody =>
      'تونل تفکیکی هر برنامه فهرست برنامه‌های لانچر دستگاه را می‌خواند تا بتوانید برنامه‌ها را از VPN کنار بگذارید. آن فهرست روی دستگاه می‌ماند.';

  @override
  String get privacyOpenWeb => 'باز کردن سیاست حریم خصوصی';

  @override
  String get privacyOpenFailed => 'نتوانست URL سیاست حریم خصوصی را باز کند';

  @override
  String get rulesEyebrow => 'سیاست ترافیک';

  @override
  String get rulesTitle => 'قوانین مسیریابی';

  @override
  String get reset => 'بازنشانی';

  @override
  String get resetRulesConfirm => 'مسیریابی به پیش‌فرض برگردد؟';

  @override
  String get mode => 'حالت';

  @override
  String get modeHintGlobalRich => 'همه ترافیک منطبق → پروکسی (پیش‌فرض Xray).';

  @override
  String get modeHintGlobalSimple => 'پیشنهادی برای Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'همه ترافیک از تونل، به‌جز Always-exclude.';

  @override
  String get modeHintRules =>
      'پیش‌تنظیم‌ها + قوانین سفارشی؛ نامنطبق → پروکسی (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'دامنه‌ها/CIDR مستقیم به استثناهای TrustTunnel تبدیل می‌شوند. Block رد می‌شود. نامنطبق در تونل می‌ماند.';

  @override
  String get modeHintDirect => 'همه → freedom. TUN روشن می‌ماند (فقط Xray).';

  @override
  String get presets => 'پیش‌تنظیم‌ها';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'مسدود کردن تبلیغات (محدود)';

  @override
  String get presetBlockAdsPack => 'مسدود کردن تبلیغات';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'فهرست میزبان داخلی کوچک → block (Xray؛ نه geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'بسته تبلیغات سرویس → block (نه geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'بسته تبلیغات سرویس → استثناهای TrustTunnel (بدون block افزونه)';

  @override
  String get presetBypassLan => 'دور زدن LAN / خصوصی';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / CIDR پیوندمحلی → استثناهای TUN (نه منطقه/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'دور زدن LAN به Android 13+ نیاز دارد. استثناهای CIDR در این نسخه کاری نمی‌کنند.';

  @override
  String get presetProtectBanking => 'محافظت از بانکداری';

  @override
  String get presetProtectBankingSubtitle =>
      'برنامه‌های بانکی نصب‌شده از TUN رد می‌شوند (هر برنامه در Android)';

  @override
  String get appsSkipVpn => 'برنامه‌هایی که VPN را رد می‌کنند';

  @override
  String get appsSkipVpnEmpty => 'موارد اختیاری فراتر از محافظت بانکداری';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count مورد انتخاب شد · در اتصال بعدی اعمال می‌شود';
  }

  @override
  String get switchToRulesForPresets =>
      'برای استفاده از پیش‌تنظیم‌ها به حالت قوانین بروید.';

  @override
  String get alwaysExcludeMerged =>
      'CIDRهای Always-exclude هنگام اتصال با قوانین IP مستقیم برای هر بک‌اند ادغام می‌شوند. آن‌ها را در پیشرفته پایین ویرایش کنید.';

  @override
  String get alwaysExcludeCidr => 'همیشه مستثنی (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'در هر خط یک IP یا CIDR. در اتصال بعدی اعمال می‌شود.';

  @override
  String get cidrHint => 'در هر خط یک IP یا CIDR\nمثلاً 10.0.0.0/8';

  @override
  String get customRules => 'قوانین سفارشی';

  @override
  String get customRulesHint =>
      'پسوند دامنه، IP یا CIDR → proxy / direct / block. هنگام اتصال روی Xray اعمال می‌شود. IP مستقیم به استثناهای سیستم هم می‌رود.';

  @override
  String get customRulesHintTrustTunnel =>
      'دامنه یا CIDR → proxy (ماندن در تونل) یا direct (استثنا). Block در دسترس نیست. بدون geosite.';

  @override
  String get matcher => 'مطابقت';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'افزودن قانون';

  @override
  String get noCustomRules => 'هنوز قانون سفارشی نیست';

  @override
  String osExclude(String action) {
    return '$action · استثنای سیستم';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · روی TrustTunnel رد می‌شود (بدون block افزونه)';

  @override
  String get enableAdvancedForRouting =>
      'برای کنترل‌های بیشتر مسیریابی، حالت پیشرفته را در تنظیمات روشن کنید.';

  @override
  String get searchApps => 'جستجوی برنامه‌ها';

  @override
  String get save => 'ذخیره';

  @override
  String get routingBannerXray =>
      'پروفایل Xray: سراسری / قوانین / مستقیم و قوانین دامنه هنگام اتصال اعمال می‌شوند.';

  @override
  String get routingBannerHysteria =>
      'پروفایل Hysteria2: قوانین دامنه/block و Direct مربوط به Xray اعمال نمی‌شوند. از سراسری استفاده کنید؛ CIDRهای Always-exclude و IP مستقیم همچنان در TUN ادغام می‌شوند.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: دامنه‌ها/CIDR مستقیم قوانین به استثنا تبدیل می‌شوند. Block رد می‌شود (بدون block افزونه). حالت مستقیم اعمال نمی‌شود. Always-exclude همچنان ادغام می‌شود. تفکیک هر برنامه فقط SOCKS است. Kill Switch در اتصال بعدی TrustTunnel اعمال می‌شود.';

  @override
  String get routingBannerUnknown =>
      'پروفایلی را انتخاب یا وصل کنید تا ببینید کدام ویژگی‌های مسیریابی اعمال می‌شوند.';

  @override
  String get logsEyebrow => 'عیب‌یابی';

  @override
  String get logsTitle => 'گزارش‌ها';

  @override
  String get copyFiltered => 'کپی فیلترشده';

  @override
  String get clear => 'پاک کردن';

  @override
  String get logCopied => 'گزارش کپی شد';

  @override
  String get logsHint =>
      'کنسول هسته. رنگ‌ها تقریبی‌اند (کلیدواژه‌های error/warn).';

  @override
  String get filterHint => 'فیلتر…';

  @override
  String get logsAll => 'همه';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'هنوز خط گزارشی نیست';

  @override
  String get noMatchesForFilter => 'برای فیلتر موردی نیست';

  @override
  String get vpnConsole => 'کنسول VPN';

  @override
  String get logsSheetEmpty => 'هنوز خطی نیست. در انتظار جریان…';

  @override
  String get copy => 'کپی';

  @override
  String get openLogs => 'باز کردن گزارش‌ها';

  @override
  String get tapToRetry => 'برای تلاش دوباره بزنید';

  @override
  String get homeErrorTitle => 'نتوانست وصل شود';

  @override
  String get homeErrorTunnel => 'تونل شکست خورد — برای تلاش دوباره بزنید';

  @override
  String get homeErrorSocks => 'SOCKS محلی شکست خورد — برای تلاش دوباره بزنید';

  @override
  String get activeProfile => 'پروفایل فعال';

  @override
  String get socksInbound => 'SOCKS محلی';

  @override
  String get socksInboundSubtitle =>
      'کاربر و رمز را خالی بگذارید تا هر اتصال اعتبار تصادفی بسازد. برنامه‌های دیگر: 127.0.0.1 به‌علاوه این اعتبارها.';

  @override
  String get socksPort => 'درگاه';

  @override
  String get socksUsername => 'نام کاربری';

  @override
  String get socksPassword => 'رمز';

  @override
  String get saveSocks => 'ذخیره SOCKS';

  @override
  String get socksSaved => 'SOCKS ذخیره شد';

  @override
  String get killSwitchAndroidConfirmTitle => 'Always-on را روشن کردید؟';

  @override
  String get killSwitchAndroidConfirmBody =>
      'برنامه کلیدهای VPN اندروید را عوض نمی‌کند. Kill Switch را اینجا فقط بعد از روشن بودن Always-on و مسدود کردن اتصال بدون VPN برای GoodWin VPN روشن کنید.';

  @override
  String get killSwitchAndroidConfirmYes => 'بله، روشن‌اند';

  @override
  String get killSwitchAndroidConfirmNo => 'هنوز نه';

  @override
  String get killSwitchIosDisconnectFailed =>
      'نتوانست اتصال درخواستی را خاموش کند. قطع ممکن است تا تلاش دوباره پایدار نماند.';

  @override
  String get support => 'پشتیبانی';

  @override
  String get supportSubtitle => 'باز کردن صفحه پشتیبانی اپراتور';

  @override
  String get supportUnavailable => 'در این اشتراک URL پشتیبانی نیست';

  @override
  String get licenses => 'مجوزهای متن‌باز';

  @override
  String get licensesSubtitle => 'هسته‌ها و کتابخانه‌های همراه این برنامه';

  @override
  String get licensesBody =>
      'این برنامه Xray-core، Hysteria 2، hev-socks5-tunnel، TrustTunnel، Flutter و Inter (SIL OFL) را همراه دارد. منبع و مجوزها در مخازن پروژه‌هاست.';

  @override
  String get onboardingSkip => 'رد شدن';

  @override
  String get onboardingNext => 'بعدی';

  @override
  String get onboardingDone => 'شروع';

  @override
  String get onboardingServerTitle => 'سرور شما';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN کلاینتی برای گره‌ای است که وارد می‌کنید. پروکسی ابری Goodwin وجود ندارد. در پروفایل‌ها لینک اشتراک یا URL اشتراک https اضافه کنید.';

  @override
  String get onboardingVpnTitle => 'VPN سیستمی';

  @override
  String get onboardingVpnBody =>
      'اتصال از سیستم می‌خواهد پیکربندی VPN اضافه کند. آن گفتگو از Android یا iOS است، نه از این برنامه. سپس ترافیک به گره پروفایل انتخاب‌شده می‌رود.';

  @override
  String get onboardingCameraTitle => 'دوربین برای QR';

  @override
  String get onboardingCameraBody =>
      'دوربین اختیاری است و فقط QR حاوی لینک اشتراک یا URL اشتراک را اسکن می‌کند. فریم‌ها روی دستگاه می‌مانند.';

  @override
  String get vpnExplainerTitle => 'مجوز VPN سیستمی';

  @override
  String get vpnExplainerBody =>
      'صفحه بعد گفتگوی VPN سیستم است. فقط اگر می‌خواهید این دستگاه ترافیک را از گره واردشده بفرستد اجازه دهید.';

  @override
  String get vpnExplainerContinue => 'ادامه';

  @override
  String get cameraExplainerTitle => 'مجوز دوربین';

  @override
  String get cameraExplainerBody =>
      'صفحه بعد ممکن است دوربین بخواهد. فقط برای اسکن QR پیکربندی است. فریم‌ها آپلود نمی‌شوند.';

  @override
  String get cameraExplainerContinue => 'اسکن QR';

  @override
  String get importLinkHint =>
      'لینک اشتراک یا URL اشتراک https:// را بچسبانید. برنامه خودش پروکسی میزبانی نمی‌کند.';
}
