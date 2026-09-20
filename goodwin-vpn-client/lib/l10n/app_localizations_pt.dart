// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'GoodWin VPN';

  @override
  String get navHome => 'Início';

  @override
  String get navProfiles => 'Perfis';

  @override
  String get navRules => 'Regras';

  @override
  String get navLogs => 'Registros';

  @override
  String get navSettings => 'Configurações';

  @override
  String get connectVpn => 'Conectar VPN';

  @override
  String get disconnectVpn => 'Desconectar VPN';

  @override
  String get noProfile => 'Nenhum perfil';

  @override
  String get addProfileToConnect => 'Adicione um perfil para conectar';

  @override
  String get addProfileToConnectHint =>
      'Importe um link de compartilhamento em Perfis e toque em Conectar aqui.';

  @override
  String get addProfile => 'Adicionar perfil';

  @override
  String get networkStatus => 'STATUS DA REDE';

  @override
  String get tapToDisconnect => 'Toque para desconectar';

  @override
  String get tapToConnect => 'Toque para conectar';

  @override
  String get statNode => 'Nó';

  @override
  String get statPing => 'Ping';

  @override
  String get statUptime => 'Tempo ativo';

  @override
  String get sessionLogs => 'Registros da sessão';

  @override
  String get noLinesYet => 'Nenhuma linha ainda';

  @override
  String logLinesCount(int count) {
    return '$count linhas';
  }

  @override
  String get uacDeclined => 'O aviso do UAC foi recusado';

  @override
  String get statusOffline => 'desconectado';

  @override
  String get statusConnecting => 'conectando';

  @override
  String get statusConnected => 'conectado';

  @override
  String get statusDisconnecting => 'desconectando';

  @override
  String get statusError => 'erro';

  @override
  String get switchProfile => 'Trocar perfil';

  @override
  String get manageProfiles => 'Gerenciar perfis';

  @override
  String get routing => 'Roteamento';

  @override
  String routingChipSubtitle(String mode) {
    return '$mode · alterar em Regras';
  }

  @override
  String get routingModeGlobal => 'Global';

  @override
  String get routingModeRules => 'Regras';

  @override
  String get routingModeDirect => 'Direto';

  @override
  String get homeReadyTitle => 'Desconectado';

  @override
  String get homeReadyTunnel =>
      'Conectar inicia um VPN do sistema neste dispositivo';

  @override
  String get homeReadySocks =>
      'Este SO ainda não tem VPN do sistema — Conectar é um proxy SOCKS local';

  @override
  String get homeBusyTitle => 'Conectando';

  @override
  String get homeBusyTunnel => 'Solicitando um túnel VPN ao SO';

  @override
  String get homeBusySocks => 'Iniciando um proxy SOCKS local';

  @override
  String get homeConnectedTunnelTitle => 'VPN do sistema';

  @override
  String get homeConnectedTunnelSubtitle =>
      'O tráfego do dispositivo passa pelo túnel, não pelo IP de casa';

  @override
  String get homeConnectedSocksTitle => 'SOCKS local';

  @override
  String get homeConnectedSocksSubtitle =>
      'Não há túnel do sistema neste SO. Os aplicativos devem usar 127.0.0.1:10808 — seu IP não está oculto';

  @override
  String get revokedTitle => 'O link da assinatura foi revogado';

  @override
  String get revokedBody =>
      'Cole uma URL nova em Perfis. Os nós antigos permanecem até você importar um substituto.';

  @override
  String get openProfiles => 'Abrir Perfis';

  @override
  String get elevationTitle => 'Direitos de administrador necessários';

  @override
  String get runAsAdministrator => 'Executar como administrador';

  @override
  String quotaUsedOfTotal(String used, String total) {
    return '$used / $total VLESS+Hy2';
  }

  @override
  String quotaUsedOnly(String used) {
    return '$used usados · VLESS+Hy2';
  }

  @override
  String get quotaExpired => 'expirado';

  @override
  String quotaDaysLeft(int days) {
    return '$days d restantes';
  }

  @override
  String get quotaScopeNote =>
      'Tráfego VLESS+Hy2 — TrustTunnel não contabilizado';

  @override
  String get profilesEyebrow => 'Sua rede';

  @override
  String get profilesTitle => 'Perfis de servidor';

  @override
  String get tooltipPinging => 'Medindo Ping…';

  @override
  String get tooltipCheckPing => 'Verificar Ping';

  @override
  String get noProfilesToPing => 'Nenhum perfil para fazer ping';

  @override
  String get tooltipImportLink => 'Importar link ou assinatura';

  @override
  String get searchServersHint => 'Buscar servidores ou protocolos';

  @override
  String get smartConnect => 'Conexão inteligente';

  @override
  String get smartConnectSubtitle =>
      'Conectar no Início usa o nó com o Ping mais baixo da assinatura atual';

  @override
  String get emptyProfiles =>
      'Ainda não há perfis salvos.\nImporte um link de compartilhamento ou uma URL de assinatura https://.';

  @override
  String get noMatches => 'Nenhuma correspondência';

  @override
  String get pinging => 'Ping em andamento';

  @override
  String get fastest => 'mais rápido';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteProfileConfirm => 'Excluir este perfil?';

  @override
  String get deleteSubscriptionConfirm =>
      'Remover esta assinatura e os nós salvos?';

  @override
  String updatedSubscription(String name) {
    return '$name atualizado';
  }

  @override
  String get importProfile => 'Importar perfil';

  @override
  String get nameOptional => 'Nome (opcional)';

  @override
  String get importLinkLabel =>
      'Link de compartilhamento ou URL de assinatura https://';

  @override
  String get paste => 'Colar';

  @override
  String get scanQr => 'Escanear QR';

  @override
  String get cancel => 'Cancelar';

  @override
  String get import => 'Importar';

  @override
  String get unrecognizedShareLink =>
      'Link de compartilhamento não reconhecido';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get name => 'Nome';

  @override
  String get shareLink => 'Link de compartilhamento';

  @override
  String get apply => 'Aplicar';

  @override
  String get importedManual => 'Importado';

  @override
  String get subscriptionFallback => 'Assinatura';

  @override
  String get revokedKeepNodes =>
      'Link revogado — cole uma URL nova. Os nós não foram apagados.';

  @override
  String nodesWithQuota(String info, int count) {
    return '$info · $count nós';
  }

  @override
  String nodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nós',
      one: '1 nó',
    );
    return '$_temp0';
  }

  @override
  String get refreshSubscription => 'Atualizar assinatura';

  @override
  String get removeSubscription => 'Remover assinatura';

  @override
  String get nothingToImport => 'Nada para importar';

  @override
  String get subscriptionImported => 'Assinatura importada';

  @override
  String importedSubscriptionNodes(String name, int count) {
    return '$name importado ($count nós)';
  }

  @override
  String get profileImported => 'Perfil importado';

  @override
  String get settingsEyebrow => 'Aplicativo';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get appearance => 'Aparência';

  @override
  String get colorTheme => 'Tema de cores';

  @override
  String get colorThemeSubtitle =>
      'Papel claro e azul-marinho escuro. Sistema segue o telefone.';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Inglês e russo. Sistema segue o telefone.';

  @override
  String get localeSystem => 'Sistema';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get general => 'Geral';

  @override
  String get advancedMode => 'Modo avançado';

  @override
  String get advancedModeSubtitle =>
      'Aba de registros e opções para usuários avançados';

  @override
  String get reconnectOnLaunch => 'Reconectar ao iniciar';

  @override
  String get reconnectOnLaunchSubtitle =>
      'Iniciar o último perfil se o VPN do SO estiver desligado';

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
  String get dnsSaved => 'Preferência de DNS salva';

  @override
  String get saveDns => 'Salvar DNS';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchSubtitleAndroid =>
      'VPN sempre ativa nas configurações do Android. Este interruptor sozinho não impede vazamentos.';

  @override
  String get killSwitchSubtitleAndroidTrustTunnel =>
      'Bloqueio de vazamento do plugin no próximo Connect do TrustTunnel. Sempre ativa ainda é necessária após reiniciar.';

  @override
  String get killSwitchSubtitleIos =>
      'Reconecta se o túnel cair. Push, Watch e iMessage continuam acessíveis.';

  @override
  String get killSwitchSubtitleIosTrustTunnel =>
      'Bloqueio de vazamento do plugin para esta sessão TrustTunnel. Desconectar desliga isso antes que um VPN SOCKS possa iniciar.';

  @override
  String get killSwitchAndroidEnableTitle =>
      'Ativar a proteção do sistema contra vazamentos';

  @override
  String get killSwitchAndroidEnableBody =>
      '1. Na próxima tela, toque em Goodwin VPN (SOCKS ou TrustTunnel).\n2. Ative VPN sempre ativa.\n3. Ative Bloquear conexões sem VPN.\n4. Volte aqui e toque em Conectar.\n\nO aplicativo não consegue alterar esses interruptores do Android sozinho. O TrustTunnel também usa proteção de vazamento do plugin no próximo Conectar.';

  @override
  String get killSwitchAndroidDisableTitle => 'Desative Sempre ativa primeiro';

  @override
  String get killSwitchAndroidDisableBody =>
      'Nas configurações de VPN do Android, desative VPN sempre ativa e Bloquear conexões sem VPN para Goodwin. Caso contrário, Desconectar trará o túnel de volta.';

  @override
  String get killSwitchOpenSettings => 'Abrir configurações de VPN';

  @override
  String get killSwitchDisconnectTitle => 'Sempre ativa pode reconectar';

  @override
  String get killSwitchDisconnectBody =>
      'A VPN sempre ativa do Android pode trazer o túnel de volta após Desconectar. Desative Sempre ativa nas configurações de VPN do sistema se você quiser a rede totalmente aberta.';

  @override
  String get killSwitchDisconnectConfirm => 'Desconectar';

  @override
  String get coreTuning => 'Ajuste do núcleo';

  @override
  String get advancedDangerTooltip => 'Avançado — pode quebrar a conectividade';

  @override
  String get mux => 'Mux';

  @override
  String get muxSubtitle => 'Ignorado com Vision — o VLESS típico inicia';

  @override
  String get fragment => 'Fragment';

  @override
  String get fragmentSubtitle => 'Ignorado no REALITY — só TLS hello';

  @override
  String get dnsHintWithTuning =>
      'Os IPs de DNS se aplicam ao TUN do SO ao conectar. DoH vai para o JSON do Xray; o TUN ainda usa IPs de bootstrap. Mux / Fragment: somente Xray.';

  @override
  String get dnsHintSimple =>
      'Os IPs de DNS se aplicam ao TUN do SO ao conectar.';

  @override
  String get backup => 'Backup';

  @override
  String get backupHubSubtitle => 'Export and import profiles';

  @override
  String get exportBackup => 'Exportar arquivo de backup';

  @override
  String get exportBackupSubtitle =>
      'Perfis e assinaturas. Uma senha opcional criptografa o arquivo';

  @override
  String get importBackup => 'Importar arquivo de backup';

  @override
  String get importBackupSubtitle => 'Mescla no catálogo atual';

  @override
  String get copyJsonClipboard => 'Copiar JSON para a área de transferência';

  @override
  String get copyJsonClipboardSubtitle =>
      'Sem criptografia — quem tiver a área de transferência pode ler os links';

  @override
  String get copiedEmptyProfiles => 'Lista de perfis vazia copiada';

  @override
  String copiedProfilesJson(int count) {
    return '$count perfil(is) copiado(s) como JSON sem criptografia';
  }

  @override
  String get exportBackupTitle => 'Exportar backup';

  @override
  String get exportBackupPasswordHint =>
      'Deixe vazio para um arquivo JSON simples. Uma senha usa AES-256-GCM.';

  @override
  String get backupFileSaved => 'Arquivo de backup salvo';

  @override
  String get encryptedBackupSaved => 'Arquivo de backup criptografado salvo';

  @override
  String get encryptedBackupTitle => 'Backup criptografado';

  @override
  String get encryptedBackupHint => 'Digite a senha usada na exportação.';

  @override
  String importedBackupCounts(int profiles, int subs) {
    return '$profiles perfil(is) e $subs assinatura(s) importados';
  }

  @override
  String get passwordOptional => 'Senha (opcional)';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get continueAction => 'Continuar';

  @override
  String get about => 'Sobre';

  @override
  String get aboutSubtitle => 'Cliente VPN para o seu próprio servidor';

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
  String get privacy => 'Privacidade';

  @override
  String get privacySubtitle =>
      'Câmera, VPN, segredos no dispositivo, backups da área de transferência';

  @override
  String get privacyWhatTitle => 'O que este aplicativo usa';

  @override
  String get privacyWhatBody =>
      'GoodWin VPN é um cliente local. Não há servidor de conta Goodwin nem SDK de análise nesta versão.';

  @override
  String get privacyVpnTitle => 'VPN';

  @override
  String get privacyVpnBody =>
      'Em plataformas com túnel do sistema, o tráfego do dispositivo é enviado ao nó do link de compartilhamento que você importou. O aplicativo não opera um proxy Goodwin. Se este SO não tiver túnel do sistema, Conectar inicia apenas um proxy SOCKS local em 127.0.0.1:10808.';

  @override
  String get privacySecretsTitle => 'Configs e segredos';

  @override
  String get privacySecretsBody =>
      'Links de compartilhamento, perfis salvos e URLs de assinatura são armazenados neste dispositivo, criptografados com AES-256-GCM. A chave fica no keystore / chaveiro do SO, não ao lado do texto cifrado. Se o keystore da plataforma estiver indisponível, o aplicativo não consegue manter esses valores criptografados.';

  @override
  String get privacyCameraTitle => 'Câmera';

  @override
  String get privacyCameraBody =>
      'A câmera é usada apenas para escanear um QR code com um link de compartilhamento ou uma URL de assinatura. Os frames não são enviados.';

  @override
  String get privacyClipboardTitle => 'Área de transferência e backups';

  @override
  String get privacyClipboardBody =>
      'Copiar JSON para a área de transferência grava um backup sem criptografia. Quem puder ler a área de transferência pode ler esses links. A exportação de arquivo pode usar uma senha opcional (AES-256-GCM).';

  @override
  String get privacyAppsTitle => 'Aplicativos instalados (Android)';

  @override
  String get privacyAppsBody =>
      'O split tunneling por aplicativo lê a lista de apps do launcher no dispositivo para você excluir aplicativos do VPN. Essa lista permanece no dispositivo.';

  @override
  String get privacyOpenWeb => 'Abrir política de privacidade';

  @override
  String get privacyOpenFailed =>
      'Não foi possível abrir a URL da política de privacidade';

  @override
  String get rulesEyebrow => 'Política de tráfego';

  @override
  String get rulesTitle => 'Regras de roteamento';

  @override
  String get reset => 'Redefinir';

  @override
  String get resetRulesConfirm => 'Redefinir o roteamento para os padrões?';

  @override
  String get mode => 'Modo';

  @override
  String get modeHintGlobalRich =>
      'Todo o tráfego correspondente → proxy (padrão do Xray).';

  @override
  String get modeHintGlobalSimple => 'Recomendado para Hysteria2.';

  @override
  String get modeHintGlobalTrustTunnel =>
      'Todo o tráfego pelo túnel, exceto Sempre excluir.';

  @override
  String get modeHintRules =>
      'Predefinições + regras próprias; o restante → proxy (Xray).';

  @override
  String get modeHintRulesTrustTunnel =>
      'Domínios/CIDRs diretos viram exclusões do TrustTunnel. Block é ignorado. O restante permanece no túnel.';

  @override
  String get modeHintDirect =>
      'Tudo → freedom. O TUN permanece ativo (somente Xray).';

  @override
  String get presets => 'Predefinições';

  @override
  String get presetsHubSubtitle => 'Ads, LAN, banking apps';

  @override
  String get customRulesHubSubtitle => 'Domain matchers and actions';

  @override
  String get excludeCidrHubSubtitle => 'CIDRs always outside the tunnel';

  @override
  String get presetBlockAds => 'Bloquear anúncios (limitado)';

  @override
  String get presetBlockAdsPack => 'Bloquear anúncios';

  @override
  String get presetBypassAdsPack => 'Bypass ads';

  @override
  String get presetBlockAdsSubtitle =>
      'Lista pequena de hosts embutida → block (Xray; não geosite)';

  @override
  String get presetBlockAdsPackXray =>
      'Pacote de anúncios de serviço → block (não geosite)';

  @override
  String get presetBlockAdsPackTrustTunnel =>
      'Pacote de anúncios de serviço → exclusões TrustTunnel (sem block do plugin)';

  @override
  String get presetBypassLan => 'Ignorar LAN / privado';

  @override
  String get presetBypassLanSubtitle =>
      'CIDRs RFC1918 / link-local → exclusões TUN (não uma região/geoip)';

  @override
  String get presetBypassLanAndroid13 =>
      'Ignorar LAN precisa do Android 13+. Exclusões CIDR não fazem nada nesta versão.';

  @override
  String get presetProtectBanking => 'Proteger banco';

  @override
  String get presetProtectBankingSubtitle =>
      'Aplicativos bancários instalados ignoram o TUN (Android por aplicativo)';

  @override
  String get appsSkipVpn => 'Aplicativos que ignoram o VPN';

  @override
  String get appsSkipVpnEmpty => 'Extras opcionais além de Proteger banco';

  @override
  String appsSkipVpnSelected(int count) {
    return '$count selecionados · aplicado na próxima conexão';
  }

  @override
  String get switchToRulesForPresets =>
      'Mude para o modo Regras para usar as predefinições.';

  @override
  String get alwaysExcludeMerged =>
      'Os CIDRs de Sempre excluir são mesclados com as regras IP-direct na conexão para cada backend. Edite-os em Avançado abaixo.';

  @override
  String get alwaysExcludeCidr => 'Sempre excluir (CIDR)';

  @override
  String get alwaysExcludeHint =>
      'Um IP ou CIDR por linha. Aplicado na próxima conexão.';

  @override
  String get cidrHint => 'Um IP ou CIDR por linha\nex.: 10.0.0.0/8';

  @override
  String get customRules => 'Regras personalizadas';

  @override
  String get customRulesHint =>
      'Sufixo de domínio, IP ou CIDR → proxy / direct / block. Aplicado ao Xray na conexão. IP direct também alimenta exclusões do SO.';

  @override
  String get customRulesHintTrustTunnel =>
      'Domínio ou CIDR → proxy (ficar no túnel) ou direct (excluir). Block não está disponível. Sem geosite.';

  @override
  String get matcher => 'Matcher';

  @override
  String get matcherHint => '.ads.example · 10.0.0.0/8';

  @override
  String get addRule => 'Adicionar regra';

  @override
  String get noCustomRules => 'Ainda não há regras personalizadas';

  @override
  String osExclude(String action) {
    return '$action · exclusão do SO';
  }

  @override
  String get routingRuleBlockSkipped =>
      'block · ignorado no TrustTunnel (sem block do plugin)';

  @override
  String get enableAdvancedForRouting =>
      'Ative o modo avançado em Configurações para controles extras de roteamento.';

  @override
  String get searchApps => 'Buscar aplicativos';

  @override
  String get save => 'Salvar';

  @override
  String get routingBannerXray =>
      'Perfil Xray: Global / Regras / Direto e regras de domínio se aplicam na conexão.';

  @override
  String get routingBannerHysteria =>
      'Perfil Hysteria2: regras de domínio/block e Xray Direct não são aplicadas. Use Global; CIDRs de Sempre excluir e IP-direct ainda são mesclados no TUN.';

  @override
  String get routingBannerTrustTunnel =>
      'TrustTunnel: domínios/CIDRs diretos de Regras viram exclusões. Block é ignorado (sem block do plugin). O modo Direto não é aplicado. Sempre excluir ainda é mesclado. Split por aplicativo é só SOCKS. Kill Switch se aplica na próxima conexão TrustTunnel.';

  @override
  String get routingBannerUnknown =>
      'Selecione ou conecte um perfil para ver quais recursos de roteamento se aplicam.';

  @override
  String get logsEyebrow => 'Diagnóstico';

  @override
  String get logsTitle => 'Registros';

  @override
  String get copyFiltered => 'Copiar filtrado';

  @override
  String get clear => 'Limpar';

  @override
  String get logCopied => 'Registro copiado';

  @override
  String get logsHint =>
      'Console do núcleo. As cores são heurísticas (palavras-chave error/warn).';

  @override
  String get filterHint => 'Filtrar…';

  @override
  String get logsAll => 'Todos';

  @override
  String get logsWarnPlus => 'Warn+';

  @override
  String get logsError => 'Erro';

  @override
  String get noLogLinesYet => 'Nenhuma linha de registro ainda';

  @override
  String get noMatchesForFilter => 'Nenhuma correspondência para o filtro';

  @override
  String get vpnConsole => 'Console VPN';

  @override
  String get logsSheetEmpty => 'Nenhuma linha ainda. Aguardando o fluxo…';

  @override
  String get copy => 'Copiar';

  @override
  String get openLogs => 'Abrir registros';

  @override
  String get tapToRetry => 'Toque para tentar de novo';

  @override
  String get homeErrorTitle => 'Não foi possível conectar';

  @override
  String get homeErrorTunnel => 'O túnel falhou — toque para tentar de novo';

  @override
  String get homeErrorSocks =>
      'O SOCKS local falhou — toque para tentar de novo';

  @override
  String get activeProfile => 'PERFIL ATIVO';

  @override
  String get socksInbound => 'SOCKS local';

  @override
  String get socksInboundSubtitle =>
      'Deixe usuário e senha vazios para gerar credenciais aleatórias a cada conexão. Outros aplicativos: 127.0.0.1 mais essas credenciais.';

  @override
  String get socksPort => 'Porta';

  @override
  String get socksUsername => 'Nome de usuário';

  @override
  String get socksPassword => 'Senha';

  @override
  String get saveSocks => 'Salvar SOCKS';

  @override
  String get socksSaved => 'SOCKS salvo';

  @override
  String get killSwitchAndroidConfirmTitle => 'Você ativou Sempre ativa?';

  @override
  String get killSwitchAndroidConfirmBody =>
      'O aplicativo não consegue alterar os interruptores de VPN do Android. Ative o Kill Switch aqui somente depois que VPN sempre ativa e Bloquear conexões sem VPN estiverem ativados para GoodWin VPN.';

  @override
  String get killSwitchAndroidConfirmYes => 'Sim, estão ativados';

  @override
  String get killSwitchAndroidConfirmNo => 'Ainda não';

  @override
  String get killSwitchIosDisconnectFailed =>
      'Não foi possível desligar o on-demand. A desconexão pode não persistir até você tentar de novo.';

  @override
  String get support => 'Suporte';

  @override
  String get supportSubtitle => 'Abrir a página de suporte do operador';

  @override
  String get supportUnavailable => 'Nenhuma URL de suporte nesta assinatura';

  @override
  String get licenses => 'Licenças de código aberto';

  @override
  String get licensesSubtitle =>
      'Núcleos e bibliotecas incluídos neste aplicativo';

  @override
  String get licensesBody =>
      'Este aplicativo inclui Xray-core, Hysteria 2, hev-socks5-tunnel, TrustTunnel, Flutter e Inter (SIL OFL). Código-fonte e licenças estão nos repositórios do projeto.';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingDone => 'Começar';

  @override
  String get onboardingServerTitle => 'Seu servidor';

  @override
  String get onboardingServerBody =>
      'GoodWin VPN é um cliente para um nó que você importa. Não há proxy na nuvem Goodwin. Adicione um link de compartilhamento ou uma URL de assinatura https em Perfis.';

  @override
  String get onboardingVpnTitle => 'VPN do sistema';

  @override
  String get onboardingVpnBody =>
      'Conectar pede ao SO para adicionar uma configuração VPN. Esse diálogo é do Android ou do iOS, não deste aplicativo. O tráfego então vai para o nó do perfil selecionado.';

  @override
  String get onboardingCameraTitle => 'Câmera para QR';

  @override
  String get onboardingCameraBody =>
      'A câmera é opcional e só escaneia um QR com um link de compartilhamento ou URL de assinatura. Os frames permanecem no dispositivo.';

  @override
  String get vpnExplainerTitle => 'Permissão de VPN do sistema';

  @override
  String get vpnExplainerBody =>
      'A próxima tela é o diálogo de VPN do SO. Permita apenas se você quiser que este dispositivo envie o tráfego pelo nó importado.';

  @override
  String get vpnExplainerContinue => 'Continuar';

  @override
  String get cameraExplainerTitle => 'Permissão da câmera';

  @override
  String get cameraExplainerBody =>
      'A próxima tela pode pedir a câmera. Ela é usada apenas para escanear um QR de configuração. Os frames não são enviados.';

  @override
  String get cameraExplainerContinue => 'Escanear QR';

  @override
  String get importLinkHint =>
      'Cole um link de compartilhamento ou uma URL de assinatura https://. O aplicativo não hospeda um proxy.';
}
