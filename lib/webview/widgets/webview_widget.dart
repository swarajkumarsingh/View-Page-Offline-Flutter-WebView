import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'fav_button.dart';
import 'menu_bar.dart';
import 'navigation_controls.dart';
import '../../constants/colors.dart';

class WebViewScreenWidget extends StatelessWidget {
  const WebViewScreenWidget({
    super.key,
    required WebViewController? controller,
  }) : _controller = controller;

  final WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        actions: <Widget>[
          NavigationControls(webViewController: _controller!),
          SampleMenu(webViewController: _controller!),
        ],
      ),
      body: WebViewWidget(controller: _controller!),
      floatingActionButton:
          FavoriteButton(controller: _controller!, context: context),
    );
  }
}
