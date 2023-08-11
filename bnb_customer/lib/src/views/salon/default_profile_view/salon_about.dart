import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
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
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SectionSpacer(
            title: (!isSingleMaster)
                ? salonTitles(
                    AppLocalizations.of(context)?.localeName ?? 'en',
                  )[1]
                : masterTitles(
                    AppLocalizations.of(context)?.localeName ?? 'en',
                  )[1],
          ),
          Container(
            // height: 1000.h,
            width: double.infinity,
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 40.h, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isPortrait
                        ? null
                        : (widget.salonModel.description != '')
                            ? 400.h
                            : 200.h,
                    child: isPortrait
                        ? PortraitAboutHeader(
                            salonModel: widget.salonModel,
                          )
                        : LandscapeAboutHeader(
                            salonModel: widget.salonModel,
                          ),
                  ),
                  if (widget.salonModel.additionalFeatures.isNotEmpty)
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.sp),
                        child: SizedBox(
                          // height: 200.h,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10.h,
                                children: widget.salonModel.additionalFeatures
                                    .map(
                                      (feature) => Padding(
                                        padding: EdgeInsets.only(right: 12.sp),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: !isLightTheme ? const Color(0XFF2D2D2D).withOpacity(0.4) : Colors.transparent,
                                            border: !isLightTheme ? null : Border.all(color: theme.primaryColor),
                                            borderRadius: BorderRadius.circular(20.sp),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 10.sp),
                                            child: Center(
                                              child: Text(
                                                feature.toCapitalized(),
                                                style: theme.textTheme.displayMedium!.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.sp,
                                                  color: isLightTheme ? Colors.black : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const Space(factor: 2.5),
                  ReviewSection(
                    reviews: _salonProfileProvider.salonReviews,
                    avgRating: widget.salonModel.avgRating,
                  ),
                ],
              ),
            ),
          ),
          const Space(factor: 2),
        ],
      ),
    );
  }
}

class SocialIcon2 extends ConsumerWidget {
  final IconData icon;
  final String type;
  final String? socialUrl;

  const SocialIcon2({
    Key? key,
    required this.icon,
    required this.type,
    this.socialUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Expanded(
      flex: 0,
      child: GestureDetector(
        onTap: () async {
          Uri uri = Uri.parse(socialLinks(type, socialUrl ?? ''));

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            showToast("Social Link is not available");
          }
        },
        child: Padding(
          padding: EdgeInsets.only(right: 10.sp),
          child: Center(
            child: FaIcon(
              icon,
              size: 25.h,
              color: theme.primaryColor,
            ),
          ),
        ),
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
            showToast("Social Link is not available");
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

class SocialLink2 extends ConsumerWidget {
  final String icon;
  final String type;
  final String? socialUrl;

  const SocialLink2({
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
            showToast("Social Link is not available");
          }
        },
        child: Padding(
          padding: EdgeInsets.only(right: 10.sp),
          child: Center(
            child: (icon == AppIcons.linkGlobeDark)
                ? FaIcon(
                    FontAwesomeIcons.globe,
                    size: 25.h,
                    color: theme.primaryColor,
                  )
                : (icon == AppIcons.linkInstaDark2)
                    ? FaIcon(
                        FontAwesomeIcons.instagram,
                        size: 25.h,
                        color: theme.primaryColor,
                      )
                    : SvgPicture.asset(
                        icon,
                        height: 25.h,
                        color: isLightTheme ? null : theme.primaryColor,
                      ),
          ),
        ),
      ),
    );
  }
}
