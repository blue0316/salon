import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_services.dart';
import 'package:bbblient/src/views/themes/glam_one/views/header.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'salon_all_works.dart';
import 'salon_masters.dart';
import 'widgets/header.dart';

class DefaultLandingTheme extends ConsumerStatefulWidget {
  const DefaultLandingTheme({Key? key}) : super(key: key);

  @override
  ConsumerState<DefaultLandingTheme> createState() => _DefaultLandingThemeState();
}

class _DefaultLandingThemeState extends ConsumerState<DefaultLandingTheme> {
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
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
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
                child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                    ? CachedImage(
                        url: _salonProfileProvider.themeSettings!.backgroundImage!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        AppIcons.photoSlider,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),

                    // physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Header(salonModel: _salonProfileProvider.chosenSalon),
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
                                              setState(() {
                                                _pageController.jumpToPage(index + 1);
                                                _activeTab = (index + 1);
                                              });
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
                                                color: _activeTab == (index + 1) ? theme.primaryColor : unselectedTabColor(theme, isLightTheme),
                                                fontWeight: _activeTab == (index + 1) ? FontWeight.w600 : FontWeight.w400,
                                                decoration: _activeTab == (index + 1) ? TextDecoration.underline : null,
                                                letterSpacing: 0,
                                                fontFamily: "Inter",
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
                                SizedBox(
                                  // color: Colors.brown,
                                  height: MediaQuery.of(context).size.height * 0.77,
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
                                                      fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 35.sp, 40.sp),
                                                      color: Colors.white,
                                                      fontFamily: "Montserrat",
                                                      letterSpacing: 0.5,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Space(factor: DeviceConstraints.getResponsiveSize(context, 3, 4, 4)),
                                              LandingButton(
                                                color: const Color(0XFFBA681E),
                                                height: 45.sp,
                                                width: 250.sp,
                                                borderRadius: 60.sp,
                                                label: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toUpperCase(),
                                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                                fontWeight: FontWeight.w500,
                                                textColor: Colors.white,
                                              ),
                                              Space(factor: DeviceConstraints.getResponsiveSize(context, 5, 5, 5)),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Wrap(
                                                  spacing: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 10.w),
                                                  runSpacing: DeviceConstraints.getResponsiveSize(context, 10.h, 20.w, 10.w),
                                                  direction: Axis.horizontal,
                                                  alignment: WrapAlignment.center,
                                                  children: _createAppointmentProvider.categoriesAvailable
                                                      .map(
                                                        (item) => GlamOneWrap(
                                                          text: item.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.translations['en'],
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
                                ),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

class LandingBottom extends ConsumerWidget {
  const LandingBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SizedBox(
      // height: 120.sp,
      width: double.infinity,
      // color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 1.5.sp,
            decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [Color.fromARGB(43, 74, 74, 74), Color(0XFF4A4A4A), Color.fromARGB(43, 74, 74, 74)],
              ),
            ),
          ),
          SizedBox(height: 18.sp),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(context, 70.sp, 30.sp, 20.sp),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms & Conditions',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                    fontWeight: FontWeight.w400,
                    color: const Color(0XFF908D8D),
                  ),
                  textAlign: TextAlign.center,
                ),
                // const Spacer(),
                Text(
                  'Privacy Policy',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                    fontWeight: FontWeight.w400,
                    color: const Color(0XFF908D8D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.sp),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 30.w, 60.w),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '© 2023 Glamiris. ',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                    fontWeight: FontWeight.w400,
                    color: const Color(0XFF908D8D),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 2.sp),
                Text(
                  'Design by GlamIris',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 16.sp),
                    fontWeight: FontWeight.w600,
                    color: const Color(0XFFBA681E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}

Color unselectedTabColor(ThemeData theme, bool isLightTheme) {
  switch (isLightTheme) {
    case false:
      return Colors.white;

    default:
      return theme.primaryColor;
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
