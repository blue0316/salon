import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Center(
                child: Text(
                  'my social network'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GlamOneTheme.headLine2.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
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
                      padding: const EdgeInsets.only(right: 15),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 270.h,
                            width: 65.w,
                            child: Image.asset(_images[index], fit: BoxFit.cover),
                          ),
                          SvgPicture.asset(
                            GlamOneIcons.insta,
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
  GlamOneImages.social1,
  GlamOneImages.social2,
  GlamOneImages.social3,
  GlamOneImages.social4,
  GlamOneImages.social1,
  GlamOneImages.social5,
  GlamOneImages.social3,
  GlamOneImages.social4,
  GlamOneImages.social3,
  GlamOneImages.social4,
  GlamOneImages.social1,
];
