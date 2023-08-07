import 'dart:math' as math;
import 'dart:math';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/buttons.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/header_height.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlamLightHeader extends ConsumerWidget {
  final SalonModel chosenSalon;
  final MasterModel masterModel;
  final bool isSalonMaster;

  const GlamLightHeader({
    Key? key,
    required this.chosenSalon,
    required this.masterModel,
    this.isSalonMaster = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    ThemeType themeType = _salonProfileProvider.themeType;

    return SizedBox(
      height: getThemeHeaderHeight(context, themeType),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Ellipse
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // color: Colors.blue,
              height: (getThemeHeaderHeight(context, themeType)) / 2,
              child: SvgPicture.asset(
                ThemeImages.glamLightEllipse,
                fit: isTab ? BoxFit.fill : BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.h),
                    child: ThemeAppBar(salonModel: chosenSalon, isSalonMaster: isSalonMaster),
                  ),
                  SizedBox(height: 20.h),
                  GlamLightHeaderBody(salonModel: chosenSalon, masterModel: masterModel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlamLightHeaderBody extends ConsumerWidget {
  final SalonModel salonModel;
  final MasterModel masterModel;

  const GlamLightHeaderBody({Key? key, required this.salonModel, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(
          context,
        )) ==
        DeviceScreenType.portrait);
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(
          context,
        )) ==
        DeviceScreenType.tab);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  Utils().getNameMaster(masterModel.personalInfo).toUpperCase(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    letterSpacing: 0.5,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 80.sp),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (isTab) const SpaceHorizontal(),
              if (isTab)
                HorizontalBookNow(
                  buttonText: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                  onTap: () => const BookingDialogWidget222().show(context),
                ),
            ],
          ),
        ),
        if (!isTab)
          RotatedBookNow(
            buttonText: AppLocalizations.of(context)?.bookNow ?? "Book Now",
            buttonBorderColor: Colors.black,
            onTap: () => const BookingDialogWidget222().show(context),
          ),
        SizedBox(
          height: DeviceConstraints.getResponsiveSize(context, 10.h, 10.h, 20.h),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.h),
          child: isPortrait
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 60.h,
                    // width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: _createAppointmentProvider.categoriesAvailable
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GlamLightWrap(
                                text: item.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.translations['en'],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 50.w),
                  ),
                  child: Wrap(
                    spacing: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 10.w),
                    runSpacing: DeviceConstraints.getResponsiveSize(context, 10.h, 20.w, 10.w),
                    alignment: WrapAlignment.center,
                    children: _createAppointmentProvider.categoriesAvailable
                        .map(
                          (item) => GlamLightWrap(
                            text: item.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.translations['en'],
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
        SizedBox(
          height: DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 90.h),
        ),
        SizedBox(
          width: double.infinity,
          height: DeviceConstraints.getResponsiveSize(
            context,
            300.h,
            350.h,
            400.h, // * heightValue[Random().nextInt(rotationValue.length)],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: salonModel.profilePics.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                child: Transform.rotate(
                  angle: math.pi / rotationValue[Random().nextInt(rotationValue.length)],
                  child: SizedBox(
                    height: DeviceConstraints.getResponsiveSize(context, 400.h, 200.h, 350.h),
                    width: DeviceConstraints.getResponsiveSize(context, 250.w, 250.w, 100.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: (salonModel.profilePics.isNotEmpty && salonModel.profilePics[0] != '')
                          ? CachedImage(
                              url: salonModel.profilePics[index],
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              ThemeImages.write1,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GlamLightWrap extends ConsumerWidget {
  final String text;
  final VoidCallback? onTap;
  const GlamLightWrap({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: DeviceConstraints.getResponsiveSize(context, 120.h, 150.h, 150.h),
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: themeType == ThemeType.GlamLight ? Colors.black : Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.bodyText1!.copyWith(
              color: themeType == ThemeType.GlamLight ? Colors.black : Colors.white,
              fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

List<double> rotationValue = [
  1.06,
  // 1.15,
  -1.06,
  // -1.18,
];

// List<double> heightValue = [0.5, 1, 0.7, 0.8, 0.6];
