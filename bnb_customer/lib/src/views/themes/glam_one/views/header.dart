import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/buttons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeHeader extends ConsumerWidget {
  final SalonModel salonModel;
  final MasterModel? masterModel;

  const ThemeHeader({Key? key, required this.salonModel, this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    // final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        (masterModel == null)
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: !isTab ? 15.w : 0),
                child: Text(
                  (salonModel.salonName).toUpperCase(),
                  style: theme.textTheme.displayMedium?.copyWith(
                    letterSpacing: 0.5,
                    fontSize: DeviceConstraints.getResponsiveSize(context, (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark) ? 70.sp : 50.sp, 75.sp, 85.sp),
                    color: titleHeaderColor(theme, themeType),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Text(
                Utils().getNameMaster(masterModel?.personalInfo).toUpperCase(),
                style: theme.textTheme.displayLarge?.copyWith(
                  letterSpacing: 0.5,
                  fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 75.sp, 85.sp),
                  color: titleHeaderColor(theme, themeType),
                ),
                textAlign: TextAlign.center,
              ),
        // if (isPortrait) const SizedBox(height: 20),
        // Text(
        //   "Beauty Salon",
        //   style: theme.textTheme.headline2?.copyWith(
        //     letterSpacing: 0.5,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
        SizedBox(height: DeviceConstraints.getResponsiveSize(context, 40.h, 40.h, 40.h)),
        getThemeButton(context, themeType, theme),

        if (themeType != ThemeType.Barbershop) SizedBox(height: DeviceConstraints.getResponsiveSize(context, 100.h, 100.h, 150.h)),
        if (themeType != ThemeType.Barbershop)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 50.w),
            ),
            child: Wrap(
              spacing: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 10.w),
              runSpacing: DeviceConstraints.getResponsiveSize(context, 10.h, 20.w, 10.w),
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: _salonProfileProvider.chosenSalon.specializations!
                  .map(
                    (item) => GlamOneWrap(text: item),
                  )
                  .toList(),
              // children: _createAppointmentProvider.categoriesAvailable
              //     .map(
              //       (item) => GlamOneWrap(
              //         text: item.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.translations['en'],
              //       ),
              //     )
              //     .toList(),
            ),
          ),
      ],
    );
  }
}

Color titleHeaderColor(ThemeData theme, ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;

    case ThemeType.GlamMinimalDark:
      return Colors.white;

    case ThemeType.GentleTouch:
      return Colors.black;

    case ThemeType.GentleTouchDark:
      return Colors.white;

    default:
      return theme.primaryColor;
  }
}

Widget getThemeButton(context, ThemeType themeType, ThemeData theme) {
  Widget squareButton = Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SquareButton(
        text: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
        height: 60.h,
        // width: DeviceConstraints.getResponsiveSize(context, 200.h, 220.h, 220.h),
        onTap: () => const BookingDialogWidget222().show(context),
      ),
    ],
  );

  switch (themeType) {
    case ThemeType.GlamBarbershop:
      return squareButton;

    case ThemeType.Barbershop:
      return squareButton;

    case ThemeType.GentleTouch:
      return SquareButton(
        borderColor: Colors.transparent,
        buttonColor: theme.colorScheme.secondary,
        width: 180.sp,
        text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
        weight: FontWeight.normal,
        textColor: const Color(0XFFFFFFFF),
        height: 47.h,
        showSuffix: false,
        borderRadius: 3,
        isGradient: true,
        hoveredColor: const Color(0XFF687830),
        onTap: () => const BookingDialogWidget222().show(context),
      );

    case ThemeType.GentleTouchDark:
      return SquareButton(
        borderColor: Colors.transparent,
        buttonColor: theme.colorScheme.secondary,
        width: 180.sp,
        text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
        weight: FontWeight.normal,
        textColor: const Color(0XFFFFFFFF),
        height: 47.h,
        showSuffix: false,
        borderRadius: 3,
        isGradient: true,
        hoveredColor: const Color(0XFF687830),
        onTap: () => const BookingDialogWidget222().show(context),
      );

    case ThemeType.GlamMinimalLight:
      return SquareButton(
        borderColor: Colors.transparent,
        buttonColor: const Color(0XFF000000),
        width: 180.sp,
        text: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
        weight: FontWeight.normal,
        textColor: const Color(0XFFFFFFFF),
        height: 60.h,
        showSuffix: false,
        onTap: () => const BookingDialogWidget222().show(context),
      );

    case ThemeType.GlamMinimalDark:
      return SquareButton(
        borderColor: Colors.transparent,
        buttonColor: const Color(0XFFFFFFFF),
        width: 180.sp,
        text: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
        weight: FontWeight.normal,
        textColor: const Color(0XFF000000),
        height: 60.h,
        showSuffix: false,
        onTap: () => const BookingDialogWidget222().show(context),
      );

    default:
      return RotatedBookNow(
        buttonText: AppLocalizations.of(context)?.bookNow ?? "Book Now",
        onTap: () => const BookingDialogWidget222().show(context),
      );
  }
}

class GlamOneWrap extends ConsumerWidget {
  final String text;
  final double? vSpacing;
  final Color? color;
  final bool showBorder;

  const GlamOneWrap({
    Key? key,
    required this.text,
    this.vSpacing,
    this.color,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return FittedBox(
      child: Container(
        decoration: (themeType != ThemeType.GentleTouch && themeType != ThemeType.GentleTouchDark)
            ? BoxDecoration(
                border: showBorder ? Border.all(color: Colors.white, width: 1) : null,
                color: color,
              )
            : ShapeDecoration(
                color: Colors.black.withOpacity(0.15000000596046448),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFA5A5A5)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: (themeType == ThemeType.GentleTouch) ? 10.sp : vSpacing ?? 13.sp),
          child: Center(
            child: Text(
              text.toTitleCase(),
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
