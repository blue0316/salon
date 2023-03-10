import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/header/landing_header.dart';
import 'package:bbblient/src/views/themes/components/header_image.dart';
import 'package:bbblient/src/views/themes/components/about/salon_about.dart';
import 'package:bbblient/src/views/themes/components/contacts/salon_contact.dart';
import 'package:bbblient/src/views/themes/components/promotions/salon_promotions.dart';
import 'package:bbblient/src/views/themes/components/reviews/salon_reviews.dart';
import 'package:bbblient/src/views/themes/components/salon_services_2.dart';
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
    final ThemeData theme = _salonProfileProvider.salonTheme;

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
                        const LandingHeader(),
                        if (chosenSalon.additionalFeatures.isNotEmpty)
                          SalonTags(
                            additionalFeatures: chosenSalon.additionalFeatures,
                          ),
                        if (_createAppointmentProvider.salonPromotions.isNotEmpty)
                          SalonPromotions(
                            salonPromotionsList: _createAppointmentProvider.salonPromotions,
                          ),
                        SalonAbout2(salonModel: chosenSalon),
                        const SalonSponsors(),
                        SalonWorks(salonModel: chosenSalon),
                        SalonPrice222(
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

                        Padding(
                          padding: const EdgeInsets.only(top: 19, bottom: 15),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Design By ",
                                  style: theme.textTheme.bodyText1!.copyWith(
                                    fontSize: 20.sp,
                                    color: theme.primaryColorLight,
                                  ),
                                ),
                                TextSpan(
                                  text: "GlamIris",
                                  style: theme.textTheme.bodyText1!.copyWith(
                                    fontSize: 20.sp,
                                    color: theme.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
