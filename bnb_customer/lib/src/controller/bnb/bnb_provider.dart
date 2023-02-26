import 'dart:async';
import 'dart:io';

import 'package:bbblient/src/firebase/app_data.dart';
import 'package:bbblient/src/firebase/bonus_referral_api.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/firebase/customer.dart';
import 'package:bbblient/src/firebase/master.dart';
// import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/models/app_initialize.dart';
import 'package:bbblient/src/models/appointment/notification.dart';
import 'package:bbblient/src/models/banner_model.dart';
import 'package:bbblient/src/models/bonus_model.dart';
import 'package:bbblient/src/models/bonus_setttings_model.dart';
import 'package:bbblient/src/models/customer/customer.dart';
import 'package:bbblient/src/models/enums/location.dart';
import 'package:bbblient/src/models/enums/platform.dart';
import 'package:bbblient/src/models/referral.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
// import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// loads important app settings and firebase data for initialisation of app
class BnbProvider with ChangeNotifier {
  List<BannerModel> generalBanners = [];
  List<BannerModel> userBanners = [];
  List<BonusModel> bonuses = [];
  List<NotificationModel> notifications = [];
  int totalBonus = 0;
  List<ReferralModel> referrals = [];
  BonusSettings bonusSettings = BonusSettings(
    doubleHours: 0,
    installBonusesAmounts: [],
    installBonusesValidity: [],
    referralBonusesAmounts: [],
    referralBonusesValidity: [],
    referralsActive: false,
    installBonusActive: false,
  );
  CustomerModel? customer;
  MasterModel? salonMaster;
  Connectivity connectivity = Connectivity();
  CurrentPlatform platform = computePlatform();
  String? langCode;
  LatLng? selectedLocation;
  String? selectedAddress;
  bool isConnectionStable = true;
  LocationModel currentLocation = LocationModel();
  Locale locale = const Locale('en');
  AppInitialization appInitialization = AppInitialization(serverDownReason: {}, serverDown: false);
  get getLocale => locale;
  get getCurrenMaster => salonMaster;
  final AppData _appData = AppData();
  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // @override
  // void dispose() {
  //    printIt("BnbProvider ChangeNotifier is disposed");
  //   _connectivitySubscription!.cancel();
  //   super.dispose();
  // }

  Future initializeApp({CustomerModel? customerModel, Locale? lang}) async {
    locale = lang ?? const Locale("en");

    if (!kIsWeb) {
      await monitorInternetConnection();
    }

    printIt("Getting to this place ");
    appInitialization = await _appData.getAppInitialization() ?? AppInitialization(serverDownReason: {}, serverDown: false);

    generalBanners = await _appData.getBanners();

    if (customerModel != null) {
      customer = customerModel;
      await getBonusSettings();
      await getNotifications(customerId: customerModel.customerId);
      await getBonuses(customerId: customerModel.customerId);
    }
  }

  refresh() async {
    if (customer == null) return;
    await getNotifications(customerId: customer!.customerId);
    await getBonuses(customerId: customer!.customerId);
  }

  Future getBonuses({required String customerId}) async {
    try {
      totalBonus = 0;
      bonuses = await BonusReferralApi().getBonuses(customerId: customerId);
      for (BonusModel b in bonuses) {
        totalBonus = totalBonus + b.amount;
      }

      notifyListeners();
    } catch (e) {
      printIt(e);
    }
  }

  Future getNotifications({required String customerId}) async {
    totalBonus = 0;
    QuerySnapshot snapshot = await Collection.notifications.where('targetId', isEqualTo: customerId).get();
    for (DocumentSnapshot snap in snapshot.docs) {
      try {
        NotificationModel _notif = NotificationModel.fromJson(snap.data() as Map<String, dynamic>);
        notifications.add(_notif);
      } catch (e) {
        printIt(e);
      }
    }
    notifications.sort((a, b) => DateTime.parse(b.triggerTime.toString()).compareTo(DateTime.parse(a.triggerTime.toString())));
    notifyListeners();
  }

  //
  retrieveSalonMasterModel(String id) async {
    salonMaster = await MastersApi().getMasterFromId(id);
    debugPrint('salonMaster Id ' + salonMaster!.masterId.toString());
    notifyListeners();
  }

  void changeLocale({required Locale locale}) async {
    this.locale = locale;
    notifyListeners();
    if (customer == null) return;
    await CustomerApi().updateLocale(customerId: customer!.customerId, locale: locale.toLanguageTag());
    notifyListeners();
  }

  //toggle the favourites present
  Future<void> toggleFav(String salonId) async {
    if (customer == null || salonId == "") return;

    final bool _isFav = checkForFav(salonId);
    if (_isFav) {
      await _removeFavourites(salonId);
    } else {
      await _addFavourites(salonId);
    }

    notifyListeners();
  }

  //checks if the salon is fav or not
  bool checkForFav(String salonId) {
    if (customer == null) return false;
    return customer!.favSalons.contains(salonId);
  }

  // checks if any favourite salon is present
  bool isFavPresent(List<SalonModel> salons) {
    if (customer == null || customer!.favSalons.isEmpty) return false;
    for (SalonModel salon in salons) {
      if (customer!.favSalons.contains(salon.salonId)) {
        return true;
      }
    }
    return false;
  }

  _addFavourites(String salonId) {
    customer!.favSalons.add(salonId);
    CustomerApi().updateFavourites(customer!);
  }

  _removeFavourites(String salonId) {
    customer!.favSalons.remove(salonId);
    CustomerApi().updateFavourites(customer!);
  }

  Future getBonusSettings() async {
    try {
      DocumentSnapshot snap = await Collection.appData.doc('referralSettings').get();
      if (snap.exists) {
        bonusSettings = BonusSettings.fromJson(snap.data() as Map<String, dynamic>);
        printIt(bonusSettings.toJson());
        notifyListeners();
      }
    } catch (e) {
      printIt(e.toString());
    }
  }

  static CurrentPlatform computePlatform() {
    if (kIsWeb) {
      return CurrentPlatform(isWeb: true);
    } else {
      if (Platform.isIOS) {
        return CurrentPlatform(isIOS: true);
      } else {
        return CurrentPlatform(isAndroid: true);
      }
    }
  }

  monitorInternetConnection() async {
    //checking for the initial status
    final ConnectivityResult status = await connectivity.checkConnectivity();
    printIt(status);
    isConnectionStable = (status != ConnectivityResult.none);
    if (status == ConnectivityResult.none) {
      showToast('No Network');
    }
    notifyListeners();
    // _connectivitySubscription =
    connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        printIt("stream $result");
        if (result == ConnectivityResult.none) {
          showToast('No Network');
        }
        isConnectionStable = (result != ConnectivityResult.none);
        notifyListeners();
      },
    );
    // notifyListeners();
  }
}
