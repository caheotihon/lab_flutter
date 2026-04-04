import 'dart:io';
import 'package:logging/logging.dart';

Logger initFileLogger(String name) {
  hierarchicalLoggingEnabled = true;
  final logger = Logger(name);
  final now = DateTime.now();

  // Tìm đường dẫn thư mục gốc của dự án
  final scriptFile = File(Platform.script.toFilePath());
  final projectDir = scriptFile.parent.parent.path;

  // Tạo thư mục 'logs' nếu chưa có
  final dir = Directory('$projectDir/logs');
  if (!dir.existsSync()) dir.createSync();

  // Tạo file log với tên theo định dạng: Năm_Tháng_Ngày_Tên.txt
  final logFile = File(
    '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
  );

  // Lắng nghe mọi cấp độ log (Level.ALL)
  logger.level = Level.ALL;

  // Ghi log vào file
  logger.onRecord.listen((record) {
    final msg = '[${record.time} - ${record.loggerName}] ${record.level.name}: ${record.message}';
    logFile.writeAsStringSync('$msg\n', mode: FileMode.append);
  });

  return logger;
}