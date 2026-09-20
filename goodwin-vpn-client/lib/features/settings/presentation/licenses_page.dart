import 'package:flutter/material.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../ui/ui.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.licenses)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          GwCard(
            child: Text(
              l10n.licensesBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          GwCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: const [
                _LicenseRow(name: 'Xray-core', license: 'MPL 2.0'),
                Divider(height: 1),
                _LicenseRow(name: 'Hysteria 2', license: 'MIT'),
                Divider(height: 1),
                _LicenseRow(name: 'hev-socks5-tunnel', license: 'MIT'),
                Divider(height: 1),
                _LicenseRow(name: 'TrustTunnel', license: 'project license'),
                Divider(height: 1),
                _LicenseRow(name: 'Flutter', license: 'BSD 3-Clause'),
                Divider(height: 1),
                _LicenseRow(name: 'Inter', license: 'SIL OFL 1.1'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LicenseRow extends StatelessWidget {
  const _LicenseRow({required this.name, required this.license});

  final String name;
  final String license;

  @override
  Widget build(BuildContext context) {
    return GwSettingsRow(
      title: name,
      subtitle: license,
    );
  }
}
