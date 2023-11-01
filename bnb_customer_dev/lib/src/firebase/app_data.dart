import 'package:bbblient/src/models/app_initialize.dart';
import 'package:bbblient/src/models/banner_model.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'collections.dart';

class AppData {
  AppData._privateConstructor();
  static final AppData _instance = AppData._privateConstructor();
  factory AppData() {
    return _instance;
  }

  Future<AppInitialization?> getAppInitialization() async {
    try {
      DocumentSnapshot<Object?> _response = await Collection.appData.doc('initialize').get();
      if (_response.exists) {
        return AppInitialization.fromJson(_response.data());
      } else {
        return null;
      }
    } catch (e) {
      // debugPrint(e.toString());
      return null;
    }
  }

  Future<List<BannerModel>> getBanners() async {
    List<BannerModel> _banners = [];
    try {
      QuerySnapshot _response = await Collection.appData.doc('0').collection('banners').get();
      printIt('banners snapshot length =>${_response.docs.length}');

      for (QueryDocumentSnapshot doc in _response.docs) {
        try {
          BannerModel _banner = BannerModel.fromJson(doc.data() as Map<String, dynamic>);
          _banners.add(_banner);
          printIt(_banner.toJson());
        } catch (e) {
          printIt(e);
        }
      }

      return _banners;
    } catch (e) {
      // debugPrint(e.toString());
      return [];
    }
  }
}
