import '../../../l10n/app_localizations.dart';
import '../../../session/import_uri.dart';
import '../../../session/subscription.dart';
import '../../connection/presentation/bloc/connection_selection_cubit.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';

Future<String> applyImportedText({
  required VpnConnectionBloc vpn,
  required ConnectionSelectionCubit selection,
  required AppLocalizations l10n,
  required String raw,
  String? name,
}) async {
  final text = unwrapImportText(raw);
  if (text.isEmpty) {
    throw ImportUriException(l10n.nothingToImport);
  }
  await vpn.importInput(text, name: name);
  final state = vpn.state;
  if (looksLikeSubscriptionUrl(text)) {
    final sub = state.subscriptions.where((s) => s.url == text).firstOrNull;
    final first = state.savedProfiles
        .where((p) => p.subscriptionId == sub?.id)
        .firstOrNull;
    if (first != null) {
      selection.selectProfile(first.id);
      await vpn.selectShareLink(first.link);
    }
    if (sub == null) return l10n.subscriptionImported;
    final count =
        state.savedProfiles.where((p) => p.subscriptionId == sub.id).length;
    return l10n.importedSubscriptionNodes(sub.name, count);
  }
  final imported =
      state.savedProfiles.where((p) => p.link == text).firstOrNull;
  if (imported != null) {
    selection.selectProfile(imported.id);
    await vpn.selectShareLink(text);
  }
  return l10n.profileImported;
}
