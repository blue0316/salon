import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
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

  const ThemeHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          (salonModel.salonName).toUpperCase(), //"Miami's Best",
          style: theme.textTheme.headline1?.copyWith(
            letterSpacing: 0.5,
            fontSize: DeviceConstraints.getResponsiveSize(
                context, 50.sp, 75.sp, 85.sp),
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
        SizedBox(
            height:
                DeviceConstraints.getResponsiveSize(context, 40.h, 40.h, 40.h)),
        (_salonProfileProvider.theme == '2' ||
                _salonProfileProvider.theme == '4' ||
                _salonProfileProvider.theme == '6' ||
                _salonProfileProvider.theme == '7')
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareButton(
                    text: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                    height: 60.h,
                    // width: DeviceConstraints.getResponsiveSize(context, 200.h, 220.h, 220.h),
                    onTap: () => const BookingDialogWidget222().show(context),
                  ),
                ],
              )
            : RotatedBookNow(
                buttonText: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                onTap: () => const BookingDialogWidget222().show(context),
              ),
        if (_salonProfileProvider.theme != '4')
          SizedBox(
              height: DeviceConstraints.getResponsiveSize(
                  context, 100.h, 100.h, 150.h)),
        if (_salonProfileProvider.theme != '4')
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(
                  context, 10.w, 10.w, 50.w),
            ),
            child: Wrap(
              spacing: DeviceConstraints.getResponsiveSize(
                  context, 20.w, 20.w, 10.w),
              runSpacing: DeviceConstraints.getResponsiveSize(
                  context, 10.h, 20.w, 10.w),
              alignment: WrapAlignment.center,
              children: _createAppointmentProvider.categoriesAvailable
                  .map(
                    (item) => GlamOneWrap(
                      text: item.translations[
                          AppLocalizations.of(context)?.localeName ?? 'en'],
                    ),
                  )
                  .toList(),

              // [
              // const GlamOneWrap(
              //   text: "Makeup",
              // ),
              // const GlamOneWrap(
              //   text: "Hairdresser",
              // ),
            ),
          ),
      ],
    );
  }
}

class GlamOneWrap extends ConsumerWidget {
  final String text;
  final VoidCallback? onTap;
  const GlamOneWrap({Key? key, required this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.h,
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyText1!.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
