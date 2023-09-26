import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/appointment/appointment.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/appointment/reviews/appointment_review.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends ConsumerWidget {
  final String text;
  final VoidCallback onTap;
  final Color? buttonColor, textColor, loaderColor, borderColor;
  final bool isLoading;

  const Button({
    Key? key,
    required this.text,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.isLoading = false,
    this.loaderColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: !isPortrait ? 300 : double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(
              color: borderColor ?? Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: (textColor != null)
                              ? textColor
                              : isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          letterSpacing: 0.5,
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

class ViewOrReview extends ConsumerWidget {
  final AppointmentModel appointment;
  final String appointmentId;

  const ViewOrReview({Key? key, required this.appointment, required this.appointmentId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            ViewOrReviewButton(
              text: 'View Receipt',
              buttonColor: viewReceiptColor(themeType, theme),
              textColor: Colors.white,
              onTap: () {},
            ),
            ViewOrReviewButton(
              text: 'Review Appointment',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewAppointments(
                      appointment: appointment,
                      appointmentId: appointmentId,
                    ),
                  ),
                );
              },
              buttonColor: Colors.white,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class ViewOrReviewButton extends ConsumerWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? loaderColor, buttonColor, textColor;

  const ViewOrReviewButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.loaderColor,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;
    ThemeType themeType = _appointmentProvider.themeType ?? ThemeType.DefaultLight;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: !isPortrait ? 300 : double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(color: borderColor2(themeType, theme), width: 1),
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
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 18.sp, 20.sp),
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

Color viewReceiptColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return const Color(0XFF000000).withOpacity(0.4);
    case ThemeType.GlamLight:
      return const Color(0XFF000000).withOpacity(0.4);
    case ThemeType.GlamMinimalLight:
      return const Color(0XFF000000).withOpacity(0.4);

    default:
      return const Color(0XFF000000).withOpacity(0.1);
  }
}

Color borderColor2(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.DefaultLight:
      return Colors.transparent;
    case ThemeType.GlamLight:
      return Colors.transparent;
    case ThemeType.GlamMinimalLight:
      return Colors.transparent;

    default:
      return const Color(0XFF4A4A4A);
  }
}
