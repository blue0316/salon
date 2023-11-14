import 'dart:async';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/status.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/themes/components/contacts/gentle_touch_contact.dart';
import 'package:bbblient/src/views/themes/components/contacts/widgets/contact_maps.dart';
import 'package:bbblient/src/views/themes/components/header_image.dart';
import 'package:bbblient/src/views/themes/components/reviews/gentle_touch_review.dart';
import 'package:bbblient/src/views/themes/components/services/widgets/widgets.dart';
import 'package:bbblient/src/views/themes/components/shop/gentle_touch_shop.dart';
import 'package:bbblient/src/views/themes/components/team/team_member_view.dart';
import 'package:bbblient/src/views/themes/components/widgets/multiple_states_button.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/header_height.dart';
import 'package:bbblient/src/views/themes/glam_one/views/header.dart';
import 'package:bbblient/src/views/themes/glam_one/views/profile/widgets/custom_text_form_field.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/services/salon_services.dart';
import 'package:bbblient/src/views/themes/components/team/gentle_touch_team.dart';
import 'package:bbblient/src/views/themes/utils/unique_landing_bottom.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class GentleTouchTestingPhone extends ConsumerStatefulWidget {
  const GentleTouchTestingPhone({super.key});

  @override
  ConsumerState<GentleTouchTestingPhone> createState() => _GentleTouchTestingPhoneState();
}

class _GentleTouchTestingPhoneState extends ConsumerState<GentleTouchTestingPhone> {
  bool isShowMenu = false;

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
  int _current = 0;

  // ** SPONSORS ** //
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  bool scroll = false;
  int speedFactor = 20;

  _scroll() {
    if (_scrollController.hasClients) {
      double maxExtent = _scrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _scrollController.offset;
      double durationDouble = distanceDifference / speedFactor;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
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
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset,
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
      }
    }
  }

  // ** WORKS ** //
  final CarouselController _worksController = CarouselController();

  // ** SERVICES ** //
  TabController? serviceTabController;
  int _selectedServiceTabbar = 0;

  // ** SHOP ** //
  final CarouselController _shopController = CarouselController();
  int _shopCurrent = 0;

  String dropdownvalue = 'All';

  bool load = false;

  // ** TEAM ** //
  final CarouselController _teamController = CarouselController();
  int _teamCurrent = 0;

  // ** REVIEWS ** //
  final CarouselController _reviewController = CarouselController();
  int _reviewCurrent = 0;

  // ** WRITE TO US ** //
  final FocusNode _focusNode = FocusNode();

  // ** CONTACT ** //

  @override
  void initState() {
    super.initState();

    // ** SPONSORS ** //
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      _toggleScrolling();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();

    _scrollController.dispose();
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
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isLandscape = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.landScape);

    void submit() {
      _salonProfileProvider.sendEnquiryToSalon(context, salonId: chosenSalon.salonId);
    }

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
              color: theme.colorScheme.background,
              child: _salonProfileProvider.currentWidgetGentle,
            )
          : !(_salonProfileProvider.showMasterView)
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
                                  // ThemeAppBar(salonModel: chosenSalon),
                                  SizedBox(height: 80.h),
                                  ThemeHeader(salonModel: chosenSalon),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ** TAGS ** //
                    if (displaySettings?.showFeatures == true)
                      if (chosenSalon.additionalFeatures.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
                            right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
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
                                      width: (MediaQuery.of(context).size.width - 20.w),
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
                                            width: null,
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
                        padding: const EdgeInsets.only(left: 0, top: 40, bottom: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                                  right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                                ),
                                child: Text(
                                  isSingleMaster ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me') : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toUpperCase(),
                                  style: theme.textTheme.displayMedium?.copyWith(
                                    fontSize: 50.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w)),
                                child: Container(
                                  height: 350.h,
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
                                                        _current = index;
                                                      });
                                                    },
                                                  ),
                                                  items: chosenSalon.profilePics
                                                      .map(
                                                        (item) => CachedImage(
                                                          url: item,
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
                                                        color: _current == entry.key
                                                            ? Colors.white
                                                            : const Color(0XFF8A8A8A).withOpacity(
                                                                _current == entry.key ? 0.9 : 0.4,
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
                                              fontSize: DeviceConstraints.getResponsiveSize(context, 80.sp, 80.sp, 100.sp),
                                              color: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.only(
                                left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                                right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    (chosenSalon.description != '') ? chosenSalon.description : 'No description yet',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.primaryColor,
                                      fontSize: 17.sp,
                                    ),
                                    maxLines: DeviceConstraints.getResponsiveSize(context, 20, 7, 7).toInt(),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MultipleStatesButton(
                                        borderColor: Colors.transparent,
                                        buttonColor: theme.colorScheme.secondary,
                                        text: (AppLocalizations.of(context)?.bookNow ?? "Book Now"),
                                        weight: FontWeight.normal,
                                        textColor: themeType == ThemeType.GentleTouch ? const Color(0XFFFFFFFF) : Colors.black,
                                        width: DeviceConstraints.getResponsiveSize(context, 180.sp, 140.sp, 180.sp),
                                        height: DeviceConstraints.getResponsiveSize(context, 47.h, 55.h, 47.h),
                                        showSuffix: false,
                                        borderRadius: 3,
                                        isGradient: _salonProfileProvider.hasThemeGradient,
                                        onTap: () => const BookingDialogWidget222().show(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                                            controller: _scrollController,
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
                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: theme.dividerColor),
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
                    if (displaySettings?.showPhotosOfWork == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toUpperCase(),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 500.h,
                            width: double.infinity,
                            child: SizedBox(
                              width: double.infinity,
                              child: CarouselSlider(
                                carouselController: _worksController,
                                options: CarouselOptions(
                                  height: 500.h,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                ),
                                items: chosenSalon.photosOfWorks!
                                    .map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                                              ),
                                            ),
                                            // color: backgroundColor ?? Colors.blue,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: item.description != null && item.description!.isNotEmpty
                                                          ? Border.all(
                                                              color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                                                            )
                                                          : null,
                                                    ),
                                                    child: CachedImage(
                                                      url: item.image ?? '',
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width - 40.w,
                                                    ),
                                                  ),
                                                ),
                                                if (item.description != null && item.description!.isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                                                    child: Text(
                                                      item.description ?? '',
                                                      style: theme.textTheme.bodyLarge?.copyWith(
                                                        color: theme.primaryColorDark,
                                                        fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.sp),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: chosenSalon.photosOfWorks!.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _worksController.animateToPage(entry.key),
                                child: Container(
                                  width: _current == entry.key ? 7 : 4,
                                  height: _current == entry.key ? 7 : 4,
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == entry.key
                                        ? themeType == ThemeType.GentleTouch
                                            ? Colors.black
                                            : Colors.white
                                        : const Color(0XFF8A8A8A).withOpacity(
                                            _current == entry.key ? 0.9 : 0.4,
                                          ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    // ** PRICE ** //
                    if (displaySettings?.services.showServices == true) SizedBox.fromSize(size: Size.zero, key: controller.price),
                    if (displaySettings?.services.showServices == true)
                      DefaultTabController(
                        length: _createAppointmentProvider.categoriesAvailable.length,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                            right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
                            top: (themeType == ThemeType.VintageCraft) ? 30.h : DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
                            bottom: DeviceConstraints.getResponsiveSize(context, 20, 20, 10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark)
                                      ? (AppLocalizations.of(context)?.itemsOfServices ?? 'services').toUpperCase()
                                      : isSingleMaster
                                          ? (AppLocalizations.of(context)?.price ?? 'Price')
                                          : (AppLocalizations.of(context)?.ourPrice ?? 'Our Price').toUpperCase(),
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
                                                _selectedServiceTabbar = index;
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

                                            isScrollable: true,
                                            labelPadding: EdgeInsets.symmetric(
                                              horizontal: (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark || themeType == ThemeType.VintageCraft) ? 15.sp : 50,
                                            ),
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
                                          if (_selectedServiceTabbar == _createAppointmentProvider.servicesAvailable.indexOf(serviceList)) {
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
                          crossAxisAlignment: themeType == ThemeType.VintageCraft ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                          children: [
                            Text(
                              themeType == ThemeType.VintageCraft ? (AppLocalizations.of(context)?.products ?? 'Products').toTitleCase() : (AppLocalizations.of(context)?.products ?? 'Products').toUpperCase(),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                              ),
                            ),
                            _salonProfileProvider.allProducts.isNotEmpty ? SizedBox(height: 60.sp) : const SizedBox(height: 50),
                            (_salonProfileProvider.allProducts.isNotEmpty)
                                ? load
                                    ? const CircularProgressIndicator()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          DropdownButton(
                                            // Initial Value
                                            value: dropdownvalue,
                                            dropdownColor: (themeType == ThemeType.GentleTouchDark || themeType == ThemeType.VintageCraft) ? Colors.black : null,
                                            // Down Arrow Icon
                                            icon: const Icon(Icons.keyboard_arrow_down),
                                            isExpanded: true,

                                            items: [
                                              (AppLocalizations.of(context)?.all ?? 'All').toTitleCase(),
                                              ..._salonProfileProvider.tabs.keys.toList(),
                                            ].map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  style: theme.textTheme.bodyLarge?.copyWith(
                                                    // color: theme.primaryColorDark,
                                                    fontSize: 20.sp,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownvalue = newValue!;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 40.sp),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                                            child: SizedBox(
                                              height: 450.h,
                                              width: double.infinity,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: CarouselSlider(
                                                  carouselController: _shopController,
                                                  options: CarouselOptions(
                                                    height: 450.h,
                                                    autoPlay: true,
                                                    viewportFraction: 1,
                                                    onPageChanged: (index, reason) {
                                                      setState(() {
                                                        _shopCurrent = index;
                                                      });
                                                    },
                                                  ),
                                                  items: dropdownvalue == (AppLocalizations.of(context)?.all ?? 'All').toTitleCase()
                                                      ? _salonProfileProvider.allProducts
                                                          .map(
                                                            (item) => ProductPortraitItemCard(product: item),
                                                          )
                                                          .toList()
                                                      : _salonProfileProvider.tabs[dropdownvalue]!
                                                          .map(
                                                            (item) => ProductPortraitItemCard(product: item),
                                                          )
                                                          .toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.sp),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: dropdownvalue == (AppLocalizations.of(context)?.all ?? 'All').toTitleCase()
                                                ? _salonProfileProvider.allProducts.asMap().entries.map((entry) {
                                                    return GestureDetector(
                                                      onTap: () => _shopController.animateToPage(entry.key),
                                                      child: Container(
                                                        width: _shopCurrent == entry.key ? 7 : 4,
                                                        height: _shopCurrent == entry.key ? 7 : 4,
                                                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: _shopCurrent == entry.key
                                                              ? themeType == ThemeType.GentleTouch
                                                                  ? Colors.black
                                                                  : Colors.white
                                                              : const Color(0XFF8A8A8A).withOpacity(
                                                                  _shopCurrent == entry.key ? 0.9 : 0.4,
                                                                ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList()
                                                : _salonProfileProvider.tabs[dropdownvalue]!.asMap().entries.map((entry) {
                                                    return GestureDetector(
                                                      onTap: () => _shopController.animateToPage(entry.key),
                                                      child: Container(
                                                        width: _shopCurrent == entry.key ? 10 : 7,
                                                        height: _shopCurrent == entry.key ? 10 : 7,
                                                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: _shopCurrent == entry.key
                                                              ? themeType == ThemeType.GentleTouch
                                                                  ? Colors.black
                                                                  : Colors.white
                                                              : const Color(0XFF8A8A8A).withOpacity(
                                                                  _shopCurrent == entry.key ? 0.9 : 0.4,
                                                                ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                          ),
                                        ],
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
                              crossAxisAlignment: themeType != ThemeType.VintageCraft ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (AppLocalizations.of(context)?.team ?? 'Team').toTitleCase(),
                                      style: theme.textTheme.displayMedium?.copyWith(
                                        fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                const Space(factor: 2),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                                      child: SizedBox(
                                        height: 500.h,
                                        width: double.infinity,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CarouselSlider(
                                            carouselController: _teamController,
                                            options: CarouselOptions(
                                              height: 500.h,
                                              autoPlay: true,
                                              viewportFraction: 1,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _teamCurrent = index;
                                                });
                                              },
                                            ),
                                            items: _createAppointmentProvider.salonMasters
                                                .map(
                                                  (item) => Padding(
                                                    padding: const EdgeInsets.only(right: 0),
                                                    child: GentleTouchTeamMember(
                                                      name: Utils().getNameMaster(item.personalInfo),
                                                      masterTitle: item.title ?? '',
                                                      image: item.profilePicUrl,
                                                      master: item,
                                                      showDesc: true,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.sp),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: _createAppointmentProvider.salonMasters.asMap().entries.map((entry) {
                                        return GestureDetector(
                                          onTap: () => _teamController.animateToPage(entry.key),
                                          child: Container(
                                            width: _teamCurrent == entry.key ? 7 : 4,
                                            height: _teamCurrent == entry.key ? 7 : 4,
                                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _teamCurrent == entry.key
                                                  ? themeType == ThemeType.GentleTouch
                                                      ? Colors.black
                                                      : Colors.white
                                                  : const Color(0XFF8A8A8A).withOpacity(
                                                      _teamCurrent == entry.key ? 0.9 : 0.4,
                                                    ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
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
                          padding: EdgeInsets.only(
                            left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
                            right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
                            top: 60.h,
                            bottom: 80.h,
                          ),
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
                                      width: double.infinity,
                                      child: CarouselSlider(
                                        carouselController: _reviewController,
                                        options: CarouselOptions(
                                          viewportFraction: 1,
                                          autoPlay: (_salonProfileProvider.salonReviews.length < 2) ? false : true,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _reviewCurrent = index;
                                            });
                                          },
                                        ),
                                        items: _salonProfileProvider.salonReviews
                                            .map(
                                              (item) => GentleTouchReviewCard(review: item),
                                            )
                                            .toList(),
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(top: 30.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: _salonProfileProvider.salonReviews.asMap().entries.map((entry) {
                                          return GestureDetector(
                                            onTap: () => _reviewController.animateToPage(entry.key),
                                            child: Container(
                                              width: _reviewCurrent == entry.key ? 7.5 : 6,
                                              height: _reviewCurrent == entry.key ? 7.5 : 6,
                                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _reviewCurrent == entry.key
                                                    ? (themeType == ThemeType.GentleTouch)
                                                        ? Colors.black
                                                        : Colors.white.withOpacity(0.5)
                                                    : const Color(0XFF8A8A8A).withOpacity(
                                                        _reviewCurrent == entry.key ? 0.9 : 0.4,
                                                      ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
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
                        padding: EdgeInsets.only(
                          left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
                          top: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h),
                          right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (AppLocalizations.of(context)?.writeToUsTitle ?? 'write to us').toUpperCase(),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 50.sp,
                              ),
                            ),
                            SizedBox(height: 5.sp),
                            Text(
                              AppLocalizations.of(context)?.writeToUsTitleDesc ?? 'Write to us and we will get back to you as soon as possible',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30.sp),
                            SizedBox(
                              height: isLandscape ? 120.h : 80.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    (AppLocalizations.of(context)?.firstName ?? "First name").toTitleCase(),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      // fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 8.sp),
                                  Expanded(
                                    flex: 0,
                                    child: Container(
                                      color: themeType == ThemeType.GentleTouch ? const Color(0xFFF0E8DB) : const Color(0XFF1D1E20),
                                      child: CustomTextFormField(
                                        focusNode: _focusNode,
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
                            SizedBox(height: isLandscape ? 15.sp : 10.sp),
                            SizedBox(
                              height: isLandscape ? 120.h : 80.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    (AppLocalizations.of(context)?.lastName ?? "Last name").toTitleCase(),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      // fontFamily: 'Inter',
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
                            SizedBox(height: isLandscape ? 15.sp : 10.sp),
                            SizedBox(
                              height: isLandscape ? 120.h : 80.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    (AppLocalizations.of(context)?.email ?? "email").toTitleCase(),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      // fontFamily: 'Inter',
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
                            SizedBox(height: isLandscape ? 15.sp : 10.sp),
                            SizedBox(
                              height: isLandscape ? 120.h : 80.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    (AppLocalizations.of(context)?.phone ?? "phone").toTitleCase(),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      // fontFamily: 'Inter',
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
                            SizedBox(height: isLandscape ? 15.sp : 10.sp),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (AppLocalizations.of(context)?.message ?? 'Message').toTitleCase(),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
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
                            SizedBox(height: 30.sp),
                            _salonProfileProvider.enquiryStatus == Status.loading
                                ? Center(
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(color: theme.colorScheme.secondary),
                                    ),
                                  )
                                : Center(
                                    child: MultipleStatesButton(
                                      height: isLandscape ? 60.h : 50,
                                      width: MediaQuery.of(context).size.width,
                                      text: (AppLocalizations.of(context)?.sendMessage ?? "Send Message").toTitleCase(),
                                      onTap: () => submit(),
                                      buttonColor: theme.colorScheme.secondary,
                                      borderColor: theme.colorScheme.secondary,
                                      textColor: (themeType == ThemeType.GentleTouch || themeType == ThemeType.VintageCraft) ? const Color(0XFFFFFFFF) : Colors.black,
                                      weight: FontWeight.w500,
                                      borderRadius: 2,
                                      showSuffix: false,
                                      isGradient: _salonProfileProvider.hasThemeGradient,
                                    ),
                                  ),
                          ],
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
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                    const SizedBox(
                      width: double.infinity,
                      child: UniquePortraitLandingBottom(),
                    )
                  ],
                )
              : GentleTouchMasterView(
                  masters: _createAppointmentProvider.salonMasters,
                  initialIndex: _salonProfileProvider.showMasterAtIndex,
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
