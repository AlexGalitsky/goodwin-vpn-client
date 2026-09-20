import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../session/import_uri.dart';
import '../../../session/subscription_parser.dart';
import '../../connection/presentation/bloc/connection_selection_cubit.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'import_flow.dart';

/// Listens for `goodwin://import?url=` while the app is running.
class ImportLinkBinder extends StatefulWidget {
  const ImportLinkBinder({super.key, required this.child});

  final Widget child;

  @override
  State<ImportLinkBinder> createState() => _ImportLinkBinderState();
}

class _ImportLinkBinderState extends State<ImportLinkBinder> {
  StreamSubscription<Uri>? _sub;
  final _seen = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _listen());
  }

  Future<void> _listen() async {
    if (!mounted) return;
    try {
      final links = AppLinks();
      final initial = await links.getInitialLink();
      if (initial != null) await _handle(initial);
      if (!mounted) return;
      _sub = links.uriLinkStream.listen(_handle);
    } catch (_) {
      // Plugin missing in tests / desktop stubs.
    }
  }

  Future<void> _handle(Uri uri) async {
    if (!isGoodwinImportUri(uri)) return;
    if (!_seen.add(uri.toString())) return;
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final message = await applyImportedText(
        vpn: context.read<VpnConnectionBloc>(),
        selection: context.read<ConnectionSelectionCubit>(),
        l10n: context.l10n,
        raw: uri.toString(),
      );
      if (!mounted) return;
      context.go('/servers');
      messenger?.showSnackBar(SnackBar(content: Text(message)));
    } on ImportUriException catch (e) {
      messenger?.showSnackBar(SnackBar(content: Text(e.message)));
    } on ShareLinkParseException {
      messenger?.showSnackBar(
        SnackBar(content: Text(context.l10n.unrecognizedShareLink)),
      );
    } on SubscriptionParseException catch (e) {
      messenger?.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger?.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
