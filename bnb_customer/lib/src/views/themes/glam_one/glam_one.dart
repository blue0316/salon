import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/components/drawer.dart';
import 'package:bbblient/src/views/themes/components/header/landing_header.dart';
import 'package:bbblient/src/views/themes/components/about/salon_about.dart';
import 'package:bbblient/src/views/themes/components/contacts/salon_contact.dart';
import 'package:bbblient/src/views/themes/components/promotions/salon_promotions.dart';
import 'package:bbblient/src/views/themes/components/reviews/salon_reviews.dart';
import 'package:bbblient/src/views/themes/components/services/salon_services.dart';
import 'package:bbblient/src/views/themes/components/shop/salon_shop.dart';
import 'package:bbblient/src/views/themes/components/salon_sponsors.dart';
import 'package:bbblient/src/views/themes/components/salon_tags.dart';
import 'package:bbblient/src/views/themes/components/salon_team.dart';
import 'package:bbblient/src/views/themes/components/works/salon_works.dart';
import 'package:bbblient/src/views/themes/components/write_to_us/write_to_us.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        //  drawerEnableOpenDragGesture: false, // Prevent user sliding open
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        drawer: const ThemeDrawer(),
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
                        // TAGS
                        SizedBox.fromSize(size: Size.zero, key: controller.tags),
                        if (chosenSalon.additionalFeatures.isNotEmpty)
                          SalonTags(
                            salonModel: chosenSalon,
                            additionalFeatures: chosenSalon.additionalFeatures,
                          ),

                        // PROMOTIONS
                        SizedBox.fromSize(size: Size.zero, key: controller.promotions),
                        if (_createAppointmentProvider.salonPromotions.isNotEmpty)
                          SalonPromotions(
                            salonPromotionsList: _createAppointmentProvider.salonPromotions,
                          ),

                        // ABOUT
                        SizedBox.fromSize(size: Size.zero, key: controller.about),
                        SalonAbout2(salonModel: chosenSalon),

                        // SPONSORS
                        SizedBox.fromSize(size: Size.zero, key: controller.sponsor),
                        const SalonSponsors(),

                        // WORKS
                        SizedBox.fromSize(size: Size.zero, key: controller.works),
                        SalonWorks(salonModel: chosenSalon),

                        // PRICE
                        SizedBox.fromSize(size: Size.zero, key: controller.price),
                        SalonPrice222(
                          salonModel: chosenSalon,
                          categories: _salonSearchProvider.categories,
                          categoryServicesMapNAWA: _createAppointmentProvider.categoryServicesMap,
                        ),

                        // SHOP
                        SizedBox.fromSize(size: Size.zero, key: controller.shop),
                        const SalonShop(),

                        // TEAM
                        SizedBox.fromSize(size: Size.zero, key: controller.team),
                        if (_salonProfileProvider.chosenSalon.ownerType != OwnerType.singleMaster)
                          SalonTeam(
                            salonModel: chosenSalon,
                          ),

                        // REVIEWS
                        SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                        SalonReviews(salonModel: chosenSalon),

                        // WRITE TO US
                        SizedBox.fromSize(size: Size.zero, key: controller.writeToUs),
                        WriteToUs(salonModel: chosenSalon),

                        // CONTACT
                        SizedBox.fromSize(size: Size.zero, key: controller.contacts),
                        SalonContact(salonModel: chosenSalon),

                        // BOTTOM ITEM
                        Padding(
                          padding: const EdgeInsets.only(top: 19, bottom: 15),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Design By ",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 20.sp,
                                    color: theme.primaryColorLight,
                                  ),
                                ),
                                TextSpan(
                                  text: "GlamIris",
                                  style: theme.textTheme.bodyLarge!.copyWith(
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
