// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/mongodb/db_service.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/home/home_iframe.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bot_toast/bot_toast.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'src/mongodb/collection.dart';
import 'src/routes.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // if (adminMongo != null) {
  //   stylePrint('CHECKPOINT B');

  //   print(adminMongo);
  //   // var admin = json.decode(adminMongo!.toJson()) as Map<String, dynamic>;
  //   // print(admin);

  //   // var fullDocument = MongoDocument.parse(adminMongo);
  //   // print(fullDocument);

  //   stylePrint('');
  // }

  // await Firebase.initializeApp();
  // await initializeNotifications();
  await dotenv.load();

  final el = html.window.document.getElementById('__ff-recaptcha-container');
  if (el != null) {
    el.style.visibility = 'hidden';
  }

  if (!kIsWeb) {
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  //logs the app opening..okay
  // Analytics.openApp();

  usePathUrlStrategy();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool loading = false;
  @override
  void initState() {
    super.initState();

    loadDBFromProvider();
  }

  loadDBFromProvider() async {
    setState(() => loading = true);
    final _dbProvider = ref.read(dbProvider);
    await _dbProvider.initMongoDB();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final _bnbProvider = ref.watch(bnbProvider);

    // todo wrap with settings provider
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ),
          )
        : ScreenUtilInit(
            designSize: const Size(414, 896),
            minTextAdapt: true,
            builder: (context, c) => MaterialApp.router(
              routerConfig: router,
              // routeInformationParser: router.routeInformationParser,
              // routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              //useInheritedMediaQuery: true, // !! remove with device previewe
              localeResolutionCallback: (
                Locale? locale,
                Iterable<Locale> supportedLocales,
              ) {
                return _bnbProvider.getLocale;
              },
              locale: _bnbProvider.getLocale,
              title: 'Glamiris',
              theme: AppTheme.mainTheme,

              builder: BotToastInit(),

              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown,
                },
              ),
            ),
          );
  }
}

class NavigatorPage extends ConsumerStatefulWidget {
  static const route = "/home";
  static const redirect = "";
  const NavigatorPage({Key? key}) : super(key: key);
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends ConsumerState<NavigatorPage> {
  @override
  void initState() {
    super.initState();
    final AppProvider _appProvider = ref.read(appProvider);
    printIt("current location : ${router.location}");
    _appProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    // final AppProvider _appProvider = ref.watch(appProvider);
    // return Container(
    //   color: Colors.purple,
    //   child: const Text('OMO NAWA'),
    // );
    return const Material(
      color: AppTheme.white,
      child: HomeIframe(),
    );
  }
}

Set availableLocales = {'ar', 'en', 'es', 'fr', 'pt', 'ro', 'uk', 'cs'};

class OmoTest2 extends ConsumerStatefulWidget {
  static const route = 'salon';
  final String salonId;
  final String locale;
  final bool showBooking;

  const OmoTest2({super.key, required this.salonId, required this.locale, required this.showBooking});

  @override
  ConsumerState<OmoTest2> createState() => _OmoTest2State();
}

class _OmoTest2State extends ConsumerState<OmoTest2> {
  @override
  void initState() {
    super.initState();
    // aaa();
  }

  aaa() async {
    // final provider = ref.watch(bnbProvider);

    // var adminMongo = await provider.db!.getCollection('salons').findOne(
    //   filter: {"__path__": "salons/35krciRAhaew9sZ07RnY"},
    //   projection: {},
    // );
    // print(adminMongo);
    // var admin = json.decode(adminMongo!.toJson()) as Map<String, dynamic>;
    // print(admin);

    // // var fullDocument = MongoDocument.parse(adminMongo);
    // // print(fullDocument);

    // stylePrint('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          final provider = ref.read(dbProvider);
          stylePrint('test on dummy widget');

          var adminMongo = await provider.fetchCollection(CollectionMongo.services).findOne(
            filter: {"salonId": "PpYIROiYRN683G9JenMQ"},
          );

          stylePrint('test on dummy complete');

          print(adminMongo);
          var admin = json.decode(adminMongo!.toJson()) as Map<String, dynamic>;
          print(admin);

          stylePrint('test on dummy widget 2 ');
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.pink,
        ),
      ),
    );
  }
}



//////
// ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:convert';

// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/app_provider.dart';
// import 'package:bbblient/src/theme/app_main_theme.dart';
// import 'package:bbblient/src/utils/utils.dart';
// import 'package:bbblient/src/views/home/home_iframe.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:bot_toast/bot_toast.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:html' as html;
// import 'src/mongodb/collection.dart';
// import 'src/routes.dart';
// import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // initialize Realm
//   await RealmApp.init("glamirisapp-ylzgj");

//   MongoRealmClient? client;
//   MongoRealmClient? collection;
//   MongoDatabase? db;

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

//   CoreRealmUser? mongoUser = await app.login(Credentials.jwt(jwtPref)).then((value) async {
//     client = MongoRealmClient();
//     db = client!.getDatabase("glamiris");
//     var adminMongo = await db?.getCollection('services').find(
//       filter: {"salonId": "PpYIROiYRN683G9JenMQ"},
//     );

//     stylePrint('$db');
//     // await initializeNotifications();
//     // centralState.initializeAppMongo();

//     return value;
//   });

//   stylePrint('CHECKPOINT A');
//   stylePrint('$db');
//   stylePrint('CHECKPOINT ----');

//   // if (adminMongo != null) {
//   //   stylePrint('CHECKPOINT B');

//   //   print(adminMongo);
//   //   // var admin = json.decode(adminMongo!.toJson()) as Map<String, dynamic>;
//   //   // print(admin);

//   //   // var fullDocument = MongoDocument.parse(adminMongo);
//   //   // print(fullDocument);

//   //   stylePrint('');
//   // }

//   // await Firebase.initializeApp();
//   // await initializeNotifications();
//   await dotenv.load();

//   final el = html.window.document.getElementById('__ff-recaptcha-container');
//   if (el != null) {
//     el.style.visibility = 'hidden';
//   }

//   if (!kIsWeb) {
//     // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
//     // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//   }
//   //logs the app opening..okay
//   // Analytics.openApp();
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context, ref) {
//     final _bnbProvider = ref.watch(bnbProvider);

//     // todo wrap with settings provider
//     return ScreenUtilInit(
//       designSize: const Size(414, 896),
//       minTextAdapt: true,
//       builder: (context, c) => MaterialApp.router(
//         routerConfig: router,
//         // routeInformationParser: router.routeInformationParser,
//         // routerDelegate: router.routerDelegate,
//         debugShowCheckedModeBanner: false,
//         localizationsDelegates: AppLocalizations.localizationsDelegates,
//         supportedLocales: AppLocalizations.supportedLocales,
//         //useInheritedMediaQuery: true, // !! remove with device previewe
//         localeResolutionCallback: (
//           Locale? locale,
//           Iterable<Locale> supportedLocales,
//         ) {
//           return _bnbProvider.getLocale;
//         },
//         locale: _bnbProvider.getLocale,
//         title: 'Glamiris',
//         theme: AppTheme.mainTheme,

//         builder: BotToastInit(),

//         scrollBehavior: const MaterialScrollBehavior().copyWith(
//           dragDevices: {
//             PointerDeviceKind.mouse,
//             PointerDeviceKind.touch,
//             PointerDeviceKind.stylus,
//             PointerDeviceKind.unknown,
//           },
//         ),
//       ),
//     );
//   }
// }

// class NavigatorPage extends ConsumerStatefulWidget {
//   static const route = "/home";
//   static const redirect = "";
//   const NavigatorPage({Key? key}) : super(key: key);
//   @override
//   _NavigatorPageState createState() => _NavigatorPageState();
// }

// class _NavigatorPageState extends ConsumerState<NavigatorPage> {
//   @override
//   void initState() {
//     super.initState();
//     final AppProvider _appProvider = ref.read(appProvider);
//     printIt("current location : ${router.location}");
//     _appProvider.init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final AppProvider _appProvider = ref.watch(appProvider);
//     // return Container(
//     //   color: Colors.purple,
//     //   child: const Text('OMO NAWA'),
//     // );
//     return const Material(
//       color: AppTheme.white,
//       child: HomeIframe(),
//     );
//   }
// }

// Set availableLocales = {'ar', 'en', 'es', 'fr', 'pt', 'ro', 'uk', 'cs'};

// class OmoTest2 extends ConsumerStatefulWidget {
//   static const route = 'salon';
//   final String salonId;
//   final String locale;
//   final bool showBooking;

//   const OmoTest2({super.key, required this.salonId, required this.locale, required this.showBooking});

//   @override
//   ConsumerState<OmoTest2> createState() => _OmoTest2State();
// }

// class _OmoTest2State extends ConsumerState<OmoTest2> {
//   @override
//   void initState() {
//     super.initState();
//     aaa();
//   }

//   aaa() async {
//     final provider = ref.watch(bnbProvider);

//     var adminMongo = await provider.db!.getCollection('salons').findOne(
//       filter: {"__path__": "salons/35krciRAhaew9sZ07RnY"},
//       projection: {},
//     );
//     print(adminMongo);
//     var admin = json.decode(adminMongo!.toJson()) as Map<String, dynamic>;
//     print(admin);

//     // var fullDocument = MongoDocument.parse(adminMongo);
//     // print(fullDocument);

//     stylePrint('');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
