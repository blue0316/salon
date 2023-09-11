import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'salon_about.dart';

class LandscapeAboutHeader extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  const LandscapeAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<LandscapeAboutHeader> createState() => _LandscapeAboutHeaderState();
}

class _LandscapeAboutHeaderState extends ConsumerState<LandscapeAboutHeader> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: widget.salonModel.profilePics.isNotEmpty ? null : 250.h,
            decoration: BoxDecoration(
              color: widget.salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
            ),
            child: (widget.salonModel.profilePics.isNotEmpty)
                ? Column(
                    children: [
                      SizedBox(
                        height: 350.h,
                        width: double.infinity,
                        child: SizedBox(
                          // height: 360.sp,
                          width: double.infinity,
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              height: 350.h,
                              autoPlay: true,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            items: widget.salonModel.profilePics
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
                      SizedBox(height: 15.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.salonModel.profilePics.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: !isLightTheme
                                    ? Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4)
                                    : const Color(0XFF8A8A8A).withOpacity(
                                        _current == entry.key ? 0.9 : 0.4,
                                      ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      (widget.salonModel.salonName.isNotEmpty) ? widget.salonModel.salonName[0].toUpperCase() : '',
                      style: theme.textTheme.displayLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 80.sp, 100.sp),
                        color: Colors.white,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 35),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.salonModel.salonName.toCapitalized(),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontFamily: "Inter",
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const Space(factor: 0.7),
                  SizedBox(height: 12.sp),
                  BnbRatings(
                    rating: widget.salonModel.rating,
                    editable: false,
                    starSize: 15.sp,
                  ),
                  SizedBox(height: 12.sp),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                        color: isLightTheme ? Colors.black : Colors.white,
                      ),
                      SizedBox(width: 8.sp),
                      Text(
                        widget.salonModel.address,
                        style: theme.textTheme.displayMedium!.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isLightTheme ? Colors.black : Colors.white,
                          fontFamily: "Inter",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.salonModel.description != '') SizedBox(height: 20.sp),
              if (widget.salonModel.description != '')
                Text(
                  widget.salonModel.description,
                  style: theme.textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                    color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
                    fontFamily: "Inter-Light",
                  ),
                  maxLines: 7,
                  // overflow: TextOverflow.ellipsis,
                ),
              FollowUs(
                salonModel: widget.salonModel,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PortraitAboutHeader extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const PortraitAboutHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<PortraitAboutHeader> createState() => _PortraitAboutHeaderState();
}

class _PortraitAboutHeaderState extends ConsumerState<PortraitAboutHeader> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.salonModel.salonName.toCapitalized(),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: isLightTheme ? Colors.black : Colors.white,
                    fontFamily: "Inter",
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.sp),
                BnbRatings(
                  rating: widget.salonModel.rating,
                  editable: false,
                  starSize: 15.sp,
                  color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
                ),
                SizedBox(height: 12.sp),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    // Image.asset(
                    //   AppIcons.mapPinPNG,
                    // height: DeviceConstraints.getResponsiveSize(context, 18.h, 18.h, 15.h),
                    // color: isLightTheme ? Colors.black : Colors.white,
                    // ),
                    SizedBox(width: 8.sp),
                    Text(
                      widget.salonModel.address,
                      style: theme.textTheme.displayMedium!.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isLightTheme ? Colors.black : Colors.white,
                        fontFamily: "Inter",
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            // const Space(factor: 0.5),
          ],
        ),
        SizedBox(height: 20.sp),
        Container(
          height: 350.sp,
          width: double.infinity,
          decoration: BoxDecoration(
            // border: !isLightTheme ? Border.all(color: Colors.white, width: 1) : null,
            color: widget.salonModel.profilePics.isNotEmpty ? null : theme.primaryColor,
          ),
          child: (widget.salonModel.profilePics.isNotEmpty)
              // ? CachedImage(url: salonModel.profilePics[0])
              ? Column(
                  children: [
                    SizedBox(
                      height: 300.sp,
                      width: double.infinity,
                      child: CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        items: widget.salonModel.profilePics
                            .map(
                              (item) => CachedImage(
                                url: item, // item.image!,
                                fit: BoxFit.cover,
                                height: 300.h,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 15.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.salonModel.profilePics.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: !isLightTheme
                                  ? Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4)
                                  : const Color(0XFF8A8A8A).withOpacity(
                                      _current == entry.key ? 0.9 : 0.4,
                                    ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    (widget.salonModel.salonName.isNotEmpty) ? widget.salonModel.salonName[0].toUpperCase() : '',
                    style: theme.textTheme.displayLarge!.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 80.sp, 100.sp),
                      color: Colors.white,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
        ),
        SizedBox(height: 7.sp),
        if (widget.salonModel.description != '')
          Text(
            widget.salonModel.description,
            style: theme.textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
              color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
              fontFamily: "Inter-Light",
            ),
            // maxLines: 8,
            // overflow: TextOverflow.ellipsis,
          ),
        FollowUs(
          salonModel: widget.salonModel,
        ),
      ],
    );
  }
}

class FollowUs extends ConsumerWidget {
  final SalonModel salonModel;

  const FollowUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (AppLocalizations.of(context)?.followUs ?? "Follow Us").toCapitalized(),
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: isLightTheme ? Colors.black : Colors.white,
                fontFamily: "Inter",
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (salonModel.links?.website != '' && salonModel.links?.website != null)
                (!isLightTheme)
                    ? SocialLink2(
                        icon: AppIcons.linkGlobeDark,
                        type: 'website',
                        socialUrl: salonModel.links?.website,
                      )
                    : SocialIcon2(
                        icon: FontAwesomeIcons.globe,
                        type: 'website',
                        socialUrl: salonModel.links?.website,
                      ),
              if (salonModel.links?.instagram != '' && salonModel.links?.instagram != null)
                (!isLightTheme)
                    ? SocialLink2(
                        icon: AppIcons.linkInstaDark2,
                        type: 'insta',
                        socialUrl: salonModel.links?.instagram,
                      )
                    : SocialIcon2(
                        icon: FontAwesomeIcons.instagram,
                        type: 'insta',
                        socialUrl: salonModel.links?.instagram,
                      ),
              if (salonModel.links?.tiktok != '' && salonModel.links?.tiktok != null)
                SocialLink2(
                  icon: isLightTheme ? AppIcons.linkTikTok : AppIcons.linkTikTokDark,
                  type: 'tiktok',
                  socialUrl: salonModel.links?.tiktok,
                ),
              if (salonModel.links?.facebook != '' && salonModel.links?.facebook != null)
                SocialLink2(
                  icon: isLightTheme ? AppIcons.linkFacebook : AppIcons.linkFacebookDark,
                  type: 'facebook',
                  socialUrl: salonModel.links?.facebook,
                ),
              if (salonModel.links?.twitter != '' && salonModel.links?.twitter != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.twitter,
                  type: 'twitter',
                  socialUrl: salonModel.links?.twitter,
                ),
              if (salonModel.links?.pinterest != '' && salonModel.links?.pinterest != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.pinterest,
                  type: 'pinterest',
                  socialUrl: salonModel.links?.pinterest,
                ),
              if (salonModel.links?.yelp != '' && salonModel.links?.yelp != null)
                SocialIcon2(
                  icon: FontAwesomeIcons.yelp,
                  type: 'yelp',
                  socialUrl: salonModel.links?.yelp,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
