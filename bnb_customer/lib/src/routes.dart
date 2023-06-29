// ignore_for_file: avoid_web_libraries_in_flutter, unused_local_variable

import 'package:bbblient/main.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/loadingLink.dart';
import 'package:bbblient/src/models/backend_codings/payment_methods.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/appointment/view_appointment.dart';
import 'package:bbblient/src/views/payment/payment.dart';
import 'package:bbblient/src/views/policy/policy.dart';
import 'package:bbblient/src/views/policy/testes.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile_copy.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'as.dart';
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
        final String query = state.queryParams['RESPONSECODE'] as String;
        final String transactionId = state.queryParams['ORDERID'] as String;
        return MaterialPage(
          child: ConfirmationSuccess(
            responseCode: query,
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
            transactionID: transactionId,
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
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const NewTEst()),
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
        return MaterialPage(
            key: state.pageKey,
            child: Payment(
              amount: amount,
              currency: currency,
              transactionId: transactionId,
              terminalId: terminalId,
            ));
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
              // printIt('idefeeeeeeeeeeeeeeee  + $id2');
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
                debugPrint("id 2 dey here oo" + id2);
                if (id2 != "") {
                  repository.retrieveSalonMasterModel(
                      state.queryParams['id2']!.toString());
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




// import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
// import 'package:bbblient/src/firebase/transaction.dart';
// import 'package:bbblient/src/models/appointment/appointment.dart';
// import 'package:bbblient/src/utils/device_constraints.dart';
// import 'package:bbblient/src/views/widgets/buttons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class ThankYou<T> extends ConsumerStatefulWidget {
//   static const route = "/confirmation";

//   final String responseCode;
//   final String transactionID;

//   const ThankYou(
//       {Key? key, required this.responseCode, required this.transactionID})
//       : super(key: key);

//   Future<void> show(BuildContext context) async {
//     await showDialog<T>(
//       context: context,
//       builder: (context) => this,
//     );
//   }

//   @override
//   ConsumerState<ThankYou> createState() => _ThankYouState();
// }

// class _ThankYouState extends ConsumerState<ThankYou> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     TransactionApi()
//         .getAllAppointmentWithTransaction(widget.transactionID)
//         .listen((event) {
//       if (event.isNotEmpty) {
//         appointment = event[0];
//         setState(() {
//           isCreated = true;
//         });
//       }
//     });
//     super.initState();
//   }

//   AppointmentModel? appointment;
//   bool isCreated = false;
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context).size;
//     final SalonProfileProvider _salonProfileProvider =
//         ref.watch(salonProfileProvider);

//     final ThemeData theme = _salonProfileProvider.salonTheme;

//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: Dialog(
//         backgroundColor: theme.dialogBackgroundColor,
//         insetPadding: EdgeInsets.symmetric(
//           horizontal: DeviceConstraints.getResponsiveSize(
//             context,
//             0,
//             20, // mediaQuery.width / 5,
//             mediaQuery.width / 6,
//           ),
//           vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
//         ),
//         child: SizedBox(
//           width: double.infinity,
//           child: Padding(
//             padding: EdgeInsets.all(15.sp),
//             child: !isCreated
//                 ? Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Spacer(flex: 2),
//                       SpinKitPouringHourGlass(
//                         color: theme.primaryColor,
//                         size: DeviceConstraints.getResponsiveSize(
//                             context, 120.sp, 80.sp, 100.sp),
//                         // itemBuilder: (BuildContext context, int index) {
//                         //   return DecoratedBox(
//                         //     decoration: BoxDecoration(
//                         //       color: index.isEven ? Colors.red : Colors.green,
//                         //     ),
//                         //   );
//                         // },
//                       ),
// //                       FaIcon(
// //                         FontAwesomeIcons.circleCheck,
//                       // size: DeviceConstraints.getResponsiveSize(
//                       //     context, 120.sp, 80.sp, 100.sp),
// //                         color: theme.primaryColor,
// //                       ),
//                       SizedBox(height: 15.sp),
//                       Text(
//                         'Please Wait',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.w500,
//                           fontSize: DeviceConstraints.getResponsiveSize(
//                               context, 30.sp, 30.sp, 35.sp),
//                           color: theme.colorScheme.tertiary,
//                         ),
//                       ),
//                       SizedBox(height: 15.sp),
//                       Text(
//                         'Your appointment is being created!',
//                         textAlign: TextAlign.center,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.normal,
//                           fontSize: DeviceConstraints.getResponsiveSize(
//                               context, 16.sp, 20.sp, 18.sp),
//                           color: theme.colorScheme.tertiary,
//                         ),
//                       ),
//                       const Spacer(),
//                     ],
//                   )
//                 : Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Spacer(flex: 2),
//                       FaIcon(
//                         FontAwesomeIcons.circleCheck,
//                         size: DeviceConstraints.getResponsiveSize(
//                             context, 120.sp, 80.sp, 100.sp),
//                         color: theme.primaryColor,
//                       ),
//                       const Spacer(),
//                       Text(
//                         'Thank you',
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.w500,
//                           fontSize: DeviceConstraints.getResponsiveSize(
//                               context, 30.sp, 30.sp, 35.sp),
//                           color: theme.colorScheme.tertiary,
//                         ),
//                       ),
//                       SizedBox(height: 15.sp),
//                       Text(
//                         'Your appointment has been created.\nWe are looking forward to seeing you!',
//                         textAlign: TextAlign.center,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.normal,
//                           fontSize: DeviceConstraints.getResponsiveSize(
//                               context, 16.sp, 20.sp, 18.sp),
//                           color: theme.colorScheme.tertiary,
//                         ),
//                       ),
//                       const Spacer(),
//                       SizedBox(
//                         width: 220.sp,
//                         child: DefaultButton(
//                           height: 60.sp,
//                           borderRadius: 60.sp,
//                           color: theme.dialogBackgroundColor,
//                           borderColor:
//                               theme.colorScheme.tertiary.withOpacity(0.6),
//                           label: 'View details',
//                           fontWeight: FontWeight.w400,
//                           fontSize: DeviceConstraints.getResponsiveSize(
//                               context, 16.sp, 20.sp, 18.sp),
//                           textColor: theme.colorScheme.tertiary,
//                           onTap: () async {},
//                         ),
//                       ),
//                       const Spacer(flex: 2),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
