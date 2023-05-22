import 'package:flutter/material.dart';
import 'package:offline_webview/constants/colors.dart';
import 'package:offline_webview/utils/snackbar.dart';
import 'package:offline_webview/webview/screens/webview_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Webview',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: colors.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: colors.backgroundColor,
          elevation: 0,
        ),
      ),
      home: const WebViewExample(),
    );
  }
}
