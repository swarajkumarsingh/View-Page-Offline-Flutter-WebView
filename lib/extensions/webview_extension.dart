import 'dart:convert';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

extension WebViewControllerExtension on WebViewController {
  Future<String> getHtml() {
    return runJavaScriptReturningResult('document.documentElement.outerHTML')
        .then((value) {
      if (Platform.isAndroid) {
        return jsonDecode(value as String) as String;
      } else {
        return value as String;
      }
    });
  }
}
