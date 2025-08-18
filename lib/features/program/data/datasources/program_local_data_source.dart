import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/program_models.dart';

class ProgramLocalDataSource {
  static const String fileName = 'progress.json';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  Future<ProgramProgressDto?> readProgress() async {
    final file = await _getFile();
    if (!await file.exists()) return null;
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return null;
    final jsonMap = json.decode(raw) as Map<String, dynamic>;
    return ProgramProgressDto.fromJson(jsonMap);
  }

  Future<void> writeProgress(ProgramProgressDto dto) async {
    final file = await _getFile();
    final raw = const JsonEncoder.withIndent('  ').convert(dto.toJson());
    await file.writeAsString(raw);
  }

  Future<void> clear() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}


