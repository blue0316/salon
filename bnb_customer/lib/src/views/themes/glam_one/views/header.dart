import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeHeader extends ConsumerWidget {
  final SalonModel salonModel;

  const ThemeHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          salonModel.salonName, //"Miami's Best",
          style: theme.textTheme.headline1?.copyWith(
            letterSpacing: 0.5,
            fontSize: DeviceConstraints.getResponsiveSize(context, 70.sp, 80.sp, 100.sp),
          ),
          textAlign: TextAlign.center,
        ),
        if (isPortrait) const SizedBox(height: 20),
        Text(
          "Beauty Salon",
          style: theme.textTheme.headline2?.copyWith(
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: DeviceConstraints.getResponsiveSize(context, 40.h, 40.h, 40.h)),
        (_salonProfileProvider.chosenSalon.selectedTheme == 1)
            ? Stack(
                alignment: Alignment.center,
                children: [
                  const RotatedBookNow(),
                  Text(
                    "Book Now",
                    style: GlamOneTheme.bodyText1.copyWith(),
                  ),
                ],
              )
            : (_salonProfileProvider.chosenSalon.selectedTheme == 5)
                ? const SizedBox()
                : SquareButton(
                    text: 'BOOK NOW',
                    height: 65.h,
                    onTap: () {},
                  ),
        SizedBox(height: DeviceConstraints.getResponsiveSize(context, 100.h, 100.h, 150.h)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 50.w),
          ),
          child: Wrap(
            spacing: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 10.w),
            runSpacing: DeviceConstraints.getResponsiveSize(context, 10.h, 20.w, 10.w),
            alignment: WrapAlignment.center,
            children: [
              //  for (var slot in widget.createAppointment.morningTimeslots)
              const GlamOneButton(
                text: "Makeup",
              ),
              const GlamOneButton(
                text: "Hairdresser",
              ),

              // TODO: REMOVE ALL THESE (TEMPORARY FOR UI)
              if (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                const GlamOneButton(
                  text: "Esthetician",
                ),
              if (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                const GlamOneButton(
                  text: "Injectable & Med Spa",
                ),
              if (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                const GlamOneButton(
                  text: "Nail Artist",
                ),
              if (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                const GlamOneButton(
                  text: "Massage",
                ),
              if (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                const GlamOneButton(
                  text: "Epilation",
                ),
              if (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                const GlamOneButton(
                  text: "Eyebrow makeup",
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class RotatedBookNow extends StatelessWidget {
  const RotatedBookNow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: const AlwaysStoppedAnimation(175 / 360), // (15 / 360),
      child: Container(
        width: 170.h,
        height: 65.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: GlamOneTheme.primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(170),
        ),
      ),
    );
  }
}

class GlamOneButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const GlamOneButton({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120.h,
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            text,
            style: GlamOneTheme.bodyText1.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
