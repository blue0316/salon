// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
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
import 'dart:js' as js;

class GlamOneScreen extends ConsumerStatefulWidget {
  static const route = '/glam-one';
  final bool showBooking;

  // final SalonModel salonModel;

  const GlamOneScreen({Key? key, this.showBooking = false}) : super(key: key);

  @override
  _GlamOneScreenState createState() => _GlamOneScreenState();
}

class _GlamOneScreenState extends ConsumerState<GlamOneScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showBooking) {
      Future.delayed(Duration.zero, () {
        const BookingDialogWidget222().show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final DisplaySettings? displaySettings = _salonProfileProvider.themeSettings?.displaySettings;

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
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const LandingHeader(),

                    // TAGS
                    if (displaySettings?.showFeatures == true) SizedBox.fromSize(size: Size.zero, key: controller.tags),
                    if (displaySettings?.showFeatures == true)
                      if (chosenSalon.additionalFeatures.isNotEmpty)
                        SalonTags(
                          salonModel: chosenSalon,
                          additionalFeatures: chosenSalon.additionalFeatures,
                        ),

                    // PROMOTIONS
                    if (displaySettings?.showPromotions == true) SizedBox.fromSize(size: Size.zero, key: controller.promotions),
                    if (displaySettings?.showPromotions == true)
                      if (_createAppointmentProvider.salonPromotions.isNotEmpty)
                        SalonPromotions(
                          salonPromotionsList: _createAppointmentProvider.salonPromotions,
                        ),

                    // ABOUT
                    if (displaySettings?.showAbout == true) SizedBox.fromSize(size: Size.zero, key: controller.about),
                    if (displaySettings?.showAbout == true) SalonAbout2(salonModel: chosenSalon),

                    // SPONSORS
                    if (displaySettings?.showBrands == true) SizedBox.fromSize(size: Size.zero, key: controller.sponsor),
                    if (displaySettings?.showBrands == true) const SalonSponsors(),

                    // WORKS
                    if (displaySettings?.showPhotosOfWork == true) SizedBox.fromSize(size: Size.zero, key: controller.works),
                    if (displaySettings?.showPhotosOfWork == true) SalonWorks(salonModel: chosenSalon),

                    // PRICE
                    if (displaySettings?.services.showServices == true) SizedBox.fromSize(size: Size.zero, key: controller.price),
                    if (displaySettings?.services.showServices == true)
                      SalonPrice222(
                        salonModel: chosenSalon,
                        categories: _salonSearchProvider.categories,
                        categoryServicesMapNAWA: _createAppointmentProvider.categoryServicesMap,
                      ),

                    // SHOP
                    if (displaySettings?.product.showProduct == true) SizedBox.fromSize(size: Size.zero, key: controller.shop),
                    if (displaySettings?.product.showProduct == true) const SalonShop(),

                    // TEAM
                    if (displaySettings?.showTeam == true) SizedBox.fromSize(size: Size.zero, key: controller.team),
                    if (displaySettings?.showTeam == true)
                      if (!_salonProfileProvider.isSingleMaster)
                        SalonTeam(
                          salonModel: chosenSalon,
                        ),

                    // REVIEWS
                    if (displaySettings?.reviews.showReviews == true) SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                    if (displaySettings?.reviews.showReviews == true) SalonReviews(salonModel: chosenSalon),

                    // WRITE TO US
                    if (displaySettings?.showRequestForm == true) SizedBox.fromSize(size: Size.zero, key: controller.writeToUs),
                    if (displaySettings?.showRequestForm == true) WriteToUs(salonModel: chosenSalon),

                    // CONTACT
                    if (displaySettings?.showContact == true) SizedBox.fromSize(size: Size.zero, key: controller.contacts),
                    if (displaySettings?.showContact == true) SalonContact(salonModel: chosenSalon),

                    // BOTTOM ITEM
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 19, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Powered by ',
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                                fontWeight: FontWeight.w400,
                                color: const Color(0XFF908D8D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 2.sp),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  js.context.callMethod('open', ['https://www.glamiris.com/']);
                                },
                                child: Text(
                                  'Glamiris',
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(255, 19, 121, 204), // const Color(0XFF908D8D),
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 // fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),