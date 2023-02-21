import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/header_image.dart';
import 'package:bbblient/src/views/themes/components/salon_about.dart';
import 'package:bbblient/src/views/themes/components/salon_contact.dart';
import 'package:bbblient/src/views/themes/components/salon_promotions.dart';
import 'package:bbblient/src/views/themes/components/salon_reviews.dart';
import 'package:bbblient/src/views/themes/components/salon_services.dart';
import 'package:bbblient/src/views/themes/components/salon_shop.dart';
import 'package:bbblient/src/views/themes/components/salon_sponsors.dart';
import 'package:bbblient/src/views/themes/components/salon_tags.dart';
import 'package:bbblient/src/views/themes/components/salon_team.dart';
import 'package:bbblient/src/views/themes/components/salon_works.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/glam_one/views/header.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/write_to_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;

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
                          height: DeviceConstraints.getResponsiveSize(context, 1000.h, 1000.h, 1000.h),
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // TOP BACKGROUND IMAGE
                              const ThemeHeaderImage(),
                              SizedBox(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 40.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // InkWell(
                                        //   child: Container(
                                        //     height: 100,
                                        //     width: 600,
                                        //     color: Colors.green,
                                        //   ),
                                        //   onTap: () {
                                        //     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                                        //     // print(_salonSearchProvider.categories);
                                        //     print(_createAppointmentProvider.categoryServicesMap);
                                        //     print(_createAppointmentProvider.servicesAvailable);

                                        //     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                                        //   },
                                        // ),
                                        ThemeAppBar(salonModel: chosenSalon),
                                        SizedBox(height: 70.h),
                                        ThemeHeader(salonModel: chosenSalon),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (chosenSalon.additionalFeatures.isNotEmpty)
                          SalonTags(
                            additionalFeatures: chosenSalon.additionalFeatures,
                          ),
                        if (_createAppointmentProvider.salonPromotions.isNotEmpty) const SalonPromotions(),
                        SalonAbout2(salonModel: chosenSalon),
                        const SalonSponsors(),
                        SalonWorks(salonModel: chosenSalon),
                        SalonPrice(
                          salonModel: chosenSalon,
                          categories: _salonSearchProvider.categories,
                          categoryServicesMapNAWA: _createAppointmentProvider.categoryServicesMap,
                        ),
                        const SalonShop(),
                        if (_salonProfileProvider.chosenSalon.ownerType != OwnerType.singleMaster)
                          SalonTeam(
                            salonModel: chosenSalon,
                          ),
                        SalonReviews(salonModel: chosenSalon),
                        WriteToUs(salonModel: chosenSalon),
                        SalonContact(salonModel: chosenSalon),
                        // SalonSocials(
                        //   salonModel: chosenSalon,
                        // ),
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
