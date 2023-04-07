import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'about.dart';
import 'salon_reviews.dart';
import 'widgets/section_spacer.dart';

class SalonAbout extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAbout({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonAbout> createState() => _SalonAboutState();
}

class _SalonAboutState extends ConsumerState<SalonAbout> {
  getFeature(String s) {
    debugPrint(widget.salonModel.ownerType);
    if (widget.salonModel.ownerType == 'singleMaster') {
      for (Map registeredFeatures in masterFeatures) {
        if (registeredFeatures.containsKey(s)) {
          return registeredFeatures[s];
        }
      }
    }

    if (widget.salonModel.ownerType == 'salon') {
      for (Map registeredFeatures in salonFeatures) {
        if (registeredFeatures.containsKey(s)) {
          return registeredFeatures[s];
        }
      }
    }
  }

  getFeatureUk(String s) {
    debugPrint(widget.salonModel.ownerType);
    for (Map registeredFeatures in ukMasterFeatures) {
      if (registeredFeatures.containsKey(s)) {
        return registeredFeatures[s];
      }
    }

    if (widget.salonModel.ownerType == 'salon') {
      for (Map registeredFeatures in ukSalonFeatures) {
        if (registeredFeatures.containsKey(s)) {
          return registeredFeatures[s];
        }
      }
    }
  }

  int maxLinesForAdditionalFeature = 1;
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    BnbProvider _bnbProvider = ref.read(bnbProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.lightTheme);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SectionSpacer(
            title: (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[1] : saloonDetailsTitles[1],
          ),
          Container(
            // height: 1000.h,
            width: double.infinity,
            color: theme.colorScheme.background.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: isPortrait ? null : 200.h,
                      child: isPortrait
                          ? PortraitAboutHeader(
                              salonModel: widget.salonModel,
                            )
                          : LandscapeAboutHeader(
                              salonModel: widget.salonModel,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: DeviceConstraints.getResponsiveSize(context, 10, 10, 30),
                  ),
                  if (widget.salonModel.additionalFeatures.isNotEmpty)
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        // height: 200.h,
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ExtendedWrap(
                                spacing: 10,
                                maxLines: maxLinesForAdditionalFeature,
                                runSpacing: 10.h,
                                children: [
                                  for (String s in widget.salonModel.additionalFeatures) ...[
                                    if (AppIcons.getIconFromFacilityString(feature: s) != null) ...[
                                      if (_bnbProvider.locale == const Locale('en')) ...[
                                        Container(
                                          color: theme.colorScheme.background,
                                          height: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                          width: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () => showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return ShowAdditionaFeatureInfo(_bnbProvider, s);
                                                  },
                                                ),
                                                child: SvgPicture.asset(
                                                  AppIcons.getIconFromFacilityString(feature: s)!,
                                                  height: DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 30.h),
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                getFeature(s) ?? '',
                                                style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 13.sp,
                                                  height: 0,
                                                  color: isLightTheme ? Colors.black : Colors.white,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      if (_bnbProvider.locale == const Locale('uk')) ...[
                                        Container(
                                          color: theme.colorScheme.background,
                                          height: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                          width: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () => showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return ShowAdditionaFeatureInfo(_bnbProvider, s);
                                                  },
                                                ),
                                                child: SvgPicture.asset(
                                                  AppIcons.getIconFromFacilityString(feature: s)!,
                                                  height: DeviceConstraints.getResponsiveSize(context, 50.h, 50.h, 60.h),
                                                  color: theme.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                getFeatureUk(s) ?? '',
                                                style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 13.sp,
                                                  height: 0,
                                                  color: isLightTheme ? Colors.black : Colors.white,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                    ]
                                  ],
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (maxLinesForAdditionalFeature != widget.salonModel.additionalFeatures.length) {
                                    setState(() {
                                      maxLinesForAdditionalFeature = widget.salonModel.additionalFeatures.length;
                                    });
                                  } else {
                                    setState(() {
                                      maxLinesForAdditionalFeature = 1;
                                    });
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.background,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: theme.primaryColor,
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: DeviceConstraints.getResponsiveSize(context, 15, 15, 30),
                  ),
                  Expanded(
                    flex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          (AppLocalizations.of(context)?.socialMedia ?? "Social media").toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: isLightTheme ? Colors.black : Colors.white,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            SocialLink(icon: AppIcons.linkGlobe),
                            SocialLink(icon: AppIcons.linkInsta),
                            SocialLink(icon: AppIcons.linkTikTok),
                            SocialLink(icon: AppIcons.linkFacebook),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Space(factor: 2),
                  ReviewSection(
                    reviews: _salonProfileProvider.salonReviews,
                    avgRating: widget.salonModel.avgRating,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialLink extends ConsumerWidget {
  final String icon;

  const SocialLink({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Expanded(
      flex: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          height: 50.h,
          width: 50.h,
          color: theme.colorScheme.background,
          child: Center(
            child: SvgPicture.asset(
              icon,
              height: 30.h,
              color: theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
