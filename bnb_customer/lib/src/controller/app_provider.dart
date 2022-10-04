// ignore_for_file: prefer_conditional_assignment

import 'package:bbblient/main.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  Status appStatus = Status.loading;
  bool isFirstTime = false;
  String? firstRoute;

  init() async {
    appStatus = Status.loading;
    await getSalonFirstTime();
    appStatus = Status.success;
    selectFirstRoute();
    notifyListeners();
  }

  setSalonFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = false;
    await prefs.setBool(Keys.isFirstTime, false);
    notifyListeners();
  }

  getSalonFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool(Keys.isFirstTime) ?? true;
  }

  //selecting route after going through referral link
  selectFirstRoute() async {
    if (router.location.contains('locale')) {
      printIt('It contains \'locale\'');
      firstRoute = router.location;
    } else {
      printIt('It does not contains \'locale\'');
    }
    notifyListeners();
  }

  selectSalonFirstRoute() async {
    printIt("This is the $firstRoute");
    if (firstRoute == null) {
      firstRoute = router.location;
    }

    notifyListeners();
  }
}
