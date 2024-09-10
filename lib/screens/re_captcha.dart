import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class ReCaptcha extends StatelessWidget {
  static const String routeName = '/reCaptcha';
  const ReCaptcha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controllerPlus) {
          controllerPlus.loadUrl("assets/index.html");
        },
        javascriptChannels: {
          JavascriptChannel(
            name: 'Captcha',
            onMessageReceived: (message) {
              Navigator.of(context).pop(true);
            },
          )
        },
      ),
    );
  }
}
