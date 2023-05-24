import 'package:flutter/material.dart';

import 'utils/snackbar.dart';
import 'constants/colors.dart';
import 'webview/screens/webview_screen.dart';

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
      home: const WebViewScreen(),
    );
  }
}
