// ignore_for_file: avoid_web_libraries_in_flutter, unused_local_variable

import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/loadingLink.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/appointment/view_appointment.dart';
import 'package:bbblient/src/views/policy/policy.dart';
import 'package:bbblient/src/views/policy/testes.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'utils/analytics.dart';
import 'dart:html' as html;

final GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  urlPathStrategy: UrlPathStrategy.path,
  observers: [BotToastNavigatorObserver(), Analytics.getObserver()],
  errorBuilder: (context, state) {
    if (kIsWeb) {
      var myPath = state.path;
      myPath = myPath!.substring(1);
      try {
        // FirebaseFirestore.instance
        //       .collection('stories')
        //       .where('uid', isEqualTo: user.uid)
        //       .snapshots()
        return LoadingLink(
          key: const Key("Loading Link"),
          myPath: myPath,
        );
      } catch (e) {
        html.window.open("https://bowandbeautiful.com/error", "_self");
      }
      return const SizedBox();
    } else {
      return ErrorScreen(error: state.error?.toString());
    }
  },
  initialLocation: NavigatorPage.route,
  routes: [
    // Appointments
    GoRoute(
      path: AppointmentViewDetails.route,
      name: AppointmentViewDetails.route,
      pageBuilder: (context, state) {
        final String query = state.queryParams['id'] as String;
        return MaterialPage(
          child: AppointmentViewDetails(
            appointmentDocId: query,
          ),
        );
      },
    ),

    /// Error screen
    GoRoute(
      path: ErrorScreen.route,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ErrorScreen(
          error: "Invalid Link",
        ),
      ),
    ),

    /// privacy
    GoRoute(
      path: EasyWebDemo.route,
      pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const NewTEst()),
    ),

    /// home/salon for either master or salonOwner
    GoRoute(
        path: NavigatorPage.route,
        pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const NavigatorPage(),
            ),
        routes: [
          GoRoute(
            path: SalonPage.route,
            pageBuilder: (context, state) {
              final String id = state.queryParams['id']!;
              final String locale = state.queryParams['locale'] ?? "en";
              final String id2 = state.queryParams['id2'] ?? "";
              printIt('idefeeeeeeeeeeeeeeee  + $id2');
              bool back = true;
              MasterModel? salonMaster;
              if (state.queryParams['back'] != null) {
                back = !(state.queryParams['back'] == 'false');
              }

              final bnbProvider = ChangeNotifierProvider<BnbProvider>(
                (ref) => BnbProvider(),
              );

              final provider = Provider((ref) async {
                // use ref to obtain other providers
                final repository = ref.watch(bnbProvider);
                repository.changeLocale(locale: Locale(state.queryParams['locale']!.toString()));
                debugPrint("id 2 dey here oo" + id2);
                if (id2 != "") {
                  repository.retrieveSalonMasterModel(state.queryParams['id2']!.toString());
                  salonMaster = repository.getCurrenMaster;
                  debugPrint(repository.getCurrenMaster);
                }
                return repository;
              });
              debugPrint(salonMaster.toString());
              return MaterialPage(
                key: state.pageKey,
                child: SalonPage(
                  salonId: id,
                  showBackButton: back,
                  locale: locale,
                ),
              );
            },
          ),
          // GoRoute(
          //   path: MasterProfile.route,
          //   pageBuilder: (context, state) {
          //     final String id = state.queryParams['id']!;
          //     final String id2 = state.queryParams['id2']!;
          //
          //     final String locale = state.queryParams['locale'] ?? "en";
          //     printIt('id'+id2);
          //     bool back = true;
          //     if (state.queryParams['back'] != null) {
          //       back = !(state.queryParams['back'] == 'false');
          //     }
          //
          //     final bnbProvider = ChangeNotifierProvider<BnbProvider>(
          //           (ref) => BnbProvider(),
          //     );
          //
          //     final provider = Provider((ref) {
          //       // use ref to obtain other providers
          //       final repository = ref.watch(bnbProvider);
          //       repository.changeLocale(
          //           locale: Locale(state.queryParams['locale']!.toString()));
          //       repository.retrieveSalonMasterModel(id2);
          //       return repository;
          //     });
          //
          //     return MaterialPage(
          //         key: state.pageKey,
          //         child: id2 != null ? MasterProfile(masterModel : AppProvider().salonMaster):  SalonPage(
          //           salonId: id,
          //           showBackButton: back,
          //           locale: locale,
          //         ));
          //   },
          // ),
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
