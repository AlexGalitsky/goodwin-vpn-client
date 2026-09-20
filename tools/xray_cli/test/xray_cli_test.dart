import 'dart:io';

import 'package:test/test.dart';
import 'package:xray_cli/xray_cli.dart';

void main() {
  test('resolveRepoRoot finds development-plan.md', () {
    final root = resolveRepoRoot();
    expect(
      File('${root.path}${Platform.pathSeparator}development-plan.md').existsSync(),
      isTrue,
    );
  });
}
