// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/themes/components/drawer.dart';
import 'package:bbblient/src/views/themes/components/header/landing_header.dart';
import 'package:bbblient/src/views/themes/components/about/salon_about.dart';
import 'package:bbblient/src/views/themes/components/contacts/salon_contact.dart';
import 'package:bbblient/src/views/themes/components/reviews/salon_reviews.dart';
import 'package:bbblient/src/views/themes/components/services/salon_services.dart';
import 'package:bbblient/src/views/themes/components/shop/salon_shop.dart';
import 'package:bbblient/src/views/themes/components/salon_sponsors.dart';
import 'package:bbblient/src/views/themes/components/salon_tags.dart';
import 'package:bbblient/src/views/themes/components/team/gentle_touch_team.dart';
import 'package:bbblient/src/views/themes/components/works/salon_works.dart';
import 'package:bbblient/src/views/themes/components/write_to_us/write_to_us.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/themes/utils/unique_landing_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/team/team_member_view.dart';

class GentleTouch extends ConsumerStatefulWidget {
  static const route = '/gentle-touch';
  final bool showBooking;

  // final SalonModel salonModel;

  const GentleTouch({Key? key, this.showBooking = false}) : super(key: key);

  @override
  _GentleTouchState createState() => _GentleTouchState();
}

class _GentleTouchState extends ConsumerState<GentleTouch> {
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
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    ThemeType themeType = _salonProfileProvider.themeType;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        //  drawerEnableOpenDragGesture: false, // Prevent user sliding open
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        drawer: const ThemeDrawer(),
        appBar: AppBar(
          backgroundColor: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
          automaticallyImplyLeading: false,
          toolbarHeight: 70.h,
          actions: [
            if (!isTab)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Icon(
                        Icons.menu,
                        size: 35.sp,
                        color: themeType == ThemeType.GentleTouch ? Colors.black : const Color(0XFF616161),
                      ),
                    ),
                  ),
                ),
              ),
          ],
          title: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
              border: themeType == ThemeType.GentleTouch
                  ? Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 0.6),
                    )
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: isTab ? 30.w : 5.w),
                  child: SizedBox(
                    height: 70.h,
                    child: Center(
                      child: Text(
                        chosenSalon.salonName.initials,
                        style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 50.sp),
                          color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                          fontFamily: "VASQUZ",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isTab)
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 70.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppBarItem(
                            title: 'About Us',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.about.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          AppBarItem(
                            title: 'Portfolio',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.works.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          AppBarItem(
                            title: 'Services',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.price.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          AppBarItem(
                            title: 'Products',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.shop.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          AppBarItem(
                            title: 'Team',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.team.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          AppBarItem(
                            title: 'Reviews',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.reviews.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                          AppBarItem(
                            isLast: true,
                            title: 'Contacts',
                            onTap: () {
                              Scrollable.ensureVisible(
                                controller.contacts.currentContext!,
                                duration: const Duration(seconds: 2),
                                curve: Curves.ease,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isTab)
                  Padding(
                    padding: EdgeInsets.only(right: 30.w),
                    child: const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Scrollable.ensureVisible(
                controller.landing.currentContext!,
                duration: const Duration(seconds: 2),
                curve: Curves.ease,
              );
            },
            child: Container(
              height: 60.h,
              width: 60.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0XFFC1C1C1), width: 1.2),
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 30.h,
                color: const Color(0XFFC1C1C1),
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: !(_salonProfileProvider.showMasterView)
              ? Column(
                  children: [
                    // SizedBox.fromSize(size: Size.zero, key: controller.landing),
                    // const LandingHeader(),

                    // // TAGS
                    // if (displaySettings?.showFeatures == true) SizedBox.fromSize(size: Size.zero, key: controller.tags),
                    // if (displaySettings?.showFeatures == true)
                    //   if (chosenSalon.additionalFeatures.isNotEmpty)
                    //     SalonTags(
                    //       salonModel: chosenSalon,
                    //       additionalFeatures: chosenSalon.additionalFeatures,
                    //       isScrollingNeeded: false,
                    //     ),

                    // // ABOUT
                    // if (displaySettings?.showAbout == true) SizedBox.fromSize(size: Size.zero, key: controller.about),
                    // if (displaySettings?.showAbout == true) SalonAbout2(salonModel: chosenSalon),

                    // // SPONSORS
                    // if (displaySettings?.showBrands == true) SizedBox.fromSize(size: Size.zero, key: controller.sponsor),
                    // if (displaySettings?.showBrands == true) const SalonSponsors(),

                    // // WORKS
                    // if (displaySettings?.showPhotosOfWork == true) SizedBox.fromSize(size: Size.zero, key: controller.works),
                    // if (displaySettings?.showPhotosOfWork == true) SalonWorks(salonModel: chosenSalon),

                    // PRICE
                    if (displaySettings?.services.showServices == true) SizedBox.fromSize(size: Size.zero, key: controller.price),
                    if (displaySettings?.services.showServices == true)
                      SalonPrice222(
                        salonModel: chosenSalon,
                        categories: _salonSearchProvider.categories,
                        categoryServicesMapNAWA: _createAppointmentProvider.categoryServicesMap,
                      ),

                    // // SHOP
                    // if (displaySettings?.product.showProduct == true) SizedBox.fromSize(size: Size.zero, key: controller.shop),
                    // if (displaySettings?.product.showProduct == true) const SalonShop(),

                    // // TEAM
                    // if (displaySettings?.showTeam == true) SizedBox.fromSize(size: Size.zero, key: controller.team),
                    // if (displaySettings?.showTeam == true)
                    //   if (!_salonProfileProvider.isSingleMaster)
                    //     GentleTouchTeam(
                    //       salonModel: chosenSalon,
                    //     ),

                    // // REVIEWS
                    // if (displaySettings?.reviews.showReviews == true) SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                    // if (displaySettings?.reviews.showReviews == true) SalonReviews(salonModel: chosenSalon),

                    // // WRITE TO US
                    // if (displaySettings?.showRequestForm == true) SizedBox.fromSize(size: Size.zero, key: controller.writeToUs),
                    // if (displaySettings?.showRequestForm == true) WriteToUs(salonModel: chosenSalon),

                    // // CONTACT
                    // if (displaySettings?.showContact == true) SizedBox.fromSize(size: Size.zero, key: controller.contacts),
                    // if (displaySettings?.showContact == true) SalonContact(salonModel: chosenSalon),

                    // BOTTOM
                    Padding(
                      padding: EdgeInsets.only(top: 100.sp, bottom: 30.sp),
                      child: const LandingBottom(),
                    ),
                    // Center(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 19, bottom: 15),
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           'Powered by ',
                    //           style: theme.textTheme.titleSmall!.copyWith(
                    //             fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                    //             fontWeight: FontWeight.w400,
                    //             color: const Color(0XFF908D8D),
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //         SizedBox(width: 2.sp),
                    //         MouseRegion(
                    //           cursor: SystemMouseCursors.click,
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               js.context.callMethod('open', ['https://www.glamiris.com/']);
                    //             },
                    //             child: Text(
                    //               'Glamiris',
                    //               style: theme.textTheme.titleSmall!.copyWith(
                    //                 fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                    //                 fontWeight: FontWeight.w500,
                    //                 color: const Color.fromARGB(255, 19, 121, 204), // const Color(0XFF908D8D),
                    //                 decoration: TextDecoration.underline,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : GentleTouchMasterView(
                  masters: _createAppointmentProvider.salonMasters,
                  initialIndex: _salonProfileProvider.showMasterAtIndex,
                ),
        ),
      ),
    );
  }
}

class LandingBottom extends ConsumerWidget {
  const LandingBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    return SizedBox(
      // height: 120.sp,
      width: double.infinity,
      // color: Colors.amber,
      child: isTab ? const UniqueLandscapeLandingBottom() : const UniquePortraitLandingBottom(),
    );
  }
}

class AppBarItem extends ConsumerWidget {
  final String title;
  final bool isLast;
  final VoidCallback onTap;

  const AppBarItem({
    Key? key,
    required this.title,
    this.isLast = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 15.w),
          child: Text(
            title,
            style: theme.textTheme.displayLarge!.copyWith(
              fontSize: 15.sp,
              color: themeType == ThemeType.GentleTouch ? const Color(0XFF0D0D0E) : Colors.white,
              fontWeight: FontWeight.normal,
              fontFamily: "Inter-Light",
            ),
          ),
        ),
      ),
    );
  }
}
