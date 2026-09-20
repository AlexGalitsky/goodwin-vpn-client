import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../domain/log_line.dart';
import 'logs_console_view.dart';

/// Advanced Logs tab — live console from [VpnConnectionBloc].
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final _filterController = TextEditingController();
  LogLineLevel? _minLevel;

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            GwPageHeader(
              eyebrow: context.l10n.logsEyebrow,
              title: context.l10n.logsTitle,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GwIconButton(
                    tooltip: context.l10n.copyFiltered,
                    icon: Icons.copy,
                    onPressed: () async {
                      final logs =
                          context.read<VpnConnectionBloc>().state.logs;
                      final filtered = filterLogLines(
                        logs,
                        query: _filterController.text,
                        minLevel: _minLevel,
                      );
                      if (filtered.isEmpty) return;
                      await Clipboard.setData(
                        ClipboardData(text: filtered.join('\n')),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.logCopied)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  GwIconButton(
                    tooltip: context.l10n.clear,
                    icon: Icons.delete_outline,
                    onPressed: () {
                      context.read<VpnConnectionBloc>().clearLogs();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      context.l10n.logsHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: TextField(
                      controller: _filterController,
                      onTapOutside: gwUnfocusOnTapOutside,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: context.l10n.filterHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FilterChip(
                          label: Text(context.l10n.logsAll),
                          selected: _minLevel == null,
                          onSelected: (_) => setState(() => _minLevel = null),
                        ),
                        FilterChip(
                          label: Text(context.l10n.logsWarnPlus),
                          selected: _minLevel == LogLineLevel.warning,
                          onSelected: (_) => setState(
                            () => _minLevel = LogLineLevel.warning,
                          ),
                        ),
                        FilterChip(
                          label: Text(context.l10n.logsError),
                          selected: _minLevel == LogLineLevel.error,
                          onSelected: (_) => setState(
                            () => _minLevel = LogLineLevel.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
                      buildWhen: (p, n) => p.logs != n.logs,
                      builder: (context, conn) {
                        final filtered = filterLogLines(
                          conn.logs,
                          query: _filterController.text,
                          minLevel: _minLevel,
                        );
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLowest,
                          ),
                          child: LogsConsoleView(
                            lines: filtered,
                            emptyLabel: conn.logs.isEmpty
                                ? context.l10n.noLogLinesYet
                                : context.l10n.noMatchesForFilter,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
