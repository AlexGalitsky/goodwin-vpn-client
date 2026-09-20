import 'dart:convert';
import 'dart:io';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

Directory resolveRepoRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 6; i++) {
    final marker = File('${dir.path}${Platform.pathSeparator}development-plan.md');
    if (marker.existsSync()) return dir.absolute;
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  throw StateError('repo root not found from ${Directory.current.path}');
}

Future<String> curlViaSocks({required int port, required String url}) async {
  final curl = Platform.isWindows ? 'curl.exe' : 'curl';
  final result = await Process.run(curl, [
    '-sS',
    '--max-time',
    '20',
    '--socks5-hostname',
    '127.0.0.1:$port',
    '--proxy-user',
    'gw:test',
    url,
  ]);
  if (result.exitCode != 0) {
    throw ProcessException(curl, [], '${result.stderr}', result.exitCode);
  }
  return (result.stdout as String).trim();
}

Future<void> runSmokeTest() async {
  final root = resolveRepoRoot();
  final secretsDir = Directory(
    '${root.path}${Platform.pathSeparator}configs${Platform.pathSeparator}secrets',
  );
  final uriFile = File('${secretsDir.path}${Platform.pathSeparator}vless.url');
  final configFile = File('${secretsDir.path}${Platform.pathSeparator}xray-test.json');

  late final String jsonConfig;
  if (uriFile.existsSync()) {
    final profile = const ShareLinkParser().parse(uriFile.readAsStringSync());
    if (profile is! XrayProfile) {
      throw StateError('vless.url did not parse to XrayProfile');
    }
    jsonConfig = const XrayConfigBuilder(
      socksUser: 'gw',
      socksPass: 'test',
    ).buildJson(profile);
    configFile.writeAsStringSync(jsonConfig);
    stdout.writeln('built config from vless.url via goodwin_vpn_core');
  } else if (configFile.existsSync()) {
    jsonConfig = configFile.readAsStringSync();
  } else {
    throw StateError('missing ${uriFile.path} or ${configFile.path}');
  }

  final socksPort = _socksPortFromConfig(jsonConfig);
  final dllPath = const NativeLibraryLocator().resolve();
  final lib = LibXray.open(dllPath);
  stdout.writeln('dll: $dllPath');
  stdout.writeln('xray-core: ${lib.version()}');

  const instance = 'dart-smoke';
  final started = lib.start(instance, jsonConfig);
  stdout.writeln('Start status=${started.status} type=${started.contentType} body=${started.body}');
  if (!started.ok) {
    exitCode = 1;
    return;
  }
  if (!lib.isStarted(instance)) {
    stderr.writeln('IsStarted returned false');
    exitCode = 1;
    return;
  }

  try {
    await Future<void>.delayed(const Duration(seconds: 1));
    stdout.writeln('probing https://ifconfig.me/ip via socks5://127.0.0.1:$socksPort ...');
    final ip = await curlViaSocks(port: socksPort, url: 'https://ifconfig.me/ip');
    stdout.writeln('exit IP via proxy: $ip');
  } finally {
    lib.stop(instance);
    stdout.writeln('stopped');
  }
}

int _socksPortFromConfig(String jsonConfig) {
  final map = jsonDecode(jsonConfig) as Map<String, dynamic>;
  final inbounds = map['inbounds'] as List<dynamic>;
  for (final raw in inbounds) {
    final ib = raw as Map<String, dynamic>;
    if (ib['protocol'] == 'socks') {
      return ib['port'] as int;
    }
  }
  return 10808;
}
