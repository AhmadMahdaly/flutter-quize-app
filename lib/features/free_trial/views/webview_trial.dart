import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // لتفعيل جافاسكربت
      ..loadRequest(Uri.parse('https://smlegate.com/free-trial/create'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('عرض SMLE Free Trial')),
      body: Column(
        children: [
          36.verticalSpace,
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
