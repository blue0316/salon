import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/cat_sub_service/price_and_duration.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/google_calendar.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/appointment/widgets/theme_colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/confirm/order_details.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/day_and_time/day_and_time.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    // final PriceAndDurationModel _priceAndDuration = _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId] ?? PriceAndDurationModel();
    // TimeOfDay _startTime = Time().stringToTime(_createAppointmentProvider.selectedAppointmentSlot!);
    // TimeOfDay _endTime = _startTime.addMinutes(
    //   int.parse(_priceAndDuration.duration!),
    // );

    // String totalAmount = _createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '0'; // _priceAndDuration.price!;

    // String deposit = _createAppointmentProvider.chosenServices[0].deposit ?? '0';
    // int payAtAppointment = int.parse(totalAmount) - int.parse(deposit);

    AppointmentModel? appointment = _createAppointmentProvider.appointmentConfirmation;

    String totalAmount = _createAppointmentProvider.totalAmount;
    double deposit = _createAppointmentProvider.totalDeposit;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Dialog(
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
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
              // horizontal: DeviceConstraints.getResponsiveSize(context, 16.sp, 25.sp, 30.sp),
            ), // , horizontal: 5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        (AppLocalizations.of(context)?.appointmentDetails ?? 'appointment details').toUpperCase(),
                        // 'appointment details'.toUpperCase(),
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const Spacer(flex: 2),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          _createAppointmentProvider.resetFlow();
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

                  const Space(factor: 2.2),

                  // CUSTOMER DETAILS
                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.firstName ?? 'First Name'}:',
                    servicePrice: '${_auth.currentCustomer?.personalInfo.firstName}',
                  ),
                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.lastName ?? 'Last Name'}:',
                    servicePrice: '${_auth.currentCustomer?.personalInfo.lastName}',
                  ),
                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.phoneNumber ?? 'Phone number'}:',
                    servicePrice: '${_auth.currentCustomer?.personalInfo.phone}',
                  ),
                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.email ?? 'Email'}:',
                    servicePrice: '${_auth.currentCustomer?.personalInfo.email}',
                  ),

                  const GradientDivider(),

                  // SERVICE PROVIDER DETAILS
                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.serviceProvider ?? 'Service provider'}:',
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
                            '${AppLocalizations.of(context)?.services ?? 'Services'}:',
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
                                    service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? service.translations?['en'],
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
                    serviceName: '${AppLocalizations.of(context)?.date ?? 'Date'}:',
                    servicePrice: Time().getDateInStandardFormat(_createAppointmentProvider.chosenDay),
                  ),

                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.time ?? 'Time'}:',
                    servicePrice: (!_salonProfileProvider.isSingleMaster) ? '${_createAppointmentProvider.getStartTime()} - ${_createAppointmentProvider.getEndTime()}' : "${_createAppointmentProvider.selectedAppointmentSlot} - ${_createAppointmentProvider.selectedSlotEndTime}",
                  ),

                  const GradientDivider(),

                  // PAYMENT DETAILS
                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: AppLocalizations.of(context)?.payAtAppointment ?? 'Pay at Appointment:',
                    servicePrice: '\$${double.parse(totalAmount) - deposit}',
                  ),

                  ServiceNameAndPrice(
                    notService: true,
                    serviceName: '${AppLocalizations.of(context)?.depositPaid ?? 'Deposit paid'}:',
                    servicePrice: '\$$deposit',
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
                            '${AppLocalizations.of(context)?.total ?? 'Total'}:',
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
                            '\$$totalAmount',

                            // '\$${_createAppointmentProvider.priceAndDuration[_createAppointmentProvider.chosenMaster?.masterId]?.price ?? '0'}',
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

                  SizedBox(height: 50.sp),

                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h, left: 2, right: 2),
                    child: Column(
                      children: [
                        AddToCalendarButton(
                          icon: AppIcons.appleLogoSvg,
                          text: AppLocalizations.of(context)?.addToAppleCalendar ?? 'Add to Apple Calendar',
                          onTap: () async {
                            // Date
                            DateTime tempDate = DateTime.parse(appointment!.appointmentDate);

                            // Generate full Date + Time
                            DateTime start = Time().generateDateTimeFromString(tempDate, appointment.appointmentTime);
                            DateTime end = Time().generateDateTimeFromString(
                              tempDate,
                              Time().getAppointmentEndTime(appointment) ?? '',
                            );

                            _appointmentProvider.addToAppleCalendar(
                              context,
                              appointment: appointment,
                              appointmentId: appointment.appointmentIdentifier!,
                              startTime: start.toIso8601String(),
                              endTime: end.toIso8601String(),
                            );
                          },
                          isLoading: _appointmentProvider.appleCalendarStatus == Status.loading,
                          loaderColor: transparentLoaderColor(themeType, theme),
                        ),
                        SizedBox(height: 10.sp),
                        AddToCalendarButton(
                          icon: AppIcons.coloredGoogleLogoPNG,
                          text: AppLocalizations.of(context)?.addToGoogleCalendar ?? 'Add to Google Calendar',
                          onTap: () async {
                            // Date
                            DateTime tempDate = DateTime.parse(appointment!.appointmentDate);

                            // Generate full Date + Time
                            DateTime start = Time().generateDateTimeFromString(tempDate, appointment.appointmentTime);
                            DateTime end = Time().generateDateTimeFromString(
                              tempDate,
                              Time().getAppointmentEndTime(appointment) ?? '',
                            );

                            // Convert to YYYYMMDDTHHMMSSZ
                            final DateTime startFormat = DateTime(start.year, start.month, start.day, start.hour, start.minute, 0, 0, 0);
                            final DateTime endFormat = DateTime(end.year, end.month, end.day, end.hour, end.minute, 0, 0, 0);
                            final String formattedStartDateTime = AddToCalendar().formatDateTime(startFormat);
                            final String formattedEndDateTime = AddToCalendar().formatDateTime(endFormat);

                            // Create Event Template
                            final String url = AddToCalendar().getGoogleCalendarUrl(
                              title: 'Appointment Confirmation',
                              description: 'Appointment with ${appointment.master?.name} at ${appointment.salon.name}',
                              startTime: formattedStartDateTime,
                              endTime: formattedEndDateTime,
                            );

                            debugPrint(url);
                            // Launch URL
                            final parsedURL = Uri.parse(url);
                            if (await canLaunchUrl(parsedURL)) {
                              await launchUrl(parsedURL);
                            } else {
                              await launchUrl(parsedURL);
                              debugPrint('didn\'t launch');
                              showToast(AppLocalizations.of(context)?.somethingWentWrongPleaseTryAgain ?? 'Something went wrong, please try again');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddToCalendarButton extends ConsumerWidget {
  final String text, icon;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? loaderColor;

  const AddToCalendarButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.loaderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _appointmentProvider = ref.watch(appointmentProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.tertiary.withOpacity(0.6), // borderColor(themeType, theme),
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(color: loaderColor ?? Colors.white),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (icon == AppIcons.coloredGoogleLogoPNG)
                          ? Image.asset(
                              AppIcons.coloredGoogleLogoPNG,
                              height: 20.sp,
                            )
                          : SvgPicture.asset(
                              icon,
                              fit: BoxFit.cover,
                              height: 20.sp,
                              color: theme.colorScheme.tertiary,
                            ),
                      SizedBox(width: 8.sp),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 15.sp, 16.sp),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
