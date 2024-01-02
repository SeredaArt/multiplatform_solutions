import 'package:flutter/material.dart';
import 'app_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget webView(String link) => AppPlatform.isMobile()
    ? WebViewWidget(
  controller: WebViewController()..loadRequest(Uri.parse(link)),
)
    : HyperLink(link);

class HyperLink extends StatelessWidget {
  final String link;
  const HyperLink(this.link, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _launchUrl,
      child: Text(link),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(link))) {
      throw Exception('Could not launch $link');
    }
  }
}