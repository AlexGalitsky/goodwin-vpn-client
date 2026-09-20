import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';

/// In-app rationale immediately before an OS permission sheet.
Future<bool> showPermissionExplainer({
  required BuildContext context,
  required String title,
  required String body,
  required String continueLabel,
}) async {
  final go = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(continueLabel),
        ),
      ],
    ),
  );
  return go == true;
}
