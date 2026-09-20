// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'होम';

  @override
  String get navProfiles => 'प्रोफ़ाइल';

  @override
  String get navRules => 'नियम';

  @override
  String get navLogs => 'लॉग';

  @override
  String get navSettings => 'सेटिंग';

  @override
  String get connectVpn => 'VPN कनेक्ट करें';

  @override
  String get disconnectVpn => 'VPN डिस्कनेक्ट करें';

  @override
  String get noProfile => 'कोई प्रोफ़ाइल नहीं';

  @override
  String get addProfileToConnect => 'कनेक्ट करने के लिए प्रोफ़ाइल जोड़ें';

  @override
  String get addProfileToConnectHint =>
      'प्रोफ़ाइल पर शेयर लिंक इंपोर्ट करें, फिर यहाँ कनेक्ट टैप करें।';

  @override
  String get addProfile => 'प्रोफ़ाइल जोड़ें';

  @override
  String get networkStatus => 'नेटवर्क स्थिति';

  @override
  String get tapToDisconnect => 'डिस्कनेक्ट करने के लिए टैप करें';

  @override
  String get tapToConnect => 'कनेक्ट करने के लिए टैप करें';

  @override
  String get statNode => 'नोड';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'अपटाइम';

  @override
  String get sessionLogs => 'सत्र लॉग';

  @override
  String get noLinesYet => 'अभी कोई पंक्ति नहीं';

  @override
  String logLinesCount(int count) {
    return '$count पंक्तियाँ';
  }

  @override
  String get uacDeclined => 'UAC प्रॉम्प्ट अस्वीकार किया गया';

  @override
  String get statusOffline => 'डिस्कनेक्टेड';

  @override
  String get statusConnecting => 'कनेक्ट हो रहा है';

  @override
  String get statusConnected => 'कनेक्टेड';

  @override
  String get statusDisconnecting => 'डिस्कनेक्ट हो रहा है';

  @override
  String get statusError => 'त्रुटि';

  @override
  String get switchProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get manageProfiles => 'प्रोफ़ाइल प्रबंधित करें';

  @override
  String get routing => 'रूटिंग';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · नियमों में बदलें';
  }

  @override
  String get routingModeGlobal => 'ग्लोबल';

  @override
  String get routingModeRules => 'नियम';

  @override
  String get routingModeDirect => 'डायरेक्ट';

  @override
  String get homeReadyTitle => 'डिस्कनेक्टेड';

  @override
  String get homeReadyTunnel => 'कनेक्ट इस डिवाइस पर सिस्टम VPN शुरू करता है';

  @override
  String get homeReadySocks =>
      'इस OS पर अभी सिस्टम VPN नहीं है — कनेक्ट एक लोकल SOCKS प्रॉक्सी है';

  @override
  String get homeBusyTitle => 'कनेक्ट हो रहा है';

  @override
  String get homeBusyTunnel => 'OS से VPN टनल माँगा जा रहा है';

  @override
  String get homeBusySocks => 'लोकल SOCKS प्रॉक्सी शुरू हो रही है';

  @override
  String get homeConnectedTunnelTitle => 'सिस्टम VPN';

  @override
  String get homeConnectedTunnelSubtitle =>
      'डिवाइस ट्रैफ़िक टनल से जाता है, आपके होम IP से नहीं';

  @override
  String get homeConnectedSocksTitle => 'लोकल SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      'इस OS पर सिस्टम टनल नहीं है। ऐप्स को 127.0.0.1:10808 इस्तेमाल करना होगा — आपका IP छिपा नहीं है';

  @override
  String get revokedTitle => 'सब्सक्रिप्शन लिंक रद्द कर दिया गया';

  @override
  String get revokedBody =>
      'प्रोफ़ाइल पर नया URL पेस्ट करें। बदले का इंपोर्ट होने तक पुराने नोड रहेंगे।';

  @override
  String get openProfiles => 'प्रोफ़ाइल खोलें';

  @override
  String get elevationTitle => 'एडमिनिस्ट्रेटर अधिकार आवश्यक';

  @override
  String get runAsAdministrator => 'एडमिनिस्ट्रेटर के रूप में चलाएँ';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used उपयोग · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'समाप्त';

  @override
  String quotaDaysLeft(int days) {
    return '$days दिन शेष';
  }

  @override
  String get quotaScopeNote =>
      'VLESS+Hy2 ट्रैफ़िक — TrustTunnel गिना नहीं जाता';

  @override
  String get profilesEyebrow => 'आपका नेटवर्क';

  @override
  String get profilesTitle => 'सर्वर प्रोफ़ाइल';

  @override
  String get tooltipPinging => 'Ping हो रहा है…';

  @override
  String get tooltipCheckPing => 'Ping जाँचें';

  @override
  String get noProfilesToPing => 'Ping के लिए कोई प्रोफ़ाइल नहीं';

  @override
  String get tooltipImportLink => 'लिंक या सब्सक्रिप्शन इंपोर्ट करें';

  @override
  String get searchServersHint => 'सर्वर या प्रोटोकॉल खोजें';

  @override
  String get smartConnect => 'स्मार्ट कनेक्ट';

  @override
  String get smartConnectSubtitle =>
      'होम कनेक्ट मौजूदा सब्सक्रिप्शन में सबसे कम Ping वाले नोड का उपयोग करता है';

  @override
  String get emptyProfiles =>
      'अभी कोई सहेजी प्रोफ़ाइल नहीं।\nशेयर लिंक या https:// सब्सक्रिप्शन URL इंपोर्ट करें।';

  @override
  String get noMatches => 'कोई मेल नहीं';

  @override
  String get pinging => 'Ping हो रहा है';

  @override
  String get fastest => 'सबसे तेज़';

  @override
  String get delete => 'हटाएँ';

  @override
  String get deleteProfileConfirm => 'यह प्रोफ़ाइल हटाएँ?';

  @override
  String get deleteSubscriptionConfirm =>
      'यह सब्सक्रिप्शन और उसके सहेजे नोड हटाएँ?';

  @override
  String updatedSubscription(String name) {
    return '$name अपडेट हुआ';
  }

  @override
  String get importProfile => 'प्रोफ़ाइल इंपोर्ट करें';

  @override
  String get nameOptional => 'नाम (वैकल्पिक)';

  @override
  String get importLinkLabel => 'शेयर लिंक या https:// सब्सक्रिप्शन URL';

  @override
  String get paste => 'पेस्ट';

  @override
  String get scanQr => 'QR स्कैन करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get import => 'इंपोर्ट';

  @override
  String get unrecognizedShareLink => 'अज्ञात शेयर लिंक';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get name => 'नाम';

  @override
  String get shareLink => 'शेयर लिंक';

  @override
  String get apply => 'लागू करें';

  @override
  String get importedManual => 'इंपोर्ट किया गया';

  @override
  String get subscriptionFallback => 'सब्सक्रिप्शन';

  @override
  String get revokedKeepNodes =>
      'लिंक रद्द — नया URL पेस्ट करें। नोड साफ़ नहीं किए गए।';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count नोड';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नोड',
      one: '1 नोड',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'सब्सक्रिप्शन रीफ़्रेश करें';

  @override
  String get removeSubscription => 'सब्सक्रिप्शन हटाएँ';

  @override
  String get nothingToImport => 'इंपोर्ट करने के लिए कुछ नहीं';

  @override
  String get subscriptionImported => 'सब्सक्रिप्शन इंपोर्ट हुआ';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name इंपोर्ट हुआ ($count नोड)';
  }

  @override
  String get profileImported => 'प्रोफ़ाइल इंपोर्ट हुई';

  @override
  String get settingsEyebrow => 'एप्लिकेशन';

  @override
  String get settingsTitle => 'सेटिंग';

  @override
  String get appearance => 'दिखावट';

  @override
  String get colorTheme => 'रंग थीम';

  @override
  String get colorThemeSubtitle =>
      'पेपर लाइट और नेवी डार्क। सिस्टम फ़ोन का अनुसरण करता है।';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get language => 'भाषा';

  @override
  String get languageSubtitle =>
      'अंग्रेज़ी और रूसी। सिस्टम फ़ोन का अनुसरण करता है।';

  @override
  String get localeSystem => 'सिस्टम';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'सामान्य';

  @override
  String get advancedMode => 'एडवांस्ड मोड';

  @override
  String get advancedModeSubtitle => 'लॉग टैब और पावर-यूज़र विकल्प';

  @override
  String get reconnectOnLaunch => 'लॉन्च पर फिर कनेक्ट करें';

  @override
  String get reconnectOnLaunchSubtitle =>
      'OS VPN बंद हो तो पिछली प्रोफ़ाइल शुरू करें';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'सिस्टम';

  @override
  String get dnsCustom => 'कस्टम';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS सर्वर / DoH URL';

  @override
  String get dnsSaved => 'DNS पसंद सहेजी गई';

  @override
  String get saveDns => 'DNS सहेजें';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Android सेटिंग में Always-on VPN। यहाँ का टॉगल अकेले लीक-प्रूफ़ नहीं है।';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'अगले TrustTunnel कनेक्ट पर प्लगइन लीक-लॉक। रीबूट के बाद भी Always-on चाहिए।';

  @override
  String get killSwitchSubtitleIos =>
      'टनल गिरे तो फिर कनेक्ट करता है। Push, Watch और iMessage पहुँच योग्य रहते हैं।';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'इस TrustTunnel सत्र के लिए प्लगइन लीक-लॉक। डिस्कनेक्ट SOCKS VPN शुरू होने से पहले इसे बंद करता है।';

  @override
  String get killSwitchAndroidEnableTitle => 'सिस्टम लीक सुरक्षा चालू करें';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. अगली स्क्रीन पर GoodWin VPN (SOCKS या TrustTunnel) टैप करें।\n2. Always-on VPN चालू करें।\n3. VPN के बिना कनेक्शन ब्लॉक चालू करें।\n4. यहाँ लौटें और कनेक्ट टैप करें।\n\nऐप ये Android स्विच खुद नहीं बदल सकता। TrustTunnel अगले कनेक्ट पर प्लगइन लीक सुरक्षा भी उपयोग करता है।';

  @override
  String get killSwitchAndroidDisableTitle => 'पहले Always-on बंद करें';

  @override
  String get killSwitchAndroidDisableBody =>
      'Android VPN सेटिंग में GoodWin के लिए Always-on VPN और VPN के बिना कनेक्शन ब्लॉक बंद करें। वरना डिस्कनेक्ट टनल वापस लाएगा।';

  @override
  String get killSwitchOpenSettings => 'VPN सेटिंग खोलें';

  @override
  String get killSwitchDisconnectTitle => 'Always-on फिर कनेक्ट कर सकता है';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN डिस्कनेक्ट के बाद टनल वापस ला सकता है। नेटवर्क पूरी तरह खुला चाहिए तो सिस्टम VPN सेटिंग में Always-on बंद करें।';

  @override
  String get killSwitchDisconnectConfirm => 'डिस्कनेक्ट';

  @override
  String get coreTuning => 'कोर ट्यूनिंग';

  @override
  String get advancedDangerTooltip => 'एडवांस्ड — कनेक्टिविटी टूट सकती है';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Vision के साथ नहीं — सामान्य VLESS चालू रहता है';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'REALITY पर नहीं — केवल TLS hello';

  @override
  String get dnsHintWithTuning =>
      'DNS IP कनेक्ट पर OS TUN पर लागू होते हैं। DoH Xray JSON में जाता है; TUN फिर भी बूटस्ट्रैप IP उपयोग करता है। Mux / Fragment: केवल Xray।';

  @override
  String get dnsHintSimple => 'DNS IP कनेक्ट पर OS TUN पर लागू होते हैं।';

  @override
  String get backup => 'बैकअप';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'बैकअप फ़ाइल एक्सपोर्ट करें';

  @override
  String get exportBackupSubtitle =>
      'प्रोफ़ाइल और सब्सक्रिप्शन। वैकल्पिक पासवर्ड फ़ाइल एन्क्रिप्ट करता है';

  @override
  String get importBackup => 'बैकअप फ़ाइल इंपोर्ट करें';

  @override
  String get importBackupSubtitle => 'वर्तमान कैटलॉग में मर्ज होता है';

  @override
  String get copyJsonClipboard => 'क्लिपबोर्ड पर JSON कॉपी करें';

  @override
  String get copyJsonClipboardSubtitle =>
      'अनएन्क्रिप्टेड — क्लिपबोर्ड पढ़ने वाला लिंक देख सकता है';

  @override
  String get copiedEmptyProfiles => 'खाली प्रोफ़ाइल सूची कॉपी हुई';

  @override
  String copiedProfilesJson(int count) {
    return '$count प्रोफ़ाइल अनएन्क्रिप्टेड JSON के रूप में कॉपी हुईं';
  }

  @override
  String get exportBackupTitle => 'बैकअप एक्सपोर्ट करें';

  @override
  String get exportBackupPasswordHint =>
      'सादा JSON फ़ाइल के लिए खाली छोड़ें। पासवर्ड AES-256-GCM उपयोग करता है।';

  @override
  String get backupFileSaved => 'बैकअप फ़ाइल सहेजी गई';

  @override
  String get encryptedBackupSaved => 'एन्क्रिप्टेड बैकअप फ़ाइल सहेजी गई';

  @override
  String get encryptedBackupTitle => 'एन्क्रिप्टेड बैकअप';

  @override
  String get encryptedBackupHint =>
      'एक्सपोर्ट करते समय इस्तेमाल किया पासवर्ड दर्ज करें।';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles प्रोफ़ाइल और $subs सब्सक्रिप्शन इंपोर्ट हुए';
  }

  @override
  String get passwordOptional => 'पासवर्ड (वैकल्पिक)';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get continueAction => 'जारी रखें';

  @override
  String get about => 'परिचय';

  @override
  String get aboutSubtitle => 'आपके अपने सर्वर के लिए VPN क्लाइंट';

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
  String get privacy => 'गोपनीयता';

  @override
  String get privacySubtitle =>
      'कैमरा, VPN, डिवाइस पर सीक्रेट, क्लिपबोर्ड बैकअप';

  @override
  String get privacyWhatTitle => 'यह ऐप क्या उपयोग करता है';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN एक लोकल क्लाइंट है। इस बिल्ड में कोई GoodWin अकाउंट सर्वर और कोई एनालिटिक्स SDK नहीं है।';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'सिस्टम टनल वाले प्लेटफ़ॉर्म पर डिवाइस ट्रैफ़िक आपके इंपोर्ट किए शेयर लिंक के नोड पर भेजा जाता है। ऐप GoodWin प्रॉक्सी नहीं चलाता। यदि इस OS पर सिस्टम टनल नहीं है, तो कनेक्ट केवल 127.0.0.1:10808 पर लोकल SOCKS प्रॉक्सी शुरू करता है।';

  @override
  String get privacySecretsTitle => 'कॉन्फ़िग और सीक्रेट';

  @override
  String get privacySecretsBody =>
      'शेयर लिंक, सहेजी प्रोफ़ाइल और सब्सक्रिप्शन URL इस डिवाइस पर AES-256-GCM से एन्क्रिप्ट करके रखे जाते हैं। एन्क्रिप्शन कुंजी सिफरटेक्स्ट के पास नहीं, OS कीस्टोर / कीचेन में रहती है। यदि प्लेटफ़ॉर्म कीस्टोर उपलब्ध नहीं है, तो ऐप उन मानों को एन्क्रिप्ट नहीं रख सकता।';

  @override
  String get privacyCameraTitle => 'कैमरा';

  @override
  String get privacyCameraBody =>
      'कैमरा केवल उस QR को स्कैन करने के लिए है जिसमें शेयर लिंक या सब्सक्रिप्शन URL हो। फ़्रेम अपलोड नहीं होते।';

  @override
  String get privacyClipboardTitle => 'क्लिपबोर्ड और बैकअप';

  @override
  String get privacyClipboardBody =>
      'क्लिपबोर्ड पर JSON कॉपी अनएन्क्रिप्टेड बैकअप लिखता है। जो क्लिपबोर्ड पढ़ सकता है वह वे लिंक पढ़ सकता है। फ़ाइल एक्सपोर्ट वैकल्पिक पासवर्ड (AES-256-GCM) उपयोग कर सकता है।';

  @override
  String get privacyAppsTitle => 'इंस्टॉल ऐप्स (Android)';

  @override
  String get privacyAppsBody =>
      'प्रति-ऐप स्प्लिट टनलिंग डिवाइस पर लॉन्चर ऐप सूची पढ़ती है ताकि आप ऐप्स को VPN से बाहर कर सकें। वह सूची डिवाइस पर रहती है।';

  @override
  String get privacyOpenWeb => 'गोपनीयता नीति खोलें';

  @override
  String get privacyOpenFailed => 'गोपनीयता नीति URL नहीं खुल सका';

  @override
  String get rulesEyebrow => 'ट्रैफ़िक नीति';

  @override
  String get rulesTitle => 'रूटिंग नियम';

  @override
  String get reset => 'रीसेट';

  @override
  String get resetRulesConfirm => 'रूटिंग डिफ़ॉल्ट पर रीसेट करें?';

  @override
  String get mode => 'मोड';

  @override
  String get modeHintGlobalRich =>
      'सारा मेल खाता ट्रैफ़िक → प्रॉक्सी (Xray डिफ़ॉल्ट)।';

  @override
  String get modeHintGlobalSimple => 'Hysteria2 के लिए अनुशंसित।';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Always-exclude को छोड़कर सारा ट्रैफ़िक टनल से।';

  @override
  String get modeHintRules => 'प्रीसेट + कस्टम नियम; बेमेल → प्रॉक्सी (Xray)।';

  @override
  String get modeHintRulesTrustTunnel =>
      'डायरेक्ट डोमेन/CIDR TrustTunnel बहिष्करण बनते हैं। Block छोड़ दिया जाता है। बेमेल टनल में रहता है।';

  @override
  String get modeHintDirect => 'सब → freedom। TUN चालू रहता है (केवल Xray)।';

  @override
  String get presets => 'प्रीसेट';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'विज्ञापन ब्लॉक (सीमित)';

  @override
  String get presetBlockAdsPack => 'विज्ञापन ब्लॉक';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'छोटी अंतर्निहित होस्ट सूची → block (Xray; geosite नहीं)';

  @override
  String get presetBlockAdsPackXray =>
      'सेवा विज्ञापन पैक → block (geosite नहीं)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'सेवा विज्ञापन पैक → TrustTunnel बहिष्करण (प्लगइन block नहीं)';

  @override
  String get presetBypassLan => 'LAN / निजी बायपास';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / लिंक-लोकल CIDR → TUN बहिष्करण (क्षेत्र/geoip नहीं)';

  @override
  String get presetBypassLanAndroid13 =>
      'LAN बायपास के लिए Android 13+ चाहिए। इस संस्करण पर CIDR बहिष्करण कुछ नहीं करते।';

  @override
  String get presetProtectBanking => 'बैंकिंग सुरक्षित करें';

  @override
  String get presetProtectBankingSubtitle =>
      'इंस्टॉल बैंक ऐप्स TUN छोड़ते हैं (Android प्रति-ऐप)';

  @override
  String get appsSkipVpn => 'ऐप्स जो VPN छोड़ते हैं';

  @override
  String get appsSkipVpnEmpty => 'बैंकिंग सुरक्षा के अलावा वैकल्पिक अतिरिक्त';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count चयनित · अगले कनेक्ट पर लागू';
  }

  @override
  String get switchToRulesForPresets =>
      'प्रीसेट उपयोग के लिए नियम मोड पर जाएँ।';

  @override
  String get alwaysExcludeMerged =>
      'Always-exclude CIDR हर बैकएंड के लिए कनेक्ट पर IP-direct नियमों के साथ मर्ज होते हैं। उन्हें नीचे एडवांस्ड में संपादित करें।';

  @override
  String get alwaysExcludeCidr => 'Always exclude (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'प्रति पंक्ति एक IP या CIDR। अगले कनेक्ट पर लागू।';

  @override
  String get cidrHint => 'प्रति पंक्ति एक IP या CIDR\nउदा. 10.0.0.0/8';

  @override
  String get customRules => 'कस्टम नियम';

  @override
  String get customRulesHint =>
      'डोमेन सफ़िक्स, IP या CIDR → proxy / direct / block। कनेक्ट पर Xray पर लागू। IP direct OS बहिष्करण भी भरता है।';

  @override
  String get customRulesHintTrustTunnel =>
      'डोमेन या CIDR → proxy (टनल में रहें) या direct (बहिष्कृत)। Block उपलब्ध नहीं। कोई geosite नहीं।';

  @override
  String get matcher => 'मैचर';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'नियम जोड़ें';

  @override
  String get noCustomRules => 'अभी कोई कस्टम नियम नहीं';

  @override
  String osExclude(String action) {
    return '$action · OS बहिष्करण';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · TrustTunnel पर छोड़ा गया (प्लगइन block नहीं)';

  @override
  String get enableAdvancedForRouting =>
      'अतिरिक्त रूटिंग नियंत्रण के लिए सेटिंग में एडवांस्ड मोड चालू करें।';

  @override
  String get searchApps => 'ऐप खोजें';

  @override
  String get save => 'सहेजें';

  @override
  String get routingBannerXray =>
      'Xray प्रोफ़ाइल: ग्लोबल / नियम / डायरेक्ट और डोमेन नियम कनेक्ट पर लागू होते हैं।';

  @override
  String get routingBannerHysteria =>
      'Hysteria2 प्रोफ़ाइल: डोमेन/block नियम और Xray डायरेक्ट लागू नहीं होते। ग्लोबल उपयोग करें; Always-exclude CIDR और IP-direct फिर भी TUN में मर्ज होते हैं।';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: नियमों के डायरेक्ट डोमेन/CIDR बहिष्करण बनते हैं। Block छोड़ा जाता है (प्लगइन block नहीं)। डायरेक्ट मोड लागू नहीं होता। Always-exclude फिर भी मर्ज होता है। प्रति-ऐप स्प्लिट केवल SOCKS है। Kill Switch अगले TrustTunnel कनेक्ट पर लागू होता है।';

  @override
  String get routingBannerUnknown =>
      'कौन से रूटिंग फ़ीचर लागू होते हैं, यह देखने के लिए प्रोफ़ाइल चुनें या कनेक्ट करें।';

  @override
  String get logsEyebrow => 'निदान';

  @override
  String get logsTitle => 'लॉग';

  @override
  String get copyFiltered => 'फ़िल्टर किया कॉपी करें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get logCopied => 'लॉग कॉपी हुआ';

  @override
  String get logsHint => 'कोर कंसोल। रंग अनुमानित हैं (error/warn कीवर्ड)।';

  @override
  String get filterHint => 'फ़िल्टर…';

  @override
  String get logsAll => 'सभी';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'त्रुटि';

  @override
  String get noLogLinesYet => 'अभी कोई लॉग पंक्ति नहीं';

  @override
  String get noMatchesForFilter => 'फ़िल्टर से कोई मेल नहीं';

  @override
  String get vpnConsole => 'VPN कंसोल';

  @override
  String get logsSheetEmpty => 'अभी कोई पंक्ति नहीं। स्ट्रीम की प्रतीक्षा…';

  @override
  String get copy => 'कॉपी';

  @override
  String get openLogs => 'लॉग खोलें';

  @override
  String get tapToRetry => 'फिर कोशिश के लिए टैप करें';

  @override
  String get homeErrorTitle => 'कनेक्ट नहीं हो सका';

  @override
  String get homeErrorTunnel => 'टनल विफल — फिर कोशिश के लिए टैप करें';

  @override
  String get homeErrorSocks => 'लोकल SOCKS विफल — फिर कोशिश के लिए टैप करें';

  @override
  String get activeProfile => 'सक्रिय प्रोफ़ाइल';

  @override
  String get socksInbound => 'लोकल SOCKS';

  @override
  String get socksInboundSubtitle =>
      'प्रत्येक कनेक्ट पर यादृच्छिक क्रेडेंशियल बनाने के लिए उपयोगकर्ता और पासवर्ड खाली छोड़ें। अन्य ऐप्स: 127.0.0.1 और ये क्रेडेंशियल।';

  @override
  String get socksPort => 'पोर्ट';

  @override
  String get socksUsername => 'उपयोगकर्ता नाम';

  @override
  String get socksPassword => 'पासवर्ड';

  @override
  String get saveSocks => 'SOCKS सहेजें';

  @override
  String get socksSaved => 'SOCKS सहेजा गया';

  @override
  String get killSwitchAndroidConfirmTitle => 'क्या आपने Always-on चालू किया?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'ऐप Android VPN स्विच नहीं बदल सकता। GoodWin VPN के लिए Always-on और VPN के बिना कनेक्शन ब्लॉक चालू होने के बाद ही यहाँ Kill Switch चालू करें।';

  @override
  String get killSwitchAndroidConfirmYes => 'हाँ, वे चालू हैं';

  @override
  String get killSwitchAndroidConfirmNo => 'अभी नहीं';

  @override
  String get killSwitchIosDisconnectFailed =>
      'ऑन-डिमांड बंद नहीं हो सका। फिर कोशिश तक डिस्कनेक्ट टिक नहीं सकता।';

  @override
  String get support => 'सहायता';

  @override
  String get supportSubtitle => 'ऑपरेटर सहायता पृष्ठ खोलें';

  @override
  String get supportUnavailable => 'इस सब्सक्रिप्शन में कोई सहायता URL नहीं';

  @override
  String get licenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get licensesSubtitle => 'इस ऐप में बंडल कोर और लाइब्रेरी';

  @override
  String get licensesBody =>
      'यह ऐप Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter और Inter (SIL OFL) बंडल करता है। स्रोत और लाइसेंस प्रोजेक्ट रिपॉज़िटरी में हैं।';

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingNext => 'आगे';

  @override
  String get onboardingDone => 'शुरू करें';

  @override
  String get onboardingServerTitle => 'आपका सर्वर';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN आपके इंपोर्ट किए नोड का क्लाइंट है। कोई GoodWin क्लाउड प्रॉक्सी नहीं है। प्रोफ़ाइल पर शेयर लिंक या https सब्सक्रिप्शन URL जोड़ें।';

  @override
  String get onboardingVpnTitle => 'सिस्टम VPN';

  @override
  String get onboardingVpnBody =>
      'कनेक्ट OS से VPN कॉन्फ़िगरेशन जोड़ने को कहता है। वह डायलॉग Android या iOS का है, इस ऐप का नहीं। फिर ट्रैफ़िक आपके चुने प्रोफ़ाइल के नोड पर जाता है।';

  @override
  String get onboardingCameraTitle => 'QR के लिए कैमरा';

  @override
  String get onboardingCameraBody =>
      'कैमरा वैकल्पिक है और केवल शेयर लिंक या सब्सक्रिप्शन URL वाले QR को स्कैन करता है। फ़्रेम डिवाइस पर रहते हैं।';

  @override
  String get vpnExplainerTitle => 'सिस्टम VPN अनुमति';

  @override
  String get vpnExplainerBody =>
      'अगली स्क्रीन OS VPN डायलॉग है। तभी अनुमति दें जब आप चाहें कि यह डिवाइस इंपोर्ट किए नोड से ट्रैफ़िक भेजे।';

  @override
  String get vpnExplainerContinue => 'जारी रखें';

  @override
  String get cameraExplainerTitle => 'कैमरा अनुमति';

  @override
  String get cameraExplainerBody =>
      'अगली स्क्रीन कैमरा माँग सकती है। यह केवल कॉन्फ़िगरेशन QR स्कैन के लिए है। फ़्रेम अपलोड नहीं होते।';

  @override
  String get cameraExplainerContinue => 'QR स्कैन करें';

  @override
  String get importLinkHint =>
      'शेयर लिंक या https:// सब्सक्रिप्शन URL पेस्ट करें। ऐप प्रॉक्सी होस्ट नहीं करता।';
}
