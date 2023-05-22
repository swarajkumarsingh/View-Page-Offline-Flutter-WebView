import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:offline_webview/common/loader.dart';
import 'package:offline_webview/constants/colors.dart';
import 'package:offline_webview/utils/storage_help.dart';
import 'package:offline_webview/webview/widgets/menu_bar.dart';
import 'package:offline_webview/webview/widgets/navigation_controls.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../constants/constant.dart';
import '../../utils/snackbar.dart';
import '../controller/webview_controller.dart';
import '../widgets/fav_buttton.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  WebViewController? _controller;
  bool connectionStatus = false;
  String htmlText = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getConnectionStatus();
    if (connectionStatus == false) await getHtmlString();
    await initWebView();
  }

  Future<void> initWebView() async {
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: webViewController.onProgress,
          onPageStarted: webViewController.onPageStarted,
          onPageFinished: (url) async =>
              await webViewController.onPageFinished(url, controller),
          onWebResourceError: webViewController.onWebResourceError,
          onNavigationRequest: webViewController.onNavigationRequest,
          onUrlChange: webViewController.onUrlChange,
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
        : controller.loadHtmlString(htmlText);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    setState(() {
      _controller = controller;
    });
  }

  Future<void> getConnectionStatus() async {
    bool value = await InternetConnectionChecker().hasConnection;
    setState(() {
      connectionStatus = value;
    });
  }

  Future<void> getHtmlString() async {
    String html = await storageHelper.readFromFile("webview.html");
    String shortString = html.substring(0, 10);

    if (shortString.contains("003")) html = jsonDecode(html);
    
    setState(() {
      htmlText = html;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? Scaffold(
            backgroundColor: colors.backgroundColor,
            appBar: AppBar(
              title: const Text('Flutter WebView example'),
              actions: <Widget>[
                NavigationControls(webViewController: _controller!),
                SampleMenu(webViewController: _controller!),
              ],
            ),
            body: WebViewWidget(controller: _controller!),
            floatingActionButton:
                FavoriteButton(controller: _controller!, context: context),
          )
        : const LoaderWithScaffold();
  }
}
