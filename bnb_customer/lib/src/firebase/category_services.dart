import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cat_sub_service/category_service.dart';
import 'collections.dart';

class CategoryServicesApi {
  CategoryServicesApi._privateConstructor();
  static final CategoryServicesApi _instance =
      CategoryServicesApi._privateConstructor();
  factory CategoryServicesApi() {
    return _instance;
  }

  Future<List<CategoryModel>> getCategories() async {
    QuerySnapshot _response;
    try {
      _response = await Collection.allCategories.get();

      return _response.docs.map<CategoryModel>((e) {
        // print(e.data().);
        Map _temp = e.data() as Map<dynamic, dynamic>;
        _temp['categoryId'] = e.id;

        return CategoryModel.fromJson(_temp as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('eeee${e.toString()}');
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
    try {
      QuerySnapshot _response =
          await Collection.services.where('salonId', isEqualTo: salonId).get();
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
          // print(serviceModel.serviceName);
          allServices.add(serviceModel);

          // if (serviceModel.priceAndDuration.price != "0") {
          // } else {
          //   printIt('service price not valid ${serviceModel.serviceName} : ${serviceModel.priceAndDuration.price}');
          // }
        }
      }
      return allServices;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<List<ServiceModel>> getServicesByName(
      {required String searchText}) async {
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
