import 'dart:ui';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_services.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/landing_bottom.dart';
import 'package:bbblient/src/views/themes/glam_one/views/header.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'salon_all_works.dart';
import 'salon_masters.dart';
import 'widgets/header.dart';

class DefaultLandingTheme extends ConsumerStatefulWidget {
  final bool showBooking;
  const DefaultLandingTheme({Key? key, this.showBooking = false}) : super(key: key);

  @override
  ConsumerState<DefaultLandingTheme> createState() => _DefaultLandingThemeState();
}

class _DefaultLandingThemeState extends ConsumerState<DefaultLandingTheme> {
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerSmooth = ScrollController();
  final PageController _pageController = PageController();

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
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    return Scaffold(
      body: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.75), BlendMode.darken),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                      ? CachedImage(
                          url: _salonProfileProvider.themeSettings!.backgroundImage!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(AppIcons.photoSlider, fit: BoxFit.cover),
                ),
              ),
            ),

            WebSmoothScroll(
              controller: _scrollControllerSmooth,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  Header(
                    salonModel: _salonProfileProvider.chosenSalon,
                    goToLanding: () {
                      _pageController.jumpToPage(0);
                      _activeTab = (0);
                    },
                  ),
                  Space(
                    factor: DeviceConstraints.getResponsiveSize(context, 2, 3, 5),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
                        ),
                        child: Container(
                          height: 65.h,
                          // width: double.infinity,
                          color: theme.canvasColor,

                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35.sp, vertical: 20.sp),
                            child: ListView.separated(
                              itemCount: (!isSingleMaster) ? saloonDetailsTitles.length : masterDetailsTitles.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              controller: _scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, index) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 15.w, 15.w),
                                ),
                                child: Container(
                                  width: 1.5,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400], // isLightTheme ? Colors.white : Colors.grey,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                              itemBuilder: (_, index) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        {
                                          setState(() {
                                            _pageController.jumpToPage(_salonProfileProvider.hasLandingPage ? index + 1 : index);
                                            _activeTab = (_salonProfileProvider.hasLandingPage ? index + 1 : index);
                                          });
                                        }
                                      },
                                      child: Text(
                                        ((!isSingleMaster)
                                                ? salonTitles(
                                                    AppLocalizations.of(context)?.localeName ?? 'en',
                                                  )[index]
                                                : masterTitles(
                                                    AppLocalizations.of(context)?.localeName ?? 'en',
                                                  )[index])
                                            // (AppLocalizations.of(context)?.localeName == 'uk')
                                            //     ? saloonDetailsTitlesUK[index]
                                            //     : saloonDetailsTitles[index]
                                            // : (AppLocalizations.of(context)?.localeName == 'uk')
                                            //     ? masterDetailsTitlesUk[index]
                                            //     : masterDetailsTitles[index])
                                            .toUpperCase(),
                                        style: theme.textTheme.displayLarge!.copyWith(
                                          fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 16.sp, 18.sp),
                                          color: _activeTab == (_salonProfileProvider.hasLandingPage ? index + 1 : index) ? theme.primaryColor : unselectedTabColor(theme, isLightTheme),
                                          fontWeight: _activeTab == (_salonProfileProvider.hasLandingPage ? index + 1 : index) ? FontWeight.w600 : FontWeight.w400,
                                          decoration: _activeTab == (_salonProfileProvider.hasLandingPage ? index + 1 : index) ? TextDecoration.underline : null,
                                          letterSpacing: 0,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Space(
                      //   factor: DeviceConstraints.getResponsiveSize(context, 2, 3, 5),
                      // ),
                      ExpandablePageView(
                        padEnds: false,
                        key: const ValueKey("exp"),
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (i) {
                          setState(() {
                            _activeTab = i;
                          });
                        },
                        children: [
                          if (_salonProfileProvider.hasLandingPage) const LandingView(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
                            ),
                            child: const SalonServices(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
                            ),
                            child: SalonAbout(
                              salonModel: _salonProfileProvider.chosenSalon,
                            ),
                          ),
                          if (!isSingleMaster)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
                              ),
                              child: SalonMasters(
                                salonModel: _salonProfileProvider.chosenSalon,
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
                            ),
                            child: SalonAllWorks(
                              salonModel: _salonProfileProvider.chosenSalon,
                            ),
                          ),
                        ],
                      ),
                      const Space(factor: 2),
                    ],
                  ),
                ],
              ),
            ),

            // const Align(
            //   alignment: Alignment.bottomCenter,
            //   child: FloatingBar(),
            // ),
          ],
        ),
      ),
    );
  }
}

class LandingView extends ConsumerWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SizedBox(
      // color: Colors.brown,
      height: DeviceConstraints.getResponsiveSize(
        context,
        MediaQuery.of(context).size.height * 0.77,
        MediaQuery.of(context).size.height * 0.67,
        MediaQuery.of(context).size.height * 0.7,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Space(factor: DeviceConstraints.getResponsiveSize(context, 4, 5, 5)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
            ),
            child: SizedBox(
              // height: 200.sp,
              width: double.infinity,
              // color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _salonProfileProvider.chosenSalon.salonName.toUpperCase(),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 55.sp, 60.sp),
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Space(factor: DeviceConstraints.getResponsiveSize(context, 3, 4, 4)),
                  LandingButton(
                    color: theme.primaryColor,
                    height: 45.sp,
                    width: 250.sp,
                    borderRadius: 60.sp,
                    label: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
                    fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                    fontWeight: FontWeight.w500,
                    textColor: isLightTheme ? Colors.white : Colors.black,
                    onTap: () => const BookingDialogWidget222().show(context),
                  ),
                  Space(factor: DeviceConstraints.getResponsiveSize(context, 5, 5, 5)),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 10.w),
                      runSpacing: DeviceConstraints.getResponsiveSize(context, 10.h, 20.w, 10.w),
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: _salonProfileProvider.chosenSalon.specializations!
                          .map(
                            (item) => GlamOneWrap(
                              text: item,
                              vSpacing: 11.sp,
                              color: const Color(0XFF020203).withOpacity(0.4),
                              showBorder: false,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const LandingBottom(),
        ],
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
      child: isTab ? const LandscapeLandingBottom() : const PortraitLandingBottom(),
    );
  }
}

Color unselectedTabColor(ThemeData theme, bool isLightTheme) {
  switch (isLightTheme) {
    case false:
      return Colors.white;

    default:
      return Colors.black;
  }
}

List<String> salonTitles(String locale) {
  switch (locale) {
    case 'es':
      return saloonDetailsTitlesES;
    case 'pt':
      return saloonDetailsTitlesPT;
    case 'ro':
      return saloonDetailsTitlesRO;
    case 'uk':
      return saloonDetailsTitlesUK;

    default:
      return saloonDetailsTitles;
  }
}

List<String> masterTitles(String locale) {
  switch (locale) {
    case 'es':
      return masterDetailsTitlesES;
    case 'pt':
      return masterDetailsTitlesPT;
    case 'ro':
      return masterDetailsTitlesRO;
    case 'uk':
      return masterDetailsTitlesUK;

    default:
      return masterDetailsTitles;
  }
}


//  FirebaseFirestore.instance.collection('salons').doc('wIivFKnshpgS2HjC6CWE').update(
//     {
//       'specializations': [
//         'Hair styling',
//         'Hair cut',
//         'Hair Coloring',
//         'Hair Care & Recovery',
//         'Hair Extension',
//       ],
//     },
//   );