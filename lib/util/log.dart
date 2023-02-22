import 'package:flutter/foundation.dart';

class Log {
  static const veryVerbose = true;
  static const useConsolePrint = false;

  static final Function log = useConsolePrint ? print : debugPrint;

  static void vv(String tag, String message) {
    if (kReleaseMode || !veryVerbose) return;

    log('$tag: $message');
  }

  static void v(String tag, String message) {
    if (kReleaseMode) return;

    log('$tag: $message');
  }

  static void d(String tag, String message) {
    log('$tag: $message');
  }

  static void e(String tag, String message) {
    log('$tag: $message');
  }
}
