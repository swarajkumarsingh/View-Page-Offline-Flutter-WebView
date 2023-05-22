import 'package:flutter/material.dart';
import 'package:offline_webview/utils/snackbar.dart';
import 'package:offline_webview/webview/screens/webview_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
      home: const WebViewExample(),
    );
  }
}
