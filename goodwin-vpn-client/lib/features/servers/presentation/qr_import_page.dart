import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../l10n/l10n_extension.dart';
import '../../onboarding/permission_explainer.dart';
import '../../settings/presentation/bloc/app_settings_bloc.dart';

/// Full-screen camera scan. Pops the first QR payload.
class QrImportPage extends StatefulWidget {
  const QrImportPage({super.key});

  static Future<String?> open(BuildContext context) async {
    final settings = context.read<AppSettingsBloc>();
    if (!settings.state.cameraExplainerSeen) {
      final go = await showPermissionExplainer(
        context: context,
        title: context.l10n.cameraExplainerTitle,
        body: context.l10n.cameraExplainerBody,
        continueLabel: context.l10n.cameraExplainerContinue,
      );
      if (go != true || !context.mounted) return null;
      settings.add(const AppSettingsCameraExplainerSeen());
    }
    if (!context.mounted) return null;
    return Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrImportPage()),
    );
  }

  @override
  State<QrImportPage> createState() => _QrImportPageState();
}

class _QrImportPageState extends State<QrImportPage> {
  var _done = false;

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    final value = capture.barcodes
        .map((b) => b.rawValue?.trim() ?? '')
        .firstWhere((s) => s.isNotEmpty, orElse: () => '');
    if (value.isEmpty) return;
    _done = true;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanQr)),
      body: MobileScanner(onDetect: _onDetect),
    );
  }
}
