// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Payment extends StatefulWidget {
  static const route = "/payment";
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final IFrameElement _iframeElement = IFrameElement();
  DateTime timeNow = DateTime.now();
  var hash;
  @override
  void initState() {
    super.initState();
    // TERMINALID:ORDERID:AMOUNT:DATETIME:SECRET
// bnbUkraine20211!
    var bytesToHash = utf8
        .encode("5363001:0001:325.56:23-6-2023:10:43:01:673:bnbUkraine20211!");
    hash = sha512.convert(bytesToHash);
    print(hash);
    _iframeElement.style.height = '100%';
    _iframeElement.style.width = '100%';
    _iframeElement.src =
        'https://testpayments.worldnettps.com/merchant/paymentpage?TERMINALID=5363001&ORDERID=0001&AMOUNT=325.56&DATETIME=23-6-2023:10:43:01:673&HASH=$hash&CURRENCY=USD';
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
