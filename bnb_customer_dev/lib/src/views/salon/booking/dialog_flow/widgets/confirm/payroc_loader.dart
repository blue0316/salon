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
    f();
  }

  f() async {
    stylePrint('started here 1');
    setState(() => isLoading = true);

    final DatabaseProvider _dbProvider = ref.read(dbProvider);

    if (widget.orderId.isNotEmpty) {
      stylePrint('started here 2a');
      final selector = {"_id": widget.orderId};

      final modifier = UpdateOperator.set({
        'MERCHANTREF': widget.merchantRef,
        'RESPONSECODE': widget.responseCode,
        'RESPONSETEXT': widget.responseText,
        'CARDREFERENCE': widget.cardReference,
        'CARDTYPE': widget.cardType,
        'MASKEDCARDNUMBER': widget.maskedCardNumber,
        'CARDEXPIRY': widget.cardExpiry,
        'CARDHOLDERNAME': widget.cardHolderNumber,
      });
      stylePrint('started here 2b');
      await _dbProvider.fetchCollection(CollectionMongo.transactions).updateOne(filter: selector, update: modifier);
      stylePrint('started here 2c');
    } else {
      stylePrint('started here 3a');
      final selector = {"_id": widget.merchantRef};

      final modifier = UpdateOperator.set({
        'ORDERID': widget.merchantRef,
        'MERCHANTREF': widget.merchantRef,
        'RESPONSECODE': widget.responseCode,
        'RESPONSETEXT': widget.responseText,
        'CARDREFERENCE': widget.cardReference,
        'CARDTYPE': widget.cardType,
        'MASKEDCARDNUMBER': widget.maskedCardNumber,
        'CARDEXPIRY': widget.cardExpiry,
        'CARDHOLDERNAME': widget.cardHolderNumber,
      });

      stylePrint('started here 3b');
      await _dbProvider.fetchCollection(CollectionMongo.transactions).updateOne(filter: selector, update: modifier);
      stylePrint('started here 3c');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.pink[800],
        ),
      ),
    );
  }
}
