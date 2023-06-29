import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/appointment/widgets/calendar_buttons.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/confirm/order_details.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/day_and_time/day_and_time.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// CONFIRMATION DIALOG
class ConfirmedDialog<T> extends ConsumerStatefulWidget {
  const ConfirmedDialog({Key? key}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<T>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  ConsumerState<ConfirmedDialog<T>> createState() => _ConfirmedDialogState<T>();
}

class _ConfirmedDialogState<T> extends ConsumerState<ConfirmedDialog<T>> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final CreateAppointmentProvider _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final AuthProvider _auth = ref.watch(authProvider);
    final _appointmentProvider = ref.watch(appointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    final PriceAndDurationModel _priceAndDuration = _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId] ?? PriceAndDurationModel();
    TimeOfDay _startTime = Time().stringToTime(_createAppointmentProvider.selectedAppointmentSlot!);
    TimeOfDay _endTime = _startTime.addMinutes(
      int.parse(_priceAndDuration.duration),
    );

    return Dialog(
      backgroundColor: theme.dialogBackgroundColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(
          context,
          0,
          mediaQuery.width / 6,
          mediaQuery.width / 6,
        ),
        vertical: DeviceConstraints.getResponsiveSize(context, 0, 50.h, 50.h),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10), // , horizontal: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      'appointment details'.toUpperCase(),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 30.sp),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        color: defaultTheme ? AppTheme.textBlack : Colors.white,
                      ),
                    ),
                    const Spacer(flex: 2),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _createAppointmentProvider.resetFlow();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppTheme.lightGrey,
                          size: DeviceConstraints.getResponsiveSize(context, 20.h, 30.h, 30.h),
                        ),
                      ),
                    ),
                  ],
                ),

                const Space(factor: 1),

                // CUSTOMER DETAILS
                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'First Name:',
                  servicePrice: '${_auth.currentCustomer?.personalInfo.firstName}',
                ),
                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Last Name:',
                  servicePrice: '${_auth.currentCustomer?.personalInfo.lastName}',
                ),
                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Phone number:',
                  servicePrice: '${_auth.currentCustomer?.personalInfo.phone}',
                ),
                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Email:',
                  servicePrice: '${_auth.currentCustomer?.personalInfo.email}',
                ),

                const GradientDivider(),

                // SERVICE PROVIDER DETAILS
                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Service provider:',
                  servicePrice: '${_createAppointmentProvider.chosenMaster?.personalInfo?.lastName} ${_createAppointmentProvider.chosenMaster?.personalInfo?.firstName}',
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 12.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Services:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            color: theme.colorScheme.tertiary.withOpacity(0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _createAppointmentProvider.chosenServices
                              .map(
                                (service) => Text(
                                  service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                    color: theme.colorScheme.tertiary,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Date:',
                  servicePrice: Time().getDateInStandardFormat(_createAppointmentProvider.chosenDay),
                ),

                ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Time:',
                  servicePrice: '$_startTime - $_endTime',
                ),

                const GradientDivider(),

                // PAYMENT DETAILS
                const ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Pay at Appointment:',
                  servicePrice: '\$',
                ),

                const ServiceNameAndPrice(
                  notService: true,
                  serviceName: 'Deposit paid:',
                  servicePrice: '\$',
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 12.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Total:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 21.sp, 20.sp),
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Text(
                          '\$${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '0'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 21.sp, 20.sp),
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.sp),

                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DeviceConstraints.getResponsiveSize(context, 0, 20.w, 20.w),
                    ),
                    child: Column(
                      children: [
                        CalendarButton(
                          icon: AppIcons.appleLogoSvg,
                          text: 'Add to Apple Calendar',
                          onTap: () async {},
                          // isLoading: _appointmentProvider.appleCalendarStatus == Status.loading,
                          // loaderColor: transparentLoaderColor(themeType, theme),
                        ),
                        SizedBox(height: 10.sp),
                        CalendarButton(
                          icon: AppIcons.coloredGoogleLogoPNG,
                          text: 'Add to Google Calendar',
                          onTap: () async {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
