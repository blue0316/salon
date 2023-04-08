import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_about.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_services.dart';
import 'package:bbblient/src/views/salon/widgets/floating_button_booking.dart';
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
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.lightTheme);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
            image: const AssetImage(AppIcons.photoSlider),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Header(salonModel: _salonProfileProvider.chosenSalon),
                        Space(
                          factor: DeviceConstraints.getResponsiveSize(context, 2, 3, 5),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: DeviceConstraints.getResponsiveSize(context, 10.w, 50.w, 90.w),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: DeviceConstraints.getResponsiveSize(context, 0, 0, 25.w),
                                ),
                                child: Container(
                                  height: 75.h,
                                  width: double.infinity,
                                  color: theme.colorScheme.background,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: DeviceConstraints.getResponsiveSize(context, 5.w, 5.w, 10.w),
                                    vertical: 20.h,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 30.h,
                                      width: double.infinity,
                                      child: Center(
                                        child: ListView.separated(
                                          itemCount: (_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon) ? saloonDetailsTitles.length : masterDetailsTitles.length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          controller: _scrollController,
                                          separatorBuilder: (_, index) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Container(
                                              width: 3,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                color: isLightTheme ? Colors.white : const Color(0XFFEDEDED),
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
                                                      _pageController.jumpToPage(index);
                                                      _activeTab = index;
                                                    });
                                                  },
                                                  child: Text(
                                                    ((_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon)
                                                            ? (AppLocalizations.of(context)?.localeName == 'uk')
                                                                ? saloonDetailsTitlesUK[index]
                                                                : saloonDetailsTitles[index]
                                                            : (AppLocalizations.of(context)?.localeName == 'uk')
                                                                ? masterDetailsTitlesUk[index]
                                                                : masterDetailsTitles[index])
                                                        .toUpperCase(),
                                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 18.sp, 20.sp),
                                                          color: _activeTab == index ? theme.primaryColor : unselectedTabColor(theme, isLightTheme),
                                                          fontWeight: _activeTab == index ? FontWeight.w700 : FontWeight.w500,
                                                          decoration: !isLightTheme
                                                              ? null
                                                              : _activeTab == index
                                                                  ? TextDecoration.underline
                                                                  : null,
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
                                ),
                              ),
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
                                  const SalonServices(),
                                  SalonAbout(
                                    salonModel: _salonProfileProvider.chosenSalon,
                                  ),
                                  if (_salonProfileProvider.chosenSalon.ownerType == OwnerType.salon)
                                    SalonMasters(
                                      salonModel: _salonProfileProvider.chosenSalon,
                                    ),
                                  SalonAllWorks(
                                    salonModel: _salonProfileProvider.chosenSalon,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: FloatingBar(),
            ),
          ],
        ),
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
