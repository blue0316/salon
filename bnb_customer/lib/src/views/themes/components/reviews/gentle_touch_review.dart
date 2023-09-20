import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GentleTouchReviewView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final CarouselController controller;

  const GentleTouchReviewView({Key? key, required this.salonModel, required this.controller}) : super(key: key);

  @override
  ConsumerState<GentleTouchReviewView> createState() => _GentleTouchReviewViewState();
}

class _GentleTouchReviewViewState extends ConsumerState<GentleTouchReviewView> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Container(
      color: theme.colorScheme.secondary.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
          top: 100.h, // DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
          bottom: 80.h, // DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
        ),
        child: (_salonProfileProvider.salonReviews.isNotEmpty)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (AppLocalizations.of(context)?.reviews ?? 'Reviews').toUpperCase(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
                    ),
                  ),
                  // SizedBox(height: 10.sp),
                  SizedBox(
                    height: 280.h,
                    width: double.infinity,
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          // setState(() {
                          //   _current = index;
                          // });
                        },
                      ),
                      items: _salonProfileProvider.salonReviews
                          .map(
                            (item) => GentleTouchReviewCard(review: item),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  PrevAndNextButtons(
                    backOnTap: () => _controller.previousPage(),
                    forwardOnTap: () => _controller.nextPage(),
                    leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                    rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    (AppLocalizations.of(context)?.noReviews ?? 'No reviews yet').toUpperCase(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class GentleTouchReviewCard extends ConsumerWidget {
  final ReviewModel review;

  const GentleTouchReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10.sp),
        RatingBar.builder(
          initialRating: review.rating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemSize: 15,
          itemCount: 5,
          updateOnDrag: true,
          unratedColor: Colors.black,
          onRatingUpdate: (rating) {},
          itemBuilder: (context, _) {
            return Icon(Icons.star, color: theme.colorScheme.secondary);
          },
        ),
        SizedBox(height: 20.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
              width: 80.h,
              child: Center(
                child: SvgPicture.asset(ThemeIcons.quote),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.sp),
                child: Text(
                  review.review,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              height: 100.h,
              width: 80.h,
              child: SvgPicture.asset(ThemeIcons.quote2),
            ),
          ],
        ),
        SizedBox(height: 20.sp),
        Text(
          review.customerName.toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
