// ignore_for_file: camel_case_types

import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/cancellation_noShow_policy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Cancelation_NoShowApi {
  /// create cancellation or Noshow
  Future<CancellationNoShowPolicy?> createPolicyDoc(CancellationNoShowPolicy? policy) async {
    try {
      DocumentReference _docRef;
      if (policy != null) {
        _docRef = Collection.cancellationAndNoShow.doc();
        await _docRef.set(policy.toJson(), SetOptions(merge: true));
        return policy;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
