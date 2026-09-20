import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../ui/ui.dart';
import '../settings/presentation/bloc/app_settings_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _page = PageController();
  var _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _finish() {
    context.read<AppSettingsBloc>().add(const AppSettingsOnboardingCompleted());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.gw;
    final pages = [
      (
        icon: Icons.dns_outlined,
        title: l10n.onboardingServerTitle,
        body: l10n.onboardingServerBody,
      ),
      (
        icon: Icons.vpn_lock_outlined,
        title: l10n.onboardingVpnTitle,
        body: l10n.onboardingVpnBody,
      ),
      (
        icon: Icons.qr_code_scanner_rounded,
        title: l10n.onboardingCameraTitle,
        body: l10n.onboardingCameraBody,
      ),
    ];
    final last = _index >= pages.length - 1;
    return GwCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              GwSpacing.screen,
              GwSpacing.xl,
              GwSpacing.screen,
              GwSpacing.lg,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: GwSizes.touchTarget,
                  child: last
                      ? null
                      : Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _finish,
                            child: Text(l10n.onboardingSkip),
                          ),
                        ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _page,
                    itemCount: pages.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) {
                      final page = pages[i];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 88,
                                    height: 88,
                                    decoration: BoxDecoration(
                                      color: colors.accentMuted,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colors.accent
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Icon(
                                      page.icon,
                                      size: 40,
                                      color: colors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: GwSpacing.xxl),
                                  Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(height: GwSpacing.lg),
                                  GwCard(
                                    child: Text(
                                      page.body,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: colors.textSecondary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: GwSpacing.lg),
                Row(
                  children: [
                    for (var i = 0; i < pages.length; i++)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (last) {
                          _finish();
                          return;
                        }
                        _page.nextPage(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text(
                        last ? l10n.onboardingDone : l10n.onboardingNext,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
