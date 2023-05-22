import 'package:flutter/material.dart';
import 'package:offline_webview/common/loader.dart';
import 'package:offline_webview/utils/logger.dart';
import 'package:offline_webview/extensions/webview_extension.dart';
import 'package:offline_webview/utils/storage_help.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/clipboard.dart';

final webViewController = _WebViewController();

class _WebViewController {
  Widget onProgress(int progress) => const Loader();

  void onPageStarted(String url) {}
  void onUrlChange(UrlChange change) {
    logger.debug("url change to ${change.url}");
  }

  Future<void> onPageFinished(String url, WebViewController controller) async {
    final html = await controller.getHtml();
    await clipboard.copy(html);
    await storageHelper.writeTextToFile(
      "webview.html",
      html,
    );
  }

  void onWebResourceError(WebResourceError error) {
    logger.error('''
      message: "Page resource error"
      code: ${error.errorCode}
      description: ${error.description}
      errorType: ${error.errorType}
      isForMainFrame: ${error.isForMainFrame}
          ''');
  }

  NavigationDecision onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/')) {
      debugPrint('blocking navigation to {request.url}');
      return NavigationDecision.prevent;
    }
    debugPrint('allowing navigation to {request.url}');
    return NavigationDecision.navigate;
  }
}
