// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class Payment extends StatefulWidget {
  String? amount;
  String? currency;
  String? terminalId;
  String? transactionId;

  static const route = "/payment";
  Payment(
      {Key? key,
      this.amount = "325.56",
      this.currency = "USD",
      this.transactionId,
      this.terminalId = "5363001"})
      : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final IFrameElement _iframeElement = IFrameElement();
  DateTime timeNow = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy:hh:mm:ss:Ms');
  var hash;
  @override
  void initState() {
    super.initState();
    // TERMINALID:ORDERID:AMOUNT:DATETIME:SECRET
// bnbUkraine20211!
    var bytesToHash = utf8.encode(
        "${widget.terminalId ?? "5363001"}:${widget.transactionId ?? "${timeNow.day}${timeNow.hour}${timeNow.minute}${timeNow.second}"}:${widget.amount ?? "325.56"}:${formatter.format(timeNow)}:bnbUkraine20211!");
    hash = sha512.convert(bytesToHash);
    // print();
    _iframeElement.style.height = '100%';
    _iframeElement.style.width = '100%';
    _iframeElement.src =
        'https://testpayments.worldnettps.com/merchant/paymentpage?TERMINALID=${widget.terminalId ?? "5363001"}&ORDERID=${widget.transactionId ?? "${timeNow.day}${timeNow.hour}${timeNow.minute}${timeNow.second}"}&AMOUNT=${widget.amount ?? "325.56"}&DATETIME=${formatter.format(timeNow)}&HASH=$hash&CURRENCY=${widget.currency ?? "USD"}';
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
