import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/controller/appointment/apointment_provider.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/home/salon_search_provider.dart';
import 'package:bbblient/src/firebase/dynamic_link.dart';
import 'package:bbblient/src/routes.dart';
import 'package:bbblient/src/utils/analytics.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/widgets/smooth_scroll/smooth_scroll.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_main_theme.dart';
import '../utils/bottom_nav_bar.dart';
import '../utils/icons.dart';
import 'calendar/calendar_view.dart';
import 'favourites/favourites.dart';
import 'home/home.dart';
import 'notifications/notifications.dart';
import 'profile/user_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends ConsumerStatefulWidget {
  //  static const route = "/homepage";
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late BnbProvider _bnbProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initHome();
  }

  initHome() async {
    _bnbProvider = ref.read(bnbProvider);
    printIt(router.location);
    AuthProvider _authProvider = ref.read(authProvider);
    SalonSearchProvider _salonSearchProvider = ref.read(salonSearchProvider);
    AppointmentProvider _appointmentProvider = ref.read(appointmentProvider);

    await _authProvider.getUserInfo(context: context);

    await _bnbProvider.initializeApp(
        customerModel: _authProvider.currentCustomer,
        lang: _bnbProvider.getLocale);

    setState(() {});
    await _salonSearchProvider.initialize();

    if (_authProvider.userLoggedIn) {
      await DynamicLinksApi().handleDynamicLink(
          context: context, bonusSettings: _bnbProvider.bonusSettings);
      await _appointmentProvider.loadAppointments(
        customerId: _authProvider.currentCustomer?.customerId ?? '',
        salonSearchProvider: _salonSearchProvider,
      );
      _authProvider.quizReminder(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 0.0.h,
        ),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            checkUser(
                context,
                ref,
                () => setState(() {
                      _currentIndex = i;
                      _pageController.jumpToPage(
                        i,
                      );
                      Analytics.reportTabChange(selectedTab: i, tabNames: [
                        "home",
                        "favourites",
                        "calendarView",
                        "profile",
                        "notifications"
                      ]);
                    }));
          },
          curve: Curves.ease,
          duration: const Duration(milliseconds: 200),
          selectedColorOpacity: 1,
          backgroundColor: Colors.white,
          itemPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin:
              EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w, top: 8),
          items: [
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 20.h,
                width: 24.h,
                child: SvgPicture.asset(AppIcons.homeIconSVG),
              ),
              title: Text(
                AppLocalizations.of(context)?.home ?? "Home",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textBlack),
              ),
              selectedColor: AppTheme.milkeyGrey,
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 20.h,
                width: 24.h,
                child: SvgPicture.asset(AppIcons.heartIconSVG),
              ),
              title: Text(
                AppLocalizations.of(context)?.favourites ?? "Favourites",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textBlack),
              ),
              selectedColor: AppTheme.milkeyGrey,
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 20.h,
                width: 24.h,
                child: SvgPicture.asset(AppIcons.calenderIconSVG),
              ),
              title: Text(
                AppLocalizations.of(context)?.calendar ?? "Calendar",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textBlack),
              ),
              selectedColor: AppTheme.milkeyGrey,
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 20.h,
                width: 24.h,
                child: SvgPicture.asset(AppIcons.personIconSVG),
              ),
              title: Text(
                AppLocalizations.of(context)?.profile ?? "Profile",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textBlack),
              ),
              selectedColor: AppTheme.milkeyGrey,
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                height: 20.h,
                width: 24.h,
                child: SvgPicture.asset(AppIcons.notifBellSVG),
              ),
              title: Text(
                AppLocalizations.of(context)?.notifications ?? "Notifications",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textBlack),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              selectedColor: AppTheme.milkeyGrey,
            ),
          ],
        ),
      ),
      body: WebSmoothScroll(
        controller:_scrollController ,
        child: SafeArea(
          child: PageView(
            key: const ValueKey("page-view"),
            controller: _pageController,
            allowImplicitScrolling: false,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _bnbProvider.appInitialization.serverDown
                  ? ServerDownScreen(
                      reason:
                          _bnbProvider.appInitialization.serverDownReason["uk"])
                  : const Home(
                      key: ValueKey("home"),
                    ),
              _bnbProvider.appInitialization.serverDown
                  ? ServerDownScreen(
                      reason:
                          _bnbProvider.appInitialization.serverDownReason["uk"])
                  : const Favourites(key: ValueKey("fav")),
              const CalendarView(
                key: ValueKey("cal"),
              ),
              UserProfile(
                onLogOut: () {
                  setState(() {
                    _currentIndex = 0;
                    _pageController.jumpToPage(_currentIndex);
                  });
                },
                key: const ValueKey("user-prof"),
              ),
              const UserNotifications(
                key: Key("notif"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServerDownScreen extends StatelessWidget {
  final String reason;
  const ServerDownScreen({Key? key, required this.reason}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.margin),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppIcons.networkIssueDialogue),
          const Space(),
          Text(
            reason,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      )),
    );
  }
}
