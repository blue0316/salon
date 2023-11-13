import 'dart:convert';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/mongodb/collection.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cat_sub_service/category_service.dart';
import 'collections.dart';

class CategoryServicesApi {
  // CategoryServicesApi._privateConstructor();
  // static final CategoryServicesApi _instance = CategoryServicesApi._privateConstructor();
  // factory CategoryServicesApi() {
  //   return _instance;
  // }

  CategoryServicesApi._privateConstructor(this.mongodbProvider);

  static final CategoryServicesApi _instance = CategoryServicesApi._privateConstructor(null);

  factory CategoryServicesApi({DatabaseProvider? mongodbProvider}) {
    _instance.mongodbProvider = mongodbProvider;
    return _instance;
  }

  DatabaseProvider? mongodbProvider;

  Future<List<CategoryModel>> getCategories() async {
    try {
      var _response = await mongodbProvider!.db!.getCollection(CollectionMongo.allCategories).find();

      return _response.map<CategoryModel>((e) {
        Map _temp = json.decode(e.toJson()) as Map<String, dynamic>;
        _temp['categoryId'] = _temp['__id__'];

        return CategoryModel.fromJson(_temp as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('Error on getCategories - ${e.toString()}');
      return [];
    }
  }

  Future<List<SubCategoryModel>> getSubCategories() async {
    QuerySnapshot _response;
    try {
      _response = await Collection.allSubCategories.get();
      return _response.docs.map<SubCategoryModel>((e) {
        Map _temp = e.data() as Map<dynamic, dynamic>;
        _temp['subCategoryId'] = e.id;
        return SubCategoryModel.fromJson(_temp as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<ServiceModel>> getSalonServices({required String salonId}) async {
    List<ServiceModel> allServices = [];

    try {
      var _response = await mongodbProvider!.fetchCollection(CollectionMongo.services).findOne(
        filter: {"salonId": salonId},
      );

      if (_response != null) {
        Map<String, dynamic> _temp = json.decode(_response.toJson()) as Map<String, dynamic>;
        _temp['serviceId'] = _temp["__id__"];
        ServiceModel? serviceModel;

        serviceModel = ServiceModel.fromJson(_temp);

        allServices.add(serviceModel);

        // if (serviceModel.priceAndDuration.price != "0") {
        // } else {
        //   printIt('service price not valid ${serviceModel.serviceName} : ${serviceModel.priceAndDuration.price}');
        // }
      }
      return allServices;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<ServiceModel>> getServicesByName({required String searchText}) async {
    try {
      QuerySnapshot _response = await Collection.services
          .where('searchTags', arrayContainsAny: [
            searchText,
            searchText[0].toUpperCase(),
            searchText.toUpperCase(),
            searchText.toLowerCase(),
          ])
          .where('isAvailableOnline', isEqualTo: true)
          .limit(5)
          .get();
      // QuerySnapshot _response = await Collection.services
      //     .orderBy('serviceName')
      //     .startAt([searchText[0].toUpperCase()])
      //     .endAt([searchText.toLowerCase() + '\uf8ff'])
      //     // .where('isAvaliableOnline', isEqualTo: true)
      //     .limit(10)
      //     .get();
      printIt(_response.docs.length);
      printIt('services res');
      List<ServiceModel> allServices = [];
      for (DocumentSnapshot doc in _response.docs) {
        Map _temp = doc.data() as Map<dynamic, dynamic>;
        _temp['serviceId'] = doc.id;
        ServiceModel? serviceModel;
        try {
          serviceModel = ServiceModel.fromJson(_temp);
        } catch (e) {
          printIt(e);
        }
        if (serviceModel != null) {
          allServices.add(serviceModel);
          // if (serviceModel.isAvailableOnline) {
          // } else {
          //   printIt('service not available ${serviceModel.serviceName}');
          // }
        }
      }
      return allServices;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
