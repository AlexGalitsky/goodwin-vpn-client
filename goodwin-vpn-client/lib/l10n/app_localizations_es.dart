// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Inicio';

  @override
  String get navProfiles => 'Perfiles';

  @override
  String get navRules => 'Reglas';

  @override
  String get navLogs => 'Registros';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get connectVpn => 'Conectar VPN';

  @override
  String get disconnectVpn => 'Desconectar VPN';

  @override
  String get noProfile => 'Sin perfil';

  @override
  String get addProfileToConnect => 'Agrega un perfil para conectar';

  @override
  String get addProfileToConnectHint =>
      'Importa un enlace para compartir en Perfiles y luego toca Conectar aquí.';

  @override
  String get addProfile => 'Agregar perfil';

  @override
  String get networkStatus => 'ESTADO DE LA RED';

  @override
  String get tapToDisconnect => 'Toca para desconectar';

  @override
  String get tapToConnect => 'Toca para conectar';

  @override
  String get statNode => 'Nodo';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Tiempo activo';

  @override
  String get sessionLogs => 'Registros de sesión';

  @override
  String get noLinesYet => 'Aún no hay líneas';

  @override
  String logLinesCount(int count) {
    return '$count líneas';
  }

  @override
  String get uacDeclined => 'Se rechazó el aviso de UAC';

  @override
  String get statusOffline => 'desconectado';

  @override
  String get statusConnecting => 'conectando';

  @override
  String get statusConnected => 'conectado';

  @override
  String get statusDisconnecting => 'desconectando';

  @override
  String get statusError => 'error';

  @override
  String get switchProfile => 'Cambiar perfil';

  @override
  String get manageProfiles => 'Administrar perfiles';

  @override
  String get routing => 'Enrutamiento';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · cambiar en Reglas';
  }

  @override
  String get routingModeGlobal => 'Global';

  @override
  String get routingModeRules => 'Reglas';

  @override
  String get routingModeDirect => 'Directo';

  @override
  String get homeReadyTitle => 'Desconectado';

  @override
  String get homeReadyTunnel =>
      'Conectar inicia un VPN del sistema en este dispositivo';

  @override
  String get homeReadySocks =>
      'Este SO aún no tiene VPN del sistema — Conectar es un proxy SOCKS local';

  @override
  String get homeBusyTitle => 'Conectando';

  @override
  String get homeBusyTunnel => 'Solicitando un túnel VPN al SO';

  @override
  String get homeBusySocks => 'Iniciando un proxy SOCKS local';

  @override
  String get homeConnectedTunnelTitle => 'VPN del sistema';

  @override
  String get homeConnectedTunnelSubtitle =>
      'El tráfico del dispositivo pasa por el túnel, no por tu IP de casa';

  @override
  String get homeConnectedSocksTitle => 'SOCKS local';

  @override
  String get homeConnectedSocksSubtitle =>
      'No hay túnel del sistema en este SO. Las apps deben usar 127.0.0.1:10808 — tu IP no está oculta';

  @override
  String get revokedTitle => 'Se revocó el enlace de suscripción';

  @override
  String get revokedBody =>
      'Pega una URL nueva en Perfiles. Los nodos antiguos se quedan hasta que importes un reemplazo.';

  @override
  String get openProfiles => 'Abrir Perfiles';

  @override
  String get elevationTitle => 'Se requieren derechos de administrador';

  @override
  String get runAsAdministrator => 'Ejecutar como administrador';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used usados · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'vencido';

  @override
  String quotaDaysLeft(int days) {
    return '$days d restantes';
  }

  @override
  String get quotaScopeNote => 'Tráfico VLESS+Hy2 — TrustTunnel sin contar';

  @override
  String get profilesEyebrow => 'Tu red';

  @override
  String get profilesTitle => 'Perfiles de servidor';

  @override
  String get tooltipPinging => 'Midiendo Ping…';

  @override
  String get tooltipCheckPing => 'Comprobar Ping';

  @override
  String get noProfilesToPing => 'No hay perfiles para hacer ping';

  @override
  String get tooltipImportLink => 'Importar enlace o suscripción';

  @override
  String get searchServersHint => 'Buscar servidores o protocolos';

  @override
  String get smartConnect => 'Conexión inteligente';

  @override
  String get smartConnectSubtitle =>
      'Conectar en Inicio usa el nodo con el Ping más bajo de la suscripción actual';

  @override
  String get emptyProfiles =>
      'Aún no hay perfiles guardados.\nImporta un enlace para compartir o una URL de suscripción https://.';

  @override
  String get noMatches => 'Sin coincidencias';

  @override
  String get pinging => 'Ping en curso';

  @override
  String get fastest => 'más rápido';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteProfileConfirm => '¿Eliminar este perfil?';

  @override
  String get deleteSubscriptionConfirm =>
      '¿Quitar esta suscripción y sus nodos guardados?';

  @override
  String updatedSubscription(String name) {
    return 'Se actualizó $name';
  }

  @override
  String get importProfile => 'Importar perfil';

  @override
  String get nameOptional => 'Nombre (opcional)';

  @override
  String get importLinkLabel =>
      'Enlace para compartir o URL de suscripción https://';

  @override
  String get paste => 'Pegar';

  @override
  String get scanQr => 'Escanear QR';

  @override
  String get cancel => 'Cancelar';

  @override
  String get import => 'Importar';

  @override
  String get unrecognizedShareLink => 'Enlace para compartir no reconocido';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get name => 'Nombre';

  @override
  String get shareLink => 'Enlace para compartir';

  @override
  String get apply => 'Aplicar';

  @override
  String get importedManual => 'Importado';

  @override
  String get subscriptionFallback => 'Suscripción';

  @override
  String get revokedKeepNodes =>
      'Enlace revocado — pega una URL nueva. Los nodos no se borraron.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count nodos';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nodos',
      one: '1 nodo',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Actualizar suscripción';

  @override
  String get removeSubscription => 'Quitar suscripción';

  @override
  String get nothingToImport => 'Nada que importar';

  @override
  String get subscriptionImported => 'Suscripción importada';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return 'Se importó $name ($count nodos)';
  }

  @override
  String get profileImported => 'Perfil importado';

  @override
  String get settingsEyebrow => 'Aplicación';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get colorTheme => 'Tema de color';

  @override
  String get colorThemeSubtitle =>
      'Papel claro y azul marino oscuro. Sistema sigue el teléfono.';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Inglés y ruso. Sistema sigue el teléfono.';

  @override
  String get localeSystem => 'Sistema';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'General';

  @override
  String get advancedMode => 'Modo avanzado';

  @override
  String get advancedModeSubtitle =>
      'Pestaña de registros y opciones para usuarios avanzados';

  @override
  String get reconnectOnLaunch => 'Reconectar al iniciar';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Iniciar el último perfil si el VPN del SO está caído';

  @override
  String get dns => 'DNS';

  @override
  String get dnsSystem => 'Sistema';

  @override
  String get dnsCustom => 'Personalizado';

  @override
  String get dnsDoh => 'DoH';

  @override
  String get dnsServerLabel => 'Servidor DNS / URL DoH';

  @override
  String get dnsSaved => 'Preferencia de DNS guardada';

  @override
  String get saveDns => 'Guardar DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'VPN siempre activa en los ajustes de Android. Este interruptor por sí solo no evita fugas.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Bloqueo de fugas del plugin en el próximo Connect de TrustTunnel. Siempre activa sigue siendo necesaria después de reiniciar.';

  @override
  String get killSwitchSubtitleIos =>
      'Se reconecta si cae el túnel. Push, Watch e iMessage siguen alcanzables.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Bloqueo de fugas del plugin para esta sesión de TrustTunnel. Desconectar lo apaga antes de que pueda iniciar un VPN SOCKS.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Activar la protección del sistema contra fugas';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. En la siguiente pantalla, toca Goodwin VPN (SOCKS o TrustTunnel).\n2. Activa VPN siempre activa.\n3. Activa Bloquear conexiones sin VPN.\n4. Vuelve aquí y toca Conectar.\n\nLa app no puede cambiar esos interruptores de Android por sí sola. TrustTunnel también usa protección de fugas del plugin en el próximo Conectar.';

  @override
  String get killSwitchAndroidDisableTitle =>
      'Primero desactiva Siempre activa';

  @override
  String get killSwitchAndroidDisableBody =>
      'En los ajustes de VPN de Android, desactiva VPN siempre activa y Bloquear conexiones sin VPN para Goodwin. Si no, Desconectar volverá a levantar el túnel.';

  @override
  String get killSwitchOpenSettings => 'Abrir ajustes de VPN';

  @override
  String get killSwitchDisconnectTitle => 'Siempre activa puede reconectar';

  @override
  String get killSwitchDisconnectBody =>
      'La VPN siempre activa de Android puede traer el túnel de vuelta después de Desconectar. Desactiva Siempre activa en los ajustes de VPN del sistema si quieres la red totalmente abierta.';

  @override
  String get killSwitchDisconnectConfirm => 'Desconectar';

  @override
  String get coreTuning => 'Ajuste del núcleo';

  @override
  String get advancedDangerTooltip => 'Avanzado — puede romper la conectividad';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'No se usa con Vision — el VLESS típico arranca';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'No se usa en REALITY — solo TLS hello';

  @override
  String get dnsHintWithTuning =>
      'Las IP de DNS se aplican al TUN del SO al conectar. DoH va al JSON de Xray; el TUN sigue usando IP de arranque. Mux / Fragment: solo Xray.';

  @override
  String get dnsHintSimple =>
      'Las IP de DNS se aplican al TUN del SO al conectar.';

  @override
  String get backup => 'Respaldo';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Exportar archivo de respaldo';

  @override
  String get exportBackupSubtitle =>
      'Perfiles y suscripciones. Una contraseña opcional cifra el archivo';

  @override
  String get importBackup => 'Importar archivo de respaldo';

  @override
  String get importBackupSubtitle => 'Se fusiona con el catálogo actual';

  @override
  String get copyJsonClipboard => 'Copiar JSON al portapapeles';

  @override
  String get copyJsonClipboardSubtitle =>
      'Sin cifrar — cualquiera con el portapapeles puede leer los enlaces';

  @override
  String get copiedEmptyProfiles => 'Lista de perfiles vacía copiada';

  @override
  String copiedProfilesJson(int count) {
    return 'Se copiaron $count perfil(es) como JSON sin cifrar';
  }

  @override
  String get exportBackupTitle => 'Exportar respaldo';

  @override
  String get exportBackupPasswordHint =>
      'Déjalo vacío para un archivo JSON simple. Una contraseña usa AES-256-GCM.';

  @override
  String get backupFileSaved => 'Archivo de respaldo guardado';

  @override
  String get encryptedBackupSaved => 'Archivo de respaldo cifrado guardado';

  @override
  String get encryptedBackupTitle => 'Respaldo cifrado';

  @override
  String get encryptedBackupHint => 'Ingresa la contraseña usada al exportar.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return 'Se importaron $profiles perfil(es) y $subs suscripción(es)';
  }

  @override
  String get passwordOptional => 'Contraseña (opcional)';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get continueAction => 'Continuar';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutSubtitle => 'Cliente VPN para tu propio servidor';

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
  String get privacy => 'Privacidad';

  @override
  String get privacySubtitle =>
      'Cámara, VPN, secretos en el dispositivo, respaldos del portapapeles';

  @override
  String get privacyWhatTitle => 'Qué usa esta app';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN es un cliente local. En esta versión no hay servidor de cuenta Goodwin ni SDK de analítica.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'En plataformas con túnel del sistema, el tráfico del dispositivo se envía al nodo del enlace para compartir que importaste. La app no opera un proxy Goodwin. Si este SO no tiene túnel del sistema, Conectar solo inicia un proxy SOCKS local en 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Configs y secretos';

  @override
  String get privacySecretsBody =>
      'Los enlaces para compartir, perfiles guardados y URL de suscripción se almacenan en este dispositivo, cifrados con AES-256-GCM. La clave vive en el keystore / llavero del SO, no junto al texto cifrado. Si el keystore de la plataforma no está disponible, la app no puede mantener esos valores cifrados.';

  @override
  String get privacyCameraTitle => 'Cámara';

  @override
  String get privacyCameraBody =>
      'La cámara solo se usa para escanear un código QR con un enlace para compartir o una URL de suscripción. Los fotogramas no se suben.';

  @override
  String get privacyClipboardTitle => 'Portapapeles y respaldos';

  @override
  String get privacyClipboardBody =>
      'Copiar JSON al portapapeles escribe un respaldo sin cifrar. Quien pueda leer el portapapeles puede leer esos enlaces. La exportación a archivo puede usar una contraseña opcional (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Apps instaladas (Android)';

  @override
  String get privacyAppsBody =>
      'El túnel dividido por app lee la lista de apps del launcher en el dispositivo para que puedas excluir apps del VPN. Esa lista se queda en el dispositivo.';

  @override
  String get privacyOpenWeb => 'Abrir política de privacidad';

  @override
  String get privacyOpenFailed =>
      'No se pudo abrir la URL de la política de privacidad';

  @override
  String get rulesEyebrow => 'Política de tráfico';

  @override
  String get rulesTitle => 'Reglas de enrutamiento';

  @override
  String get reset => 'Restablecer';

  @override
  String get resetRulesConfirm =>
      '¿Restablecer el enrutamiento a los valores predeterminados?';

  @override
  String get mode => 'Modo';

  @override
  String get modeHintGlobalRich =>
      'Todo el tráfico coincidente → proxy (predeterminado de Xray).';

  @override
  String get modeHintGlobalSimple => 'Recomendado para Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Todo el tráfico por el túnel excepto Excluir siempre.';

  @override
  String get modeHintRules =>
      'Ajustes preestablecidos + reglas propias; lo no coincidente → proxy (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Los dominios/CIDR directos se vuelven exclusiones de TrustTunnel. Block se omite. Lo no coincidente se queda en el túnel.';

  @override
  String get modeHintDirect =>
      'Todo → freedom. El TUN sigue activo (solo Xray).';

  @override
  String get presets => 'Ajustes preestablecidos';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Bloquear anuncios (limitado)';

  @override
  String get presetBlockAdsPack => 'Bloquear anuncios';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Lista pequeña de hosts integrada → block (Xray; no geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'Paquete de anuncios de servicio → block (no geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Paquete de anuncios de servicio → exclusiones TrustTunnel (sin block del plugin)';

  @override
  String get presetBypassLan => 'Omitir LAN / privado';

  @override
  String get presetBypassLanSubtitle =>
      'CIDR RFC1918 / link-local → exclusiones TUN (no una región/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Omitir LAN necesita Android 13+. Las exclusiones CIDR no hacen nada en esta versión.';

  @override
  String get presetProtectBanking => 'Proteger banca';

  @override
  String get presetProtectBankingSubtitle =>
      'Las apps bancarias instaladas omiten el TUN (Android por app)';

  @override
  String get appsSkipVpn => 'Apps que omiten el VPN';

  @override
  String get appsSkipVpnEmpty => 'Extras opcionales además de Proteger banca';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count seleccionadas · se aplica en la próxima conexión';
  }

  @override
  String get switchToRulesForPresets =>
      'Cambia al modo Reglas para usar los ajustes preestablecidos.';

  @override
  String get alwaysExcludeMerged =>
      'Los CIDR de Excluir siempre se fusionan con las reglas IP-direct al conectar para cada backend. Edítalos en Avanzado abajo.';

  @override
  String get alwaysExcludeCidr => 'Excluir siempre (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Una IP o CIDR por línea. Se aplica en la próxima conexión.';

  @override
  String get cidrHint => 'Una IP o CIDR por línea\nej. 10.0.0.0/8';

  @override
  String get customRules => 'Reglas personalizadas';

  @override
  String get customRulesHint =>
      'Sufijo de dominio, IP o CIDR → proxy / direct / block. Se aplica a Xray al conectar. IP direct también alimenta exclusiones del SO.';

  @override
  String get customRulesHintTrustTunnel =>
      'Dominio o CIDR → proxy (quedarse en el túnel) o direct (excluir). Block no está disponible. Sin geosite.';

  @override
  String get matcher => 'Matcher';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Agregar regla';

  @override
  String get noCustomRules => 'Aún no hay reglas personalizadas';

  @override
  String osExclude(String action) {
    return '$action · exclusión del SO';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · omitido en TrustTunnel (sin block del plugin)';

  @override
  String get enableAdvancedForRouting =>
      'Activa el modo avanzado en Ajustes para controles extra de enrutamiento.';

  @override
  String get searchApps => 'Buscar apps';

  @override
  String get save => 'Guardar';

  @override
  String get routingBannerXray =>
      'Perfil Xray: Global / Reglas / Directo y las reglas de dominio se aplican al conectar.';

  @override
  String get routingBannerHysteria =>
      'Perfil Hysteria2: las reglas de dominio/block y Xray Direct no se aplican. Usa Global; los CIDR de Excluir siempre y IP-direct siguen fusionándose en el TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: los dominios/CIDR directos de Reglas se vuelven exclusiones. Block se omite (sin block del plugin). El modo Directo no se aplica. Excluir siempre sigue fusionándose. El split por app es solo SOCKS. Kill Switch se aplica en la próxima conexión TrustTunnel.';

  @override
  String get routingBannerUnknown =>
      'Selecciona o conecta un perfil para ver qué funciones de enrutamiento se aplican.';

  @override
  String get logsEyebrow => 'Diagnóstico';

  @override
  String get logsTitle => 'Registros';

  @override
  String get copyFiltered => 'Copiar filtrado';

  @override
  String get clear => 'Borrar';

  @override
  String get logCopied => 'Registro copiado';

  @override
  String get logsHint =>
      'Consola del núcleo. Los colores son heurísticos (palabras clave error/warn).';

  @override
  String get filterHint => 'Filtrar…';

  @override
  String get logsAll => 'Todos';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Error';

  @override
  String get noLogLinesYet => 'Aún no hay líneas de registro';

  @override
  String get noMatchesForFilter => 'Sin coincidencias para el filtro';

  @override
  String get vpnConsole => 'Consola VPN';

  @override
  String get logsSheetEmpty => 'Aún no hay líneas. Esperando el flujo…';

  @override
  String get copy => 'Copiar';

  @override
  String get openLogs => 'Abrir registros';

  @override
  String get tapToRetry => 'Toca para reintentar';

  @override
  String get homeErrorTitle => 'No se pudo conectar';

  @override
  String get homeErrorTunnel => 'Falló el túnel — toca para reintentar';

  @override
  String get homeErrorSocks => 'Falló el SOCKS local — toca para reintentar';

  @override
  String get activeProfile => 'PERFIL ACTIVO';

  @override
  String get socksInbound => 'SOCKS local';

  @override
  String get socksInboundSubtitle =>
      'Deja usuario y contraseña vacíos para generar credenciales aleatorias en cada conexión. Otras apps: 127.0.0.1 más esas credenciales.';

  @override
  String get socksPort => 'Puerto';

  @override
  String get socksUsername => 'Usuario';

  @override
  String get socksPassword => 'Contraseña';

  @override
  String get saveSocks => 'Guardar SOCKS';

  @override
  String get socksSaved => 'SOCKS guardado';

  @override
  String get killSwitchAndroidConfirmTitle => '¿Activaste Siempre activa?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'La app no puede cambiar los interruptores de VPN de Android. Activa el Kill Switch aquí solo después de que VPN siempre activa y Bloquear conexiones sin VPN estén activados para GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Sí, están activados';

  @override
  String get killSwitchAndroidConfirmNo => 'Todavía no';

  @override
  String get killSwitchIosDisconnectFailed =>
      'No se pudo desactivar on-demand. La desconexión puede no mantenerse hasta que reintentes.';

  @override
  String get support => 'Soporte';

  @override
  String get supportSubtitle => 'Abrir la página de soporte del operador';

  @override
  String get supportUnavailable => 'No hay URL de soporte en esta suscripción';

  @override
  String get licenses => 'Licencias de código abierto';

  @override
  String get licensesSubtitle => 'Núcleos y bibliotecas incluidos en esta app';

  @override
  String get licensesBody =>
      'Esta app incluye Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter e Inter (SIL OFL). El código fuente y las licencias están en los repositorios del proyecto.';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingDone => 'Empezar';

  @override
  String get onboardingServerTitle => 'Tu servidor';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN es un cliente para un nodo que importas. No hay un proxy en la nube Goodwin. Agrega un enlace para compartir o una URL de suscripción https en Perfiles.';

  @override
  String get onboardingVpnTitle => 'VPN del sistema';

  @override
  String get onboardingVpnBody =>
      'Conectar pide al SO que agregue una configuración VPN. Ese diálogo es de Android o iOS, no de esta app. El tráfico luego va al nodo del perfil que seleccionaste.';

  @override
  String get onboardingCameraTitle => 'Cámara para QR';

  @override
  String get onboardingCameraBody =>
      'La cámara es opcional y solo escanea un QR con un enlace para compartir o una URL de suscripción. Los fotogramas se quedan en el dispositivo.';

  @override
  String get vpnExplainerTitle => 'Permiso de VPN del sistema';

  @override
  String get vpnExplainerBody =>
      'La siguiente pantalla es el diálogo de VPN del SO. Permítelo solo si quieres que este dispositivo envíe tráfico por el nodo importado.';

  @override
  String get vpnExplainerContinue => 'Continuar';

  @override
  String get cameraExplainerTitle => 'Permiso de cámara';

  @override
  String get cameraExplainerBody =>
      'La siguiente pantalla puede pedir la cámara. Solo se usa para escanear un QR de configuración. Los fotogramas no se suben.';

  @override
  String get cameraExplainerContinue => 'Escanear QR';

  @override
  String get importLinkHint =>
      'Pega un enlace para compartir o una URL de suscripción https://. La app no aloja un proxy.';
}
