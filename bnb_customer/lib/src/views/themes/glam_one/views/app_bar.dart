import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final SalonModel salonModel;

  const CustomAppBar({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isPortrait)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(ThemeIcons.insta, height: 25.h),
                    const SizedBox(width: 20),
                    SvgPicture.asset(ThemeIcons.tiktok, height: 25.h, color: Colors.white),
                    const SizedBox(width: 20),
                    SvgPicture.asset(ThemeIcons.whatsapp, height: 25.h, color: Colors.white),
                  ],
                ),
              if (!isPortrait) const Spacer(),
              Text(
                "Beauty Miami".toUpperCase(),
                style: GlamOneTheme.headLine1.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(ThemeIcons.menu, height: 25.h),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            width: double.infinity, // getHorizontalSize(310.00),

            decoration: const BoxDecoration(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
