import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonWorks extends StatelessWidget {
  final SalonModel salonModel;

  const SalonWorks({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    // Check if Salon is a single master
    final bool isSingleMaster = (salonModel.ownerType == OwnerType.singleMaster);

    return Padding(
      padding: EdgeInsets.only(
        top: DeviceConstraints.getResponsiveSize(context, 40, 60, 70),
        bottom: DeviceConstraints.getResponsiveSize(context, 30, 40, 50),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0XFFFFC692)),
        child: Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
            top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
            bottom: DeviceConstraints.getResponsiveSize(context, 60.h, 90.h, 100.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${isSingleMaster ? "MY" : "OUR"} WORKS",
                    style: GlamOneTheme.headLine2.copyWith(
                      color: Colors.black,
                      fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                    ),
                  ),
                  if (isPortrait) const Spacer(),
                  if (isPortrait) const PrevAndNext(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: DeviceConstraints.getResponsiveSize(context, 350.w, 150.w, 150.w),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.",
                      style: GlamOneTheme.bodyText2.copyWith(
                        color: Colors.black,
                        fontSize: 17.5.sp,
                      ),
                    ),
                  ),
                  if (!isPortrait) const PrevAndNext(),
                ],
              ),
              SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 50, 35)),
              SizedBox(
                height: 255.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(width: DeviceConstraints.getResponsiveSize(context, 10, 10, 25));
                  },
                  itemCount: ladyImages.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      ladyImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrevAndNext extends StatelessWidget {
  const PrevAndNext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          ThemeIcons.leftArrow,
          color: Colors.black,
          height: 35.sp,
        ),
        const SizedBox(width: 20),
        SvgPicture.asset(
          ThemeIcons.rightArrow,
          color: const Color(0XFF0A0A0A),
          height: 35.sp,
        ),
      ],
    );
  }
}

List<String> ladyImages = [
  ThemeImages.lady1,
  ThemeImages.lady2,
  ThemeImages.lady3,
  ThemeImages.lady4,
  ThemeImages.lady1,
  ThemeImages.lady2,
  ThemeImages.lady3,
  ThemeImages.lady2,
  ThemeImages.lady3,
];
