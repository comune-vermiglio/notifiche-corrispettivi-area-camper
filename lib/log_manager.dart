import 'dart:collection';
import 'dart:io';

import 'package:logging/logging.dart';

class LogManager {
  final File logFile;
  Queue<String> queue;

  LogManager({required this.logFile}) : queue = Queue<String>();

  void initialize() {
    Logger.root.onRecord.listen((record) {
      queue.add('${record.time} - [${record.level.name}]: ${record.message}');
    });
  }

  Future<void> save() async {
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
    for (final str in queue) {
      await logFile.writeAsString('$str\r\n', mode: mode, flush: true);
    }
  }
}
