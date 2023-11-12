import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // debugPrint('Error on createTransaction()- ${e.toString()}');
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
      DocumentSnapshot transaction = await Collection.transactions.doc(id).get();

      Map? _temp = transaction.data() as Map<dynamic, dynamic>?;
      if (_temp != null) {
        _temp['transactionId'] = transaction.id;
        return TransactionModel.fromJson(_temp as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      //(e);
      return null;
    }
  }
}
