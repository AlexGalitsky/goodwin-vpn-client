import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// User-chosen backup file. Returns null when the dialog is cancelled.
class BackupFileIO {
  const BackupFileIO();

  Future<bool> save({
    required String fileName,
    required String contents,
  }) async {
    final uri = await FilePicker.saveFile(
      dialogTitle: 'Save VPN backup',
      fileName: fileName,
      bytes: Uint8List.fromList(utf8.encode(contents)),
      type: FileType.custom,
      allowedExtensions: const ['json'],
      mimeType: 'application/json',
    );
    return uri != null;
  }

  Future<String?> pick() async {
    final file = await FilePicker.pickFile(
      dialogTitle: 'Open VPN backup',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (file == null) return null;
    return utf8.decode(await file.readAsBytes());
  }
}
