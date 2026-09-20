// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Главная';

  @override
  String get navProfiles => 'Профили';

  @override
  String get navRules => 'Правила';

  @override
  String get navLogs => 'Логи';

  @override
  String get navSettings => 'Настройки';

  @override
  String get connectVpn => 'Подключить VPN';

  @override
  String get disconnectVpn => 'Отключить VPN';

  @override
  String get noProfile => 'Нет профиля';

  @override
  String get addProfileToConnect => 'Добавьте профиль, чтобы подключиться';

  @override
  String get addProfileToConnectHint =>
      'Импортируйте ссылку на экране Профили, затем нажмите Connect здесь.';

  @override
  String get addProfile => 'Добавить профиль';

  @override
  String get networkStatus => 'СТАТУС СЕТИ';

  @override
  String get tapToDisconnect => 'Нажмите, чтобы отключить';

  @override
  String get tapToConnect => 'Нажмите, чтобы подключиться';

  @override
  String get statNode => 'Нода';

  @override
  String get statPing => 'Пинг';

  @override
  String get statUptime => 'Аптайм';

  @override
  String get sessionLogs => 'Логи сессии';

  @override
  String get noLinesYet => 'Пока пусто';

  @override
  String logLinesCount(int count) {
    return '$count строк';
  }

  @override
  String get uacDeclined => 'Запрос UAC отклонён';

  @override
  String get statusOffline => 'отключён';

  @override
  String get statusConnecting => 'подключение';

  @override
  String get statusConnected => 'подключено';

  @override
  String get statusDisconnecting => 'отключение';

  @override
  String get statusError => 'ошибка';

  @override
  String get switchProfile => 'Сменить профиль';

  @override
  String get manageProfiles => 'Управление профилями';

  @override
  String get routing => 'Маршрутизация';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · изменить в Правилах';
  }

  @override
  String get routingModeGlobal => 'Глобальный';

  @override
  String get routingModeRules => 'Правила';

  @override
  String get routingModeDirect => 'Напрямую';

  @override
  String get homeReadyTitle => 'Отключён';

  @override
  String get homeReadyTunnel =>
      'Connect поднимает системный VPN на этом устройстве';

  @override
  String get homeReadySocks =>
      'На этой ОС ещё нет системного VPN — Connect это локальный SOCKS';

  @override
  String get homeBusyTitle => 'Подключение';

  @override
  String get homeBusyTunnel => 'Запрашиваем у ОС VPN-туннель';

  @override
  String get homeBusySocks => 'Запускаем локальный SOCKS';

  @override
  String get homeConnectedTunnelTitle => 'Системный VPN';

  @override
  String get homeConnectedTunnelSubtitle =>
      'Трафик устройства идёт в туннель, не с домашнего IP';

  @override
  String get homeConnectedSocksTitle => 'Локальный SOCKS';

  @override
  String get homeConnectedSocksSubtitle =>
      'Системного туннеля на этой ОС нет. Приложениям нужен 127.0.0.1:10808 — ваш IP не скрыт';

  @override
  String get revokedTitle => 'Ссылка подписки отозвана';

  @override
  String get revokedBody =>
      'Вставьте новый URL на экране Профили. Старые ноды остаются, пока не импортируете замену.';

  @override
  String get openProfiles => 'Открыть профили';

  @override
  String get elevationTitle => 'Нужны права администратора';

  @override
  String get runAsAdministrator => 'Запустить от администратора';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used использовано · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'истёк';

  @override
  String quotaDaysLeft(int days) {
    return 'ещё $days дн.';
  }

  @override
  String get quotaScopeNote => 'Трафик VLESS+Hy2 — TrustTunnel не считается';

  @override
  String get profilesEyebrow => 'Ваша сеть';

  @override
  String get profilesTitle => 'Профили серверов';

  @override
  String get tooltipPinging => 'Пинг…';

  @override
  String get tooltipCheckPing => 'Проверить пинг';

  @override
  String get noProfilesToPing => 'Нет профилей для пинга';

  @override
  String get tooltipImportLink => 'Импорт ссылки или подписки';

  @override
  String get searchServersHint => 'Поиск серверов или протоколов';

  @override
  String get smartConnect => 'Умное подключение';

  @override
  String get smartConnectSubtitle =>
      'Connect на Главной берёт ноду с наименьшим пингом в текущей подписке';

  @override
  String get emptyProfiles =>
      'Пока нет сохранённых профилей.\nИмпортируйте share-ссылку или https:// URL подписки.';

  @override
  String get noMatches => 'Ничего не найдено';

  @override
  String get pinging => 'пинг';

  @override
  String get fastest => 'быстрее всех';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteProfileConfirm => 'Удалить этот профиль?';

  @override
  String get deleteSubscriptionConfirm =>
      'Удалить подписку и сохранённые ноды?';

  @override
  String updatedSubscription(String name) {
    return 'Обновлено $name';
  }

  @override
  String get importProfile => 'Импорт профиля';

  @override
  String get nameOptional => 'Имя (необязательно)';

  @override
  String get importLinkLabel => 'Ссылка или https:// подписка';

  @override
  String get paste => 'Вставить';

  @override
  String get scanQr => 'Сканировать QR';

  @override
  String get cancel => 'Отмена';

  @override
  String get import => 'Импорт';

  @override
  String get unrecognizedShareLink => 'Неизвестная share-ссылка';

  @override
  String get editProfile => 'Изменить профиль';

  @override
  String get name => 'Имя';

  @override
  String get shareLink => 'Share-ссылка';

  @override
  String get apply => 'Применить';

  @override
  String get importedManual => 'Импортированные';

  @override
  String get subscriptionFallback => 'Подписка';

  @override
  String get revokedKeepNodes =>
      'Ссылка отозвана — вставьте новый URL. Ноды не очищались.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count нод';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ноды',
      many: '$count нод',
      few: '$count ноды',
      one: '1 нода',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Обновить подписку';

  @override
  String get removeSubscription => 'Удалить подписку';

  @override
  String get nothingToImport => 'Нечего импортировать';

  @override
  String get subscriptionImported => 'Подписка импортирована';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return 'Импортировано $name ($count нод)';
  }

  @override
  String get profileImported => 'Профиль импортирован';

  @override
  String get settingsEyebrow => 'Приложение';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get appearance => 'Оформление';

  @override
  String get colorTheme => 'Цветовая тема';

  @override
  String get colorThemeSubtitle =>
      'Светлая бумага и тёмный navy. Система следует за телефоном.';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSystem => 'Система';

  @override
  String get language => 'Язык';

  @override
  String get languageSubtitle =>
      'Английский и русский. Система следует за телефоном.';

  @override
  String get localeSystem => 'Система';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Общее';

  @override
  String get advancedMode => 'Расширенный режим';

  @override
  String get advancedModeSubtitle => 'Вкладка логов и настройки для опытных';

  @override
  String get reconnectOnLaunch => 'Подключаться при запуске';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Поднять последний профиль, если системный VPN выключен';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'Система';

  @override
  String get dnsCustom => 'Свой';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'DNS-сервер / URL DoH';

  @override
  String get dnsSaved => 'Настройка DNS сохранена';

  @override
  String get saveDns => 'Сохранить DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'Always-on VPN в настройках Android. Тумблер здесь сам по себе не leak-proof.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Защита от утечек на следующем Connect. После reboot всё равно нужен Always-on.';

  @override
  String get killSwitchSubtitleIos =>
      'Поднимает туннель снова при обрыве. Push, Watch и iMessage остаются доступны.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Защита от утечек на эту сессию. Disconnect снимает её до старта другого VPN.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Включить системную защиту от утечек';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. На следующем экране нажмите GoodWin VPN.\n2. Включите Always-on VPN.\n3. Включите «Блокировать соединения без VPN».\n4. Вернитесь сюда и нажмите Connect.\n\nПриложение само эти системные тумблеры не переключает.';

  @override
  String get killSwitchAndroidDisableTitle => 'Сначала выключите Always-on';

  @override
  String get killSwitchAndroidDisableBody =>
      'В системных настройках VPN выключите Always-on и «Блокировать соединения без VPN» для Goodwin. Иначе Disconnect снова поднимет туннель.';

  @override
  String get killSwitchOpenSettings => 'Открыть настройки VPN';

  @override
  String get killSwitchDisconnectTitle => 'Always-on может поднять VPN снова';

  @override
  String get killSwitchDisconnectBody =>
      'Android Always-on VPN может вернуть туннель после Disconnect. Выключите Always-on в системных настройках VPN, если нужна полностью открытая сеть.';

  @override
  String get killSwitchDisconnectConfirm => 'Disconnect';

  @override
  String get coreTuning => 'Ядро';

  @override
  String get advancedDangerTooltip => 'Расширенное — может оборвать связь';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Не применяется с Vision — обычный VLESS не падает';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Не применяется на REALITY — только TLS hello';

  @override
  String get dnsHintWithTuning =>
      'IP DNS применяются к OS TUN при подключении. DoH попадает в JSON Xray; TUN всё равно использует bootstrap IP. Mux / Fragment: только Xray.';

  @override
  String get dnsHintSimple => 'IP DNS применяются к OS TUN при подключении.';

  @override
  String get backup => 'Резервная копия';

  @override
  String get backupHubSubtitle => 'Экспорт и импорт профилей';

  @override
  String get exportBackup => 'Экспорт файла бэкапа';

  @override
  String get exportBackupSubtitle =>
      'Профили и подписки. Пароль по желанию шифрует файл';

  @override
  String get importBackup => 'Импорт файла бэкапа';

  @override
  String get importBackupSubtitle => 'Сливается с текущим каталогом';

  @override
  String get copyJsonClipboard => 'Копировать JSON в буфер';

  @override
  String get copyJsonClipboardSubtitle =>
      'Без шифрования — кто читает буфер, видит ссылки';

  @override
  String get copiedEmptyProfiles => 'Скопирован пустой список профилей';

  @override
  String copiedProfilesJson(int count) {
    return 'Скопировано профилей: $count (JSON без шифрования)';
  }

  @override
  String get exportBackupTitle => 'Экспорт бэкапа';

  @override
  String get exportBackupPasswordHint =>
      'Пустое поле — обычный JSON. Пароль включает AES-256-GCM.';

  @override
  String get backupFileSaved => 'Файл бэкапа сохранён';

  @override
  String get encryptedBackupSaved => 'Зашифрованный бэкап сохранён';

  @override
  String get encryptedBackupTitle => 'Зашифрованный бэкап';

  @override
  String get encryptedBackupHint =>
      'Введите пароль, который задали при экспорте.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return 'Импортировано профилей: $profiles, подписок: $subs';
  }

  @override
  String get passwordOptional => 'Пароль (необязательно)';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Повторите пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get about => 'О приложении';

  @override
  String get aboutSubtitle => 'Клиент VPN для своего сервера';

  @override
  String get aboutHubSubtitle => 'Версия, конфиденциальность, поддержка';

  @override
  String get subscriptionAbout => 'О подписке';

  @override
  String get subscriptionAccount => 'Аккаунт';

  @override
  String get subscriptionHost => 'Хост';

  @override
  String get subscriptionLastFetched => 'Обновлено';

  @override
  String get subscriptionNeverFetched => 'Ещё не обновлялась';

  @override
  String subscriptionUpdateInterval(int hours) {
    return 'Обновление каждые $hours ч';
  }

  @override
  String get subscriptionQuota => 'Трафик';

  @override
  String get subscriptionExpires => 'Срок';

  @override
  String get subscriptionNoUserinfo => 'Панель ещё не отдала квоту или срок';

  @override
  String get subscriptionDevices => 'Устройства';

  @override
  String subscriptionDevicesUsedOfLimit(int used, int limit) {
    return '$used / $limit устр.';
  }

  @override
  String subscriptionDeviceLimitOnly(int limit) {
    return 'До $limit устр.';
  }

  @override
  String subscriptionDeviceCountOnly(int count) {
    return 'Устройств: $count';
  }

  @override
  String expireWarningSoon(int days) {
    return 'Подписка закончится через $days дн.';
  }

  @override
  String get expireWarningExpired => 'Подписка истекла';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacySubtitle =>
      'Камера, VPN, секреты на устройстве, бэкапы в буфере';

  @override
  String get privacyWhatTitle => 'Что использует приложение';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN — локальный клиент. В этой сборке нет сервера аккаунтов Goodwin и нет SDK аналитики.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'На платформах с системным туннелем трафик устройства уходит на ноду из импортированной ссылки. Приложение не поднимает прокси Goodwin. Если системного туннеля нет, Connect запускает только локальный SOCKS на 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Конфиги и секреты';

  @override
  String get privacySecretsBody =>
      'Share-ссылки, сохранённые профили и URL подписок хранятся на этом устройстве, шифруются AES-256-GCM. Ключ лежит в keystore / keychain ОС, не рядом с шифротекстом. Если keystore недоступен, приложение не сможет хранить эти значения зашифрованными.';

  @override
  String get privacyCameraTitle => 'Камера';

  @override
  String get privacyCameraBody =>
      'Камера используется только чтобы считать QR с share-ссылкой или URL подписки. Кадры никуда не загружаются.';

  @override
  String get privacyClipboardTitle => 'Буфер обмена и резервные копии';

  @override
  String get privacyClipboardBody =>
      'Копирование JSON в буфер — незашифрованный бэкап. Кто читает буфер, видит ссылки. Экспорт в файл может быть с паролем (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Установленные приложения (Android)';

  @override
  String get privacyAppsBody =>
      'Per-app split читает список приложений на устройстве, чтобы исключить их из VPN. Список остаётся на устройстве.';

  @override
  String get privacyOpenWeb => 'Открыть политику в браузере';

  @override
  String get privacyOpenFailed =>
      'Не удалось открыть URL политики конфиденциальности';

  @override
  String get rulesEyebrow => 'Политика трафика';

  @override
  String get rulesTitle => 'Правила маршрутизации';

  @override
  String get reset => 'Сброс';

  @override
  String get resetRulesConfirm => 'Сбросить правила к значениям по умолчанию?';

  @override
  String get mode => 'Режим';

  @override
  String get modeHintGlobalRich =>
      'Весь совпавший трафик → прокси (по умолчанию Xray).';

  @override
  String get modeHintGlobalSimple => 'Рекомендуется для Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Весь трафик в туннель, кроме Always-exclude.';

  @override
  String get modeHintRules =>
      'Пресеты и свои правила; остальное → прокси (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Direct-домены/CIDR становятся исключениями TrustTunnel. Block пропускается. Остальное остаётся в туннеле.';

  @override
  String get modeHintDirect => 'Всё → freedom. TUN остаётся (только Xray).';

  @override
  String get presets => 'Пресеты';

  @override
  String get presetsHubSubtitle => 'Реклама, LAN, банки';

  @override
  String get customRulesHubSubtitle => 'Домены и действия';

  @override
  String get excludeCidrHubSubtitle => 'CIDR всегда вне туннеля';

  @override
  String get presetBlockAds => 'Блок рекламы (ограниченно)';

  @override
  String get presetBlockAdsPack => 'Блок рекламы';

  @override
  String get presetBypassAdsPack => 'Обход рекламы';

  @override
  String get presetBlockAdsSubtitle =>
      'Короткий встроенный список хостов → block (Xray; не geosite)';

  @override
  String get presetBlockAdsPackXray => 'Пак ads сервиса → block (не geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Пак ads сервиса → исключения (в плагине нет block)';

  @override
  String get presetBypassLan => 'Миновать LAN / private';

  @override
  String get presetBypassLanSubtitle =>
      'RFC1918 / link-local CIDR → исключения TUN (не регион/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Bypass LAN нужен Android 13+. На этой версии CIDR-исключения ничего не делают.';

  @override
  String get presetProtectBanking => 'Банки мимо VPN';

  @override
  String get presetProtectBankingSubtitle =>
      'Установленные банковские приложения обходят TUN (Android per-app)';

  @override
  String get appsSkipVpn => 'Приложения вне VPN';

  @override
  String get appsSkipVpnEmpty => 'Дополнительно к пресету банков';

  @override
  String appsSkipVpnSelected(int count) {
    return 'Выбрано $count · применится при следующем подключении';
  }

  @override
  String get switchToRulesForPresets =>
      'Чтобы пользоваться пресетами, включите режим Правила.';

  @override
  String get alwaysExcludeMerged =>
      'CIDR из Always-exclude сливаются с IP-direct при подключении для любого бэкенда. Править — в Расширенном ниже.';

  @override
  String get alwaysExcludeCidr => 'Всегда исключать (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Один IP или CIDR на строку. Применится при следующем подключении.';

  @override
  String get cidrHint => 'Один IP или CIDR на строку\nнапример 10.0.0.0/8';

  @override
  String get customRules => 'Свои правила';

  @override
  String get customRulesHint =>
      'Суффикс домена, IP или CIDR → proxy / direct / block. Применяются к Xray при подключении. IP direct также идёт в исключения ОС.';

  @override
  String get customRulesHintTrustTunnel =>
      'Домен или CIDR → proxy (остаётся в туннеле) или direct (исключение). Block недоступен. Без geosite.';

  @override
  String get matcher => 'Совпадение';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Добавить правило';

  @override
  String get noCustomRules => 'Пока нет своих правил';

  @override
  String osExclude(String action) {
    return '$action · исключение ОС';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · пропускается на TrustTunnel (в плагине нет block)';

  @override
  String get enableAdvancedForRouting =>
      'Включите расширенный режим в Настройках для дополнительных правил.';

  @override
  String get searchApps => 'Поиск приложений';

  @override
  String get save => 'Сохранить';

  @override
  String get routingBannerXray =>
      'Профиль Xray: Global / Rules / Direct и доменные правила применяются при подключении.';

  @override
  String get routingBannerHysteria =>
      'Профиль Hysteria2: доменные/block правила и Xray Direct не применяются. Используйте Global; Always-exclude CIDR и IP-direct всё равно попадают в TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: домены/CIDR с действием direct становятся исключениями. Block пропускается (в плагине нет block). Режим Direct не применяется. Always-exclude по-прежнему сливается. Per-app split только у SOCKS. Kill Switch — при следующем Connect TrustTunnel.';

  @override
  String get routingBannerUnknown =>
      'Выберите или подключите профиль, чтобы увидеть доступные правила.';

  @override
  String get logsEyebrow => 'Диагностика';

  @override
  String get logsTitle => 'Логи';

  @override
  String get copyFiltered => 'Копировать отфильтрованное';

  @override
  String get clear => 'Очистить';

  @override
  String get logCopied => 'Лог скопирован';

  @override
  String get logsHint =>
      'Консоль ядра. Цвета эвристические (слова error/warn).';

  @override
  String get filterHint => 'Фильтр…';

  @override
  String get logsAll => 'Все';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'Пока нет строк лога';

  @override
  String get noMatchesForFilter => 'Нет совпадений с фильтром';

  @override
  String get vpnConsole => 'Консоль VPN';

  @override
  String get logsSheetEmpty => 'Пока пусто. Ждём поток…';

  @override
  String get copy => 'Копировать';

  @override
  String get openLogs => 'Открыть логи';

  @override
  String get tapToRetry => 'Нажмите, чтобы повторить';

  @override
  String get homeErrorTitle => 'Не удалось подключиться';

  @override
  String get homeErrorTunnel =>
      'Туннель не поднялся — нажмите, чтобы повторить';

  @override
  String get homeErrorSocks =>
      'Локальный SOCKS не поднялся — нажмите, чтобы повторить';

  @override
  String get activeProfile => 'АКТИВНЫЙ ПРОФИЛЬ';

  @override
  String get socksInbound => 'Локальный SOCKS';

  @override
  String get socksInboundSubtitle =>
      'Пустые логин и пароль — случайные на каждое подключение. Другие приложения: 127.0.0.1 и эти данные.';

  @override
  String get socksPort => 'Порт';

  @override
  String get socksUsername => 'Имя пользователя';

  @override
  String get socksPassword => 'Пароль';

  @override
  String get saveSocks => 'Сохранить SOCKS';

  @override
  String get socksSaved => 'SOCKS сохранён';

  @override
  String get killSwitchAndroidConfirmTitle => 'Always-on включён?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'Приложение само не переключает системные тумблеры VPN. Включайте Kill Switch здесь только после Always-on и «Блокировать соединения без VPN» для GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Да, включены';

  @override
  String get killSwitchAndroidConfirmNo => 'Ещё нет';

  @override
  String get killSwitchIosDisconnectFailed =>
      'Не удалось снять on-demand. Disconnect может не закрепиться — повторите.';

  @override
  String get support => 'Поддержка';

  @override
  String get supportSubtitle => 'Открыть страницу поддержки оператора';

  @override
  String get supportUnavailable => 'В этой подписке нет URL поддержки';

  @override
  String get licenses => 'Лицензии open-source';

  @override
  String get licensesSubtitle =>
      'Компоненты с открытым кодом в этом приложении';

  @override
  String get licensesBody =>
      'Сетевые библиотеки, Flutter и Inter (SIL OFL) входят в сборку. Исходники и лицензии — в списке ниже и в репозиториях проектов.';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingDone => 'Начать';

  @override
  String get onboardingServerTitle => 'Ваш сервер';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN — клиент к ноде, которую вы импортируете. Облачного прокси Goodwin нет. Добавьте share-ссылку или https URL подписки на экране Профили.';

  @override
  String get onboardingVpnTitle => 'Системный VPN';

  @override
  String get onboardingVpnBody =>
      'Connect просит ОС добавить VPN-конфигурацию. Этот диалог от Android или iOS, не от приложения. Трафик пойдёт на ноду выбранного профиля.';

  @override
  String get onboardingCameraTitle => 'Камера для QR';

  @override
  String get onboardingCameraBody =>
      'Камера необязательна и только сканирует QR с share-ссылкой или URL подписки. Кадры остаются на устройстве.';

  @override
  String get vpnExplainerTitle => 'Разрешение системного VPN';

  @override
  String get vpnExplainerBody =>
      'Следующий экран — системный диалог VPN. Разрешайте, только если устройство должно слать трафик на импортированную ноду.';

  @override
  String get vpnExplainerContinue => 'Продолжить';

  @override
  String get cameraExplainerTitle => 'Доступ к камере';

  @override
  String get cameraExplainerBody =>
      'Следующий экран может запросить камеру. Она нужна только чтобы считать QR с конфигурацией. Кадры никуда не загружаются.';

  @override
  String get cameraExplainerContinue => 'Сканировать QR';

  @override
  String get importLinkHint =>
      'Вставьте share-ссылку или https:// URL подписки. Приложение само прокси не поднимает.';
}
