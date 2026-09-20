import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../session/backup_codec.dart';
import '../../../../session/connection_controller.dart';
import '../../../../session/vpn_connection_state.dart';
import '../../../../vpn/system_tunnel.dart';

/// App-scoped VPN FSM — thin Cubit over [ConnectionController].
class VpnConnectionBloc extends Cubit<VpnConnectionState> {
  VpnConnectionBloc({
    required ConnectionController controller,
    required SystemTunnel tunnel,
  })  : _controller = controller,
        _tunnel = tunnel,
        super(controller.state);

  final ConnectionController _controller;
  final SystemTunnel _tunnel;

  /// Called from [ConnectionController.onState].
  void emitState(VpnConnectionState next) {
    if (!isClosed) emit(next);
  }

  Future<void> connect(String shareLink) => _controller.connect(shareLink);

  Future<void> disconnect() => _controller.disconnect();

  Future<bool> requestElevation() => _tunnel.requestElevation();

  bool get tunnelSupported => _tunnel.isSupported;

  Future<void> restoreFromOs() => _controller.restoreFromOs();

  Future<void> setAutoConnect(bool enabled) =>
      _controller.setAutoConnect(enabled);

  Future<void> setSmartConnect(bool enabled) =>
      _controller.setSmartConnect(enabled);

  Future<String?> lastShareLink() => _controller.store.lastShareLink();

  Future<void> selectShareLink(String link) =>
      _controller.selectShareLink(link);

  Future<void> saveShareLinkToList(String link, {String? name}) =>
      _controller.saveShareLinkToList(link, name: name);

  Future<void> removeSavedProfile(String id) =>
      _controller.removeSavedProfile(id);

  Future<void> updateSavedProfile({
    required String id,
    String? name,
    String? link,
  }) =>
      _controller.updateSavedProfile(id: id, name: name, link: link);

  Future<void> setExcludeRoutes(List<String> routes) =>
      _controller.setExcludeRoutes(routes);

  Future<void> setDisallowedPackages(List<String> packages) =>
      _controller.setDisallowedPackages(packages);

  Future<void> importInput(String raw, {String? name}) =>
      _controller.importInput(raw, name: name);

  Future<BackupMergeResult> restoreBackup(ProfileBackup backup) =>
      _controller.restoreBackup(backup);

  Future<void> refreshSubscription(String id) =>
      _controller.refreshSubscription(id);

  Future<void> removeSubscription(String id) =>
      _controller.removeSubscription(id);

  Future<void> refreshDueSubscriptions() =>
      _controller.refreshDueSubscriptions();

  void clearLogs() => _controller.clearLogs();

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
