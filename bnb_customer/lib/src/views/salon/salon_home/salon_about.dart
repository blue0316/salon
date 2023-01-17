import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/authentication/auth_provider.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/widgets/additional%20featured.dart';
import 'package:bbblient/src/views/salon/widgets/service_expension_tile.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
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

  void _launchURL(String url) async => await lauch.canLaunch(url)
      ? await lauch.launch(url)
      : showToast('Could not launch $url');

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

  getSalonType(_salon) {
    if (_salon.ownerType == OwnerType.salon) {
      return 0;
    }
    if (_salon.workStation == WorkStation.home) {
      return 1;
    }
    return 2;
  }

  String getIcon(int id) {
    switch (id) {
      case 0:
        return AppIcons.salon;
      case 1:
        return AppIcons.singleMasterFromHome;
      case 2:
        return AppIcons.singleMasterFromStudio;
      default:
        return AppIcons.salon;
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
    final int type = getSalonType(widget.salonModel);
    final String icon = getIcon(type);
    BnbProvider _bnbProvider = ref.read(bnbProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    return ConstrainedContainer(
      child: ListView(
        primary: false,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.symmetric(vertical: (AppTheme.margin * 2).h),
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,right: 20.w,bottom: 30.h
            ),
            child: Text(
              AppLocalizations.of(context)?.about ?? "About",
              style: AppTheme.aboutScreenStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,right: 20.w,bottom: 30.h
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 145.sp ,
                  width: 250.sp,
                  child: SvgPicture.asset(
                      icon,
                    color: AppTheme.bookingBlack,
                    fit: BoxFit.cover,
                  )
                 ),
                SizedBox(width:20.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.salonModel.salonName,
                        style: AppTheme.aboutScreenStyle.copyWith(fontSize:30.sp,),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,size: 20.sp,),
                          SizedBox(width: 5.w,),
                          Expanded(
                            child: Text(
                              widget.salonModel.address,
                              style: AppTheme.aboutScreenStyle.copyWith(fontSize:18.sp,fontWeight: FontWeight.w500,),
                            ),
                          ),
                        ],
                      ),
                      BnbRatings(rating: widget.salonModel.avgRating, editable: false, starSize: 15)

                    ],
                  ),
                )
              ],
            ) ,),
          if (widget.salonModel.description != '') ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Text(
                widget.salonModel.description,
                style: AppTheme.aboutScreenStyle.copyWith(fontWeight: FontWeight.w400,fontSize: 18.sp),
              ),
              // Container(
              //   constraints: BoxConstraints(maxHeight: 300.h),
              //   child: Scrollbar(
              //     controller: controller,
              //     child: ListView(
              //       controller: controller,
              //       shrinkWrap: true,
              //       primary: false,
              //       children: [
              //         ReadMoreText(
              //           widget.salonModel.description,
              //           trimLines: 4,
              //           colorClickableText: AppTheme.textBlack,
              //           trimMode: TrimMode.Line,
              //           trimCollapsedText:
              //               AppLocalizations.of(context)?.readMore ??
              //                   '...Read More',
              //           trimExpandedText:
              //               AppLocalizations.of(context)?.less ?? '  Less',
              //           style: Theme.of(context)
              //               .textTheme
              //               .bodyText1!
              //               .copyWith(fontWeight: FontWeight.w400),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ],
          if (widget.salonModel.additionalFeatures.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Wrap(spacing: 16.w, runSpacing: 16.h, children: [
                for (String s in widget.salonModel.additionalFeatures) ...[
                  if (AppIcons.getIconFromFacilityString(feature: s) !=
                      null) ...[
                        if(_bnbProvider.locale == const Locale('en'))...[
                          SizedBox(
                            height: 100.sp,
                            width: 70.sp,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ShowAdditionaFeatureInfo(
                                            _bnbProvider, s);
                                      }),
                                  child: Container(
                                    height: 52.sp,
                                    width: 52.sp,
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(color: AppTheme.black, width: 1),
                                      borderRadius: BorderRadius.circular(12.sp),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: SvgPicture.asset(
                                          AppIcons.getIconFromFacilityString(
                                              feature: s)!),
                                    ),
                                  ),
                                ),
                                Text(getFeature(s) ?? '',
                                    style:
                                    TextStyle(overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                        ],
                    if(_bnbProvider.locale == const Locale('uk'))...[
                      SizedBox(
                        height: 100.sp,
                        width: 70.sp,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    print(s);
                                    return ShowAdditionaFeatureInfo(
                                        _bnbProvider, s);
                                  }),
                              child: Container(
                                height: 52.sp,
                                width: 52.sp,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: AppTheme.black, width: 1),
                                  borderRadius: BorderRadius.circular(12.sp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: SvgPicture.asset(
                                      AppIcons.getIconFromFacilityString(
                                          feature: s)!),
                                ),
                              ),
                            ),
                            Text(getFeatureUk(s) ?? '',
                                style:
                                TextStyle(overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    ]
                  ],
                ],
              ]),
            )
          ],
          Padding(
            padding: EdgeInsets.only(left: 20.0.w,right: 20.w,top: 30.h,bottom: 20.h),
            child: Text(
              AppLocalizations.of(context)?.socialMedia ?? "Social Media",
              style: AppTheme.aboutScreenStyle.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:20.w),
            child: Row(
              children: [
                if (widget.salonModel.salonWebSite != null &&
                    widget.salonModel.salonWebSite != "") ...[
                  GestureDetector(
                    onTap: () {
                      _launchURL(widget.salonModel.links!.instagram!);
                    },
                    child: Container(
                      height: 40.sp,
                      width: 40.sp,
                      decoration: BoxDecoration(
                        color: AppTheme.bookingWhite,
                        border: const Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide.none),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: SvgPicture.asset(
                          "assets/icons/Global.svg",color: AppTheme.bookingBlack,),
                      ),
                    ),
                  ),
                ],
                if (widget.salonModel.links != null) ...[
                  if (widget.salonModel.links!.instagram != "" &&
                      widget.salonModel.links!.instagram != null) ...[
                    GestureDetector(
                      onTap: () {
                        _launchURL(widget.salonModel.links!.instagram!);
                      },
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        decoration: BoxDecoration(
                          border: const Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide.none),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            "assets/social_media/insta.svg",color: AppTheme.bookingBlack,),
                        ),
                      ),
                    ),
                  ],
                  if (widget.salonModel.links!.whatsapp != "" &&
                      widget.salonModel.links!.whatsapp != null) ...[
                    GestureDetector(
                      onTap: () {
                        _launchURL(widget.salonModel.links!.whatsapp!);
                      },
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        decoration: BoxDecoration(
                          border: const Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide.none),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            "assets/social_media/whatsapp.svg", color: AppTheme.bookingBlack,),
                        ),
                      ),
                    ),
                  ],
                  if (widget.salonModel.links!.facebookMessenger != "" &&
                      widget.salonModel.links!.facebookMessenger != null) ...[
                    GestureDetector(
                      onTap: () {
                        _launchURL(
                            widget.salonModel.links!.facebookMessenger!);
                      },
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        decoration: BoxDecoration(
                          border: const Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide.none),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            "assets/social_media/facebook_messenger.svg", color: AppTheme.bookingBlack,),
                        ),
                      ),
                    ),
                  ],
                  // if (widget.salonModel.links!.telegram != "" &&
                  //     widget.salonModel.links!.telegram != null) ...[
                  //   Column(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           _launchURL(widget.salonModel.links!.telegram!);
                  //         },
                  //         child: Container(
                  //           height: 52.sp,
                  //           width: 52.sp,
                  //           decoration: BoxDecoration(
                  //             border:
                  //             Border.all(color: AppTheme.black, width: 1),
                  //             borderRadius: BorderRadius.circular(12.sp),
                  //           ),
                  //           child: Padding(
                  //             padding: EdgeInsets.all(10.sp),
                  //             child: SvgPicture.asset(
                  //                 "assets/social_media/telegram.svg"),
                  //           ),
                  //         ),
                  //       ),
                  //       const Text('Telegram'),
                  //     ],
                  //   ),
                  // ],
                  // if (widget.salonModel.links!.viber != "" &&
                  //     widget.salonModel.links!.viber != null) ...[
                  //   Column(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           _launchURL(widget.salonModel.links!.viber!);
                  //         },
                  //         child: Container(
                  //           height: 52.sp,
                  //           width: 52.sp,
                  //           decoration: BoxDecoration(
                  //             border:
                  //             Border.all(color: AppTheme.black, width: 1),
                  //             borderRadius: BorderRadius.circular(12.sp),
                  //           ),
                  //           child: Padding(
                  //             padding: EdgeInsets.all(10.sp),
                  //             child: SvgPicture.asset(
                  //                 "assets/social_media/viber.svg"),
                  //           ),
                  //         ),
                  //       ),
                  //       const Text('viber'),
                  //     ],
                  //   ),
                  // ],
                ],
              ],
            ),
          ),
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
          //       if (widget.salonModel.salonWebSite != null &&
          //           widget.salonModel.salonWebSite != "") ...[
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
          //                   Utils()
          //                       .launchUrl(url: widget.salonModel.salonWebSite);
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

  const ReviewWidget({Key? key, required this.reviews, this.avgRating = 0})
      : super(key: key);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final int reviewCount = widget.reviews.length;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0.w,
        vertical: 20.0.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.reviews.isNotEmpty) ...[
            Text(
              AppLocalizations.of(context)?.reviews ?? "Reviews",
              style: AppTheme.aboutScreenStyle.copyWith(fontWeight: FontWeight.w500,fontSize: 24.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            RatingGraph(
              allReviews: widget.reviews,
              avgRating: widget.avgRating,
              noOfReviews: widget.reviews.length,
            ),
            SizedBox(
              height: 50.h,
            ),
          ],
          if (reviewCount != 0) ...[
            ListView.builder(
                itemCount: widget.reviews.length > 3
                    ? totalReviewsToShow
                    : reviewCount,
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
                padding: EdgeInsets.all(16.0.w),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (totalReviewsToShow == 3) {
                              totalReviewsToShow = widget.reviews.length;
                            } else {
                              totalReviewsToShow = 3;
                            }
                          });
                        },
                        child: Container(
                          height: DeviceConstraints.getResponsiveSize(
                              context, 32, 35, 40),
                          width: DeviceConstraints.getResponsiveSize(
                              context, 32, 35, 40),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(totalReviewsToShow == 3
                                ? AppIcons.arrowDownSVG
                                : AppIcons.arrowUpSVG),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        totalReviewsToShow == 3
                            ? AppLocalizations.of(context)?.moreReviews ??
                                "More reviews"
                            : AppLocalizations.of(context)?.lessReviews ??
                                "Less Reviews",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ],
        ],
      ),
    );
  }
}
