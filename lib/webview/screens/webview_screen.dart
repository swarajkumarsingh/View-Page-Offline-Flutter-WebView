import 'package:offline_webview/constants/colors.dart';
import 'package:offline_webview/webview/widgets/menu_bar.dart';
import 'package:offline_webview/webview/widgets/navigation_controls.dart';
import 'package:offline_webview/webview/widgets/webview_widget.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;

  void _onProgress(int progress) {}
  void _onPageStarted(String url) {}
  void _onUrlChange(UrlChange change) {
    debugPrint('url change to {change.url}');
  }

  void _onPageFinished(String url) {}
  void _onWebResourceError(WebResourceError error) {
    debugPrint('''
        Page resource error:
        code: {error.errorCode}
      description: {error.description}
      errorType: {error.errorType}
  isForMainFrame: {error.isForMainFrame}
          ''');
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/')) {
      debugPrint('blocking navigation to {request.url}');
      return NavigationDecision.prevent;
    }
    debugPrint('allowing navigation to {request.url}');
    return NavigationDecision.navigate;
  }

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: _onProgress,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
          onNavigationRequest: _onNavigationRequest,
          onUrlChange: _onUrlChange,
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://neetcode.io'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
          SampleMenu(webViewController: _controller),
        ],
      ),
      body: WebViewWidget(controller: _controller),
      floatingActionButton:
          FavoriteButton(controller: _controller, context: context),
    );
  }
}
