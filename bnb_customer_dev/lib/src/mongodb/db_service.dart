import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  // // Initialize the database in the constructor
  // DatabaseProvider() {
  //   _initDatabase();
  // }

  // DATABASE CONNECTION
  MongoRealmClient? client;
  MongoRealmClient? collection;
  MongoDatabase? db;

  bool connected = false;
  get dbConnected => connected;

  initMongoDB() async {
    // No deed to run if connected already
    if (connected) return;

    // initialize Realm
    await RealmApp.init("glamirisapp-ylzgj");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwtPref = prefs.getString("jwtPref");

    if (jwtPref == null) {
      String? deviceInfo = await Utils().getDeviceInfo();

      final jwt = JWT(
        {
          "aud": "glamirisapp-ylzgj",
          "sub": "654cee212b2a1443f89fd1a6",
          "createdAt": (DateTime.now()).toString(),
          "name": deviceInfo,
          "pass": "jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746",
        },
        // {"UID": deviceInfo!, "createdAt": DateTime.now().toString()},
        issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
      );

      // Sign it (default with HS256 algorithm)
      final token = jwt.sign(SecretKey("jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746"), expiresIn: const Duration(days: 6));
      jwtPref = token;
      prefs.setString("jwtPref", token);
    } else {
      final jwtToken = JWT.verify(jwtPref, SecretKey("jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746"));
      // debugPrint('__------+++++-------___');
      // debugPrint('${jwtToken.audience}');
      // debugPrint('__------+++++-------___');

      if (DateTime.parse(jwtToken.payload["createdAt"]).add(const Duration(days: 5)).isBefore(DateTime.now())) {
        String? deviceInfo = await Utils().getDeviceInfo();
        // String? deviceInfo = DateTime(2025, 8, 2).difference(DateTime.now()).toString(); // await Utils().getDeviceInfo();

        final jwt = JWT(
          {
            "aud": "glamirisapp-ylzgj",
            "sub": "654cee212b2a1443f89fd1a6",
            "createdAt": (DateTime.now()).toString(),
            "name": deviceInfo,
            "pass": "jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746",
          },
          // {"UID": deviceInfo!, "createdAt": DateTime.now().toString()},
          issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
        );

        // Sign it (default with HS256 algorithm)
        final token = jwt.sign(
          SecretKey("jhhdhvvcvdvfvvfvrfhjHJKKKEEHWKWEUJYYTRGBGSFT6338738746574849938737455389290384746"),
          expiresIn: const Duration(days: 6),
        );
        jwtPref = token;
        prefs.setString("jwtPref", token);
      }
    }

    final RealmApp app = RealmApp();

    await app.login(Credentials.jwt(jwtPref)).then(
      (value) async {
        client = MongoRealmClient();
        db = client!.getDatabase("glamiris");
        if (db != null) {
          stylePrint('MONGODB CONNECTED!');
          connected = true;
        }

        notifyListeners();
      },
    );
  }

  // Method to get a collection from the database
  MongoCollection fetchCollection(String collectionName) {
    return db!.getCollection(collectionName);
  }

  Future<void> closeDatabase() async {}
}
