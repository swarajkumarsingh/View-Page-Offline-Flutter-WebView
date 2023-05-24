import 'package:logger/logger.dart';

import '../config.dart';

final logger = _CustomLogger();

final _log = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 1000,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

class _CustomLogger {
  void info(dynamic message, [dynamic extra, StackTrace? stackTrace]) {
    if (isDebugMode) _log.i(message, extra, stackTrace);
  }

  void verbose(dynamic message, [dynamic extra, StackTrace? stackTrace]) {
    if (isDebugMode) _log.v(message, extra, stackTrace);
  }

  void wtf(dynamic message, [dynamic extra, StackTrace? stackTrace]) {
    if (isDebugMode) _log.wtf(message, extra, stackTrace);
  }

  void debug(dynamic message, [dynamic extra, StackTrace? stackTrace]) {
    if (isDebugMode) _log.d(message, extra, stackTrace);
  }

  void warning(dynamic message, [dynamic extra, StackTrace? stackTrace]) {
    if (isDebugMode) _log.w(message);
  }

  void error(dynamic message, [dynamic extra, StackTrace? stackTrace]) {
    if (isDebugMode) _log.e(message);
  }
}
