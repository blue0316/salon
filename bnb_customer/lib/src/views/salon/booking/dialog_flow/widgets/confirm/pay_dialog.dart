// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class PayDialog<T> extends ConsumerStatefulWidget {
  String? amount;
  String? currency;
  String? terminalId;
  String? transactionId;

  static const route = "/payment";
  PayDialog({Key? key, this.amount = "325.56", this.currency = "USD", this.transactionId, this.terminalId = "5363001"}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  ConsumerState<PayDialog> createState() => _PayDialogState();
}

class _PayDialogState extends ConsumerState<PayDialog> {
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
      "${widget.terminalId ?? "5363001"}:${widget.transactionId ?? "${timeNow.day}${timeNow.hour}${timeNow.minute}${timeNow.second}"}:${widget.amount ?? "325.56"}:${formatter.format(timeNow)}:https://us-central1-bowandbeautiful-3372d.cloudfunctions.net/payrocreceipt-payrocReceipt:bnbUkraine20211!",
    );
    hash = sha512.convert(bytesToHash);
    // print();
    _iframeElement.style.height = '100%';
    _iframeElement.style.width = '100%';
    _iframeElement.src =
        'https://testpayments.worldnettps.com/merchant/paymentpage?TERMINALID=${widget.terminalId ?? "5363001"}&ORDERID=${widget.transactionId ?? "${timeNow.day}${timeNow.hour}${timeNow.minute}${timeNow.second}"}&AMOUNT=${widget.amount ?? "325.56"}&DATETIME=${formatter.format(timeNow)}&HASH=$hash&CURRENCY=${widget.currency ?? "USD"}&SECURECARDMERCHANTREF=${"Glamiris181234${timeNow.day}${timeNow.hour}${timeNow.minute}${timeNow.second}"}&STOREDCREDENTIALUSE=UNSCHEDULED&STOREDCREDENTIALTXTYPE=FIRST_TXN&RECEIPTPAGEURL=https://us-central1-bowandbeautiful-3372d.cloudfunctions.net/payrocreceipt-payrocReceipt';
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
    var mediaQuery = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(
            context,
            0,
            20, // mediaQuery.width / 5,
            mediaQuery.width / 6,
          ),
          vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _iframeWidget,
        ),
      ),
    );
  }
}
