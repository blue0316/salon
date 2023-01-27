import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart' as lauch;
import '../../../models/salon_master/salon.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../../utils/read_more_widget.dart';
import '../widgets/rating_graph.dart';
import '../widgets/review_description.dart';

class SalonAbout extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonAbout({Key? key, required this.salonModel}) : super(key: key);

  @override
  _SaloonAboutState createState() => _SaloonAboutState();
}

class _SaloonAboutState extends ConsumerState<SalonAbout> {
  ScrollController controller = ScrollController();
  int totalReviewsToShow = 3;
  late AuthProvider _authProvider;

  @override
  void initState() {
    _authProvider = ref.read(authProvider);
    // TODO: implement initState
    super.initState();
  }

  void _launchURL(String url) async => await lauch.canLaunch(url) ? await lauch.launch(url) : showToast('Could not launch $url');

  getFeature(String s) {
    print(widget.salonModel.ownerType);
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
    print(widget.salonModel.ownerType);
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

  @override
  Widget build(BuildContext context) {
    BnbProvider _bnbProvider = ref.read(bnbProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    var mediaQuery = MediaQuery.of(context);

    return ConstrainedContainer(
      child: ListView(
        primary: false,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.symmetric(vertical: (AppTheme.margin * 2).h),
        children: [
          SizedBox(height: 20.h),
          Text(
            (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[1] : saloonDetailsTitles[1].toCapitalized(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: AppTheme.textBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 30.sp,
                ),
          ),
          const Space(factor: 1.5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (DeviceConstraints.getDeviceType(mediaQuery) != DeviceScreenType.portrait)
                SizedBox(
                  height: 120.h,
                  width: 120.h,
                  child: Image.asset(AppIcons.logoBnbPNG, fit: BoxFit.fill), // CachedImage(url: widget.salonModel.)
                ),
              if (DeviceConstraints.getDeviceType(mediaQuery) != DeviceScreenType.portrait) const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (DeviceConstraints.getDeviceType(mediaQuery) == DeviceScreenType.portrait)
                      SizedBox(
                        height: 170.h,
                        width: double.infinity,
                        child: Image.asset(AppIcons.logoBnbPNG, fit: BoxFit.cover), // CachedImage(url: widget.salonModel.)
                      ),
                    if (DeviceConstraints.getDeviceType(mediaQuery) == DeviceScreenType.portrait) const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.salonModel.salonName,
                          style: Theme.of(context).textTheme.headline2!.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 20.sp, 20.sp),
                                color: AppTheme.textBlack,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const Space(factor: 0.7),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.mapPin2WhiteSVG,
                          height: DeviceConstraints.getResponsiveSize(context, 20.sp, 22.sp, 22.sp),
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.salonModel.address,
                          style: Theme.of(context).textTheme.headline2!.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.textBlack,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const Space(factor: 0.8),
                    BnbRatings(rating: widget.salonModel.rating, editable: false, starSize: 9.sp)
                  ],
                ),
              ),
            ],
          ),
          const Space(factor: 2),
          if (widget.salonModel.description != '') ...[
            Container(
              constraints: BoxConstraints(maxHeight: 300.h),
              child: Scrollbar(
                controller: controller,
                child: ListView(
                  controller: controller,
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    ReadMoreText(
                      // widget.salonModel.description,
                      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.''',
                      trimLines: 4,
                      colorClickableText: AppTheme.textBlack,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: AppLocalizations.of(context)?.readMore ?? '...Read More',
                      trimExpandedText: AppLocalizations.of(context)?.less ?? '  Less',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            const Space(factor: 1.5),
          ],
          if (widget.salonModel.additionalFeatures.isNotEmpty) ...[
            Wrap(
              spacing: 13.w,
              runSpacing: 15.h,
              children: [
                for (String s in widget.salonModel.additionalFeatures) ...[
                  if (AppIcons.getIconFromFacilityString(feature: s) != null) ...[
                    if (_bnbProvider.locale == const Locale('en')) ...[
                      SizedBox(
                        height: 100.sp,
                        width: 70.sp,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ShowAdditionaFeatureInfo(_bnbProvider, s);
                                  }),
                              child: Container(
                                height: 52.sp,
                                width: 52.sp,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.black, width: 1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: SvgPicture.asset(AppIcons.getIconFromFacilityString(feature: s)!),
                                ),
                              ),
                            ),
                            Text(getFeature(s) ?? '', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 13.sp)),
                          ],
                        ),
                      ),
                    ],
                    if (_bnbProvider.locale == const Locale('uk')) ...[
                      Container(
                        color: Colors.yellow,
                        height: 100.sp,
                        width: 70.sp,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    print(s);
                                    return ShowAdditionaFeatureInfo(_bnbProvider, s);
                                  }),
                              child: Container(
                                height: 52.sp,
                                width: 52.sp,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.black, width: 1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: SvgPicture.asset(AppIcons.getIconFromFacilityString(feature: s)!),
                                ),
                              ),
                            ),
                            Text(getFeatureUk(s) ?? '', style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 13.sp)),
                          ],
                        ),
                      ),
                    ]
                  ]
                ],
                // ---- FORMER SOCIAL MEDIA LINKS -----
                // if (widget.salonModel.links != null) ...[
                //   if (widget.salonModel.links!.instagram != "" && widget.salonModel.links!.instagram != null) ...[
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             _launchURL(widget.salonModel.links!.instagram!);
                //           },
                //           child: Container(
                //             height: 52.sp,
                //             width: 52.sp,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: AppTheme.black, width: 1),
                //               borderRadius: BorderRadius.circular(12.sp),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(10.sp),
                //               child: SvgPicture.asset("assets/social_media/insta.svg"),
                //             ),
                //           ),
                //         ),
                //         const Text('instagram'),
                //       ],
                //     ),
                //   ],
                //   if (widget.salonModel.links!.whatsapp != "" && widget.salonModel.links!.whatsapp != null) ...[
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             _launchURL(widget.salonModel.links!.whatsapp!);
                //           },
                //           child: Container(
                //             height: 52.sp,
                //             width: 52.sp,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: AppTheme.black, width: 1),
                //               borderRadius: BorderRadius.circular(12.sp),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(10.sp),
                //               child: SvgPicture.asset("assets/social_media/whatsapp.svg"),
                //             ),
                //           ),
                //         ),
                //         const Text('whatsapp'),
                //       ],
                //     ),
                //   ],
                //   if (widget.salonModel.links!.facebookMessenger != "" && widget.salonModel.links!.facebookMessenger != null) ...[
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             _launchURL(widget.salonModel.links!.facebookMessenger!);
                //           },
                //           child: Container(
                //             height: 52.sp,
                //             width: 52.sp,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: AppTheme.black, width: 1),
                //               borderRadius: BorderRadius.circular(12.sp),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(10.sp),
                //               child: SvgPicture.asset("assets/social_media/facebook_messenger.svg"),
                //             ),
                //           ),
                //         ),
                //         const Text('facebook'),
                //       ],
                //     ),
                //   ],
                //   if (widget.salonModel.links!.telegram != "" && widget.salonModel.links!.telegram != null) ...[
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             _launchURL(widget.salonModel.links!.telegram!);
                //           },
                //           child: Container(
                //             height: 52.sp,
                //             width: 52.sp,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: AppTheme.black, width: 1),
                //               borderRadius: BorderRadius.circular(12.sp),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(10.sp),
                //               child: SvgPicture.asset("assets/social_media/telegram.svg"),
                //             ),
                //           ),
                //         ),
                //         const Text('Telegram'),
                //       ],
                //     ),
                //   ],
                //   if (widget.salonModel.links!.viber != "" && widget.salonModel.links!.viber != null) ...[
                //     Column(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             _launchURL(widget.salonModel.links!.viber!);
                //           },
                //           child: Container(
                //             height: 52.sp,
                //             width: 52.sp,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: AppTheme.black, width: 1),
                //               borderRadius: BorderRadius.circular(12.sp),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.all(10.sp),
                //               child: SvgPicture.asset("assets/social_media/viber.svg"),
                //             ),
                //           ),
                //         ),
                //         const Text('viber'),
                //       ],
                //     ),
                //   ],
                // ],
              ],
            )
          ],
          const SizedBox(height: 20),
          Text(
            'Social Media',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(),
          ),
          const Space(factor: 0.7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: socialMedia
                .map(
                  (social) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 33.sp,
                        width: 33.sp,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 239, 239, 239),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Center(
                            child: Image.asset(
                              social['icon'],
                              height: 15.sp,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          /// --- WEBSITE LINK SECTION ---
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 20.0.w,
          //     vertical: 20.0.w,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // if (widget.salonModel.workingHours != null) ...[
          //       //   WorkingHoursTable(
          //       //     workingHoursModel: widget.salonModel.workingHours!,
          //       //   ),
          //       // ],
          //       if (widget.salonModel.salonWebSite != null && widget.salonModel.salonWebSite != "") ...[
          //         Text(
          //           AppLocalizations.of(context)?.website ?? "website",
          //           style: Theme.of(context).textTheme.subtitle1,
          //         ),
          //         SizedBox(
          //           height: 16.h,
          //         ),
          //         Row(
          //           children: [
          //             SizedBox(
          //               height: 15,
          //               width: 15,
          //               child: SvgPicture.asset(AppIcons.globalSVG),
          //             ),
          //             SizedBox(
          //               width: 8.w,
          //             ),
          //             Expanded(
          //               child: GestureDetector(
          //                 onTap: () {
          //                   Utils().launchUrl(url: widget.salonModel.salonWebSite);
          //                 },
          //                 child: Text(
          //                   widget.salonModel.salonWebSite ?? "",
          //                   maxLines: 1,
          //                   overflow: TextOverflow.ellipsis,
          //                   style: const TextStyle(color: Colors.blue),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ],
          //   ),
          // ),

          const Space(factor: 2.6),

          /// --- REVIEW SECTION ---
          ReviewWidget(
            reviews: _salonProfileProvider.salonReviews,
            avgRating: widget.salonModel.avgRating,
          )
        ],
      ),
    );
  }
}

class ReviewWidget extends StatefulWidget {
  final List<ReviewModel> reviews;
  final double avgRating;

  const ReviewWidget({Key? key, required this.reviews, this.avgRating = 0}) : super(key: key);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final int reviewCount = widget.reviews.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.reviews.isNotEmpty) ...[
          Text(
            AppLocalizations.of(context)?.reviews ?? "Reviews",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20.h),
          RatingGraph(
            allReviews: widget.reviews,
            avgRating: widget.avgRating,
            noOfReviews: widget.reviews.length,
          ),
          SizedBox(height: 25.h),
        ],
        if (reviewCount != 0) ...[
          ListView.builder(
              itemCount: widget.reviews.length > 3 ? totalReviewsToShow : reviewCount,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(0),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return ReviewDescription(
                    isFirst: true,
                    review: widget.reviews[index],
                  );
                } else {
                  return ReviewDescription(
                    isFirst: false,
                    review: widget.reviews[index],
                  );
                }
              }),
          if (widget.reviews.length > 3) ...[
            Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Center(
                child: Container(
                  width: DeviceConstraints.getResponsiveSize(context, 150, 200, 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0XFF000000),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (totalReviewsToShow == 3) {
                            totalReviewsToShow = widget.reviews.length;
                          } else {
                            totalReviewsToShow = 3;
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            // height: DeviceConstraints.getResponsiveSize(context, 32, 35, 40),
                            // width: DeviceConstraints.getResponsiveSize(context, 32, 35, 40),
                            // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.add, color: AppTheme.white),
                          ),
                          // const SizedBox(width: 6),
                          Text(
                            totalReviewsToShow == 3 ? AppLocalizations.of(context)?.moreReviews ?? "More reviews" : AppLocalizations.of(context)?.lessReviews ?? "Less Reviews",
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12, color: AppTheme.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ],
      ],
    );
  }
}

List socialMedia = [
  {
    'name': 'Web',
    'link': '',
    'icon': 'images/media-globe.png',
  },
  {
    'name': 'Facebook',
    'link': '',
    'icon': 'images/media-facebook.png',
  },
  {
    'name': 'Instagram',
    'link': '',
    'icon': 'images/media-instagram.png',
  },
  {
    'name': 'WhatsApp',
    'link': '',
    'icon': 'images/media-whatsapp.png',
  },
];
