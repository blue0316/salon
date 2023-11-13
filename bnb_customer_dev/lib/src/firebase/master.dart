import 'dart:convert';

import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/salon_master/master.dart';
import 'collections.dart';

class MastersApi {
  // MastersApi._privateConstructor();
  // static final MastersApi _instance = MastersApi._privateConstructor();
  // factory MastersApi() {
  //   return _instance;
  // }

  MastersApi._privateConstructor(this.mongodbProvider);

  static final MastersApi _instance = MastersApi._privateConstructor(null);

  factory MastersApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  Future<MasterModel?> getMasterFromId(String masterId) async {
    try {
      printIt(masterId);
      DocumentSnapshot _response = await Collection.masters.doc(masterId).get();
      printIt(_response.data());
      Map<String, dynamic> _masterMap = _response.data() as Map<String, dynamic>;
      _masterMap['masterId'] = _response.id;
      return MasterModel.fromJson(_masterMap);
    } catch (e) {
      // debugPrint(e.toString());
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
      // debugPrint(e.toString());
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
      // debugPrint(e.toString());
      return [];
    }
  }

  Future<List<MasterModel>> getAllSalonMasters(String salonId) async {
    try {
      List<MasterModel> masters = [];

      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.masters).find(
        filter: {"salonId": salonId},
      );
      for (var item in _response) {
        Map<String, dynamic> _temp = json.decode(item.toJson()) as Map<String, dynamic>;
        _temp['masterId'] = _temp["__id__"];

        var master = MasterModel.fromJson(_temp);
        masters.add(master);
      }
      return masters;
    } catch (e) {
      debugPrint('Error on getAllSalonMasters() - ${e.toString()}');
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
      // debugPrint(e.toString());
      return 0;
    }
  }

  //updates the salon admin data
  Future updateMaster(MasterModel master, {bool isNewMaster = false}) async {
    try {
      //updates salon data

      //assigns a timestamp in-case of a new master
      if (isNewMaster) master.createdAt = DateTime.now();

      master = removeExtraPriceAndDuration(master);

      if (isNewMaster) {
        final DocumentReference _doc = Collection.masters.doc();

        await _doc.set(master.toJson());
        master.masterId = _doc.id;
        //(master.masterId);

        return master;
      } else if (master.masterId != null || !isNewMaster) {
        await Collection.masters.doc(master.masterId).set(
              master.toJson(),
            );
        //('not here');
        return master;
      }

      //links th salon with ownerId

      return null;
    } catch (e) {
      // debugPrint(e.toString());
      return null;
    }
  }

  //removes the extra price and duration
  MasterModel removeExtraPriceAndDuration(MasterModel master) {
    try {
      List<String>? serviceIds = master.serviceIds;
      if (serviceIds == null) return master;

      Map<String, PriceAndDurationModel>? _map = {};

      for (String id in serviceIds) {
        if (master.servicesPriceAndDuration!.containsKey(id)) {
          _map[id] = master.servicesPriceAndDuration![id]!;
        }
      }
      master.servicesPriceAndDuration = _map;
    } catch (e) {
      //(e);
    }
    return master;
  }

  Future<List<MasterModel>?> getMasterFromPhone({required String phone, required String salonId}) async {
    try {
      QuerySnapshot _response = await Collection.masters
          .where('personalInfo.phone', isEqualTo: phone)
          .where(
            'salonId',
            isEqualTo: salonId,
          )
          .get();
      return _response.docs.map<MasterModel>((master) {
        Map _temp = master.data() as Map<dynamic, dynamic>;
        _temp['masterId'] = master.id;
        return MasterModel.fromJson(_temp as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      // debugPrint(e.toString());
      return null;
    }
  }
}
