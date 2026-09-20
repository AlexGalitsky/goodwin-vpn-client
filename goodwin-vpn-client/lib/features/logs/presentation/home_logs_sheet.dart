import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../session/vpn_connection_state.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'logs_console_view.dart';

/// Compact Advanced mini-console over Home (`tabs_ideas` «шторка»).
Future<void> showHomeLogsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: context.read<VpnConnectionBloc>(),
        child: const _HomeLogsSheet(),
      );
    },
  );
}

class _HomeLogsSheet extends StatelessWidget {
  const _HomeLogsSheet();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.42;

    return SizedBox(
      height: height,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.vpnConsole,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
                  buildWhen: (p, n) => p.logs != n.logs,
                  builder: (context, state) {
                    final lines = state.logs.take(16).toList(growable: false);
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLowest,
                      ),
                      child: LogsConsoleView(
                        lines: lines,
                        emptyLabel: context.l10n.logsSheetEmpty,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final logs =
                          context.read<VpnConnectionBloc>().state.logs;
                      if (logs.isEmpty) return;
                      await Clipboard.setData(
                        ClipboardData(text: logs.join('\n')),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.logCopied)),
                      );
                    },
                    child: Text(context.l10n.copy),
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/logs');
                    },
                    child: Text(context.l10n.openLogs),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
