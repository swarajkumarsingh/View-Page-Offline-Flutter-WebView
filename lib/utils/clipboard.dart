import 'package:flutter/services.dart';

final clipboard = _Clipboard();

class _Clipboard {
  Future<void> copy(dynamic text) async {
    await Clipboard.setData(ClipboardData(text: text.toString()));
  }
}