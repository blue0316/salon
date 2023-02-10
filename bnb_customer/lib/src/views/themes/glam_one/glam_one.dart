import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// SINGLE MASTER THEME
class GlamOneScreen extends ConsumerStatefulWidget {
  static const route = '/glam-one';

  // final SalonModel salonModel;

  const GlamOneScreen({Key? key}) : super(key: key);

  @override
  _GlamOneScreenState createState() => _GlamOneScreenState();
}

class _GlamOneScreenState extends ConsumerState<GlamOneScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);

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
                          height: DeviceConstraints.getResponsiveSize(context, 900.h, 1000.h, 1000.h),
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // TOP BACKGROUND IMAGE
                              SizedBox(
                                width: double.infinity,
                                child: Image.asset(
                                  isPortrait ? ThemeImages.longBG : ThemeImages.shortBG,
                                  fit: BoxFit.cover,
                                ),
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
                                        ThemeHeader(
                                          salonModel: _salonProfileProvider.chosenSalon,
                                        ),
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
                        SalonPrice(
                          salonModel: _salonProfileProvider.chosenSalon,
                          categories: _salonSearchProvider.categories,
                        ),
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
