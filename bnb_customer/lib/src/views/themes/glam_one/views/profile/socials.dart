import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SalonSocials extends StatelessWidget {
  const SalonSocials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0XFFFFC692),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 30.w, 50.w)),
              child: Center(
                child: Text(
                  'my social network'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GlamOneTheme.headLine2.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 300.h,
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: DeviceConstraints.getResponsiveSize(context, 30, 30, 15)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 270.h,
                            width: DeviceConstraints.getResponsiveSize(context, 250.w, 180.w, 65.w),
                            child: Image.asset(_images[index], fit: BoxFit.cover),
                          ),
                          SvgPicture.asset(
                            ThemeIcons.insta,
                            color: GlamOneTheme.primaryColor,
                            height: 30.h,
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
    );
  }
}

List<String> _images = [
  ThemeImages.social1,
  ThemeImages.social2,
  ThemeImages.social3,
  ThemeImages.social4,
  ThemeImages.social1,
  ThemeImages.social5,
  ThemeImages.social3,
  ThemeImages.social4,
  ThemeImages.social3,
  ThemeImages.social4,
  ThemeImages.social1,
];
