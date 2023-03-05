import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/analytics.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/home_page.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bbblient/src/utils/notification/notifications.dart';
import 'package:bbblient/src/views/onboarding/onboarding.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:html' as html;
import 'src/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await initializeNotifications();
  final el = html.window.document.getElementById('__ff-recaptcha-container');
  if (el != null) {
    el.style.visibility = 'hidden';
  }

  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  //logs the app opening..okay
  Analytics.openApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final _bnbProvider = ref.watch(bnbProvider);

    // todo wrap with settings provider
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      builder: (context, c) => MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        //useInheritedMediaQuery: true, // !! remove with device preview
        localeResolutionCallback: (
          Locale? locale,
          Iterable<Locale> supportedLocales,
        ) {
          return _bnbProvider.getLocale;
        },
        locale: _bnbProvider.getLocale,
        title: 'bnb',
        theme: AppTheme.lightTheme,

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
    final AppProvider _appProvider = ref.watch(appProvider);
    return Material(
      color: AppTheme.white,
      child: Loader(
        status: _appProvider.appStatus,
        child: _appProvider.isFirstTime ? const OnBoarding() : const HomePage(),
      ),
    );
  }
}
// 