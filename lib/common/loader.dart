import 'package:flutter/material.dart';
import 'package:offline_webview/constants/colors.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.size = 80.0, this.semanticsLabel})
      : super(key: key);

  final double size;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.0,
            semanticsLabel: semanticsLabel,
          ),
        ),
      ),
    );
  }
}

class LoaderWithScaffold extends StatelessWidget {
  const LoaderWithScaffold({Key? key, this.size = 80.0, this.semanticsLabel})
      : super(key: key);

  final double size;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
                semanticsLabel: semanticsLabel,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
