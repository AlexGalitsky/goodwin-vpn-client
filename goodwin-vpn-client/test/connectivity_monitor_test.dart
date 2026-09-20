import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/session/connectivity_monitor.dart';

void main() {
  test('connectivityKey ignores Apple VPN other/vpn noise', () {
    expect(connectivityKey([ConnectivityResult.wifi]), 'wifi');
    expect(
      connectivityKey([ConnectivityResult.wifi, ConnectivityResult.other]),
      'wifi',
    );
    expect(
      connectivityKey([ConnectivityResult.wifi, ConnectivityResult.vpn]),
      'wifi',
    );
    expect(connectivityKey([ConnectivityResult.other]), 'online');
    expect(connectivityKey([ConnectivityResult.vpn]), 'online');
    expect(connectivityKey([ConnectivityResult.none]), 'none');
  });

  test('connectivityKey still distinguishes wifi ↔ mobile', () {
    expect(connectivityKey([ConnectivityResult.wifi]), isNot(connectivityKey([ConnectivityResult.mobile])));
    expect(
      connectivityKey([ConnectivityResult.wifi, ConnectivityResult.mobile]),
      'mobile+wifi',
    );
  });
}
