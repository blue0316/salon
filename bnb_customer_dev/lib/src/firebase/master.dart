import 'dart:convert';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
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

      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.masters).find(
        filter: {"salonId": salonId},
      );

      for (var item in _response) {
        Map<String, dynamic> _temp = json.decode(item.toJson()) as Map<String, dynamic>;

        _temp['masterId'] = _temp["__id__"];
        var master = MasterModel.fromJson(_temp);

        if (master.availableOnline) {
          masters.add(master);
        }
      }
      return masters;
    } catch (e) {
      debugPrint('Error on getAllMaster() -$e');
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

  // Future<int> updateMasterBlockTime(MasterModel master) async {
  //   try {
  //     await Collection.masters.doc(master.masterId).update({
  //       'blockedTime': master.blockedTime,
  //     });
  //     return 1;
  //   } catch (e) {
  //     // debugPrint(e.toString());
  //     return 0;
  //   }
  // }

  Future<int> updateMasterBlockTimeMongo(MasterModel master) async {
    try {
      print(master.masterId);
      final selector = {"masterId": master.masterId};

      // Map<String, dynamic> aa = master.blockedTime!;
      final modifier = UpdateOperator.set(
        {
          'blockedTime': master.blockedTime,
        },
      );

      await mongodbProvider!.fetchCollection(CollectionMongo.masters).updateOne(filter: selector, update: modifier).catchError((err) {
        return [];
      });

      // Map<String, dynamic> aa = {
      //   '2023-11-20': ['09:00', '09:29'],
      // };
// {2023-11-20: [09:00, 09:01, 09:02, 09:03, 09:04, 09:05, 09:06, 09:07, 09:08, 09:09, 09:10, 09:11, 09:12, 09:13, 09:14, 09:15, 09:16, 09:17, 09:18, 09:19, 09:20, 09:21, 09:22, 09:23, 09:24, 09:25, 09:26, 09:27, 09:28, 09:29, 09:00, 09:15, 09:16, 09:17, 09:18, 09:19, 09:20, 09:21, 09:22, 09:23, 09:24, 09:25, 09:26, 09:27, 09:28, 09:29]}

      return 1;
    } catch (e) {
      debugPrint('Error on updateMasterBlockTimeMongo() -$e');
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

  Future updateMasterMongo(MasterModel master, {bool isNewMaster = false}) async {
    try {
      //updates salon data

      //assigns a timestamp in-case of a new master
      if (isNewMaster) master.createdAt = DateTime.now();

      master = removeExtraPriceAndDuration(master);

      if (isNewMaster) {
        final _doc = await mongodbProvider!.fetchCollection(CollectionMongo.masters).insertOne(MongoDocument(master.toJson()));

        String val = _doc.toHexString();

        if (val != null) {
          final selector = {"_id": _doc};
          master.masterId = val;
          final modifier = UpdateOperator.set({"__path__": 'salonMasters/$val', "masterId": val});
          await mongodbProvider!.fetchCollection(CollectionMongo.masters).updateOne(filter: selector, update: modifier);
        }

        return master;
      } else if (master.masterId != null || !isNewMaster) {
        // master.reviewCount = 20; // 1
        final selector = {"__path__": 'salonMasters/${master.masterId}'};
        final modifier = UpdateOperator.set(master.toJson());

        await mongodbProvider!.fetchCollection(CollectionMongo.masters).updateOne(filter: selector, update: modifier);

        // await mongodbProvider!.fetchCollection(CollectionMongo.masters).updateOne(
        //   filter: {"masterId": master.masterId},
        //   update: UpdateOperator.set(master.toJson()),
        // );

        master.title = 'omo nawa';
        // await mongodbProvider!.fetchCollection(CollectionMongo.masters).insertOne(MongoDocument(master.toJson()));

        // print('@@@@@@######---@@@@@@######---');

        // print(a);
        // print('@@@@@@######---@@@@@@######---');

        return master;
      }

      //links th salon with ownerId

      return null;
    } catch (e) {
      debugPrint(e.toString());
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
      List<MongoDocument> _response = await mongodbProvider!.fetchCollection(CollectionMongo.masters).find(
        filter: {
          "personalInfo.phone": phone,
          "salonId": salonId,
        },
      );

      return _response.map<MasterModel>((master) {
        Map<String, dynamic> temp = json.decode(master.toJson()) as Map<String, dynamic>;
        temp['masterId'] = temp["__id__"];
        return MasterModel.fromJson(temp);
      }).toList();
    } catch (e) {
      debugPrint('Error on getMasterFromPhone() - $e');
      return null;
    }
  }
}
