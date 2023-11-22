// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/home/home_iframe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:html' as html;
import 'src/routes.dart';
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
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    // todo wrap with settings provider
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ScreenUtilInit(
            designSize: !isTab ? const Size(414, 896) : const Size(1440, 828), //  Size(1200, 800), //
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
    //   child: const Text('DEV ENV'),
    // );
    return const Material(
      color: AppTheme.white,
      child: HomeIframe(),
    );
  }
}

Set availableLocales = {'ar', 'en', 'es', 'fr', 'pt', 'ro', 'uk', 'cs'};
