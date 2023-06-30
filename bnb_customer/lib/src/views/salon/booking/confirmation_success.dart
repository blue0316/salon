import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/firebase/transaction.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/confirmed_dialog.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfirmationSuccess<T> extends ConsumerStatefulWidget {
  static const route = "/confirmation";

  final String responseCode;
  final String transactionID;
  const ConfirmationSuccess({Key? key, required this.responseCode, required this.transactionID}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  ConsumerState<ConfirmationSuccess> createState() => _ConfirmationSuccessState();
}

class _ConfirmationSuccessState extends ConsumerState<ConfirmationSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    TransactionApi().getAllAppointmentWithTransaction(widget.transactionID).listen((event) {
      if (event.isNotEmpty) {
        appointment = event[0];
        setState(() {
          isCreated = true;
        });
      }
    });
    super.initState();
  }

  AppointmentModel? appointment;
  bool isCreated = false;
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(
            context,
            0,
            20, // mediaQuery.width / 5,
            mediaQuery.width / 6,
          ),
          vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: !isCreated
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 15.sp),
                              child: Icon(
                                Icons.close_rounded,
                                color: theme.colorScheme.tertiary.withOpacity(0.6),
                                size: DeviceConstraints.getResponsiveSize(context, 20.sp, 22.sp, 24.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 2),
                      SpinKitPouringHourGlass(
                        color: theme.primaryColor,
                        size: DeviceConstraints.getResponsiveSize(context, 120.sp, 80.sp, 100.sp),
                        // itemBuilder: (BuildContext context, int index) {
                        //   return DecoratedBox(
                        //     decoration: BoxDecoration(
                        //       color: index.isEven ? Colors.red : Colors.green,
                        //     ),
                        //   );
                        // },
                      ),
//                       FaIcon(
//                         FontAwesomeIcons.circleCheck,
                      // size: DeviceConstraints.getResponsiveSize(
                      //     context, 120.sp, 80.sp, 100.sp),
//                         color: theme.primaryColor,
//                       ),
                      SizedBox(height: 15.sp),
                      Text(
                        'Please Wait',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 35.sp),
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(height: 15.sp),
                      Text(
                        'Your appointment is being created!',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      const Spacer(),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: DeviceConstraints.getResponsiveSize(context, 120.sp, 80.sp, 100.sp),
                        color: theme.primaryColor,
                      ),
                      const Spacer(),
                      Text(
                        'Thank you',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 35.sp),
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(height: 15.sp),
                      Text(
                        'Your appointment has been created.\nWe are looking forward to seeing you!',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 220.sp,
                        child: DefaultButton(
                          height: 60.sp,
                          borderRadius: 60.sp,
                          color: theme.dialogBackgroundColor,
                          borderColor: theme.colorScheme.tertiary.withOpacity(0.6),
                          label: 'View details',
                          fontWeight: FontWeight.w400,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          textColor: theme.colorScheme.tertiary,
                          onTap: () async {
                            Navigator.pop(context);

                            const ConfirmedDialog().show(context);
                          },
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationError<T> extends ConsumerStatefulWidget {
  static const route = "/confirmationError";

  final String responseCode;

  const ConfirmationError({Key? key, required this.responseCode}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  ConsumerState<ConfirmationError> createState() => _ConfirmationErrorState();
}

class _ConfirmationErrorState extends ConsumerState<ConfirmationError> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: DeviceConstraints.getResponsiveSize(
            context,
            0,
            20, // mediaQuery.width / 5,
            mediaQuery.width / 6,
          ),
          vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.sp),
                        child: Icon(
                          Icons.close_rounded,
                          color: theme.colorScheme.tertiary.withOpacity(0.6),
                          size: DeviceConstraints.getResponsiveSize(context, 20.sp, 22.sp, 24.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                FaIcon(
                  FontAwesomeIcons.x,
                  size: DeviceConstraints.getResponsiveSize(context, 120.sp, 80.sp, 100.sp),
                  color: theme.primaryColor,
                ),
                const Spacer(),
                Text(
                  'Failed!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 30.sp, 35.sp),
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 15.sp),
                Text(
                  'Failed failed failed',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 220.sp,
                  child: DefaultButton(
                    height: 60.sp,
                    borderRadius: 60.sp,
                    color: theme.dialogBackgroundColor,
                    borderColor: theme.colorScheme.tertiary.withOpacity(0.6),
                    label: 'Exit',
                    fontWeight: FontWeight.w400,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                    textColor: theme.colorScheme.tertiary,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
