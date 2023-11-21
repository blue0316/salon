import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/database/update_operator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayrocLoader extends ConsumerStatefulWidget {
  static const route = "/payrocloader";

  final String orderId;
  final String merchantRef;
  final String responseCode;
  final String responseText;
  final String cardReference;
  final String cardType;
  final String maskedCardNumber;
  final String cardExpiry;
  final String cardHolderNumber;

  const PayrocLoader({
    super.key,
    required this.orderId,
    required this.merchantRef,
    required this.responseCode,
    required this.responseText,
    required this.cardReference,
    required this.cardType,
    required this.maskedCardNumber,
    required this.cardExpiry,
    required this.cardHolderNumber,
  });

  @override
  ConsumerState<PayrocLoader> createState() => _PayrocLoaderState();
}

class _PayrocLoaderState extends ConsumerState<PayrocLoader> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        f();
      },
    );
  }

  f() async {
    print('inside here ');
    setState(() => isLoading = true);

    final DatabaseProvider _dbProvider = ref.read(dbProvider);
    final _auth = ref.read(authProvider);

    await _auth.authenticatePhone(
      context,
      code: '+234',
      phone: '8135822208',
      otpSent: () {},
    );

    if (widget.orderId != '') {
      final selector = {"_id": widget.orderId};

      final modifier = UpdateOperator.set({'CARDHOLDERNAME': 'widget.cardHolderNumber'});
      //  final modifier = UpdateOperator.set({
      //   'MERCHANTREF': widget.merchantRef,
      //   'RESPONSECODE': widget.responseCode,
      //   'RESPONSETEXT': widget.responseText,
      //   'CARDREFERENCE': widget.cardReference,
      //   'CARDTYPE': widget.cardType,
      //   'MASKEDCARDNUMBER': widget.maskedCardNumber,
      //   'CARDEXPIRY': widget.cardExpiry,
      //   'CARDHOLDERNAME': widget.cardHolderNumber,
      // });

      await _dbProvider.fetchCollection(CollectionMongo.transactions).updateOne(filter: selector, update: modifier);
    } else {
      final selector = {"transactionId": widget.merchantRef};
      final modifier = UpdateOperator.set({'CARDHOLDERNAME': ' widget.cardHolderNumber'});

      // final modifier = UpdateOperator.set({
      //   'ORDERID': widget.merchantRef,
      //   'MERCHANTREF': widget.merchantRef,
      //   'RESPONSECODE': widget.responseCode,
      //   'RESPONSETEXT': widget.responseText,
      //   'CARDREFERENCE': widget.cardReference,
      //   'CARDTYPE': widget.cardType,
      //   'MASKEDCARDNUMBER': widget.maskedCardNumber,
      //   'CARDEXPIRY': widget.cardExpiry,
      //   'CARDHOLDERNAME': widget.cardHolderNumber,
      // });

      await _dbProvider.fetchCollection(CollectionMongo.transactions).updateOne(filter: selector, update: modifier);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final _auth = ref.read(authProvider);

        await _auth.authenticatePhone(
          context,
          code: '+234',
          phone: '8020752193',
          otpSent: () {},
        );
      },
    );

    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: Colors.green,
            ),
            Text('nawa'),
          ],
        ),
      ),
    );
  }
}
