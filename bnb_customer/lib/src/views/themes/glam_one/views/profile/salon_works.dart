import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonWorks extends StatelessWidget {
  const SalonWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 50),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0XFFFFC692)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "MY WORKS",
                style: GlamOneTheme.headLine2.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 130.w,
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.",
                      style: GlamOneTheme.bodyText2.copyWith(
                        color: Colors.black,
                        fontSize: 17.5.sp,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        GlamOneIcons.leftArrow,
                        color: Colors.black,
                        height: 35.sp, // TODO: RESPONSIVE
                      ),
                      const SizedBox(width: 20), // TODO: RESPONSIVE
                      SvgPicture.asset(
                        GlamOneIcons.rightArrow,
                        color: const Color(0XFF0A0A0A),
                        height: 35.sp, // TODO: RESPONSIVE
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Container(
                height: 255.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 25);
                  },
                  itemCount: ladyImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.asset(
                        ladyImages[index],
                        fit: BoxFit.cover,
                      ),
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

List<String> ladyImages = [
  GlamOneImages.lady1,
  GlamOneImages.lady2,
  GlamOneImages.lady3,
  GlamOneImages.lady4,
  GlamOneImages.lady1,
  GlamOneImages.lady2,
  GlamOneImages.lady3,
  GlamOneImages.lady2,
  GlamOneImages.lady3,
];
