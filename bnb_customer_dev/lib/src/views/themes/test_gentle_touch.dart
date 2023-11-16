// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/app_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/themes/components/drawer.dart';
import 'package:bbblient/src/views/themes/components/services/salon_services.dart';
import 'package:bbblient/src/views/themes/components/salon_tags.dart';
import 'package:bbblient/src/views/themes/components/team/gentle_touch_team.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/components/works/salon_works.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/themes/utils/unique_landing_bottom.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/contacts/gentle_touch_contact.dart';
import 'components/contacts/widgets/contact_maps.dart';
import 'components/header_image.dart';
import 'components/reviews/gentle_touch_review.dart';
import 'components/services/widgets/widgets.dart';
import 'components/shop/gentle_touch_shop.dart';
import 'components/shop/widgets/gentle_touch_shop_card.dart';
import 'components/team/team_member_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/widgets/multiple_states_button.dart';
import 'glam_one/core/utils/header_height.dart';
import 'glam_one/core/utils/prev_and_next.dart';
import 'glam_one/views/header.dart';

class GentleTouchDesktop extends ConsumerStatefulWidget {
  // static const route = '/gentle-touch-desktop';
  final bool showBooking;

  // final SalonModel salonModel;

  const GentleTouchDesktop({Key? key, this.showBooking = false}) : super(key: key);

  @override
  _GentleTouchDesktopState createState() => _GentleTouchDesktopState();
}

class _GentleTouchDesktopState extends ConsumerState<GentleTouchDesktop> {
  // ** TAGS ** //
  getFeature(String s) {
    final repository = ref.watch(bnbProvider);

    List<Map<String, String>> searchList = getFeaturesList(repository.locale.toString());

    for (Map registeredFeatures in searchList) {
      if (registeredFeatures.containsKey(s)) {
        return registeredFeatures[s];
      }
    }

    return s;
  }

  // ** ABOUT ** //
  final CarouselController _aboutController = CarouselController();
  int _aboutCurrent = 0;

  // ** SPONSORS ** //
  final ScrollController _sponsorScrollController = ScrollController();
  Timer? _timer;

  bool scroll = false;
  int speedFactor = 20;

  _scroll() {
    if (_sponsorScrollController.hasClients) {
      double maxExtent = _sponsorScrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _sponsorScrollController.offset;
      double durationDouble = distanceDifference / speedFactor;

      _sponsorScrollController.animateTo(
        _sponsorScrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear,
      );
    }
  }

  _toggleScrolling() {
    if (mounted) {
      setState(() {
        scroll = !scroll;
      });
    }

    if (scroll) {
      _scroll();
    } else {
      if (_sponsorScrollController.hasClients) {
        _sponsorScrollController.animateTo(
          _sponsorScrollController.offset,
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
      }
    }
  }

  // ** PRICE ** //
  TabController? serviceTabController;
  int _selectedTabbar = 0;

  // ** SHOP ** //
  String? currentSelectedEntry;

  // ** TEAM ** //
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int tabInitial = 3;
  int portraitInitial = 1;

  // ** REVIEWS ** //
  final CarouselController _reviewController = CarouselController();

  // ** WRITE TO US ** //

  // ** CONTACT ** //

  // ** BOTTOM ** //

  @override
  void initState() {
    super.initState();
    if (widget.showBooking) {
      Future.delayed(Duration.zero, () {
        const BookingDialogWidget222().show(context);
      });
    }

    // ** SPONSORS ** //
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _toggleScrolling();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();

    _sponsorScrollController.dispose();
    serviceTabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final DisplaySettings? displaySettings = _salonProfileProvider.themeSettings?.displaySettings;
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    void submit() {
      _salonProfileProvider.sendEnquiryToSalon(context, salonId: chosenSalon.salonId);
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        //  drawerEnableOpenDragGesture: false, // Prevent user sliding open
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        drawer: const ThemeDrawer(),
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background, //  themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
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
              color: theme.colorScheme.background, // themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
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
                  child: GestureDetector(
                    onTap: () => const BookingDialogWidget222().show(context),
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
                                  color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                                  fontFamily: "VASQUZ",
                                  fontWeight: FontWeight.w500,
                                ),
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
                          if (chosenSalon.description.isNotEmpty && displaySettings?.showAbout == true)
                            AppBarItem(
                              title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
                              onTap: () {
                                Scrollable.ensureVisible(
                                  controller.about.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          if (chosenSalon.photosOfWorks != null && chosenSalon.photosOfWorks!.isNotEmpty && displaySettings?.showPhotosOfWork == true)
                            AppBarItem(
                              title: AppLocalizations.of(context)?.portfolio ?? 'Portfolio',
                              onTap: () {
                                Scrollable.ensureVisible(
                                  controller.works.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          if (displaySettings?.services.showServices == true)
                            AppBarItem(
                              title: AppLocalizations.of(context)?.services ?? 'Services',
                              onTap: () {
                                Scrollable.ensureVisible(
                                  controller.price.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          if (_salonProfileProvider.allProducts.isNotEmpty && displaySettings?.product.showProduct == true)
                            AppBarItem(
                              title: AppLocalizations.of(context)?.products ?? 'Products',
                              onTap: () {
                                Scrollable.ensureVisible(
                                  controller.shop.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          if (_createAppointmentProvider.salonMasters.isNotEmpty && displaySettings?.showTeam == true)
                            AppBarItem(
                              title: AppLocalizations.of(context)?.team ?? 'Team',
                              onTap: () {
                                Scrollable.ensureVisible(
                                  controller.team.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          if (_salonProfileProvider.salonReviews.isNotEmpty && displaySettings?.reviews.showReviews == true)
                            AppBarItem(
                              title: AppLocalizations.of(context)?.reviews ?? 'Reviews',
                              onTap: () {
                                Scrollable.ensureVisible(
                                  controller.reviews.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          if (displaySettings?.showContact == true)
                            AppBarItem(
                              isLast: true,
                              title: AppLocalizations.of(context)?.contacts ?? 'Contacts',
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

        body: !(_salonProfileProvider.showMasterView)
            ? ListView(
                children: [
                  // ** HEADER ** //
                  SizedBox.fromSize(size: Size.zero, key: controller.landing),
                  SizedBox(
                    height: getThemeHeaderHeight(context, themeType),
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        const ThemeHeaderImage(),
                        SizedBox(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: isTab ? 150.h : 80.h),
                                ThemeHeader(salonModel: chosenSalon),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ** TAGS ** //
                  // if (displaySettings?.showFeatures == true) SizedBox.fromSize(size: Size.zero, key: controller.tags),
                  if (displaySettings?.showFeatures == true)
                    if (chosenSalon.additionalFeatures.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          left: 40.w,
                          right: 40.w,
                          top: 100.h,
                          bottom: 50.h,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            runSpacing: 15.sp,
                            children: chosenSalon.additionalFeatures
                                .map(
                                  (item) => SizedBox(
                                    width: 350.h,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_rounded,
                                          color: theme.colorScheme.secondary,
                                          size: 30.sp,
                                        ),
                                        SizedBox(width: 10.sp),
                                        SizedBox(
                                          width: 250.h,
                                          child: Text(
                                            getFeature(item).toUpperCase(),
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),

                  // ** ABOUT ** //
                  if (displaySettings?.showAbout == true) SizedBox.fromSize(size: Size.zero, key: controller.about),
                  if (displaySettings?.showAbout == true)
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        top: 40,
                        bottom: 50,
                        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 500.h,
                              // width: double.infinity,
                              decoration: BoxDecoration(
                                color: chosenSalon.profilePics.isNotEmpty ? null : theme.primaryColor,
                              ),
                              child: (chosenSalon.profilePics.isNotEmpty)
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: 500.h,
                                          width: double.infinity,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: CarouselSlider(
                                              carouselController: _aboutController,
                                              options: CarouselOptions(
                                                height: 500.h,
                                                autoPlay: true,
                                                viewportFraction: 1,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    _aboutCurrent = index;
                                                  });
                                                },
                                              ),
                                              items: chosenSalon.profilePics
                                                  .map(
                                                    (item) => CachedImage(
                                                      url: item, //  item.image!,
                                                      fit: BoxFit.cover,
                                                      height: 300.h,
                                                      width: MediaQuery.of(context).size.width,
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 15.sp),
                                        Positioned(
                                          bottom: 0,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: chosenSalon.profilePics.asMap().entries.map((entry) {
                                              return GestureDetector(
                                                onTap: () => _aboutController.animateToPage(entry.key),
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _aboutCurrent == entry.key
                                                        ? Colors.white
                                                        : const Color(0XFF8A8A8A).withOpacity(
                                                            _aboutCurrent == entry.key ? 0.9 : 0.4,
                                                          ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        (chosenSalon.salonName.isNotEmpty) ? chosenSalon.salonName[0].toUpperCase() : '',
                                        style: theme.textTheme.displayLarge!.copyWith(
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 60.sp, 80.sp, 100.sp),
                                          color: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: DeviceConstraints.getResponsiveSize(context, 30.w, 30.w, 25.w),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
                                  style: theme.textTheme.displayMedium?.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                                    color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  (chosenSalon.description != '') ? chosenSalon.description : 'No description yet',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                  maxLines: 10,
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MultipleStatesButton(
                                      borderColor: Colors.transparent,
                                      buttonColor: theme.colorScheme.secondary,
                                      width: 180.sp,
                                      text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
                                      weight: FontWeight.normal,
                                      textColor: themeType == ThemeType.GentleTouch ? const Color(0XFFFFFFFF) : Colors.black,
                                      height: 47.h,
                                      showSuffix: false,
                                      borderRadius: 2,
                                      isGradient: _salonProfileProvider.hasThemeGradient,
                                      onTap: () => const BookingDialogWidget222().show(context),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: DeviceConstraints.getResponsiveSize(context, 30.w, 30.w, 25.w),
                          ),
                        ],
                      ),
                    ),

                  // ** SPONSORS ** //
                  if (displaySettings?.showBrands == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Column(
                        children: [
                          Divider(color: theme.dividerColor, thickness: 1),
                          (_salonProfileProvider.allProductBrands.isEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    AppLocalizations.of(context)?.noBrandsForThisProfile ?? "No brands available for this profile",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.dividerColor,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 40.sp,
                                  child: Center(
                                    child: NotificationListener(
                                      onNotification: (notif) {
                                        if (notif is ScrollEndNotification && scroll) {
                                          Timer(const Duration(seconds: 1), () {
                                            _scroll();
                                          });
                                        }

                                        return true;
                                      },
                                      child: Center(
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          controller: _sponsorScrollController,
                                          shrinkWrap: true,
                                          physics: const ClampingScrollPhysics(),
                                          children: [
                                            Center(
                                              child: Row(
                                                children: _salonProfileProvider.allProductBrands
                                                    .map(
                                                      (item) => Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Text(
                                                              '${item.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.translations!['en'] ?? ''}'.toUpperCase(),
                                                              style: theme.textTheme.bodyLarge?.copyWith(
                                                                color: theme.dividerColor,
                                                                fontSize: 18.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 8.h,
                                                            width: 8.h,
                                                            decoration: tagSeperator(themeType, theme),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Divider(color: theme.dividerColor, thickness: 1),
                        ],
                      ),
                    ),

                  // ** WORKS ** //
                  if (displaySettings?.showPhotosOfWork == true) SizedBox.fromSize(size: Size.zero, key: controller.works),
                  if (displaySettings?.showPhotosOfWork == true) SalonWorks(salonModel: chosenSalon),

                  // ** PRICE ** //
                  if (displaySettings?.services.showServices == true) SizedBox.fromSize(size: Size.zero, key: controller.price),
                  if (displaySettings?.services.showServices == true)
                    DefaultTabController(
                      length: _createAppointmentProvider.categoriesAvailable.length,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                          top: DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
                          bottom: DeviceConstraints.getResponsiveSize(context, 20, 20, 10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                (AppLocalizations.of(context)?.itemsOfServices ?? 'services').toUpperCase(),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
                                ? Expanded(
                                    flex: 0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        height: 65.sp, // MediaQuery.of(context).size.height * 0.065, // 60.h,
                                        child: TabBar(
                                          onTap: (index) {
                                            setState(() {
                                              _selectedTabbar = index;
                                            });
                                          },
                                          controller: serviceTabController,
                                          unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor,

                                          labelColor: labelColorTheme(themeType, theme), // theme.tabBarTheme.labelColor,
                                          labelStyle: theme.textTheme.bodyLarge?.copyWith(
                                            color: labelColorTheme(themeType, theme), // theme.tabBarTheme.labelColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.sp,
                                          ),
                                          unselectedLabelStyle: theme.textTheme.bodyLarge?.copyWith(
                                            color: theme.tabBarTheme.unselectedLabelColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.sp,
                                          ),
                                          indicator: servicesTabBarTheme(themeType, theme),
                                          //  BoxDecoration(
                                          //   color: theme.primaryColor,
                                          //   border: Border(
                                          //     bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
                                          //   ),
                                          // ),
                                          isScrollable: true,
                                          labelPadding: EdgeInsets.symmetric(horizontal: 15.sp),
                                          tabs: _createAppointmentProvider.categoriesAvailable
                                              .map(
                                                (item) => Tab(
                                                  text: ('${item.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.categoryName}').toTitleCase(), //  .categoryName.toTitleCase(),
                                                  // height: 20,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
                                      child: Text(
                                        (AppLocalizations.of(context)?.noServicesAvailable ?? 'No services available').toUpperCase(),
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 30.h),
                            (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
                                ? Builder(
                                    builder: (_) {
                                      for (List<ServiceModel> serviceList in _createAppointmentProvider.servicesAvailable) {
                                        if (_selectedTabbar == _createAppointmentProvider.servicesAvailable.indexOf(serviceList)) {
                                          return ServiceAndPrice(listOfServices: serviceList);
                                        }
                                      }

                                      return const SizedBox.shrink();
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),

                  // ** SHOP ** //
                  if (displaySettings?.product.showProduct == true) SizedBox.fromSize(size: Size.zero, key: controller.shop),
                  if (displaySettings?.product.showProduct == true)
                    Padding(
                      padding: EdgeInsets.only(
                        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                        top: DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
                        bottom: 50,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              stylePrint(DeviceConstraints.getDeviceType(MediaQuery.of(context)));
                            },
                            child: Text(
                              (AppLocalizations.of(context)?.products ?? 'Products').toUpperCase(),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                              ),
                            ),
                          ),
                          _salonProfileProvider.allProducts.isNotEmpty ? SizedBox(height: 60.sp) : const SizedBox(height: 50),
                          (_salonProfileProvider.allProducts.isNotEmpty)
                              ? Expanded(
                                  flex: 0,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 450.h, //  _salonProfileProvider.isHovered ? 410.h : 360.h,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: ListView(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  GentleTouchShopTab(
                                                    title: AppLocalizations.of(context)?.all ?? 'All',
                                                    showTab: currentSelectedEntry == null,
                                                    onTap: () => setState(() => currentSelectedEntry = null),
                                                  ),

                                                  // OTHER TABS
                                                  ..._salonProfileProvider.tabs.entries
                                                      .map(
                                                        (entry) => Padding(
                                                          padding: EdgeInsets.symmetric(vertical: 20.sp),
                                                          child: GentleTouchShopTab(
                                                            title: entry.key.toUpperCase(),
                                                            showTab: currentSelectedEntry == entry.key,
                                                            onTap: () => setState(() => currentSelectedEntry = entry.key),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 60.sp),
                                            Expanded(
                                              flex: 3,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: (currentSelectedEntry == null) ? _salonProfileProvider.allProducts.length : _salonProfileProvider.tabs[currentSelectedEntry]?.length,
                                                physics: const ClampingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  // ALL
                                                  if (currentSelectedEntry == null) {
                                                    final ProductModel product = _salonProfileProvider.allProducts[index];
                                                    return GentleTouchShopCard(product: product);
                                                  }
                                                  // OTHER TABS
                                                  else {
                                                    final ProductModel product = _salonProfileProvider.tabs[currentSelectedEntry]![index];
                                                    return GentleTouchShopCard(product: product);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: 15.sp),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.end,
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     PrevAndNextButtons(
                                      //       backOnTap: () {},
                                      //       forwardOnTap: () {},
                                      //       leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                      //       rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Text(
                                      (AppLocalizations.of(context)?.noItemsAvailable ?? 'No items available for sale').toUpperCase(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),

                  // ** TEAM ** //
                  if (displaySettings?.showTeam == true) SizedBox.fromSize(size: Size.zero, key: controller.team),
                  if (displaySettings?.showTeam == true)
                    if (!_salonProfileProvider.isSingleMaster)
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
                            right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
                            top: DeviceConstraints.getResponsiveSize(context, 40.h, 80.h, 100.h),
                            bottom: DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (AppLocalizations.of(context)?.team ?? 'Team').toUpperCase(),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                                ),
                              ),
                              const Space(factor: 2),
                              Center(
                                child: SizedBox(
                                  // height: size.height * 0.4, // DeviceConstraints.getResponsiveSize(context, 230.h, 230.h, 210.h),
                                  height: 460.h,

                                  child: ScrollablePositionedList.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _createAppointmentProvider.salonMasters.length,
                                    itemBuilder: (context, index) {
                                      // Get All Salon Masters
                                      List<MasterModel> _filteredMasters = _createAppointmentProvider.salonMasters;

                                      if (_filteredMasters.isNotEmpty) {
                                        return GentleTouchTeamMember(
                                          name: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                                          masterTitle: _filteredMasters[index].title ?? '',

                                          // services: masterCategories,
                                          image: _filteredMasters[index].profilePicUrl,
                                          master: _filteredMasters[index],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                    scrollDirection: Axis.horizontal,
                                    itemScrollController: itemScrollController,
                                    itemPositionsListener: itemPositionsListener,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.sp),
                              Align(
                                alignment: Alignment.centerRight,
                                child: PrevAndNextButtons(
                                  backOnTap: isTab
                                      ? () {
                                          if (tabInitial < 3) return;
                                          setState(() {
                                            tabInitial -= 3;
                                          });

                                          itemScrollController.jumpTo(index: tabInitial);

                                          // => controller!.previousPage()
                                        }
                                      : () {
                                          if (portraitInitial < 1) return;
                                          setState(() {
                                            portraitInitial -= 1;
                                          });

                                          itemScrollController.jumpTo(index: portraitInitial);
                                        },
                                  forwardOnTap: isTab
                                      ? () {
                                          itemScrollController.jumpTo(index: tabInitial);

                                          setState(() {
                                            tabInitial += 3;
                                          });
                                          //  => controller!.nextPage()
                                        }
                                      : () {
                                          itemScrollController.jumpTo(index: portraitInitial);
                                          setState(() {
                                            portraitInitial += 1;
                                          });
                                        },
                                  leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                  rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                  // ** REVIEWS ** //
                  if (displaySettings?.reviews.showReviews == true) SizedBox.fromSize(size: Size.zero, key: controller.reviews),
                  if (displaySettings?.reviews.showReviews == true)
                    Container(
                      decoration: BoxDecoration(color: theme.colorScheme.secondary.withOpacity(0.5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 60.h, bottom: 80.h),
                        child: (_salonProfileProvider.salonReviews.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (AppLocalizations.of(context)?.reviews ?? 'Reviews').toUpperCase(),
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                                    ),
                                  ),
                                  // SizedBox(height: 10.sp),
                                  SizedBox(
                                    height: 280.h,
                                    width: double.infinity,
                                    child: CarouselSlider(
                                      carouselController: _reviewController,
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        autoPlay: (_salonProfileProvider.salonReviews.length < 2) ? false : true,
                                        onPageChanged: (index, reason) {},
                                      ),
                                      items: _salonProfileProvider.salonReviews
                                          .map(
                                            (item) => GentleTouchReviewCard(review: item),
                                          )
                                          .toList(),
                                    ),
                                  ),

                                  // SizedBox(height: 20.sp),

                                  PrevAndNextButtons(
                                    backOnTap: () => _reviewController.previousPage(),
                                    forwardOnTap: () => _reviewController.nextPage(),
                                    leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                    rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    (AppLocalizations.of(context)?.noReviews ?? 'No reviews yet').toUpperCase(),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),

                  // ** WRITE TO US ** //
                  if (displaySettings?.showRequestForm == true) SizedBox.fromSize(size: Size.zero, key: controller.writeToUs),
                  if (displaySettings?.showRequestForm == true)
                    Padding(
                      padding: EdgeInsets.only(left: 40.w),
                      child: SizedBox(
                        height: 650.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 50.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      themeType != ThemeType.VintageCraft ? (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toUpperCase() : (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toTitleCase(),
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.displayMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 50.sp),
                                      ),
                                    ),
                                    SizedBox(height: 5.sp),
                                    Text(
                                      AppLocalizations.of(context)?.writeToUsTitleDesc ?? 'Write to us and we will get back to you as soon as possible',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 30.sp),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 80.h,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),
                                                  style: theme.textTheme.bodyLarge?.copyWith(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    // fontFamily: 'Inter-Light',
                                                  ),
                                                ),
                                                SizedBox(height: 8.sp),
                                                Expanded(
                                                  flex: 0,
                                                  child: Container(
                                                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                                    child: CustomTextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: _salonProfileProvider.nameController,
                                                      contentPadding: 15.sp,

                                                      hintText: (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),
                                                      // margin: const EdgeInsets.only(top: 10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30.sp),
                                        Expanded(
                                          child: SizedBox(
                                            height: 80.h,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                                                  style: theme.textTheme.bodyLarge?.copyWith(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    // fontFamily: 'Inter-Light',
                                                  ),
                                                ),
                                                SizedBox(height: 8.sp),
                                                Expanded(
                                                  flex: 0,
                                                  child: Container(
                                                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                                    child: CustomTextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: _salonProfileProvider.lastNameController,
                                                      contentPadding: 15.sp,
                                                      hintText: (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                                                      // margin: const EdgeInsets.only(top: 10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.sp),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 80.h,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),
                                                  style: theme.textTheme.bodyLarge?.copyWith(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    // fontFamily: 'Inter-Light',
                                                  ),
                                                ),
                                                SizedBox(height: 8.sp),
                                                Expanded(
                                                  flex: 0,
                                                  child: Container(
                                                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                                    child: CustomTextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: _salonProfileProvider.emailController,
                                                      contentPadding: 15.sp,
                                                      hintText: (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),

                                                      // margin: const EdgeInsets.only(top: 10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30.sp),
                                        Expanded(
                                          child: SizedBox(
                                            height: 80.h,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                                                  style: theme.textTheme.bodyLarge?.copyWith(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w600,
                                                    // fontFamily: 'Inter-Light',
                                                  ),
                                                ),
                                                SizedBox(height: 8.sp),
                                                Expanded(
                                                  flex: 0,
                                                  child: Container(
                                                    color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                                    child: CustomTextFormField(
                                                      focusNode: FocusNode(),
                                                      controller: _salonProfileProvider.phoneController,
                                                      contentPadding: 15.sp,
                                                      hintText: (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                                                      // margin: const EdgeInsets.only(top: 10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.sp),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          (AppLocalizations.of(context)?.message ?? 'Message').toTitleCase(),
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            // fontFamily: 'Inter-Light',
                                          ),
                                        ),
                                        SizedBox(height: 8.sp),
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                            child: CustomTextFormField(
                                              focusNode: FocusNode(),
                                              controller: _salonProfileProvider.requestController,
                                              contentPadding: 15.sp,
                                              hintText: (AppLocalizations.of(context)?.writeToUsTitle ?? 'Write to us').toCapitalized(),
                                              maxLines: 4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.sp),
                                    const Spacer(),
                                    _salonProfileProvider.enquiryStatus == Status.loading
                                        ? Center(
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(color: theme.colorScheme.secondary),
                                            ),
                                          )
                                        : SquareButton(
                                            height: 50,
                                            text: (AppLocalizations.of(context)?.sendMessage ?? "Send Message").toTitleCase(),
                                            onTap: () => submit(),
                                            buttonColor: theme.colorScheme.secondary,
                                            borderColor: theme.colorScheme.secondary,
                                            textColor: (themeType == ThemeType.GentleTouch || themeType == ThemeType.VintageCraft) ? const Color(0XFFFFFFFF) : Colors.black,
                                            weight: FontWeight.w500,
                                            borderRadius: 2,
                                            showSuffix: false,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 150.sp),
                            Expanded(
                              child: SizedBox(
                                height: 650.h,
                                child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                                    ? CachedImage(
                                        url: _salonProfileProvider.themeSettings!.backgroundImage!,
                                        fit: BoxFit.cover,
                                        color: themeType == ThemeType.VintageCraft ? Colors.grey[850] : null,
                                        colorBlendMode: themeType == ThemeType.VintageCraft ? BlendMode.saturation : null,
                                      )
                                    : Image.asset(
                                        themeType == ThemeType.GentleTouch ? ThemeImages.glamLightNaturalHue : ThemeImages.darkGentleTouch,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ** CONTACT ** //
                  if (displaySettings?.showContact == true) SizedBox.fromSize(size: Size.zero, key: controller.contacts),
                  if (displaySettings?.showContact == true)
                    Padding(
                      padding: EdgeInsets.only(
                        left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
                        right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
                        top: 100.h,
                        bottom: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            (AppLocalizations.of(context)?.contacts ?? 'Contacts').toUpperCase(),
                            style: theme.textTheme.displayMedium!.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 7.sp),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            padding: null,
                            child: Text(
                              AppLocalizations.of(context)?.connectWithUsDesc ?? 'Connect with us easily. Whether it\'s questions, collaborations, or just saying hello, we\'re here for you. Reach out via email, find us on social media, give us a call, or visit our address below.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 17.sp, 18.sp),
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 40.sp),
                          Padding(
                            padding: EdgeInsets.only(
                              left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 10.w),
                              right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 10.w),
                            ),
                            child: SizedBox(
                              // height: 200.h,
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                alignment: WrapAlignment.spaceBetween,
                                runAlignment: WrapAlignment.spaceBetween,
                                runSpacing: 15.sp,
                                children: [
                                  GentleTouchContactCard(
                                    icon: Icons.message,
                                    cardTitle: (AppLocalizations.of(context)?.writeToUsTitle ?? 'Write To Us').toTitleCase(),
                                    cardDesc: AppLocalizations.of(context)?.startConversation1 ?? 'Start a conversations via email',
                                    cardValue: chosenSalon.email,
                                    onValueTap: () {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: chosenSalon.email,
                                        queryParameters: {'subject': 'Contact'},
                                      );
                                      launchUrl(emailLaunchUri);
                                    },
                                  ),
                                  GentleTouchContactCard(
                                    icon: Icons.call,
                                    cardTitle: AppLocalizations.of(context)?.callUs ?? 'Call Us',
                                    cardDesc: AppLocalizations.of(context)?.callUsDesc ?? 'Today from 10 am to 7 pm',
                                    cardValue: chosenSalon.phoneNumber,
                                    onValueTap: () {
                                      Utils().launchCaller(chosenSalon.phoneNumber.replaceAll("-", ""));
                                    },
                                  ),
                                  GentleTouchContactCard(
                                    isAddress: true,
                                    icon: Icons.location_pin,
                                    cardTitle: AppLocalizations.of(context)?.visitUs ?? 'Visit Us',
                                    cardDesc: chosenSalon.address,
                                    cardValue: (AppLocalizations.of(context)?.viewOnMap ?? 'View On The Map').toTitleCase(),
                                    onValueTap: () async {
                                      Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(chosenSalon.address)}');

                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        showToast(AppLocalizations.of(context)?.couldNotLaunch ?? "Could not launch");
                                      }
                                    },
                                  ),
                                  GentleTouchContactCard(
                                    isSocial: true,
                                    svg: ThemeIcons.socialContact,
                                    isSvg: true,
                                    cardTitle: AppLocalizations.of(context)?.socialMedia ?? 'Social Media',
                                    cardDesc: AppLocalizations.of(context)?.discoverMoreOnSocial ?? 'Discover more on social',
                                    cardValue: '',
                                    salon: chosenSalon,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 50.sp),
                          SizedBox(
                            height: 500.h,
                            width: double.infinity,
                            child: GoogleMaps(salonModel: chosenSalon),
                          ),
                        ],
                      ),
                    ),

                  // ** BOTTOM ** //
                  Padding(
                    padding: EdgeInsets.only(top: 100.sp, bottom: 30.sp),
                    child: const LandingBottom(),
                  ),
                ],
              )
            : GentleTouchMasterView(
                masters: _createAppointmentProvider.salonMasters,
                initialIndex: _salonProfileProvider.showMasterAtIndex,
              ),
      ),
    );
  }

  List<Map<String, String>> getFeaturesList(String locale) {
    switch (locale) {
      case 'uk':
        return ukSalonFeatures;
      case 'es':
        return esSalonFeatures;
      case 'fr':
        return frSalonFeatures;
      case 'pt':
        return ptSalonFeatures;
      case 'ro':
        return roSalonFeatures;
      case 'ar':
        return arSalonFeatures;

      default:
        return salonFeatures;
    }
  }
}

class LandingBottom extends ConsumerWidget {
  const LandingBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    return SizedBox(
      width: double.infinity,
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
          padding: EdgeInsets.only(right: isLast ? 0 : 20.w),
          child: Text(
            title,
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 15.sp,
              color: themeType == ThemeType.GentleTouch ? const Color(0XFF0D0D0E) : Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
