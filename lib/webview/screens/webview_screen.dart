import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/loader.dart';
import '../widgets/webview_widget.dart';
import '../controller/webview_controller.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final controller = await webViewController.init();

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? WebViewScreenWidget(controller: _controller)
        : const LoaderWithScaffold();
  }
}
