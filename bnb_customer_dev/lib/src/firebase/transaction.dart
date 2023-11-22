import 'dart:convert';

import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/transaction.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';

class TransactionApi {
  // TransactionApi._privateConstructor();

  // static final TransactionApi _instance = TransactionApi._privateConstructor();

  // factory TransactionApi() {
  //   return _instance;
  // }

  TransactionApi._privateConstructor(this.mongodbProvider);

  static final TransactionApi _instance = TransactionApi._privateConstructor(null);

  factory TransactionApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  Future<String?> createTransaction(TransactionModel transaction) async {
    try {
      DocumentReference _docRef;

      _docRef = Collection.transactions.doc();
      transaction.transactionId = _docRef.id;

      await _docRef.set(transaction.toJson());

      return _docRef.id;
    } catch (e) {
      // debugPrint('Error on createTransaction()- ${e.toString()}');
      return null;
    }
  }

  Future<String?> createTransactionMongo(TransactionModel transaction) async {
    try {
      final _docRef = await mongodbProvider!.fetchCollection(CollectionMongo.transactions).insertOne(
            MongoDocument(transaction.toJson()),
          );

      String val = _docRef.toHexString();

      if (val != null) {
        final selector = {"_id": _docRef};

        final modifier = UpdateOperator.set({
          "__path__": 'transactions/$val',
          "transactionId": val,
        });

        await mongodbProvider!.fetchCollection(CollectionMongo.transactions).updateOne(filter: selector, update: modifier);
      }
      return val;
    } catch (e) {
      printIt('Error on createTransactionMongo()- ${e.toString()}');
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
          // debugPrint('Error on streamTransaction() - $e');
          rethrow;
        }

        allTransactions.add(transactionModel);
      }
      return allTransactions;
    });
  }

  Stream<List<TransactionModel>> streamTransactionMongo(String id) {
    return mongodbProvider!.fetchCollection(CollectionMongo.transactions).watchWithFilter({'transactionId': id}).take(1).map((event) {
          if (event == null) throw 'error';
          return event.map((snapShot) {
            Map<String, dynamic> _temp = json.decode(snapShot.toJson()) as Map<String, dynamic>;
            _temp['transactionId'] = _temp["transactionId"];

            return TransactionModel.fromJson(_temp);
          }).toList();
        });
  }

  Stream<List<AppointmentModel>> getAllAppointmentWithTransaction(String? transactionId) {
    return Collection.appointments.where('transactionId', arrayContains: transactionId).snapshots().map((snapShot) => snapShot.docs.map<AppointmentModel>((appointment) {
          Map _temp = appointment.data() as Map<dynamic, dynamic>;

          _temp['appointmentId'] = appointment.id;

          return AppointmentModel.fromJson(_temp as Map<String, dynamic>);
        }).toList());
  }

  Stream<List<AppointmentModel>> getAllAppointmentWithTransactionCardOnFile(String? transactionId) {
    return Collection.appointments.where('merchantRef', isEqualTo: transactionId).snapshots().map((snapShot) => snapShot.docs.map<AppointmentModel>((appointment) {
          Map _temp = appointment.data() as Map<dynamic, dynamic>;

          _temp['appointmentId'] = appointment.id;

          return AppointmentModel.fromJson(_temp as Map<String, dynamic>);
        }).toList());
  }

  /// returns the customerModel from the customerId
  Future<TransactionModel?> getTransaction(String? id) async {
    try {
      var transaction = await mongodbProvider!.fetchCollection(CollectionMongo.transactions).findOne(
        filter: {"transactionId": id},
      );

      if (transaction != null) {
        Map<String, dynamic> _temp = json.decode(transaction.toJson()) as Map<String, dynamic>;

        _temp['transactionId'] = _temp["transactionId"];
        return TransactionModel.fromJson(_temp);
      }
      return null;
    } catch (e) {
      //(e);
      return null;
    }
  }
}
