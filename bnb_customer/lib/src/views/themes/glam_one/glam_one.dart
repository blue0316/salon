import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/glam_one/views/header.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_about.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_contact.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_price.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_promotions.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_reviews.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_shop.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_sponsors.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_tags.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/salon_works.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/socials.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/write_to_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlamOneScreen extends StatefulWidget {
  static const route = '/glam-one';

  const GlamOneScreen({Key? key}) : super(key: key);

  @override
  State<GlamOneScreen> createState() => _GlamOneScreenState();
}

class _GlamOneScreenState extends State<GlamOneScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorConstant.black900,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          // width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    // width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1000.h, // TODO: MAKE RESPONSIVE
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // TOP BACKGROUND IMAGE
                              SizedBox(
                                width: double.infinity,
                                child: Image.asset(GlamOneImages.shortBG, fit: BoxFit.cover),
                              ),
                              SizedBox(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 40.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const CustomAppBar(),
                                        SizedBox(height: 70.h),
                                        const ThemeHeader(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SalonTags(),
                        const SalonPromotions(),
                        const SalonAbout2(),
                        const SalonSponsors(),
                        const SalonWorks(),
                        const SalonPrice(),
                        const SalonShop(),
                        const SalonReviews(),
                        const WriteToUs(),
                        const SalonContact(),
                        const SalonSocials(),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 19, bottom: 19),
                              child: Text(
                                "Design by GlamIris",
                                style: GlamOneTheme.bodyText1.copyWith(fontSize: 18.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
