import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  ///instance
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  ///observer
  static final FirebaseAnalyticsObserver _observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  static FirebaseAnalyticsObserver getObserver() => _observer;

  static FirebaseAnalytics getInstance() => _analytics;

  ///User properties tells us who is the user
  static setUser(String? userId) async {
    if (userId == null) return;
    await _analytics.setUserId(id: userId);
  }

  static openApp() async {
    await _analytics.logAppOpen();
  }

  ///reports the tab change to the firebase
  static reportTabChange(
      {List<String> tabNames = const [], int selectedTab = 0}) async {
    if (tabNames.isEmpty) return;

    final String tab = tabNames[selectedTab];

    _analytics.logEvent(
      name: "Tab opened : $tab",
    );
  }

  //
  // static setPage(String? page) async {
  //   if (page == null) return;
  //
  //   await _analytics.setCurrentScreen(screenName: page);
  // }
}
