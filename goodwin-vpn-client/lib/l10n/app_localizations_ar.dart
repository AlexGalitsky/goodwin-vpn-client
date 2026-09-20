// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navProfiles => 'الملفات';

  @override
  String get navRules => 'القواعد';

  @override
  String get navLogs => 'السجلات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get connectVpn => 'اتصال VPN';

  @override
  String get disconnectVpn => 'قطع VPN';

  @override
  String get noProfile => 'لا يوجد ملف';

  @override
  String get addProfileToConnect => 'أضف ملفًا للاتصال';

  @override
  String get addProfileToConnectHint =>
      'استورد رابط مشاركة من الملفات، ثم اضغط اتصال هنا.';

  @override
  String get addProfile => 'إضافة ملف';

  @override
  String get networkStatus => 'حالة الشبكة';

  @override
  String get tapToDisconnect => 'اضغط للقطع';

  @override
  String get tapToConnect => 'اضغط للاتصال';

  @override
  String get statNode => 'العقدة';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'مدة التشغيل';

  @override
  String get sessionLogs => 'سجلات الجلسة';

  @override
  String get noLinesYet => 'لا توجد أسطر بعد';

  @override
  String logLinesCount(int count) {
    return '$count أسطر';
  }

  @override
  String get uacDeclined => 'تم رفض طلب UAC';

  @override
  String get statusOffline => 'غير متصل';

  @override
  String get statusConnecting => 'جارٍ الاتصال';

  @override
  String get statusConnected => 'متصل';

  @override
  String get statusDisconnecting => 'جارٍ القطع';

  @override
  String get statusError => 'خطأ';

  @override
  String get switchProfile => 'تبديل الملف';

  @override
  String get manageProfiles => 'إدارة الملفات';

  @override
  String get routing => 'التوجيه';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · غيّر في القواعد';
  }

  @override
  String get routingModeGlobal => 'عام';

  @override
  String get routingModeRules => 'القواعد';

  @override
  String get routingModeDirect => 'مباشر';

  @override
  String get homeReadyTitle => 'غير متصل';

  @override
  String get homeReadyTunnel => 'الاتصال يشغّل VPN نظاميًا على هذا الجهاز';

  @override
  String get homeReadySocks =>
      'لا يوجد VPN نظامي على هذا النظام بعد — الاتصال وكيل SOCKS محلي';

  @override
  String get homeBusyTitle => 'جارٍ الاتصال';

  @override
  String get homeBusyTunnel => 'يُطلب من النظام نفق VPN';

  @override
  String get homeBusySocks => 'جارٍ تشغيل وكيل SOCKS محلي';

  @override
  String get homeConnectedTunnelTitle => 'VPN النظام';

  @override
  String get homeConnectedTunnelSubtitle =>
      'يمرّر حركة الجهاز عبر النفق، وليس عبر عنوان IP المنزلي';

  @override
  String get homeConnectedSocksTitle => 'SOCKS محلي';

  @override
  String get homeConnectedSocksSubtitle =>
      'لا يوجد نفق نظامي على هذا النظام. يجب أن تستخدم التطبيقات 127.0.0.1:10808 — عنوان IP غير مخفي';

  @override
  String get revokedTitle => 'تم إلغاء رابط الاشتراك';

  @override
  String get revokedBody =>
      'الصق عنوان URL جديدًا في الملفات. تبقى العقد القديمة حتى تستورد بديلًا.';

  @override
  String get openProfiles => 'فتح الملفات';

  @override
  String get elevationTitle => 'مطلوبة صلاحيات المسؤول';

  @override
  String get runAsAdministrator => 'تشغيل كمسؤول';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return 'استُخدم $used · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'منتهٍ';

  @override
  String quotaDaysLeft(int days) {
    return 'متبقٍ $daysي';
  }

  @override
  String get quotaScopeNote => 'حركة VLESS+Hy2 — TrustTunnel غير محسوب';

  @override
  String get profilesEyebrow => 'شبكتك';

  @override
  String get profilesTitle => 'ملفات الخوادم';

  @override
  String get tooltipPinging => 'جارٍ Ping…';

  @override
  String get tooltipCheckPing => 'فحص Ping';

  @override
  String get noProfilesToPing => 'لا توجد ملفات لـ Ping';

  @override
  String get tooltipImportLink => 'استيراد رابط أو اشتراك';

  @override
  String get searchServersHint => 'البحث عن خوادم أو بروتوكولات';

  @override
  String get smartConnect => 'اتصال ذكي';

  @override
  String get smartConnectSubtitle =>
      'اتصال الصفحة الرئيسية يستخدم العقدة ذات أقل Ping في الاشتراك الحالي';

  @override
  String get emptyProfiles =>
      'لا توجد ملفات محفوظة بعد.\nاستورد رابط مشاركة أو عنوان URL للاشتراك https://.';

  @override
  String get noMatches => 'لا توجد نتائج';

  @override
  String get pinging => 'جارٍ Ping';

  @override
  String get fastest => 'الأسرع';

  @override
  String get delete => 'حذف';

  @override
  String get deleteProfileConfirm => 'حذف هذا الملف؟';

  @override
  String get deleteSubscriptionConfirm => 'إزالة هذا الاشتراك وعقده المحفوظة؟';

  @override
  String updatedSubscription(String name) {
    return 'تم تحديث $name';
  }

  @override
  String get importProfile => 'استيراد ملف';

  @override
  String get nameOptional => 'الاسم (اختياري)';

  @override
  String get importLinkLabel => 'رابط مشاركة أو عنوان URL للاشتراك https://';

  @override
  String get paste => 'لصق';

  @override
  String get scanQr => 'مسح رمز QR';

  @override
  String get cancel => 'إلغاء';

  @override
  String get import => 'استيراد';

  @override
  String get unrecognizedShareLink => 'رابط مشاركة غير معروف';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get name => 'الاسم';

  @override
  String get shareLink => 'رابط المشاركة';

  @override
  String get apply => 'تطبيق';

  @override
  String get importedManual => 'مستورد';

  @override
  String get subscriptionFallback => 'اشتراك';

  @override
  String get revokedKeepNodes =>
      'أُلغي الرابط — الصق عنوان URL جديدًا. لم تُمسح العقد.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count عقد';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عقد',
      one: 'عقدة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'تحديث الاشتراك';

  @override
  String get removeSubscription => 'إزالة الاشتراك';

  @override
  String get nothingToImport => 'لا شيء للاستيراد';

  @override
  String get subscriptionImported => 'تم استيراد الاشتراك';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return 'تم استيراد $name ($count عقد)';
  }

  @override
  String get profileImported => 'تم استيراد الملف';

  @override
  String get settingsEyebrow => 'التطبيق';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get colorTheme => 'سمة الألوان';

  @override
  String get colorThemeSubtitle => 'ورق فاتح وكحلي داكن. النظام يتبع الهاتف.';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get language => 'اللغة';

  @override
  String get languageSubtitle => 'الإنجليزية والروسية. النظام يتبع الهاتف.';

  @override
  String get localeSystem => 'النظام';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'عام';

  @override
  String get advancedMode => 'الوضع المتقدم';

  @override
  String get advancedModeSubtitle =>
      'تبويب السجلات وخيارات للمستخدمين المتقدمين';

  @override
  String get reconnectOnLaunch => 'إعادة الاتصال عند التشغيل';

  @override
  String get reconnectOnLaunchSubtitle =>
      'تشغيل آخر ملف إذا كان VPN النظام متوقفًا';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'النظام';

  @override
  String get dnsCustom => 'مخصص';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'خادم DNS / عنوان DoH';

  @override
  String get dnsSaved => 'تم حفظ تفضيل DNS';

  @override
  String get saveDns => 'حفظ DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Always-on VPN في إعدادات Android. المفتاح هنا وحده لا يمنع التسريب بالكامل.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'قفل تسريب الإضافة عند اتصال TrustTunnel التالي. ما زال Always-on مطلوبًا بعد إعادة التشغيل.';

  @override
  String get killSwitchSubtitleIos =>
      'يعيد الاتصال إذا سقط النفق. تبقى الإشعارات وWatch وiMessage قابلة للوصول.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'قفل تسريب الإضافة لهذه جلسة TrustTunnel. القطع يعطّله قبل أن يبدأ SOCKS VPN.';

  @override
  String get killSwitchAndroidEnableTitle => 'تشغيل حماية النظام من التسريب';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. في الشاشة التالية، اضغط Goodwin VPN (SOCKS أو TrustTunnel).\n2. شغّل Always-on VPN.\n3. شغّل حظر الاتصالات بدون VPN.\n4. عد إلى هنا واضغط اتصال.\n\nلا يستطيع التطبيق تبديل مفاتيح Android هذه بنفسه. يستخدم TrustTunnel أيضًا حماية تسريب الإضافة عند الاتصال التالي.';

  @override
  String get killSwitchAndroidDisableTitle => 'أوقف Always-on أولًا';

  @override
  String get killSwitchAndroidDisableBody =>
      'في إعدادات VPN في Android، أوقف Always-on VPN وحظر الاتصالات بدون VPN لـ Goodwin. وإلا سيعيد القطع النفق.';

  @override
  String get killSwitchOpenSettings => 'فتح إعدادات VPN';

  @override
  String get killSwitchDisconnectTitle => 'قد يعيد Always-on الاتصال';

  @override
  String get killSwitchDisconnectBody =>
      'قد يعيد Android Always-on VPN النفق بعد القطع. أوقف Always-on في إعدادات VPN النظام إذا أردت شبكة مفتوحة بالكامل.';

  @override
  String get killSwitchDisconnectConfirm => 'قطع';

  @override
  String get coreTuning => 'ضبط النواة';

  @override
  String get advancedDangerTooltip => 'متقدم — قد يقطع الاتصال';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'لا يُستخدم مع Vision — يظل VLESS المعتاد يعمل';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'لا يُستخدم مع REALITY — TLS hello فقط';

  @override
  String get dnsHintWithTuning =>
      'تُطبَّق عناوين DNS على TUN النظام عند الاتصال. يدخل DoH في JSON الخاص بـ Xray؛ وما زال TUN يستخدم عناوين التمهيد. Mux / Fragment: Xray فقط.';

  @override
  String get dnsHintSimple => 'تُطبَّق عناوين DNS على TUN النظام عند الاتصال.';

  @override
  String get backup => 'نسخة احتياطية';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'تصدير ملف النسخة';

  @override
  String get exportBackupSubtitle =>
      'الملفات والاشتراكات. كلمة مرور اختيارية تشفّر الملف';

  @override
  String get importBackup => 'استيراد ملف النسخة';

  @override
  String get importBackupSubtitle => 'يُدمج في الكتالوج الحالي';

  @override
  String get copyJsonClipboard => 'نسخ JSON إلى الحافظة';

  @override
  String get copyJsonClipboardSubtitle =>
      'غير مشفّر — من يقرأ الحافظة يرى الروابط';

  @override
  String get copiedEmptyProfiles => 'تم نسخ قائمة ملفات فارغة';

  @override
  String copiedProfilesJson(int count) {
    return 'تم نسخ $count ملفًا كـ JSON غير مشفّر';
  }

  @override
  String get exportBackupTitle => 'تصدير النسخة';

  @override
  String get exportBackupPasswordHint =>
      'اتركه فارغًا لملف JSON عادي. كلمة المرور تستخدم AES-256-GCM.';

  @override
  String get backupFileSaved => 'تم حفظ ملف النسخة';

  @override
  String get encryptedBackupSaved => 'تم حفظ ملف النسخة المشفّر';

  @override
  String get encryptedBackupTitle => 'نسخة مشفّرة';

  @override
  String get encryptedBackupHint => 'أدخل كلمة المرور المستخدمة عند التصدير.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return 'تم استيراد $profiles ملفًا و$subs اشتراكًا';
  }

  @override
  String get passwordOptional => 'كلمة المرور (اختياري)';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get continueAction => 'متابعة';

  @override
  String get about => 'حول';

  @override
  String get aboutSubtitle => 'عميل VPN لخادمك الخاص';

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
  String get privacy => 'الخصوصية';

  @override
  String get privacySubtitle =>
      'الكاميرا، VPN، الأسرار على الجهاز، نسخ الحافظة';

  @override
  String get privacyWhatTitle => 'ما يستخدمه هذا التطبيق';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN عميل محلي. لا يوجد خادم حسابات Goodwin ولا عدة تحليلات في هذا الإصدار.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'على المنصات ذات النفق النظامي تُرسل حركة الجهاز إلى العقدة في رابط المشاركة الذي استوردته. لا يشغّل التطبيق وكيل Goodwin. إذا لم يكن لهذا النظام نفق، يشغّل الاتصال وكيل SOCKS محليًا فقط على 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'الإعدادات والأسرار';

  @override
  String get privacySecretsBody =>
      'تُخزَّن روابط المشاركة والملفات المحفوظة وعناوين الاشتراك على هذا الجهاز، مشفّرة بـ AES-256-GCM. مفتاح التشفير في keystore / keychain للنظام، وليس بجانب النص المشفّر. إذا كان مخزن المفاتيح غير متاح، لا يستطيع التطبيق حفظ هذه القيم مشفّرة.';

  @override
  String get privacyCameraTitle => 'الكاميرا';

  @override
  String get privacyCameraBody =>
      'تُستخدم الكاميرا فقط لمسح رمز QR يحتوي على رابط مشاركة أو عنوان اشتراك. لا تُرفع الإطارات.';

  @override
  String get privacyClipboardTitle => 'الحافظة والنسخ الاحتياطي';

  @override
  String get privacyClipboardBody =>
      'نسخ JSON إلى الحافظة يكتب نسخة غير مشفّرة. من يستطيع قراءة الحافظة يرى تلك الروابط. تصدير الملف يمكن أن يستخدم كلمة مرور اختيارية (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'التطبيقات المثبّتة (Android)';

  @override
  String get privacyAppsBody =>
      'تقسيم النفق حسب التطبيق يقرأ قائمة تطبيقات المشغّل على الجهاز حتى تستبعد تطبيقات من VPN. تبقى القائمة على الجهاز.';

  @override
  String get privacyOpenWeb => 'فتح سياسة الخصوصية';

  @override
  String get privacyOpenFailed => 'تعذّر فتح عنوان سياسة الخصوصية';

  @override
  String get rulesEyebrow => 'سياسة الحركة';

  @override
  String get rulesTitle => 'قواعد التوجيه';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get resetRulesConfirm => 'إعادة التوجيه إلى الافتراضي؟';

  @override
  String get mode => 'الوضع';

  @override
  String get modeHintGlobalRich => 'كل الحركة المطابقة → وكيل (افتراضي Xray).';

  @override
  String get modeHintGlobalSimple => 'موصى به لـ Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'كل الحركة عبر النفق باستثناء Always-exclude.';

  @override
  String get modeHintRules =>
      'إعدادات مسبقة + قواعد مخصصة؛ غير المطابق → وكيل (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'النطاقات/CIDR المباشرة تصبح استثناءات TrustTunnel. يُتخطى Block. غير المطابق يبقى في النفق.';

  @override
  String get modeHintDirect => 'الكل → freedom. يبقى TUN شغّالًا (Xray فقط).';

  @override
  String get presets => 'إعدادات مسبقة';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'حظر الإعلانات (محدود)';

  @override
  String get presetBlockAdsPack => 'حظر الإعلانات';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'قائمة مضيفين مدمجة صغيرة → block (Xray؛ ليست geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'حزمة إعلانات الخدمة → block (ليست geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'حزمة إعلانات الخدمة → استثناءات TrustTunnel (لا يوجد block في الإضافة)';

  @override
  String get presetBypassLan => 'تجاوز الشبكة المحلية / الخاصة';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / CIDR محلية الارتباط → استثناءات TUN (ليست منطقة/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'تجاوز الشبكة المحلية يحتاج Android 13+. استثناءات CIDR لا تفعل شيئًا في هذا الإصدار.';

  @override
  String get presetProtectBanking => 'حماية التطبيقات المصرفية';

  @override
  String get presetProtectBankingSubtitle =>
      'تطبيقات البنوك المثبّتة تتجاوز TUN (حسب التطبيق على Android)';

  @override
  String get appsSkipVpn => 'تطبيقات تتجاوز VPN';

  @override
  String get appsSkipVpnEmpty => 'إضافات اختيارية بعد حماية المصرفية';

  @override
  String appsSkipVpnSelected(int count) {
    return 'تم اختيار $count · يُطبَّق عند الاتصال التالي';
  }

  @override
  String get switchToRulesForPresets =>
      'بدّل إلى وضع القواعد لاستخدام الإعدادات المسبقة.';

  @override
  String get alwaysExcludeMerged =>
      'تُدمج CIDR الخاصة بـ Always-exclude مع قواعد IP المباشرة عند الاتصال لكل خلفية. حرّرها في المتقدم أدناه.';

  @override
  String get alwaysExcludeCidr => 'استبعاد دائم (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'عنوان IP أو CIDR واحد في كل سطر. يُطبَّق عند الاتصال التالي.';

  @override
  String get cidrHint => 'عنوان IP أو CIDR واحد في كل سطر\nمثل 10.0.0.0/8';

  @override
  String get customRules => 'قواعد مخصصة';

  @override
  String get customRulesHint =>
      'لاحقة نطاق أو IP أو CIDR → proxy / direct / block. تُطبَّق على Xray عند الاتصال. IP المباشر يغذي أيضًا استثناءات النظام.';

  @override
  String get customRulesHintTrustTunnel =>
      'نطاق أو CIDR → proxy (البقاء في النفق) أو direct (استبعاد). Block غير متاح. بلا geosite.';

  @override
  String get matcher => 'المطابق';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'إضافة قاعدة';

  @override
  String get noCustomRules => 'لا توجد قواعد مخصصة بعد';

  @override
  String osExclude(String action) {
    return '$action · استثناء النظام';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · يُتخطى على TrustTunnel (لا يوجد block في الإضافة)';

  @override
  String get enableAdvancedForRouting =>
      'فعّل الوضع المتقدم في الإعدادات لمزيد من عناصر التوجيه.';

  @override
  String get searchApps => 'البحث في التطبيقات';

  @override
  String get save => 'حفظ';

  @override
  String get routingBannerXray =>
      'ملف Xray: تُطبَّق الأوضاع العام / القواعد / المباشر وقواعد النطاق عند الاتصال.';

  @override
  String get routingBannerHysteria =>
      'ملف Hysteria2: لا تُطبَّق قواعد النطاق/block ولا Direct في Xray. استخدم العام؛ ما زالت CIDR الخاصة بـ Always-exclude وIP المباشر تُدمج في TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: نطاقات/CIDR المباشرة في القواعد تصبح استثناءات. يُتخطى Block (لا يوجد block في الإضافة). لا يُطبَّق وضع المباشر. ما زال Always-exclude يُدمج. التقسيم حسب التطبيق لـ SOCKS فقط. يُطبَّق Kill Switch عند اتصال TrustTunnel التالي.';

  @override
  String get routingBannerUnknown =>
      'اختر ملفًا أو اتصل به لمعرفة ميزات التوجيه المتاحة.';

  @override
  String get logsEyebrow => 'التشخيص';

  @override
  String get logsTitle => 'السجلات';

  @override
  String get copyFiltered => 'نسخ المصفّى';

  @override
  String get clear => 'مسح';

  @override
  String get logCopied => 'تم نسخ السجل';

  @override
  String get logsHint =>
      'وحدة تحكم النواة. الألوان تقريبية (كلمات error/warn).';

  @override
  String get filterHint => 'تصفية…';

  @override
  String get logsAll => 'الكل';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'لا توجد أسطر سجل بعد';

  @override
  String get noMatchesForFilter => 'لا توجد نتائج للتصفية';

  @override
  String get vpnConsole => 'وحدة تحكم VPN';

  @override
  String get logsSheetEmpty => 'لا توجد أسطر بعد. بانتظار التدفق…';

  @override
  String get copy => 'نسخ';

  @override
  String get openLogs => 'فتح السجلات';

  @override
  String get tapToRetry => 'اضغط لإعادة المحاولة';

  @override
  String get homeErrorTitle => 'تعذّر الاتصال';

  @override
  String get homeErrorTunnel => 'فشل النفق — اضغط لإعادة المحاولة';

  @override
  String get homeErrorSocks => 'فشل SOCKS المحلي — اضغط لإعادة المحاولة';

  @override
  String get activeProfile => 'الملف النشط';

  @override
  String get socksInbound => 'SOCKS محلي';

  @override
  String get socksInboundSubtitle =>
      'اترك المستخدم وكلمة المرور فارغين لتوليد بيانات عشوائية في كل اتصال. التطبيقات الأخرى: 127.0.0.1 مع هذه البيانات.';

  @override
  String get socksPort => 'المنفذ';

  @override
  String get socksUsername => 'اسم المستخدم';

  @override
  String get socksPassword => 'كلمة المرور';

  @override
  String get saveSocks => 'حفظ SOCKS';

  @override
  String get socksSaved => 'تم حفظ SOCKS';

  @override
  String get killSwitchAndroidConfirmTitle => 'هل شغّلت Always-on؟';

  @override
  String get killSwitchAndroidConfirmBody =>
      'لا يستطيع التطبيق تبديل مفاتيح VPN في Android. شغّل Kill Switch هنا فقط بعد تفعيل Always-on وحظر الاتصالات بدون VPN لـ GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'نعم، هما مفعّلان';

  @override
  String get killSwitchAndroidConfirmNo => 'ليس بعد';

  @override
  String get killSwitchIosDisconnectFailed =>
      'تعذّر إيقاف الاتصال عند الطلب. قد لا يثبت القطع حتى تعيد المحاولة.';

  @override
  String get support => 'الدعم';

  @override
  String get supportSubtitle => 'فتح صفحة دعم المشغّل';

  @override
  String get supportUnavailable => 'لا يوجد عنوان دعم في هذا الاشتراك';

  @override
  String get licenses => 'تراخيص مفتوحة المصدر';

  @override
  String get licensesSubtitle => 'النوى والمكتبات المضمّنة في هذا التطبيق';

  @override
  String get licensesBody =>
      'يضم هذا التطبيق Xray-core وHysteria 2 وhev-socks5-tunnel وTrustTunnel وFlutter وInter (SIL OFL). المصدر والتراخيص في مستودعات المشاريع.';

  @override
  String get onboardingSkip => 'تخطٍ';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingDone => 'ابدأ';

  @override
  String get onboardingServerTitle => 'خادمك';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN عميل لعقدة تستوردها. لا يوجد وكيل سحابي من Goodwin. أضف رابط مشاركة أو عنوان اشتراك https في الملفات.';

  @override
  String get onboardingVpnTitle => 'VPN النظام';

  @override
  String get onboardingVpnBody =>
      'يطلب الاتصال من النظام إضافة إعداد VPN. هذا الحوار من Android أو iOS وليس من هذا التطبيق. ثم تذهب الحركة إلى العقدة في الملف الذي اخترته.';

  @override
  String get onboardingCameraTitle => 'الكاميرا لرمز QR';

  @override
  String get onboardingCameraBody =>
      'الكاميرا اختيارية وتمسح فقط رمز QR برابط مشاركة أو عنوان اشتراك. تبقى الإطارات على الجهاز.';

  @override
  String get vpnExplainerTitle => 'إذن VPN النظام';

  @override
  String get vpnExplainerBody =>
      'الشاشة التالية هي حوار VPN للنظام. اسمح به فقط إذا أردت أن يرسل هذا الجهاز الحركة عبر العقدة المستوردة.';

  @override
  String get vpnExplainerContinue => 'متابعة';

  @override
  String get cameraExplainerTitle => 'إذن الكاميرا';

  @override
  String get cameraExplainerBody =>
      'قد تطلب الشاشة التالية الكاميرا. تُستخدم فقط لمسح رمز QR للإعداد. لا تُرفع الإطارات.';

  @override
  String get cameraExplainerContinue => 'مسح رمز QR';

  @override
  String get importLinkHint =>
      'الصق رابط مشاركة أو عنوان اشتراك https://. التطبيق لا يستضيف وكيلًا.';
}
