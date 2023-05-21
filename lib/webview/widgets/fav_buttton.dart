import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required WebViewController controller,
    required this.context,
  }) : _controller = controller;

  final WebViewController _controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final String? url = await _controller.currentUrl();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Favorite url')),
          );
        }
      },
      child: const Icon(Icons.favorite),
    );
  }
}
