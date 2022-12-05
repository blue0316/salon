import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;
import 'dart:html' as html;

class Iframe extends StatelessWidget {
  static const route = "/privacy22";
  Iframe() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = 'assets/policy.html';
      return iframe;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400, height: 300, child: HtmlElementView(viewType: 'iframe'));
  }
}
