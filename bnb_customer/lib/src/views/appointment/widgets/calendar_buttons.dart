import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/google_calendar.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme_colors.dart';

class AddToCalendars extends StatelessWidget {
  final AppointmentModel appointment;

  const AddToCalendars({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Wrap(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,

          children: [
            CalendarButton(
              icon: AppIcons.appleLogoSvg,
              text: 'Add to Apple Calendar',
              onTap: () async {
                // Date
                DateTime tempDate = DateTime.parse(appointment.appointmentDate);

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
                final String url = AddToCalendar().getAppleCalendarUrl(
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
                  showToast('Something went wrong, please try again');
                }
              },
            ),
            // const SizedBox(width: 10),
            CalendarButton(
              icon: AppIcons.coloredGoogleLogoSVG,
              text: 'Add to Google Calendar',
              onTap: () async {
                // Date
                DateTime tempDate = DateTime.parse(appointment.appointmentDate);

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
                  showToast('Something went wrong, please try again');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarButton extends ConsumerWidget {
  final String text, icon;
  final VoidCallback onTap;

  const CalendarButton({Key? key, required this.text, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    ThemeType themeType = _appointmentProvider.themeType!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: !isPortrait ? 300 : double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor(themeType, theme),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  fit: BoxFit.cover,
                  height: 20.sp,
                  color: borderColor(themeType, theme),
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: borderColor(themeType, theme),
                    fontWeight: FontWeight.w600,
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
