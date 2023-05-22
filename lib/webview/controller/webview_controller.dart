import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../common/loader.dart';
import '../../utils/logger.dart';
import '../../extensions/webview_extension.dart';
import '../../utils/snackbar.dart';
import '../../utils/storage_help.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/clipboard.dart';

final webViewController = _WebViewController();

class _WebViewController {
  bool showedSnackBar = false;
  
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

  Future<NavigationDecision> onNavigationRequest(
      NavigationRequest request) async {
    bool connectionStatus = await InternetConnectionChecker().hasConnection;

    if (request.url.startsWith('https://www.youtube.com/')) {
      debugPrint('blocking navigation to ${request.url}');
      return NavigationDecision.prevent;
    }

    if (connectionStatus == false) {
      if (showedSnackBar == false) showSnackBar(msg: "No Internet Connection");
      showedSnackBar = true;
      return NavigationDecision.prevent;
    }
    debugPrint('allowing navigation to ${request.url}');
    return NavigationDecision.navigate;
  }
}
