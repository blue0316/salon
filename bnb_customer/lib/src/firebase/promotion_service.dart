import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PromotionServiceApi {
  PromotionServiceApi._privateConstructor();
  static final PromotionServiceApi _instance =
      PromotionServiceApi._privateConstructor();
  factory PromotionServiceApi() {
    return _instance;
  }

  Future<List<PromotionModel>> getMasterActivePromtions(
      {required String salonId}) async {
    try {
      QuerySnapshot _response = await Collection.promotions
          .where('salonId', isEqualTo: salonId)
          .where('activeStatus', isEqualTo: true)
          .get();
      List<PromotionModel> allPromotions = [];
      for (DocumentSnapshot doc in _response.docs) {
        Map _temp = doc.data() as Map<dynamic, dynamic>;
        _temp['promoDocId'] = doc.id;
        PromotionModel? promotionModel;
        try {
          promotionModel =
              PromotionModel.fromJson(_temp as Map<String, dynamic>);
        } catch (e) {
          printIt(e);
        }
        if (promotionModel != null) {
          // print(serviceModel.serviceName);
          allPromotions.add(promotionModel);

          // if (serviceModel.priceAndDuration.price != "0") {
          // } else {
          //   printIt('service price not valid ${serviceModel.serviceName} : ${serviceModel.priceAndDuration.price}');
          // }
        }
      }
      // printIt("Salon promotions");
      // printIt(allPromotions);
      return allPromotions;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
