import 'package:bbblient/src/views/themes/vintage_craft/desktop/about.dart';
import 'package:bbblient/src/views/themes/vintage_craft/desktop/contact.dart';
import 'package:bbblient/src/views/themes/vintage_craft/desktop/master_view.dart';
import 'package:bbblient/src/views/themes/vintage_craft/desktop/works.dart';
import 'package:flutter/material.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/header/landing_header.dart';
import 'package:bbblient/src/views/themes/components/reviews/salon_reviews.dart';
import 'package:bbblient/src/views/themes/components/services/salon_services.dart';
import 'package:bbblient/src/views/themes/components/shop/salon_shop.dart';
import 'package:bbblient/src/views/themes/components/salon_sponsors.dart';
import 'package:bbblient/src/views/themes/components/team/gentle_touch_team.dart';
import 'package:bbblient/src/views/themes/components/write_to_us/write_to_us.dart';
import 'package:bbblient/src/views/themes/utils/unique_landing_bottom.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/tags.dart';

class VintageCraftMobile extends ConsumerStatefulWidget {
  const VintageCraftMobile({super.key});

  @override
  ConsumerState<VintageCraftMobile> createState() => _VintageCraftMobileState();
}

class _VintageCraftMobileState extends ConsumerState<VintageCraftMobile> {
  bool isShowMenu = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final DisplaySettings? displaySettings = _salonProfileProvider.themeSettings?.displaySettings;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background, //  themeType == ThemeType.VintageCraftDesktop ? Colors.white : Colors.black,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        leading: Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: SizedBox(
            height: 70.h,
            width: 100.h,
            child: Center(
              child: (chosenSalon.salonLogo.isNotEmpty)
                  ? CachedImage(
                      url: chosenSalon.salonLogo,
                      fit: BoxFit.cover,
                    )
                  : Text(
                      (chosenSalon.salonName.initials.length >= 2) ? chosenSalon.salonName.initials.substring(0, 2) : chosenSalon.salonName.initials,
                      style: theme.textTheme.displayLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 50.sp),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (!_salonProfileProvider.isShowMenuMobile) {
                setState(() {
                  isShowMenu = true;
                });
                _salonProfileProvider.getWidgetForMobile('menu');
                _salonProfileProvider.changeShowMenuMobile(true);
              } else {
                setState(() {
                  isShowMenu = false;
                });
                _salonProfileProvider.changeShowMenuMobile(false);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                _salonProfileProvider.isShowMenuMobile ? "assets/test_assets/cancel_menu.svg" : "assets/test_assets/menu.svg",
                color: const Color(0XFF616161),
              ),
            ),
          ),
        ],
      ),
      body: _salonProfileProvider.isShowMenuMobile
          ? Container(
              width: double.infinity,
              color: theme.scaffoldBackgroundColor,
              child: _salonProfileProvider.currentWidgetVintage,
            )
          : !(_salonProfileProvider.showMasterView)
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox.fromSize(size: Size.zero, key: controller.landing),
                      const LandingHeader(),

                      // TAGS
                      if (displaySettings?.showFeatures == true) SizedBox.fromSize(size: Size.zero, key: controller.tags),
                      if (displaySettings?.showFeatures == true)
                        if (chosenSalon.additionalFeatures.isNotEmpty)
                          VintageTags(
                            salonModel: chosenSalon,
                            additionalFeatures: chosenSalon.additionalFeatures,
                          ),

                      // ABOUT
                      if (displaySettings?.showAbout == true) SizedBox.fromSize(size: Size.zero, key: controller.about),
                      if (displaySettings?.showAbout == true) VintageAboutUs(salonModel: chosenSalon),

                      // SPONSORS
                      if (displaySettings?.showBrands == true) SizedBox.fromSize(size: Size.zero, key: controller.sponsor),
                      if (displaySettings?.showBrands == true) const SalonSponsors(),

                      // WORKS
                      if (displaySettings?.showPhotosOfWork == true) SizedBox.fromSize(size: Size.zero, key: controller.works),
                      if (displaySettings?.showPhotosOfWork == true)
                        ClipRRect(
                          child: VintageWorks(salonModel: chosenSalon),
                        ),

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
                          GentleTouchTeam(
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
                      if (displaySettings?.showContact == true)
                        ClipRRect(
                          child: VintageSalonContact(salonModel: chosenSalon),
                        ),

                      // BOTTOM
                      Padding(
                        padding: EdgeInsets.only(top: 100.sp, bottom: 30.sp),
                        child: const UniquePortraitLandingBottom(),
                      ),
                    ],
                  ),
                )
              : VintageCraftDesktopMasterView(
                  masters: _createAppointmentProvider.salonMasters,
                  initialIndex: _salonProfileProvider.showMasterAtIndex,
                ),
    );
  }
}
