import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/oval_button.dart';

class SalonPromotions extends ConsumerWidget {
  const SalonPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 10.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 10.w, 50.w),
        top: 50,
        bottom: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PROMOTIONS",
                style: theme.textTheme.headline2?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                ),
              ),
              Row(
                children: [
                  (_salonProfileProvider.chosenSalon.selectedTheme != 2)
                      ? SvgPicture.asset(
                          ThemeIcons.leftArrow,
                          height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                        )
                      : Icon(
                          Icons.arrow_back,
                          size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                          color: Colors.white,
                        ),
                  SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
                  (_salonProfileProvider.chosenSalon.selectedTheme != 2)
                      ? SvgPicture.asset(
                          ThemeIcons.rightArrow,
                          height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                          color: Colors.white,
                        ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50.h),
          SizedBox(
            height: DeviceConstraints.getResponsiveSize(context, 400.h, 300.h, 280.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!isPortrait)
                  Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discounts 15%".toUpperCase(),
                            style: theme.textTheme.headline3?.copyWith(
                              color: GlamOneTheme.deepOrange,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 25.sp, 35.sp),
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent.",
                            style: theme.textTheme.bodyText2?.copyWith(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                              ? SquareButton(
                                  text: 'GET A DISCOUNT',
                                  height: 50.h,
                                  buttonColor: Colors.transparent,
                                  borderColor: Colors.white,
                                  textColor: Colors.white,
                                  textSize: 15.sp,
                                  onTap: () {},
                                )
                              : OvalButton(
                                  text: 'Get a discount',
                                  onTap: () {},
                                ),
                        ],
                      ),
                    ),
                  ),
                if (!isPortrait) const SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    // height: 200,
                    // width: 200,
                    child: ListView.builder(
                      itemCount: _samples.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (isPortrait)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Discounts 15%".toUpperCase(),
                                      style: theme.textTheme.headline3?.copyWith(
                                        color: GlamOneTheme.deepOrange,
                                        fontSize: 30.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent.",
                                        style: theme.textTheme.bodyText2?.copyWith(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              SizedBox(
                                width: 350.h,
                                height: DeviceConstraints.getResponsiveSize(context, 210.h, 260.h, 250.h),
                                child: Image.asset(
                                  _samples[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                _samples[index]['title'],
                                style: theme.textTheme.headline3?.copyWith(
                                  color: GlamOneTheme.primaryColor,
                                  fontSize: 20.sp,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isPortrait) const SizedBox(height: 30),
          if (isPortrait)
            Center(
              child: (_salonProfileProvider.chosenSalon.selectedTheme == 2)
                  ? SquareButton(
                      text: 'GET A DISCOUNT',
                      height: 50.h,
                      width: 250.h,
                      buttonColor: Colors.transparent,
                      borderColor: Colors.white,
                      textColor: Colors.white,
                      textSize: 15.sp,
                      onTap: () {},
                    )
                  : OvalButton(
                      width: 180.h,
                      height: 60.h,
                      textSize: 18.sp,
                      text: 'Get a discount',
                      onTap: () {},
                    ),
            ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> _samples = [
  {
    'image': ThemeImages.wideLadyPic,
    'title': "DISCOUNTS 15%",
  },
  {
    'image': ThemeImages.wideLadyPic,
    'title': "HAPPY HOURS 12:00 - 15:00",
  },
  {
    'image': ThemeImages.wideLadyPic,
    'title': "HAPPY FRIDAY",
  },
];
