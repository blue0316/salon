import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/create_apntmnt_provider/create_appointment_provider.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/salon/booking/widgets/confirmation_tab.dart/widgets.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmedDialog<T> extends ConsumerStatefulWidget {
  final AppointmentModel appointment;

  const ConfirmedDialog({Key? key, required this.appointment}) : super(key: key);

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

    return Dialog(
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
                      (DeviceConstraints.getDeviceType(MediaQuery.of(context)) != DeviceScreenType.portrait) ? 'ONLINE BOOKING' : 'Online Booking',
                      style: AppTheme.bodyText1.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 40.sp),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const Spacer(flex: 2),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                Space(factor: DeviceConstraints.getResponsiveSize(context, 3, 2.5, 2.5).toDouble()),
                const TopDetails(),
                Space(factor: DeviceConstraints.getResponsiveSize(context, 2, 1, 1).toDouble()),
                const BottomDetails(),
                // const SizedBox(height: 20),
                const Spacer(),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DeviceConstraints.getResponsiveSize(context, 0, 20.w, 20.w),
                    ),
                    child: Column(
                      children: [
                        DefaultButton(
                          label: 'Add to Apple Calendar',
                          borderRadius: 60,
                          color: Colors.black,
                          height: 60,
                          prefixIcon: SvgPicture.asset(
                            AppIcons.appleLogoSvg,
                            fit: BoxFit.cover,
                            height: 18.sp,
                          ),
                          onTap: () {},
                        ),
                        SizedBox(height: 10.h),
                        DefaultButton(
                          label: 'Add to Google Calendar',
                          borderRadius: 60,
                          color: Colors.black,
                          height: 60,
                          prefixIcon: SvgPicture.asset(
                            AppIcons.googleLogoSVG,
                            fit: BoxFit.cover,
                            height: 18.sp,
                          ),
                          onTap: () {},
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

class TopDetails extends ConsumerWidget {
  // final AppointmentModel appointment;

  const TopDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateAppointmentProvider _createAppointment = ref.watch(createAppointmentProvider);

    final String _date = Time().getLocaleDate(
      _createAppointment.appointmentModel!.appointmentStartTime,
      AppLocalizations.of(context)?.localeName ?? 'en',
    );

    final String _time = Time().getAppointmentStartEndTime(
          _createAppointment.appointmentModel!,
        ) ??
        '';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 5, 20.w, 20.w),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Booking details",
                style: AppTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 19.sp,
                ),
              ),
              const Space(factor: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.name.toCapitalized() ?? 'Name',
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _createAppointment.nameController.text,
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.phoneNumber.toCapitalized() ?? 'Phone Number',
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _createAppointment.phoneController.text,
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.email.toCapitalized() ?? 'Email',
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _createAppointment.emailController.text,
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.appointment_tabbar_line2.toCapitalized() ?? 'Service',
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    // "Brows",
                    '${_createAppointment.appointmentModel!.services.length} services',
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date",
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    // "Mon, November 7",
                    _date,
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time",
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    // "11:00 - 12:00",
                    _time,
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // -- SALON NAME
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.registration_line33.toCapitalized() ?? 'Salon Name',
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _createAppointment.appointmentModel!.salon.name.toCapitalized(),
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomDetails extends ConsumerWidget {
  const BottomDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateAppointmentProvider _createAppointment = ref.watch(createAppointmentProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 5, 20.w, 20.w),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order amount",
                    style: AppTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${_createAppointment.appointmentModel!.priceAndDuration.price} ${Keys.uah}",
                    style: AppTheme.bodyText2.copyWith(fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discount 15%",
                    style: AppTheme.bodyText1.copyWith(
                      fontSize: 15.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "-\$00",
                    style: AppTheme.bodyText2.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              const DashedDivider(),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: AppTheme.bodyText1.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    // "-\$00",
                    "${_createAppointment.appointmentModel!.priceAndDuration.price} ${Keys.uah}",
                    style: AppTheme.bodyText1.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
