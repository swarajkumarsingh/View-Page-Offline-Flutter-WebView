import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../config.dart';
import '../../utils/logger.dart';
import '../../common/loader.dart';
import '../../utils/snackbar.dart';
import '../../utils/clipboard.dart';
import '../../constants/colors.dart';
import '../../utils/storage_help.dart';
import '../../constants/constant.dart';
import '../../extensions/webview_extension.dart';

final webViewController = _WebViewController();

class _WebViewController {
  bool showedSnackBar = false;

  Widget _onProgress(int progress) => const Loader();

  void _onPageStarted(String url) {}

  void _onUrlChange(UrlChange change) {
    logger.debug("url change to ${change.url}");
  }

  void _onWebResourceError(WebResourceError error) {
    logger.error('''
      message: "Page resource error"
      code: ${error.errorCode}
      description: ${error.description}
      errorType: ${error.errorType}
      isForMainFrame: ${error.isForMainFrame}
          ''');
  }

  Future<NavigationDecision> _onNavigationRequest(
      NavigationRequest request) async {
    bool connectionStatus = await InternetConnectionChecker().hasConnection;

    for (var site in blockedSites) {
      if (request.url.startsWith(site)) {
        debugPrint('blocking navigation to ${request.url}');
        showSnackBar(msg: "Unreachable site");
        return NavigationDecision.prevent;
      }
    }

    if (connectionStatus == false) {
      if (showedSnackBar == false) showSnackBar(msg: "No Internet Connection");
      showedSnackBar = true;
      return NavigationDecision.prevent;
    }
    debugPrint('allowing navigation to ${request.url}');
    return NavigationDecision.navigate;
  }

  Future<void> _onPageFinished(String url, WebViewController controller) async {
    final html = await controller.getHtml();
    if (isDebugMode) await clipboard.copy(html);
    await storageHelper.writeTextToFile(
      BASE_FILE_NAME,
      html,
    );
  }

  Future<String> _getPageHtml() async {
    String html = await storageHelper.readFromFile(BASE_FILE_NAME);
    String shortString = html.substring(0, 10);

    if (shortString.contains("003")) html = jsonDecode(html);

    return html;
  }

  Future<bool> _getConnectionStatus() async {
    bool connectionStatus = await InternetConnectionChecker().hasConnection;
    return connectionStatus;
  }

  Future<WebViewController> initWebView() async {
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    bool connectionStatus = await _getConnectionStatus();
    String html = await _getPageHtml();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: webViewController._onProgress,
          onPageStarted: webViewController._onPageStarted,
          onPageFinished: (url) async => await _onPageFinished(url, controller),
          onWebResourceError: webViewController._onWebResourceError,
          onNavigationRequest: webViewController._onNavigationRequest,
          onUrlChange: webViewController._onUrlChange,
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage data) {
          showSnackBar(msg: data.message);
        },
      );

    connectionStatus == true
        ? controller.loadRequest(Uri.parse(BASE_URL))
        : controller.loadHtmlString(html);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    return controller;
  }
}
