import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionApi {
  TransactionApi._privateConstructor();

  static final TransactionApi _instance = TransactionApi._privateConstructor();

  factory TransactionApi() {
    return _instance;
  }

  Future<String?> createTransaction(TransactionModel transaction) async {
    try {
      DocumentReference _docRef;

      _docRef = Collection.transactions.doc();
      transaction.transactionId = _docRef.id;

      await _docRef.set(transaction.toJson());

      return _docRef.id;
    } catch (e) {
      debugPrint('Error on createTransaction()- ${e.toString()}');
      return null;
    }
  }

  Stream<List<TransactionModel>> streamTransaction(String id) {
    return Collection.transactions.where("transactionId", isEqualTo: id).limit(1).snapshots().map((snapShot) {
      List<TransactionModel> allTransactions = [];

      for (QueryDocumentSnapshot snap in snapShot.docs) {
        late TransactionModel? transactionModel;
        try {
          transactionModel = TransactionModel.fromJson(snap.data() as Map<String, dynamic>);
          transactionModel.transactionId = snap.id;
        } catch (e) {
          debugPrint('Error on streamTransaction() - $e');
          rethrow;
        }

        allTransactions.add(transactionModel);
      }
      return allTransactions;
    });
  }
}
