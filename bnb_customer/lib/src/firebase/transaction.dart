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
      transaction.docId = _docRef.id;

      await _docRef.set(transaction.toJson());

      return _docRef.id;
    } catch (e) {
      debugPrint('Error on createTransaction()- ${e.toString()}');
      return null;
    }
  }

  // Stream<List<TransactionModel>> readTicket(String uid) {
  //   return FirebaseFirestore.instance
  //       .collection("tickets")
  //       .where(
  //         "added_by",
  //         isEqualTo: uid,
  //       )
  //       .limit(1)
  //       .snapshots()
  //       .map(
  //         (querySnapshot) => querySnapshot.docs
  //             .map(
  //               (e) => TransactionModel.fromSnapshot(e),
  //             )
  //             .toList(),
  //       );
  // }
}
