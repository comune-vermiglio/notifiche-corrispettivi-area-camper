import 'dart:io';

import 'package:logging/logging.dart';

class LogManager {
  final File logFile;

  const LogManager({required this.logFile});

  Future<void> initialize() async {
    final exist = await logFile.exists();
    if (!exist) {
      await logFile.create();
    }
    final size = await logFile.length();
    final FileMode mode;
    if (size > 10e7) {
      mode = FileMode.write;
    } else {
      mode = FileMode.append;
    }
    Logger.root.onRecord.listen((record) {
      logFile.writeAsString(
        '${record.time} - [${record.level.name}]: ${record.message}\n',
        mode: mode,
      );
    });
  }
}
