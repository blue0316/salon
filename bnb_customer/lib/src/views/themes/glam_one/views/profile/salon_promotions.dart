import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/oval_button.dart';

class SalonPromotions extends StatelessWidget {
  const SalonPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
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
                style: GlamOneTheme.headLine2.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    GlamOneIcons.leftArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  ),
                  SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
                  SvgPicture.asset(
                    GlamOneIcons.rightArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50.h),
          SizedBox(
            height: isPortrait ? 400.h : 260.h,
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
                            style: GlamOneTheme.headLine3.copyWith(
                              color: GlamOneTheme.deepOrange,
                              fontSize: 35.sp,
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent.",
                            style: GlamOneTheme.bodyText2.copyWith(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          const OvalButton(text: 'Get a discount'),
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
                                      style: GlamOneTheme.headLine3.copyWith(
                                        color: GlamOneTheme.deepOrange,
                                        fontSize: 30.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent.",
                                        style: GlamOneTheme.bodyText2.copyWith(
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
                                height: 210.h,
                                child: Image.asset(
                                  _samples[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                _samples[index]['title'],
                                style: GlamOneTheme.headLine3.copyWith(
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
              child: OvalButton(
                width: 180.h,
                height: 60.h,
                textSize: 18.sp,
                text: 'Get a discount',
              ),
            ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> _samples = [
  {
    'image': GlamOneImages.wideLadyPic,
    'title': "DISCOUNTS 15%",
  },
  {
    'image': GlamOneImages.wideLadyPic,
    'title': "HAPPY HOURS 12:00 - 15:00",
  },
  {
    'image': GlamOneImages.wideLadyPic,
    'title': "HAPPY FRIDAY",
  },
];
