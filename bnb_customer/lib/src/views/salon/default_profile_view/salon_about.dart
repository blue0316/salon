import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final bool isLandscape = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.landScape);
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    BnbProvider _bnbProvider = ref.read(bnbProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

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
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: isPortrait ? null : 250.h,
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
                                      Container(
                                        color: theme.canvasColor,
                                        height: DeviceConstraints.getResponsiveSize(context, 100.h, 100.h, 110.h),
                                        width: DeviceConstraints.getResponsiveSize(context, 100.h, 100.h, 110.h),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
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
                                              const SizedBox(height: 10),
                                              Text(
                                                _bnbProvider.locale == const Locale('en') ? (getFeature(s) ?? '') : (getFeatureUk(s) ?? ''),
                                                style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: DeviceConstraints.getResponsiveSize(context, 10.sp, 10.sp, 12.sp),
                                                  height: 0,
                                                  color: isLightTheme ? Colors.black : Colors.white,
                                                ),
                                                maxLines: 3,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                ],
                              ),
                            ),
                            if ((isPortrait && widget.salonModel.additionalFeatures.length > 3) || (isLandscape && widget.salonModel.additionalFeatures.length > 4) || (isTab && widget.salonModel.additionalFeatures.length > 6))
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
                                      color: theme.canvasColor,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: DeviceConstraints.getResponsiveSize(context, 20, 20, 30),
                  ),
                  Expanded(
                    flex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => print(widget.salonModel.timeFormat),
                          child: Text(
                            (AppLocalizations.of(context)?.socialMedia ?? "Social media").toUpperCase(),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: isLightTheme ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.salonModel.links?.website != '')
                              SocialLink(
                                icon: isLightTheme ? AppIcons.linkGlobe : AppIcons.linkGlobeDark,
                                type: 'website',
                                socialUrl: widget.salonModel.links?.website,
                              ),
                            if (widget.salonModel.links?.instagram != '')
                              SocialLink(
                                icon: isLightTheme ? AppIcons.linkInsta : AppIcons.linkInstaDark2,
                                type: 'insta',
                                socialUrl: widget.salonModel.links?.instagram,
                              ),
                            if (widget.salonModel.links?.tiktok != '')
                              SocialLink(
                                icon: isLightTheme ? AppIcons.linkTikTok : AppIcons.linkTikTokDark,
                                type: 'tiktok',
                                socialUrl: widget.salonModel.links?.tiktok,
                              ),
                            if (widget.salonModel.links?.facebook != '')
                              SocialLink(
                                icon: isLightTheme ? AppIcons.linkFacebook : AppIcons.linkFacebookDark,
                                type: 'facebook',
                                socialUrl: widget.salonModel.links?.facebook,
                              ),
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
  final String type;
  final String? socialUrl;

  const SocialLink({
    Key? key,
    required this.icon,
    required this.type,
    required this.socialUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Expanded(
      flex: 0,
      child: GestureDetector(
        onTap: () async {
          Uri uri = Uri.parse(socialLinks(type, socialUrl ?? ''));

          debugPrint("launching Url: $uri");

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            showToast("No social page for this profile");
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Container(
            height: 50.h,
            width: 50.h,
            color: theme.canvasColor,
            child: Center(
              child: (icon == AppIcons.linkGlobeDark)
                  ? FaIcon(
                      FontAwesomeIcons.globe,
                      size: 30.h,
                      color: theme.primaryColor,
                    )
                  : (icon == AppIcons.linkInstaDark2)
                      ? FaIcon(
                          FontAwesomeIcons.instagram,
                          size: 30.h,
                          color: theme.primaryColor,
                        )
                      : SvgPicture.asset(
                          icon,
                          height: 30.h,
                          color: isLightTheme ? null : theme.primaryColor,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
