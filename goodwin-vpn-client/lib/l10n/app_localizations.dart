import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GoodWin VPN'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProfiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get navProfiles;

  /// No description provided for @navRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get navRules;

  /// No description provided for @navLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get navLogs;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @connectVpn.
  ///
  /// In en, this message translates to:
  /// **'Connect VPN'**
  String get connectVpn;

  /// No description provided for @disconnectVpn.
  ///
  /// In en, this message translates to:
  /// **'Disconnect VPN'**
  String get disconnectVpn;

  /// No description provided for @noProfile.
  ///
  /// In en, this message translates to:
  /// **'No profile'**
  String get noProfile;

  /// No description provided for @addProfileToConnect.
  ///
  /// In en, this message translates to:
  /// **'Add a profile to connect'**
  String get addProfileToConnect;

  /// No description provided for @addProfileToConnectHint.
  ///
  /// In en, this message translates to:
  /// **'Import a share link on Profiles, then tap Connect here.'**
  String get addProfileToConnectHint;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add profile'**
  String get addProfile;

  /// No description provided for @networkStatus.
  ///
  /// In en, this message translates to:
  /// **'NETWORK STATUS'**
  String get networkStatus;

  /// No description provided for @tapToDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Tap to disconnect'**
  String get tapToDisconnect;

  /// No description provided for @tapToConnect.
  ///
  /// In en, this message translates to:
  /// **'Tap to connect'**
  String get tapToConnect;

  /// No description provided for @statNode.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get statNode;

  /// No description provided for @statPing.
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get statPing;

  /// No description provided for @statUptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get statUptime;

  /// No description provided for @sessionLogs.
  ///
  /// In en, this message translates to:
  /// **'Session logs'**
  String get sessionLogs;

  /// No description provided for @noLinesYet.
  ///
  /// In en, this message translates to:
  /// **'No lines yet'**
  String get noLinesYet;

  /// No description provided for @logLinesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lines'**
  String logLinesCount(int count);

  /// No description provided for @uacDeclined.
  ///
  /// In en, this message translates to:
  /// **'UAC prompt was declined'**
  String get uacDeclined;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'disconnected'**
  String get statusOffline;

  /// No description provided for @statusConnecting.
  ///
  /// In en, this message translates to:
  /// **'connecting'**
  String get statusConnecting;

  /// No description provided for @statusConnected.
  ///
  /// In en, this message translates to:
  /// **'connected'**
  String get statusConnected;

  /// No description provided for @statusDisconnecting.
  ///
  /// In en, this message translates to:
  /// **'disconnecting'**
  String get statusDisconnecting;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get statusError;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch profile'**
  String get switchProfile;

  /// No description provided for @manageProfiles.
  ///
  /// In en, this message translates to:
  /// **'Manage profiles'**
  String get manageProfiles;

  /// No description provided for @routing.
  ///
  /// In en, this message translates to:
  /// **'Routing'**
  String get routing;

  /// No description provided for @routingChipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{mode} · change in Rules'**
  String routingChipSubtitle(String mode);

  /// No description provided for @routingModeGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get routingModeGlobal;

  /// No description provided for @routingModeRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get routingModeRules;

  /// No description provided for @routingModeDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get routingModeDirect;

  /// No description provided for @homeReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get homeReadyTitle;

  /// No description provided for @homeReadyTunnel.
  ///
  /// In en, this message translates to:
  /// **'Connect starts a system VPN on this device'**
  String get homeReadyTunnel;

  /// No description provided for @homeReadySocks.
  ///
  /// In en, this message translates to:
  /// **'This OS has no system VPN yet — Connect is a local SOCKS proxy'**
  String get homeReadySocks;

  /// No description provided for @homeBusyTitle.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get homeBusyTitle;

  /// No description provided for @homeBusyTunnel.
  ///
  /// In en, this message translates to:
  /// **'Asking the OS for a VPN tunnel'**
  String get homeBusyTunnel;

  /// No description provided for @homeBusySocks.
  ///
  /// In en, this message translates to:
  /// **'Starting a local SOCKS proxy'**
  String get homeBusySocks;

  /// No description provided for @homeConnectedTunnelTitle.
  ///
  /// In en, this message translates to:
  /// **'System VPN'**
  String get homeConnectedTunnelTitle;

  /// No description provided for @homeConnectedTunnelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Device traffic goes through the tunnel, not your home IP'**
  String get homeConnectedTunnelSubtitle;

  /// No description provided for @homeConnectedSocksTitle.
  ///
  /// In en, this message translates to:
  /// **'Local SOCKS'**
  String get homeConnectedSocksTitle;

  /// No description provided for @homeConnectedSocksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No system tunnel on this OS. Apps must use 127.0.0.1:10808 — your IP is not hidden'**
  String get homeConnectedSocksSubtitle;

  /// No description provided for @revokedTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription link was revoked'**
  String get revokedTitle;

  /// No description provided for @revokedBody.
  ///
  /// In en, this message translates to:
  /// **'Paste a new URL on Profiles. Old nodes stay until you import a replacement.'**
  String get revokedBody;

  /// No description provided for @openProfiles.
  ///
  /// In en, this message translates to:
  /// **'Open Profiles'**
  String get openProfiles;

  /// No description provided for @elevationTitle.
  ///
  /// In en, this message translates to:
  /// **'Administrator rights required'**
  String get elevationTitle;

  /// No description provided for @runAsAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Run as administrator'**
  String get runAsAdministrator;

  /// No description provided for @quotaUsedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{used} / {total} VLESS+Hy2'**
  String quotaUsedOfTotal(String used, String total);

  /// No description provided for @quotaUsedOnly.
  ///
  /// In en, this message translates to:
  /// **'{used} used · VLESS+Hy2'**
  String quotaUsedOnly(String used);

  /// No description provided for @quotaExpired.
  ///
  /// In en, this message translates to:
  /// **'expired'**
  String get quotaExpired;

  /// No description provided for @quotaDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days}d left'**
  String quotaDaysLeft(int days);

  /// No description provided for @quotaScopeNote.
  ///
  /// In en, this message translates to:
  /// **'VLESS+Hy2 traffic — TrustTunnel uncounted'**
  String get quotaScopeNote;

  /// No description provided for @profilesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your network'**
  String get profilesEyebrow;

  /// No description provided for @profilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Server profiles'**
  String get profilesTitle;

  /// No description provided for @tooltipPinging.
  ///
  /// In en, this message translates to:
  /// **'Pinging…'**
  String get tooltipPinging;

  /// No description provided for @tooltipCheckPing.
  ///
  /// In en, this message translates to:
  /// **'Check ping'**
  String get tooltipCheckPing;

  /// No description provided for @noProfilesToPing.
  ///
  /// In en, this message translates to:
  /// **'No profiles to ping'**
  String get noProfilesToPing;

  /// No description provided for @tooltipImportLink.
  ///
  /// In en, this message translates to:
  /// **'Import link or subscription'**
  String get tooltipImportLink;

  /// No description provided for @searchServersHint.
  ///
  /// In en, this message translates to:
  /// **'Search servers or protocols'**
  String get searchServersHint;

  /// No description provided for @smartConnect.
  ///
  /// In en, this message translates to:
  /// **'Smart connect'**
  String get smartConnect;

  /// No description provided for @smartConnectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Home Connect uses the lowest-ping node in the current subscription'**
  String get smartConnectSubtitle;

  /// No description provided for @emptyProfiles.
  ///
  /// In en, this message translates to:
  /// **'No saved profiles yet.\nImport a share link or an https:// subscription URL.'**
  String get emptyProfiles;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @pinging.
  ///
  /// In en, this message translates to:
  /// **'pinging'**
  String get pinging;

  /// No description provided for @fastest.
  ///
  /// In en, this message translates to:
  /// **'fastest'**
  String get fastest;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteProfileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this profile?'**
  String get deleteProfileConfirm;

  /// No description provided for @deleteSubscriptionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this subscription and its saved nodes?'**
  String get deleteSubscriptionConfirm;

  /// No description provided for @updatedSubscription.
  ///
  /// In en, this message translates to:
  /// **'Updated {name}'**
  String updatedSubscription(String name);

  /// No description provided for @importProfile.
  ///
  /// In en, this message translates to:
  /// **'Import profile'**
  String get importProfile;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameOptional;

  /// No description provided for @importLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Share link or https:// subscription URL'**
  String get importLinkLabel;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @unrecognizedShareLink.
  ///
  /// In en, this message translates to:
  /// **'Unrecognized share link'**
  String get unrecognizedShareLink;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get shareLink;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @importedManual.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get importedManual;

  /// No description provided for @subscriptionFallback.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionFallback;

  /// No description provided for @revokedKeepNodes.
  ///
  /// In en, this message translates to:
  /// **'Link revoked — paste a new URL. Nodes were not cleared.'**
  String get revokedKeepNodes;

  /// No description provided for @nodesWithQuota.
  ///
  /// In en, this message translates to:
  /// **'{info} · {count} nodes'**
  String nodesWithQuota(String info, int count);

  /// No description provided for @nodesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 node} other{{count} nodes}}'**
  String nodesCount(int count);

  /// No description provided for @refreshSubscription.
  ///
  /// In en, this message translates to:
  /// **'Refresh subscription'**
  String get refreshSubscription;

  /// No description provided for @removeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Remove subscription'**
  String get removeSubscription;

  /// No description provided for @nothingToImport.
  ///
  /// In en, this message translates to:
  /// **'Nothing to import'**
  String get nothingToImport;

  /// No description provided for @subscriptionImported.
  ///
  /// In en, this message translates to:
  /// **'Subscription imported'**
  String get subscriptionImported;

  /// No description provided for @importedSubscriptionNodes.
  ///
  /// In en, this message translates to:
  /// **'Imported {name} ({count} nodes)'**
  String importedSubscriptionNodes(String name, int count);

  /// No description provided for @profileImported.
  ///
  /// In en, this message translates to:
  /// **'Profile imported'**
  String get profileImported;

  /// No description provided for @settingsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settingsEyebrow;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color theme'**
  String get colorTheme;

  /// No description provided for @colorThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paper light and navy dark. System follows the phone.'**
  String get colorThemeSubtitle;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English and Russian. System follows the phone.'**
  String get languageSubtitle;

  /// No description provided for @localeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get localeSystem;

  /// No description provided for @localeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// No description provided for @localeRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get localeRussian;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @advancedMode.
  ///
  /// In en, this message translates to:
  /// **'Advanced mode'**
  String get advancedMode;

  /// No description provided for @advancedModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Logs tab and power-user depth'**
  String get advancedModeSubtitle;

  /// No description provided for @reconnectOnLaunch.
  ///
  /// In en, this message translates to:
  /// **'Reconnect on launch'**
  String get reconnectOnLaunch;

  /// No description provided for @reconnectOnLaunchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start the last profile if the OS VPN is down'**
  String get reconnectOnLaunchSubtitle;

  /// No description provided for @dns.
  ///
  /// In en, this message translates to:
  /// **'DNS'**
  String get dns;

  /// No description provided for @dnsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get dnsSystem;

  /// No description provided for @dnsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get dnsCustom;

  /// No description provided for @dnsDoh.
  ///
  /// In en, this message translates to:
  /// **'DoH'**
  String get dnsDoh;

  /// No description provided for @dnsServerLabel.
  ///
  /// In en, this message translates to:
  /// **'DNS server / DoH URL'**
  String get dnsServerLabel;

  /// No description provided for @dnsSaved.
  ///
  /// In en, this message translates to:
  /// **'DNS preference saved'**
  String get dnsSaved;

  /// No description provided for @saveDns.
  ///
  /// In en, this message translates to:
  /// **'Save DNS'**
  String get saveDns;

  /// No description provided for @killSwitch.
  ///
  /// In en, this message translates to:
  /// **'Kill Switch'**
  String get killSwitch;

  /// No description provided for @killSwitchSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Always-on VPN in Android settings. The toggle here is not leak-proof by itself.'**
  String get killSwitchSubtitleAndroid;

  /// No description provided for @killSwitchSubtitleAndroidTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'Leak-lock on the next connect. Always-on still needed after reboot.'**
  String get killSwitchSubtitleAndroidTrustTunnel;

  /// No description provided for @killSwitchSubtitleIos.
  ///
  /// In en, this message translates to:
  /// **'Reconnects if the tunnel drops. Push, Watch and iMessage stay reachable.'**
  String get killSwitchSubtitleIos;

  /// No description provided for @killSwitchSubtitleIosTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'Leak-lock for this session. Disconnect turns it off before another VPN can start.'**
  String get killSwitchSubtitleIosTrustTunnel;

  /// No description provided for @killSwitchAndroidEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on system leak protection'**
  String get killSwitchAndroidEnableTitle;

  /// No description provided for @killSwitchAndroidEnableBody.
  ///
  /// In en, this message translates to:
  /// **'1. In the next screen, tap GoodWin VPN.\n2. Turn on Always-on VPN.\n3. Turn on Block connections without VPN.\n4. Return here and tap Connect.\n\nThe app cannot flip those Android switches itself.'**
  String get killSwitchAndroidEnableBody;

  /// No description provided for @killSwitchAndroidDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off Always-on first'**
  String get killSwitchAndroidDisableTitle;

  /// No description provided for @killSwitchAndroidDisableBody.
  ///
  /// In en, this message translates to:
  /// **'In Android VPN settings, turn off Always-on VPN and Block connections without VPN for Goodwin. Otherwise Disconnect will bring the tunnel back.'**
  String get killSwitchAndroidDisableBody;

  /// No description provided for @killSwitchOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open VPN settings'**
  String get killSwitchOpenSettings;

  /// No description provided for @killSwitchDisconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Always-on may reconnect'**
  String get killSwitchDisconnectTitle;

  /// No description provided for @killSwitchDisconnectBody.
  ///
  /// In en, this message translates to:
  /// **'Android Always-on VPN can bring the tunnel back after Disconnect. Turn Always-on off in system VPN settings if you want the network fully open.'**
  String get killSwitchDisconnectBody;

  /// No description provided for @killSwitchDisconnectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get killSwitchDisconnectConfirm;

  /// No description provided for @coreTuning.
  ///
  /// In en, this message translates to:
  /// **'Core tuning'**
  String get coreTuning;

  /// No description provided for @advancedDangerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Advanced — can break connectivity'**
  String get advancedDangerTooltip;

  /// No description provided for @mux.
  ///
  /// In en, this message translates to:
  /// **'Mux'**
  String get mux;

  /// No description provided for @muxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Skipped with Vision so typical VLESS can start'**
  String get muxSubtitle;

  /// No description provided for @fragment.
  ///
  /// In en, this message translates to:
  /// **'Fragment'**
  String get fragment;

  /// No description provided for @fragmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Skipped on REALITY — TLS hello only'**
  String get fragmentSubtitle;

  /// No description provided for @dnsHintWithTuning.
  ///
  /// In en, this message translates to:
  /// **'DNS IPs apply to the OS TUN on connect. DoH goes into Xray JSON; TUN still uses bootstrap IPs. Mux / Fragment: Xray only.'**
  String get dnsHintWithTuning;

  /// No description provided for @dnsHintSimple.
  ///
  /// In en, this message translates to:
  /// **'DNS IPs apply to the OS TUN on connect.'**
  String get dnsHintSimple;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export and import profiles'**
  String get backupHubSubtitle;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup file'**
  String get exportBackup;

  /// No description provided for @exportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profiles and subscriptions. Optional password encrypts the file'**
  String get exportBackupSubtitle;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup file'**
  String get importBackup;

  /// No description provided for @importBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Merges into the current catalog'**
  String get importBackupSubtitle;

  /// No description provided for @copyJsonClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON to clipboard'**
  String get copyJsonClipboard;

  /// No description provided for @copyJsonClipboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unencrypted — anyone with the clipboard can read links'**
  String get copyJsonClipboardSubtitle;

  /// No description provided for @copiedEmptyProfiles.
  ///
  /// In en, this message translates to:
  /// **'Copied empty profile list'**
  String get copiedEmptyProfiles;

  /// No description provided for @copiedProfilesJson.
  ///
  /// In en, this message translates to:
  /// **'Copied {count} profile(s) as unencrypted JSON'**
  String copiedProfilesJson(int count);

  /// No description provided for @exportBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackupTitle;

  /// No description provided for @exportBackupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for a plain JSON file. A password uses AES-256-GCM.'**
  String get exportBackupPasswordHint;

  /// No description provided for @backupFileSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup file saved'**
  String get backupFileSaved;

  /// No description provided for @encryptedBackupSaved.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup file saved'**
  String get encryptedBackupSaved;

  /// No description provided for @encryptedBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup'**
  String get encryptedBackupTitle;

  /// No description provided for @encryptedBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the password used when exporting.'**
  String get encryptedBackupHint;

  /// No description provided for @importedBackupCounts.
  ///
  /// In en, this message translates to:
  /// **'Imported {profiles} profile(s) and {subs} subscription(s)'**
  String importedBackupCounts(int profiles, int subs);

  /// No description provided for @passwordOptional.
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get passwordOptional;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'VPN client for your own server'**
  String get aboutSubtitle;

  /// No description provided for @aboutHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version, privacy, support'**
  String get aboutHubSubtitle;

  /// No description provided for @subscriptionAbout.
  ///
  /// In en, this message translates to:
  /// **'About subscription'**
  String get subscriptionAbout;

  /// No description provided for @subscriptionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get subscriptionAccount;

  /// No description provided for @subscriptionHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get subscriptionHost;

  /// No description provided for @subscriptionLastFetched.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get subscriptionLastFetched;

  /// No description provided for @subscriptionNeverFetched.
  ///
  /// In en, this message translates to:
  /// **'Not updated yet'**
  String get subscriptionNeverFetched;

  /// No description provided for @subscriptionUpdateInterval.
  ///
  /// In en, this message translates to:
  /// **'Update every {hours}h'**
  String subscriptionUpdateInterval(int hours);

  /// No description provided for @subscriptionQuota.
  ///
  /// In en, this message translates to:
  /// **'Traffic'**
  String get subscriptionQuota;

  /// No description provided for @subscriptionExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get subscriptionExpires;

  /// No description provided for @subscriptionNoUserinfo.
  ///
  /// In en, this message translates to:
  /// **'No quota or expiry from the panel yet'**
  String get subscriptionNoUserinfo;

  /// No description provided for @subscriptionDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get subscriptionDevices;

  /// No description provided for @subscriptionDevicesUsedOfLimit.
  ///
  /// In en, this message translates to:
  /// **'{used} / {limit} devices'**
  String subscriptionDevicesUsedOfLimit(int used, int limit);

  /// No description provided for @subscriptionDeviceLimitOnly.
  ///
  /// In en, this message translates to:
  /// **'Up to {limit} devices'**
  String subscriptionDeviceLimitOnly(int limit);

  /// No description provided for @subscriptionDeviceCountOnly.
  ///
  /// In en, this message translates to:
  /// **'{count} devices reported'**
  String subscriptionDeviceCountOnly(int count);

  /// No description provided for @expireWarningSoon.
  ///
  /// In en, this message translates to:
  /// **'Subscription ends in {days}d'**
  String expireWarningSoon(int days);

  /// No description provided for @expireWarningExpired.
  ///
  /// In en, this message translates to:
  /// **'Subscription expired'**
  String get expireWarningExpired;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Camera, VPN, on-device secrets, clipboard backups'**
  String get privacySubtitle;

  /// No description provided for @privacyWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What this app uses'**
  String get privacyWhatTitle;

  /// No description provided for @privacyWhatBody.
  ///
  /// In en, this message translates to:
  /// **'GoodWin VPN is a local client. There is no Goodwin account server and no analytics SDK in this build.'**
  String get privacyWhatBody;

  /// No description provided for @privacyVpnTitle.
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get privacyVpnTitle;

  /// No description provided for @privacyVpnBody.
  ///
  /// In en, this message translates to:
  /// **'On platforms with a system tunnel, device traffic is sent to the node in the share link you imported. The app does not operate a Goodwin proxy. If this OS has no system tunnel, Connect only starts a local SOCKS proxy at 127.0.0.1:10808.'**
  String get privacyVpnBody;

  /// No description provided for @privacySecretsTitle.
  ///
  /// In en, this message translates to:
  /// **'Configs and secrets'**
  String get privacySecretsTitle;

  /// No description provided for @privacySecretsBody.
  ///
  /// In en, this message translates to:
  /// **'Share links, saved profiles, and subscription URLs are stored on this device, encrypted with AES-256-GCM. The encryption key lives in the OS keystore / keychain, not next to the ciphertext. If the platform keystore is unavailable, the app cannot keep those values encrypted.'**
  String get privacySecretsBody;

  /// No description provided for @privacyCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get privacyCameraTitle;

  /// No description provided for @privacyCameraBody.
  ///
  /// In en, this message translates to:
  /// **'The camera is used only to scan a QR code that contains a share link or a subscription URL. Frames are not uploaded.'**
  String get privacyCameraBody;

  /// No description provided for @privacyClipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard and backups'**
  String get privacyClipboardTitle;

  /// No description provided for @privacyClipboardBody.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON to clipboard writes an unencrypted backup. Anyone who can read the clipboard can read those links. File export can use an optional password (AES-256-GCM).'**
  String get privacyClipboardBody;

  /// No description provided for @privacyAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'Installed apps (Android)'**
  String get privacyAppsTitle;

  /// No description provided for @privacyAppsBody.
  ///
  /// In en, this message translates to:
  /// **'Per-app split tunneling reads the launcher app list on the device so you can exclude apps from the VPN. That list stays on the device.'**
  String get privacyAppsBody;

  /// No description provided for @privacyOpenWeb.
  ///
  /// In en, this message translates to:
  /// **'Open privacy policy'**
  String get privacyOpenWeb;

  /// No description provided for @privacyOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the privacy policy URL'**
  String get privacyOpenFailed;

  /// No description provided for @rulesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Traffic policy'**
  String get rulesEyebrow;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Routing rules'**
  String get rulesTitle;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetRulesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reset routing to defaults?'**
  String get resetRulesConfirm;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @modeHintGlobalRich.
  ///
  /// In en, this message translates to:
  /// **'All matched traffic → proxy (Xray default).'**
  String get modeHintGlobalRich;

  /// No description provided for @modeHintGlobalSimple.
  ///
  /// In en, this message translates to:
  /// **'Recommended for Hysteria2.'**
  String get modeHintGlobalSimple;

  /// No description provided for @modeHintGlobalTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'All traffic through the tunnel except Always-exclude.'**
  String get modeHintGlobalTrustTunnel;

  /// No description provided for @modeHintRules.
  ///
  /// In en, this message translates to:
  /// **'Presets + custom rules; unmatched → proxy (Xray).'**
  String get modeHintRules;

  /// No description provided for @modeHintRulesTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'Direct domains/CIDRs become TrustTunnel exclusions. Block is skipped. Unmatched stays in the tunnel.'**
  String get modeHintRulesTrustTunnel;

  /// No description provided for @modeHintDirect.
  ///
  /// In en, this message translates to:
  /// **'All → freedom. TUN stays up (Xray only).'**
  String get modeHintDirect;

  /// No description provided for @presets.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get presets;

  /// No description provided for @presetsHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ads, LAN, banking apps'**
  String get presetsHubSubtitle;

  /// No description provided for @customRulesHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Domain matchers and actions'**
  String get customRulesHubSubtitle;

  /// No description provided for @excludeCidrHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CIDRs always outside the tunnel'**
  String get excludeCidrHubSubtitle;

  /// No description provided for @presetBlockAds.
  ///
  /// In en, this message translates to:
  /// **'Block ads (limited)'**
  String get presetBlockAds;

  /// No description provided for @presetBlockAdsPack.
  ///
  /// In en, this message translates to:
  /// **'Block ads'**
  String get presetBlockAdsPack;

  /// No description provided for @presetBypassAdsPack.
  ///
  /// In en, this message translates to:
  /// **'Bypass ads'**
  String get presetBypassAdsPack;

  /// No description provided for @presetBlockAdsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tiny built-in host list → block (Xray; not geosite)'**
  String get presetBlockAdsSubtitle;

  /// No description provided for @presetBlockAdsPackXray.
  ///
  /// In en, this message translates to:
  /// **'Service ads pack → block (not geosite)'**
  String get presetBlockAdsPackXray;

  /// No description provided for @presetBlockAdsPackTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'Service ads pack → exclusions (no plugin block)'**
  String get presetBlockAdsPackTrustTunnel;

  /// No description provided for @presetBypassLan.
  ///
  /// In en, this message translates to:
  /// **'Bypass LAN / private'**
  String get presetBypassLan;

  /// No description provided for @presetBypassLanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'RFC1918 / link-local CIDRs → TUN excludes (not a region/geoip)'**
  String get presetBypassLanSubtitle;

  /// No description provided for @presetBypassLanAndroid13.
  ///
  /// In en, this message translates to:
  /// **'Bypass LAN needs Android 13+. CIDR excludes do nothing on this version.'**
  String get presetBypassLanAndroid13;

  /// No description provided for @presetProtectBanking.
  ///
  /// In en, this message translates to:
  /// **'Protect banking'**
  String get presetProtectBanking;

  /// No description provided for @presetProtectBankingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Installed bank apps skip the TUN (Android per-app)'**
  String get presetProtectBankingSubtitle;

  /// No description provided for @appsSkipVpn.
  ///
  /// In en, this message translates to:
  /// **'Apps that skip VPN'**
  String get appsSkipVpn;

  /// No description provided for @appsSkipVpnEmpty.
  ///
  /// In en, this message translates to:
  /// **'Optional extras beyond Protect banking'**
  String get appsSkipVpnEmpty;

  /// No description provided for @appsSkipVpnSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected · applied on next connect'**
  String appsSkipVpnSelected(int count);

  /// No description provided for @switchToRulesForPresets.
  ///
  /// In en, this message translates to:
  /// **'Switch to Rules mode to use presets.'**
  String get switchToRulesForPresets;

  /// No description provided for @alwaysExcludeMerged.
  ///
  /// In en, this message translates to:
  /// **'Always-exclude CIDRs are merged with IP-direct rules at connect for every backend. Edit them in Advanced below.'**
  String get alwaysExcludeMerged;

  /// No description provided for @alwaysExcludeCidr.
  ///
  /// In en, this message translates to:
  /// **'Always exclude (CIDR)'**
  String get alwaysExcludeCidr;

  /// No description provided for @alwaysExcludeHint.
  ///
  /// In en, this message translates to:
  /// **'One IP or CIDR per line. Applied on the next connect.'**
  String get alwaysExcludeHint;

  /// No description provided for @cidrHint.
  ///
  /// In en, this message translates to:
  /// **'One IP or CIDR per line\ne.g. 10.0.0.0/8'**
  String get cidrHint;

  /// No description provided for @customRules.
  ///
  /// In en, this message translates to:
  /// **'Custom rules'**
  String get customRules;

  /// No description provided for @customRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Domain suffix, IP or CIDR → proxy / direct / block. Applied to Xray on connect. IP direct also feeds OS excludes.'**
  String get customRulesHint;

  /// No description provided for @customRulesHintTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'Domain or CIDR → proxy (stay in tunnel) or direct (exclude). Block is not available. No geosite.'**
  String get customRulesHintTrustTunnel;

  /// No description provided for @matcher.
  ///
  /// In en, this message translates to:
  /// **'Matcher'**
  String get matcher;

  /// No description provided for @matcherHint.
  ///
  /// In en, this message translates to:
  /// **'.ads.example · 10.0.0.0/8'**
  String get matcherHint;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get addRule;

  /// No description provided for @noCustomRules.
  ///
  /// In en, this message translates to:
  /// **'No custom rules yet'**
  String get noCustomRules;

  /// No description provided for @osExclude.
  ///
  /// In en, this message translates to:
  /// **'{action} · OS exclude'**
  String osExclude(String action);

  /// No description provided for @routingRuleBlockSkipped.
  ///
  /// In en, this message translates to:
  /// **'block · skipped on TrustTunnel (no plugin block)'**
  String get routingRuleBlockSkipped;

  /// No description provided for @enableAdvancedForRouting.
  ///
  /// In en, this message translates to:
  /// **'Enable Advanced mode in Settings for extra routing controls.'**
  String get enableAdvancedForRouting;

  /// No description provided for @searchApps.
  ///
  /// In en, this message translates to:
  /// **'Search apps'**
  String get searchApps;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @routingBannerXray.
  ///
  /// In en, this message translates to:
  /// **'Xray profile: Global / Rules / Direct and domain rules apply on connect.'**
  String get routingBannerXray;

  /// No description provided for @routingBannerHysteria.
  ///
  /// In en, this message translates to:
  /// **'Hysteria2 profile: domain/block rules and Xray Direct are not applied. Use Global; Always-exclude CIDRs and IP-direct still merge into the TUN.'**
  String get routingBannerHysteria;

  /// No description provided for @routingBannerTrustTunnel.
  ///
  /// In en, this message translates to:
  /// **'TrustTunnel: Rules direct domains/CIDRs become exclusions. Block is skipped (no plugin block). Direct mode is not applied. Always-exclude still merges. Per-app split is SOCKS-only. Kill Switch applies on the next TrustTunnel connect.'**
  String get routingBannerTrustTunnel;

  /// No description provided for @routingBannerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Select or connect a profile to see which routing features apply.'**
  String get routingBannerUnknown;

  /// No description provided for @logsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get logsEyebrow;

  /// No description provided for @logsTitle.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logsTitle;

  /// No description provided for @copyFiltered.
  ///
  /// In en, this message translates to:
  /// **'Copy filtered'**
  String get copyFiltered;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @logCopied.
  ///
  /// In en, this message translates to:
  /// **'Log copied'**
  String get logCopied;

  /// No description provided for @logsHint.
  ///
  /// In en, this message translates to:
  /// **'Core console. Colors are heuristic (error/warn keywords).'**
  String get logsHint;

  /// No description provided for @filterHint.
  ///
  /// In en, this message translates to:
  /// **'Filter…'**
  String get filterHint;

  /// No description provided for @logsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get logsAll;

  /// No description provided for @logsWarnPlus.
  ///
  /// In en, this message translates to:
  /// **'Warn+'**
  String get logsWarnPlus;

  /// No description provided for @logsError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get logsError;

  /// No description provided for @noLogLinesYet.
  ///
  /// In en, this message translates to:
  /// **'No log lines yet'**
  String get noLogLinesYet;

  /// No description provided for @noMatchesForFilter.
  ///
  /// In en, this message translates to:
  /// **'No matches for filter'**
  String get noMatchesForFilter;

  /// No description provided for @vpnConsole.
  ///
  /// In en, this message translates to:
  /// **'VPN console'**
  String get vpnConsole;

  /// No description provided for @logsSheetEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lines yet. Waiting for stream…'**
  String get logsSheetEmpty;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @openLogs.
  ///
  /// In en, this message translates to:
  /// **'Open logs'**
  String get openLogs;

  /// No description provided for @tapToRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get tapToRetry;

  /// No description provided for @homeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not connect'**
  String get homeErrorTitle;

  /// No description provided for @homeErrorTunnel.
  ///
  /// In en, this message translates to:
  /// **'Tunnel failed — tap to retry'**
  String get homeErrorTunnel;

  /// No description provided for @homeErrorSocks.
  ///
  /// In en, this message translates to:
  /// **'Local SOCKS failed — tap to retry'**
  String get homeErrorSocks;

  /// No description provided for @activeProfile.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE PROFILE'**
  String get activeProfile;

  /// No description provided for @socksInbound.
  ///
  /// In en, this message translates to:
  /// **'Local SOCKS'**
  String get socksInbound;

  /// No description provided for @socksInboundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Leave user and password empty to generate random credentials each connect. Other apps: 127.0.0.1 plus these credentials.'**
  String get socksInboundSubtitle;

  /// No description provided for @socksPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get socksPort;

  /// No description provided for @socksUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get socksUsername;

  /// No description provided for @socksPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get socksPassword;

  /// No description provided for @saveSocks.
  ///
  /// In en, this message translates to:
  /// **'Save SOCKS'**
  String get saveSocks;

  /// No description provided for @socksSaved.
  ///
  /// In en, this message translates to:
  /// **'SOCKS saved'**
  String get socksSaved;

  /// No description provided for @killSwitchAndroidConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you turn on Always-on?'**
  String get killSwitchAndroidConfirmTitle;

  /// No description provided for @killSwitchAndroidConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The app cannot flip Android VPN switches. Turn the Kill Switch on here only after Always-on and Block connections without VPN are enabled for GoodWin VPN.'**
  String get killSwitchAndroidConfirmBody;

  /// No description provided for @killSwitchAndroidConfirmYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, they are on'**
  String get killSwitchAndroidConfirmYes;

  /// No description provided for @killSwitchAndroidConfirmNo.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get killSwitchAndroidConfirmNo;

  /// No description provided for @killSwitchIosDisconnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not turn off on-demand. Disconnect may not stick until you retry.'**
  String get killSwitchIosDisconnectFailed;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the operator support page'**
  String get supportSubtitle;

  /// No description provided for @supportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No support URL in this subscription'**
  String get supportUnavailable;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenses;

  /// No description provided for @licensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open-source components in this app'**
  String get licensesSubtitle;

  /// No description provided for @licensesBody.
  ///
  /// In en, this message translates to:
  /// **'Networking libraries, Flutter, and Inter (SIL OFL) are bundled. Source and licenses are listed below and in the project repositories.'**
  String get licensesBody;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingDone;

  /// No description provided for @onboardingServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your server'**
  String get onboardingServerTitle;

  /// No description provided for @onboardingServerBody.
  ///
  /// In en, this message translates to:
  /// **'GoodWin VPN is a client for a node you import. There is no Goodwin cloud proxy. Add a share link or an https subscription URL on Profiles.'**
  String get onboardingServerBody;

  /// No description provided for @onboardingVpnTitle.
  ///
  /// In en, this message translates to:
  /// **'System VPN'**
  String get onboardingVpnTitle;

  /// No description provided for @onboardingVpnBody.
  ///
  /// In en, this message translates to:
  /// **'Connect asks the OS to add a VPN configuration. That dialog is from Android or iOS, not from this app. Traffic then goes to the node in the profile you selected.'**
  String get onboardingVpnBody;

  /// No description provided for @onboardingCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera for QR'**
  String get onboardingCameraTitle;

  /// No description provided for @onboardingCameraBody.
  ///
  /// In en, this message translates to:
  /// **'The camera is optional and only scans a QR with a share link or subscription URL. Frames stay on the device.'**
  String get onboardingCameraBody;

  /// No description provided for @vpnExplainerTitle.
  ///
  /// In en, this message translates to:
  /// **'System VPN permission'**
  String get vpnExplainerTitle;

  /// No description provided for @vpnExplainerBody.
  ///
  /// In en, this message translates to:
  /// **'The next screen is the OS VPN dialog. Allow it only if you want this device to send traffic through the imported node.'**
  String get vpnExplainerBody;

  /// No description provided for @vpnExplainerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get vpnExplainerContinue;

  /// No description provided for @cameraExplainerTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera permission'**
  String get cameraExplainerTitle;

  /// No description provided for @cameraExplainerBody.
  ///
  /// In en, this message translates to:
  /// **'The next screen may ask for the camera. It is used only to scan a configuration QR. Frames are not uploaded.'**
  String get cameraExplainerBody;

  /// No description provided for @cameraExplainerContinue.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get cameraExplainerContinue;

  /// No description provided for @importLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a share link or an https:// subscription URL. The app does not host a proxy.'**
  String get importLinkHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
