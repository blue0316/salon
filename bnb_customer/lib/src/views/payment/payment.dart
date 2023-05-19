// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  static const route = "/payment";
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final IFrameElement _iframeElement = IFrameElement();
  @override
  void initState() {
    super.initState();
    _iframeElement.style.height = '100%';
    _iframeElement.style.width = '100%';
    _iframeElement.src =

        // incase of next time if A' keep on showing beside an embedded link....open the file from your local host on chrome..if the A doesn't show..redownload it from chrome itself ..then open the file on vscode remove all the links to personal computer..then upload this new file to firebase
        'https://testpayments.worldnettps.com/merchant/paymentpage?TERMINALID=4872001&ORDERID=123467&CURRENCY=USD&AMOUNT=25.00&DATETIME=21-07-2022:20:19:09:981&HASH=df9&SECURECARDMERCHANTREF=151516&INIFRAME=';
    _iframeElement.style.border = 'none';
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
  }

  final Widget _iframeWidget = HtmlElementView(
    key: UniqueKey(),
    viewType: 'iframeElement',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _iframeWidget,
    );
  }
}
