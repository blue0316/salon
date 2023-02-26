import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonReviews extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonReviews({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonReviews> createState() => _SalonReviewsState();
}

class _SalonReviewsState extends ConsumerState<SalonReviews> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final _ratingStr = widget.salonModel.avgRating.toString();

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: 60,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.reviews ?? 'Reviews'.toUpperCase(),
                style: theme.textTheme.headline2?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                ),
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     (_salonProfileProvider.chosenSalon.selectedTheme != 2)
              //         ? SvgPicture.asset(
              //             ThemeIcons.leftArrow,
              //             height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
              //           )
              //         : Icon(
              //             Icons.arrow_back,
              //             size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
              //             color: Colors.white,
              //           ),
              //     SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
              //     (_salonProfileProvider.chosenSalon.selectedTheme != 2)
              //         ? SvgPicture.asset(
              //             ThemeIcons.rightArrow,
              //             height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
              //           )
              //         : Icon(
              //             Icons.arrow_forward,
              //             size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
              //             color: Colors.white,
              //           ),
              //   ],
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _ratingStr.length > 3 ? _ratingStr.substring(0, 3) : _ratingStr, // "4,5",
                style: theme.textTheme.bodyText1?.copyWith(),
              ),
              const SizedBox(width: 15),
              RatingBar.builder(
                initialRating: widget.salonModel.avgRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemSize: 20,
                itemCount: 5,
                updateOnDrag: true,
                glowColor: Colors.yellow,
                glow: true,
                glowRadius: 10,
                unratedColor: Colors.grey,
                onRatingUpdate: (rating) {},
                itemBuilder: (context, _) {
                  return Icon(
                    Icons.star,
                    color: theme.primaryColorDark,
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                "${_salonProfileProvider.salonReviews.length} ${AppLocalizations.of(context)?.reviews ?? 'Reviews'}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: theme.textTheme.bodyText2?.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          (_salonProfileProvider.salonReviews.isNotEmpty)
              ? SizedBox(
                  height: DeviceConstraints.getResponsiveSize(context, 250.h, 250.h, 220.h),
                  child:
                      // (!isPortrait)
                      //     ? Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: const [
                      //           ReviewCard(
                      //             avatar: ThemeImages.review1,
                      //             reviewUser: 'Jocelyn Francis',
                      //             review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                      //             reviewStars: 5,
                      //           ),
                      //           ReviewCard(
                      //             avatar: ThemeImages.review2,
                      //             reviewUser: 'Skylar Vetrovs',
                      //             review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                      //             reviewStars: 3.5,
                      //           ),
                      //           ReviewCard(
                      //             avatar: ThemeImages.review3,
                      //             reviewUser: 'Jocelyn Francis',
                      //             review: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                      //             reviewStars: 5,
                      //           ),
                      //         ],
                      //       )
                      // :
                      ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: (_salonProfileProvider.salonReviews.length > 3) ? 3 : _salonProfileProvider.salonReviews.length, // Only show 3 reviews
                    itemBuilder: (context, index) {
                      ReviewModel review = _salonProfileProvider.salonReviews[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ReviewCard(
                          avatar: review.customerPic,
                          reviewUser: review.customerName != '' ? review.customerName : 'bnb user', // 'Jocelyn Francis',
                          review: review.review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                          reviewStars: review.rating,
                        ),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noReviews ?? 'No reviews').toUpperCase(),
                      style: theme.textTheme.bodyText1?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class ReviewCard extends ConsumerWidget {
  final String? avatar, reviewUser, review;
  final double? reviewStars;

  const ReviewCard({
    Key? key,
    required this.avatar,
    required this.reviewUser,
    required this.review,
    required this.reviewStars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return SizedBox(
      height: DeviceConstraints.getResponsiveSize(context, 400.h, 400.h, 350.h),
      width: DeviceConstraints.getResponsiveSize(context, 260.w, 260.w, 110.w),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 45),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: theme.primaryColor, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        reviewUser ?? 'bnb user'.toUpperCase(),
                        style: theme.textTheme.bodyText1?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RatingBar.builder(
                        initialRating: reviewStars ?? 5,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemSize: 17,
                        itemCount: 5,
                        updateOnDrag: true,
                        unratedColor: Colors.grey,
                        onRatingUpdate: (rating) {},
                        itemBuilder: (context, _) {
                          return Icon(
                            Icons.star,
                            color: theme.primaryColorDark,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SvgPicture.asset(
                            ThemeIcons.leftQuote,
                            height: 15,
                            color: theme.primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: DeviceConstraints.getResponsiveSize(context, 200.w, 200.w, 80.w),
                          child: Text(
                            review ?? '',
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.subtitle1?.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              letterSpacing: -0.8,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                            ThemeIcons.rightQuote,
                            height: 15,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: DeviceConstraints.getResponsiveSize(context, 80.h, 80.h, 60.h),
            width: DeviceConstraints.getResponsiveSize(context, 80.h, 80.h, 60.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.primaryColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: (avatar != null && avatar != '')
                  ? CachedImage(
                      url: avatar!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      AppIcons.masterDefaultAvtar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
