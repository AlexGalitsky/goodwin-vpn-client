import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/privacy_policy.dart';
import '../../../core/config/support_url.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../ui/ui.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'licenses_page.dart';
import 'privacy_page.dart';

/// Version / privacy / support — pushed from Settings hub.
class SettingsAboutPage extends StatefulWidget {
  const SettingsAboutPage({super.key});

  @override
  State<SettingsAboutPage> createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {
  var _versionLabel = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      final build = info.buildNumber.trim();
      setState(() {
        _versionLabel =
            build.isEmpty ? 'v${info.version}' : 'v${info.version}+$build';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.l10n.about),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          GwCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                GwSettingsRow(
                  title: 'GoodWin VPN',
                  subtitle: context.l10n.aboutSubtitle,
                  trailing: Text(
                    _versionLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Divider(color: context.gw.cardBorder, height: 1),
                GwSettingsRow(
                  title: context.l10n.privacy,
                  subtitle: context.l10n.privacySubtitle,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: context.gw.textMuted,
                  ),
                  onTap: () {
                    final url = privacyPolicyUrlFor(
                      context.read<VpnConnectionBloc>().state.subscriptions,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PrivacyPage(policyUrl: url),
                      ),
                    );
                  },
                ),
                Divider(color: context.gw.cardBorder, height: 1),
                GwSettingsRow(
                  title: context.l10n.support,
                  subtitle: context.l10n.supportSubtitle,
                  trailing: Icon(
                    Icons.open_in_new,
                    color: context.gw.textMuted,
                  ),
                  onTap: () => _openSupport(context),
                ),
                Divider(color: context.gw.cardBorder, height: 1),
                GwSettingsRow(
                  title: context.l10n.licenses,
                  subtitle: context.l10n.licensesSubtitle,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: context.gw.textMuted,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LicensesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSupport(BuildContext context) async {
    final url = supportUrlFor(
      context.read<VpnConnectionBloc>().state.subscriptions,
    );
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.supportUnavailable)),
      );
      return;
    }
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (ok || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.privacyOpenFailed)),
    );
  }
}
