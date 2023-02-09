import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/oval_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalonAbout2 extends StatelessWidget {
  const SalonAbout2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    // DeviceConstraints.getResponsiveSize(context, 70.sp, 80.sp, 100.sp),
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 50, 80, 120),
        bottom: DeviceConstraints.getResponsiveSize(context, 25, 30, 50),
      ),
      child: SizedBox(
        width: double.infinity,
        height: isPortrait ? 700.h : 450.h,
        child: (!isPortrait)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      child: Image.asset(
                        ThemeImages.makeup,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 25.w),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("ABOUT ME", style: GlamOneTheme.headLine2),
                          const SizedBox(height: 10),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex. Suspendisse ac rhoncus nisl, eu tempor urna. Curabitur vel bibendum lorem.",
                            style: GlamOneTheme.bodyText2.copyWith(
                              color: Colors.white,
                              fontSize: 15.5.sp,
                            ),
                          ),
                          const OvalButton(text: 'Book Now'),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "ABOUT ME",
                    style: GlamOneTheme.headLine2.copyWith(
                      fontSize: 40.sp,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex. Suspendisse ac rhoncus nisl, eu tempor urna. Curabitur vel bibendum lorem.",
                    style: GlamOneTheme.bodyText2.copyWith(
                      color: Colors.white,
                      fontSize: 15.5.sp,
                    ),
                  ),
                  const SizedBox(height: 30),
                  OvalButton(
                    width: 180.h,
                    height: 60.h,
                    textSize: 18.sp,
                    text: 'Book Now',
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    height: 300.h,
                    child: Image.asset(
                      ThemeImages.makeup,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
