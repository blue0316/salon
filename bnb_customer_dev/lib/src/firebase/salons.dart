import 'dart:convert';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/salon_master/salon.dart';
import 'collections.dart';

class SalonApi {
  // SalonApi._privateConstructor();
  // static final SalonApi _instance = SalonApi._privateConstructor();
  // factory SalonApi() {
  //   return _instance;
  // }

  SalonApi._privateConstructor(this.mongodbProvider);

  static final SalonApi _instance = SalonApi._privateConstructor(null);

  factory SalonApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  // final Geoflutterfire _geo = Geoflutterfire();

  Future<List<SalonModel>> getSalons({required LatLng position, required double radius}) async {
    // // printIt('Fetching salons from the server');
    // final GeoFirePoint _center = Geoflutterfire().point(
    //   latitude: position.latitude,
    //   longitude: position.longitude,
    // );
    try {
      List<DocumentSnapshot> _salons = [];

      // var query = Collection.salons.where('isAvailableOnline', isEqualTo: true);

      // Stream<List<DocumentSnapshot>> stream = _geo.collection(collectionRef: query).within(
      //       center: GeoFirePoint(position.latitude, position.longitude),
      //       radius: radius * 0.5,
      //       field: 'position',
      //     );
      // _salons = await stream.first;
      // // // printIt("salon data");
      // // // printIt(_salons.length);
      List<SalonModel> salons = [];
      for (DocumentSnapshot doc in _salons) {
        Map salonMap = doc.data() as Map<dynamic, dynamic>;
        try {
          salonMap['salonId'] = doc.id;
          SalonModel salon = SalonModel.fromJson(salonMap as Map<String, dynamic>);
          if (salon.isAvailableOnline) {
            // salon.distanceFromCenter = _center.distance(
            //   lat: salon.position!.geoPoint!.latitude,
            //   lng: salon.position!.geoPoint!.longitude,
            // );
            salons.add(salon);
          }
        } catch (e) {
          // // printIt(e);
        }
      }
      // // printIt("salons from geofire ${salons.length}");
      return salons;
    } catch (e) {
      // // printIt(e);
      return [];
    }
  }

  // Stream<List<SalonModel>> getSalonsStream({required LatLng position, required double radius}) async* {
  //   // // printIt('Fetching salons from the server');
  //   try {
  //     final GeoFirePoint _center = Geoflutterfire().point(
  //       latitude: position.latitude,
  //       longitude: position.longitude,
  //     );
  //     List<DocumentSnapshot> _salons;

  //     var query = Collection.salons.where('isAvailableOnline', isEqualTo: true);

  //     Stream<List<DocumentSnapshot>> stream = _geo.collection(collectionRef: query).within(
  //           center: GeoFirePoint(position.latitude, position.longitude),
  //           radius: radius,
  //           field: 'position',
  //         );
  //     _salons = await stream.first;
  //     // // printIt("salon data");
  //     // // printIt(_salons.length);
  //     List<SalonModel> salons = [];
  //     for (DocumentSnapshot doc in _salons) {
  //       Map salonMap = doc.data() as Map<dynamic, dynamic>;
  //       try {
  //         salonMap['salonId'] = doc.id;
  //         SalonModel salon = SalonModel.fromJson(salonMap as Map<String, dynamic>);
  //         if (salon.isAvailableOnline) {
  //           salon.distanceFromCenter = _center.distance(
  //             lat: salon.position!.geoPoint!.latitude,
  //             lng: salon.position!.geoPoint!.longitude,
  //           );
  //           salons.add(salon);
  //         }
  //       } catch (e) {
  //         // printIt(e);
  //       }
  //     }
  //     // printIt("salons from geofire ${salons.length}");
  //     yield salons;
  //   } catch (e) {
  //     // printIt(e);
  //     yield [];
  //   }
  // }

  Future<List<SalonModel>?> getSalonsForSearch({required String searchText}) async {
    try {
      //   // printIt('''
      // $searchText,
      // ${searchText[0].toUpperCase()},
      // ${searchText.toUpperCase()},
      // ${searchText.toLowerCase()},
      // ''');
      List<DocumentSnapshot> _salons;

      QuerySnapshot _response = await Collection.salons
          .where(
            'searchTags',
            arrayContainsAny: [
              searchText,
              searchText.toLowerCase(),
              searchText[0].toUpperCase(),
            ],
          )
          .where('isAvailableOnline', isEqualTo: true)
          .limit(10)
          .get();
      // QuerySnapshot _response = await Collection.salons
      //     .orderBy('salonName')
      //     .startAt([searchText[0].toUpperCase()])
      //     .endAt([searchText.toLowerCase() + '\uf8ff'])
      //     // .where('isAvaliableOnline', isEqualTo: true)
      //     .limit(10)
      //     .get();
      _salons = _response.docs;
      // printIt(_response.docs.length);
      // printIt('salon res');

      return _salons.map((e) {
        Map salonMap = e.data() as Map<dynamic, dynamic>;
        salonMap['salonId'] = e.id;
        SalonModel salon = SalonModel.fromJson(salonMap as Map<String, dynamic>);
        return salon;
      }).toList();
    } catch (e) {
      // printIt(e);
    }
    return null;
  }

  //returns salon from it's UID
  // FETCH SALON FROM DB
  Future<SalonModel?> getSalonFromId(String? salonId) async {
    if (salonId == null) return null;

    try {
      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.salons).findOne(
        filter: {"__path__": "salons/$salonId"},
      );

      if (_response != null) {
        Map<String, dynamic> _map = json.decode(_response.toJson()) as Map<String, dynamic>;

        SalonModel salon = SalonModel.fromJson(_map);
        return salon;
      }
    } catch (e) {
      debugPrint("Error on getSalonFromId() - $e");
      return null;
    }
    return null;
  }

  Stream<List<SalonModel>> getSalonFromIdList({required List<String?> salonIds}) async* {
    List<SalonModel> allSaloons = [];
    getAllSalons() async {
      for (int i = 0; i < salonIds.length; i++) {
        DocumentSnapshot _response = await Collection.salons.doc(salonIds[i]).get();
        if (_response.data() != null) {
          Map<String, dynamic> _map = _response.data() as Map<String, dynamic>;
          // printIt(_map);
          _map['salonId'] = _response.id;
          SalonModel salonModel = SalonModel.fromJson(_map);
          allSaloons.add(salonModel);
        }
      }
    }

    await getAllSalons();
    yield allSaloons;
  }

  Future<List<SalonModel>> getSalonFromIdListOnce({required List<String?> salonIds}) async {
    List<SalonModel> allSaloons = [];
    getAllSalons() async {
      for (int i = 0; i < salonIds.length; i++) {
        DocumentSnapshot _response = await Collection.salons.doc(salonIds[i]).get();
        if (_response.data() != null) {
          Map<String, dynamic> _map = _response.data() as Map<String, dynamic>;
          _map['salonId'] = _response.id;
          SalonModel salonModel = SalonModel.fromJson(_map);
          // printIt(salonModel.salonId);
          allSaloons.add(salonModel);
        }
      }
    }

    await getAllSalons();
    return allSaloons;
  }

  Future<List<ReviewModel>> getSalonReviews({required String salonId}) async {
    List<ReviewModel> allReviews = [];

    try {
      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.salons).find(
        filter: {"salonId": salonId},
      );

      for (var item in _response) {
        Map<String, dynamic> decodedItem = json.decode(item.toJson()) as Map<String, dynamic>;
        String path = decodedItem["__path__"];

        if (path.startsWith("salons/$salonId/reviews/")) {
          ReviewModel _reviewModel = ReviewModel.fromJson(decodedItem);

          List splitPath = path.split('/');
          _reviewModel.reviewId = splitPath.last;

          allReviews.add(_reviewModel);
        }
      }
    } catch (err) {
      printIt('Error on getSalonReviews() -$err');
      return [];
    }

    return allReviews;
  }

  // Get Salon Services
  // Future<List<ServiceModel>> getSalonServices({required String salonId}) async {
  //   //   QuerySnapshot _response = await Collection.services.where('salonId', isEqualTo: salonId).get();

  //   List<ServiceModel> allServices = [];
  //   //   for (QueryDocumentSnapshot doc in _response.docs) {
  //   //     try {
  //   //       ServiceModel _serviceModel = ServiceModel.fromJson(doc.data() as Map<String, dynamic>);
  //   //       print('##################');
  //   //       print(_serviceModel.serviceName);
  //   //       print('##################');
  //   //       _serviceModel.serviceId = doc.id;
  //   //       allServices.add(_serviceModel);
  //   //     } catch (e) {
  //   //       // printIt(e);
  //   //     }
  //   //   }
  //   return allServices;
  // }

  // Future updateSalonBlockedTime(SalonModel salon) async {
  //   try {
  //     await Collection.salons.doc(salon.salonId).update({"blockedTime": salon.blockedTime});
  //     return 1;
  //   } catch (e) {
  //     // printIt(e);
  //     return 0;
  //   }
  // }

  //updates the salon data
  Future updateSalon(SalonModel? salon) async {
    try {
      if (salon != null) {
        await Collection.salons.doc(salon.salonId).set(salon.toJson(), SetOptions(merge: true));
        return 1;
      }
    } catch (e) {
      //(e);
      return 0;
    }
  }

  Future updateSalonMongo(SalonModel? salon) async {
    try {
      if (salon != null) {
        final selector = {"__path__": 'salons/${salon.salonId}'};
        final modifier = UpdateOperator.set(salon.toJson());
        await mongodbProvider!.fetchCollection(CollectionMongo.salons).updateOne(filter: selector, update: modifier);

        return 1;
      }
    } catch (e) {
      printIt('Error on updateSalonMongo() - $e');
      return 0;
    }
  }
}
