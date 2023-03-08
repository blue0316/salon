import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/themes/components/reviews/widgets/review_card.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
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
                (AppLocalizations.of(context)?.reviews ?? 'Reviews')
                    .toUpperCase(),
                style: theme.textTheme.headline2?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(
                      context, 40.sp, 40.sp, 50.sp),
                ),
              ),
              PrevAndNextButtons(
                backOnTap: () => _controller.previousPage(),
                forwardOnTap: () => _controller.nextPage(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _ratingStr.length > 3
                    ? _ratingStr.substring(0, 3)
                    : _ratingStr, // "4,5",
                style: theme.textTheme.bodyText1?.copyWith(
                  fontSize: 18.sp,
                ),
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
              const SizedBox(width: 15),
              Text(
                "${_salonProfileProvider.salonReviews.length} ${AppLocalizations.of(context)?.reviews ?? 'Reviews'}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: theme.textTheme.bodyText2?.copyWith(
                  fontSize: 18.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          (_salonProfileProvider.salonReviews.isNotEmpty)
              ? ReviewBuilder(controller: _controller)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noReviews ??
                              'No reviews yet')
                          .toUpperCase(),
                      style: theme.textTheme.bodyText1?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(
                            context, 20.sp, 20.sp, 20.sp),
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

class ReviewBuilder extends ConsumerStatefulWidget {
  final CarouselController controller;
  const ReviewBuilder({Key? key, required this.controller}) : super(key: key);

  @override
  ConsumerState<ReviewBuilder> createState() => _ReviewBuilderState();
}

class _ReviewBuilderState extends ConsumerState<ReviewBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);

    String? themeNo = _salonProfileProvider.theme;

    return SizedBox(
      height: DeviceConstraints.getResponsiveSize(
        context,
        250.h,
        size.height * 0.3, // 250.h,
        size.height * 0.3,
      ),
      width: double.infinity,

      child: CarouselSlider(
        carouselController: widget.controller,
        options: CarouselOptions(
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          autoPlay: false,
          pauseAutoPlayOnTouch: true,
          viewportFraction:
              DeviceConstraints.getResponsiveSize(context, 1, 0.9, 0.4),
          // height: DeviceConstraints.getResponsiveSize(
          //     context, 280.h, 320, 350.h),
        ),
        items: _salonProfileProvider.salonReviews.map(
          (review) {
            return Padding(
              padding: EdgeInsets.only(
                  right:
                      DeviceConstraints.getResponsiveSize(context, 10, 20, 30)),
              child: (themeNo == '4')
                  ? ReviewCardWithoutAvatar(
                      reviewUser: review.customerName != ''
                          ? review.customerName
                          : 'bnb user',
                      review: review.review,
                      reviewStars: review.rating,
                    )
                  : ReviewCard(
                      avatar: review.customerPic,
                      reviewUser: review.customerName != ''
                          ? review.customerName
                          : 'bnb user', // 'Jocelyn Francis',
                      review: review
                          .review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                      reviewStars: review.rating,
                    ),
            );
          },
        ).toList(),
      ),
      // child: ListView.builder(
      //   shrinkWrap: true,
      //   scrollDirection: Axis.horizontal,
      //   itemCount: (_salonProfileProvider.salonReviews.length > 3)
      //       ? 3
      //       : _salonProfileProvider.salonReviews.length, // Only show 3 reviews
      //   itemBuilder: (context, index) {
      //     ReviewModel review = _salonProfileProvider.salonReviews[index];
      //     return Padding(
      //       padding: const EdgeInsets.only(right: 15),
      //       child: (themeNo == '4')
      //           ? ReviewCardWithoutAvatar(
      //               reviewUser: review.customerName != ''
      //                   ? review.customerName
      //                   : 'bnb user', // 'Jocelyn Francis',
      //               review: review
      //                   .review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
      //               reviewStars: review.rating,
      //             )
      //           : ReviewCard(
      //               avatar: review.customerPic,
      //               reviewUser: review.customerName != ''
      //                   ? review.customerName
      //                   : 'bnb user', // 'Jocelyn Francis',
      //               review: review
      //                   .review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
      //               reviewStars: review.rating,
      //             ),
      //     );
      //   },
      // ),
    );
  }
}
