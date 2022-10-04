import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/salon_master/master.dart';
import 'collections.dart';

class MastersApi {
  MastersApi._privateConstructor();
  static final MastersApi _instance = MastersApi._privateConstructor();
  factory MastersApi() {
    return _instance;
  }
  Future<MasterModel?> getMasterFromId(String masterId) async {
    try {
      printIt(masterId);
      DocumentSnapshot _response = await Collection.masters.doc(masterId).get();
      printIt(_response.data());
      Map<String, dynamic> _masterMap = _response.data() as Map<String, dynamic>;
      _masterMap['masterId'] = _response.id;
      return MasterModel.fromJson(_masterMap);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<MasterModel>?> getMasterFromName({required String text}) async {
    try {
      QuerySnapshot _response = await Collection.masters.where('personalInfo.name', isGreaterThanOrEqualTo: text).get();
      return _response.docs.map<MasterModel>((master) {
        Map _temp = master.data() as Map<dynamic, dynamic>;
        _temp['masterId'] = master.id;
        return MasterModel.fromJson(_temp as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<MasterModel>> getAllMaster(String salonId) async {
    try {
      List<MasterModel> masters = [];
      QuerySnapshot _response = await Collection.masters.where('salonId', isEqualTo: salonId).get();
      for (DocumentSnapshot doc in _response.docs) {
        Map _temp = doc.data() as Map<dynamic, dynamic>;
        _temp['masterId'] = doc.id;
        var master = MasterModel.fromJson(_temp as Map<String, dynamic>);
        if (master.availableOnline) {
          masters.add(master);
        }
      }
      return masters;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

// todo use pagination
  Future<List<ReviewModel>> getMasterReviews({required String masterId}) async {
    List<ReviewModel> allReviews = [];
    QuerySnapshot reviewsSnapshot = await Collection.masters.doc(masterId).collection('reviews').limit(20).get();
    for (QueryDocumentSnapshot doc in reviewsSnapshot.docs) {
      try {
        ReviewModel _reviewModel = ReviewModel.fromJson(doc.data() as Map<String, dynamic>);
        allReviews.add(_reviewModel);
      } catch (e) {
        printIt(e);
      }
    }
    return allReviews;
  }

  Future<int> updateMasterBlockTime(
    MasterModel master,
  ) async {
    try {
      await Collection.masters.doc(master.masterId).update({
        'blockedTime': master.blockedTime,
      });
      return 1;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
}
