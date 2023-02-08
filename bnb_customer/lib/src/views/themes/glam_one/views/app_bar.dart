import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              SvgPicture.asset(GlamOneIcons.insta, height: 25.h),
              const SizedBox(width: 20),
              SvgPicture.asset(GlamOneIcons.tiktok, height: 25.h, color: Colors.white),
              const SizedBox(width: 20),
              SvgPicture.asset(GlamOneIcons.whatsapp, height: 25.h, color: Colors.white),
              const Spacer(),
              Text(
                "Beauty Miami".toUpperCase(),
                style: GlamOneTheme.headLine1.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                  letterSpacing: 0.9,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(GlamOneIcons.menu, height: 25.h),
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
