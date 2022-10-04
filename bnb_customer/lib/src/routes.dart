import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/firebase/collections.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/home/home.dart';
import 'package:bbblient/src/views/home_page.dart';

import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/registration/quiz/register_quiz.dart';
import 'package:bbblient/src/views/salon/booking/booking_date_time.dart';
import 'package:bbblient/src/views/salon/booking/payment_bonus_confirmation.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'utils/analytics.dart';
import 'views/salon/salon_home/salon_profile.dart';
import 'dart:html' as html;

final GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  urlPathStrategy: UrlPathStrategy.path,
  observers: [BotToastNavigatorObserver(), Analytics.getObserver()],
  errorBuilder: (context, state) {
    if (kIsWeb) {
      var myPath = state.path;
      myPath = myPath!.substring(1);

      // FirebaseFirestore.instance
      //       .collection('stories')
      //       .where('uid', isEqualTo: user.uid)
      //       .snapshots()
      Collection.customLinks.doc(myPath.toLowerCase()).get().then((snapshot) {
        printIt(snapshot);
        var openlink;
        if (snapshot.exists) {
          openlink = snapshot['link'].toString();
          if (openlink != null) {
            html.window.open(openlink, "_self");
          } else {
            html.window.open("https://bowandbeautiful.com/error", "_self");
          }
        } else {
          html.window.open("https://bowandbeautiful.com/error", "_self");
        }
      });
      return const SizedBox();
    } else {
      return ErrorScreen(error: state.error?.toString());
    }
  },
  initialLocation: NavigatorPage.route,
  routes: [
    GoRoute(
      path: ErrorScreen.route,
      pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ErrorScreen(
            error: "Invalid Link",
          )),
    ),
    GoRoute(
        path: NavigatorPage.route,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const NavigatorPage()),
        routes: [
          GoRoute(
            path: SalonPage.route,
            pageBuilder: (context, state) {
              final String id = state.queryParams['id']!;
              final String locale = state.queryParams['locale'] ?? "en";
              printIt(locale);
              bool back = true;
              if (state.queryParams['back'] != null) {
                back = !(state.queryParams['back'] == 'false');
              }

              final bnbProvider = ChangeNotifierProvider<BnbProvider>(
                (ref) => BnbProvider(),
              );

              final provider = Provider((ref) {
                // use ref to obtain other providers
                final repository = ref.watch(bnbProvider);
                repository.changeLocale(
                    locale: Locale(state.queryParams['locale']!.toString()));
                return repository;
              });

              return MaterialPage(
                  key: state.pageKey,
                  child: SalonPage(
                    salonId: id,
                    showBackButton: back,
                    locale: locale,
                  ));
            },
          ),
        ]),

    // GoRoute(path: Home)
  ],
);

class ErrorScreen extends StatelessWidget {
  static const route = "/error";
  final String? error;
  const ErrorScreen({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error ?? "Something went wrong"),
      ),
    );
  }
}
