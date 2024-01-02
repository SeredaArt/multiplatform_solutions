import 'dart:html';
import 'dart:ui_web' as ui;
import 'dart:math';

import 'package:flutter/material.dart';

Widget webView(String link) => WebPlatformWebView(link: link);

class WebPlatformWebView extends StatelessWidget {
  final String link;
  const WebPlatformWebView({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(link);
    final id = Random().nextInt.toString();
    ui.platformViewRegistry.registerViewFactory(id, (viewId) {
      var element = IFrameElement()..src = link;
      return element;
    });
    return Container(child: HtmlElementView(viewType: id));
  }
}