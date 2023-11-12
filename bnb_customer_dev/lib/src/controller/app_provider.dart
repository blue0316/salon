// ignore_for_file: prefer_conditional_assignment

// import 'package:bbblient/src/firebase/master.dart';
import 'package:bbblient/src/models/enums/status.dart';
// import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  Status appStatus = Status.loading;
  bool isFirstTime = false;
  // MasterModel? salonMaster;
  String? firstRoute;
  // String? masterId;

  // // DATABASE CONNECTION
  // MongoRealmClient? client;
  // MongoRealmClient? collection;
  // MongoDatabase? db;

  // initMongoDB() async {
  //   stylePrint('INITIALIZE DB');
  //   // initialize Realm
  //   await RealmApp.init("glamirisapp-ylzgj");

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var jwtPref = prefs.getString("jwtPref");

  //   if (jwtPref == null) {
  //     String? deviceInfo = await Utils().getDeviceInfo();

  //     final jwt = JWT(
  //       {
  //         "aud": "glamirisapp-ylzgj",
  //         "sub": "654cee212b2a1443f89fd1a6",
  //         "createdAt": (DateTime.now()).toString(),
  //         "name": deviceInfo,
  //         "pass": "jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746",
  //       },
  //       // {"UID": deviceInfo!, "createdAt": DateTime.now().toString()},
  //       issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
  //     );

  //     // Sign it (default with HS256 algorithm)
  //     final token = jwt.sign(SecretKey("jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746"), expiresIn: const Duration(days: 6));
  //     jwtPref = token;
  //     prefs.setString("jwtPref", token);
  //   } else {
  //     final jwtToken = JWT.verify(jwtPref, SecretKey("jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746"));
  //     // debugPrint('__------+++++-------___');
  //     // debugPrint('${jwtToken.audience}');
  //     // debugPrint('__------+++++-------___');

  //     if (DateTime.parse(jwtToken.payload["createdAt"]).add(const Duration(days: 5)).isBefore(DateTime.now())) {
  //       String? deviceInfo = await Utils().getDeviceInfo();
  //       // String? deviceInfo = DateTime(2025, 8, 2).difference(DateTime.now()).toString(); // await Utils().getDeviceInfo();

  //       final jwt = JWT(
  //         {
  //           "aud": "glamirisapp-ylzgj",
  //           "sub": "654cee212b2a1443f89fd1a6",
  //           "createdAt": (DateTime.now()).toString(),
  //           "name": deviceInfo,
  //           "pass": "jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746",
  //         },
  //         // {"UID": deviceInfo!, "createdAt": DateTime.now().toString()},
  //         issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
  //       );

  //       // Sign it (default with HS256 algorithm)
  //       final token = jwt.sign(
  //         SecretKey("jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746"),
  //         expiresIn: const Duration(days: 6),
  //       );
  //       jwtPref = token;
  //       prefs.setString("jwtPref", token);
  //     }
  //   }

  //   final RealmApp app = RealmApp();

  //   await app.login(Credentials.jwt(jwtPref)).then(
  //     (value) async {
  //       client = MongoRealmClient();
  //       db = client!.getDatabase("glamiris");
  //       if (db != null) {
  //         stylePrint('MONGODB CONNECTED!');
  //       }
  //     },
  //   );
  // }

  init() async {
    appStatus = Status.loading;
    await getSalonFirstTime();
    appStatus = Status.success;
    // selectMasterID();
    selectFirstRoute();
    // retrieveSalonMasterModel();
    notifyListeners();
  }
  //
  // retrieveSalonMasterModel()async{
  //   salonMaster = await MastersApi().getMasterFromId(masterId!);
  //   print('salonMaster Id '+salonMaster!.masterId.toString());
  //   notifyListeners();
  // }

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
      // printIt('It contains \'locale\'');
      firstRoute = router.location;
    } else {
      // printIt('It does not contains \'locale\'');
    }
    notifyListeners();
  }
  //
  // selectMasterID(){
  //   if (router.location.contains('master')) {
  //     masterId = router.location.split('=').last;
  //     print('the master id '+ masterId.toString());
  //   }
  //   }

  selectSalonFirstRoute() async {
    // printIt("This is the $firstRoute");
    if (firstRoute == null) {
      firstRoute = router.location;
    }

    notifyListeners();
  }
}

stylePrint(String item) {
  printIt("--------------********--------------");
  printIt(item);
  printIt("--------------********--------------");
}
