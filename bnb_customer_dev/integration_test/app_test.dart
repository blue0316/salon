import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'robots/existing_user.dart';
import 'robots/home_page_robot.dart';
import 'robots/login_screen_robot.dart';
import 'robots/onboarding_page_robot.dart';
import 'robots/profile_screen_robot.dart';
import 'robots/salon_services_robot.dart';
import 'robots/single_master_robot.dart';

/// this tests will make use of robot methods in  which each screen has its robot that implements the tests for that specific screen
void main() async {
  final firstTime = AppProvider();
  firstTime.init();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await initializeNotifications();

  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //logs the app opening
  // Analytics.openApp();
  runApp(const ProviderScope(child: MyApp()));
  HomeRobot homeRobot;
  LoginRobots loginRobots;
  NotFirstTimeRobot notFirstTimeRobot;
  OnboardingRobot onboardingRobot;
  SalonServicesBookingRobot salonBookingRobot;
  ProfileScreenRobot profileScreenRobot;
  SingleMasterRobot singleMasterRobot;

  group("Testing bnb customers", () {
    testWidgets("testing different screen robots", (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();
      homeRobot = HomeRobot(tester);
      loginRobots = LoginRobots(tester);
      onboardingRobot = OnboardingRobot(tester);
      salonBookingRobot = SalonServicesBookingRobot(tester);
      profileScreenRobot = ProfileScreenRobot(tester);
      singleMasterRobot = SingleMasterRobot(tester);
      notFirstTimeRobot = NotFirstTimeRobot(tester);
      // final userLoggedIn = AuthProviderController();
      if (firstTime.isFirstTime) {
        await onboardingRobot.navigatingToOnboarding();
        await homeRobot.navigatingToHomePage();
        await loginRobots.loginIn();
        await homeRobot.checkingForHomeScreenWidgets();
        await profileScreenRobot.checkingForProfileScreenWidgets();
        await homeRobot.tappingOnASalonOnTheHomeScreen();
        await salonBookingRobot.selectingASaloonService();
        await salonBookingRobot.tapOnBookKey();
        await salonBookingRobot.selectingAMaster();
        await salonBookingRobot.conirmMastersBooking();
        await salonBookingRobot.confirmBooking();
        await salonBookingRobot.successfulBooking();
        await salonBookingRobot.navigatingToNotifScreen();
        await singleMasterRobot.selectingAMaster();
        await singleMasterRobot.choosingAMasterService();
        await singleMasterRobot.bookingAMastersService();
        // } else if (firstTime.isFirstTime == false && userLoggedIn.userLoggedIn == false) {
        //then we want to log in the user
        await notFirstTimeRobot.goToHomePage();
        await loginRobots.loginIn();
        await homeRobot.checkingForHomeScreenWidgets();
        await profileScreenRobot.checkingForProfileScreenWidgets();
        await homeRobot.tappingOnASalonOnTheHomeScreen();
        await salonBookingRobot.selectingASaloonService();
        await salonBookingRobot.tapOnBookKey();
        await salonBookingRobot.selectingAMaster();
        await salonBookingRobot.conirmMastersBooking();
        await salonBookingRobot.confirmBooking();
        await salonBookingRobot.successfulBooking();
        await salonBookingRobot.navigatingToNotifScreen();
        await singleMasterRobot.selectingAMaster();
        await singleMasterRobot.choosingAMasterService();
        await singleMasterRobot.bookingAMastersService();
        // } else if (userLoggedIn.userLoggedIn == true) {
        //then we want to check that the user is logged in
        await notFirstTimeRobot.ifUserIsloggedIn();
        await homeRobot.checkingForHomeScreenWidgets();
        await profileScreenRobot.checkingForProfileScreenWidgets();
        await homeRobot.tappingOnASalonOnTheHomeScreen();
        await salonBookingRobot.selectingASaloonService();
        await salonBookingRobot.tapOnBookKey();
        await salonBookingRobot.selectingAMaster();
        await salonBookingRobot.conirmMastersBooking();
        await salonBookingRobot.confirmBooking();
        await salonBookingRobot.successfulBooking();
        await salonBookingRobot.navigatingToNotifScreen();
        await singleMasterRobot.selectingAMaster();
        await singleMasterRobot.choosingAMasterService();
        await singleMasterRobot.bookingAMastersService();
      }
      //await singleMasterRobot.selectingBookingTime();
    });
  });
}
