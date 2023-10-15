// ignore_for_file: avoid_web_libraries_in_flutter, unused_local_variable

import 'dart:io';

import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/loadingLink.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/views/appointment/view_appointment.dart';
import 'package:bbblient/src/views/payment/payment.dart';
import 'package:bbblient/src/views/policy/policy.dart';
import 'package:bbblient/src/views/policy/cookies.dart';
import 'package:bbblient/src/views/policy/terms_condition.dart';
import 'package:bbblient/src/views/policy/testes.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'utils/analytics.dart';
import 'dart:html' as html;

import 'views/salon/booking/confirmation_success.dart';

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

    GoRoute(
      path: ConfirmationSuccess.route,
      name: ConfirmationSuccess.route,
      pageBuilder: (context, state) {
        // print(state.queryParams);
        final String query = state.queryParams['RESPONSECODE'] as String;
        final String transactionId = state.queryParams['ORDERID'] as String;
        return MaterialPage(
          child: ConfirmationSuccess(
            responseCode: query,
            transactionID: transactionId,
          ),
        );
      },
    ),

    GoRoute(
      path: ConfirmationError.route,
      name: ConfirmationError.route,
      pageBuilder: (context, state) {
        final String query = state.queryParams['RESPONSECODE'] as String;

        return MaterialPage(
          child: ConfirmationError(
            responseCode: query,
          ),
        );
      },
    ),

    /// Error screen
    GoRoute(
      path: ErrorScreen.route,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ErrorScreen(error: "Invalid Link"),
      ),
    ),

    /// privacy
    GoRoute(
      path: EasyWebDemo.route,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const NewTEst(),
      ),
    ),

    /// Cookies
    GoRoute(
      path: Cookies.route,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const Cookies(),
      ),
    ),

    /// terms and Condition
    GoRoute(
      path: TermsCondition.route,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const TermsCondition(),
      ),
    ),

    /// payment
    GoRoute(
      path: Payment.route,
      name: Payment.route,
      pageBuilder: (context, state) {
        final String? amount = state.queryParams['amount'] == null
            ? "325.56"
            : state.queryParams['amount'] as String;
        final String? currency = state.queryParams['currency'] == null
            ? "USD"
            : state.queryParams['currency'] as String;
        DateTime timeNow = DateTime.now();
        final String? transactionId = state.queryParams['transactionId'] == null
            ? "${timeNow.day}${timeNow.hour}${timeNow.minute}${timeNow.second}AT"
            : state.queryParams['transactionId'] as String;
        final String? terminalId = state.queryParams['terminalId'] == null
            ? "5363001"
            : state.queryParams['terminalId'] as String;
        final bool? isDeposit = state.queryParams['isDeposit'] == null
            ? true
            : state.queryParams['isDeposit'] as bool;
        return MaterialPage(
          key: state.pageKey,
          child: Payment(
            amount: amount,
            currency: currency,
            transactionId: transactionId,
            terminalId: terminalId,
            // isDeposit: isDeposit!,
          ),
        );
      },
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
            final String showBooking = state.queryParams['booking'] ?? "";

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

              repository.changeLocale(
                  locale: Locale(state.queryParams['locale']!.toString()));

              if (id2 != "") {
                repository.retrieveSalonMasterModel(
                    state.queryParams['id2']!.toString());
                salonMaster = repository.getCurrenMaster;
                // debugPrint(repository.getCurrenMaster);
              }
              return repository;
            });
            // debugPrint(salonMaster.toString());
            return MaterialPage(
              key: state.pageKey,
              child: SalonPage(
                salonId: id,
                showBackButton: back,
                locale: locale,
                showBooking: (showBooking == 'true') ? true : false,
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
      ],
    ),

    // GoRoute(path: Home)
  ],
);

class ErrorScreen extends StatelessWidget {
  static const route = "/error";
  final String? error;
  final Color? backgroundColor, textColor;

  const ErrorScreen(
      {Key? key, this.error, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          error ?? "Something went wrong",
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
