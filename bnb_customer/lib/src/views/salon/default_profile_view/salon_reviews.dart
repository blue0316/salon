import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/widgets/rating_graph.dart';
import 'package:bbblient/src/views/salon/widgets/review_description.dart';

class ReviewSection extends ConsumerStatefulWidget {
  final List<ReviewModel> reviews;
  final double avgRating;
  final bool isFromMasterView;

  const ReviewSection({
    Key? key,
    required this.reviews,
    this.avgRating = 0,
    this.isFromMasterView = false,
  }) : super(key: key);

  @override
  ConsumerState<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends ConsumerState<ReviewSection> {
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final int reviewCount = widget.reviews.length;
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return !isPortrait
        ? Expanded(
            flex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!widget.isFromMasterView)
                  Text(
                    (AppLocalizations.of(context)?.reviews ?? "Reviews").trim().toCapitalized(),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontFamily: "Inter",
                    ),
                  ),
                if (!widget.isFromMasterView) SizedBox(height: 30.sp),

                if (!widget.isFromMasterView)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TotalReviewsCount(
                        count: widget.reviews.length,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const VerticalGradientDivider(),
                      ),
                      AverageReviewsCount(
                        count: widget.avgRating.toStringAsFixed(1),
                        avgRating: widget.avgRating,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const VerticalGradientDivider(),
                      ),
                      NewDistributedRating(
                        allReviews: widget.reviews,
                      ),
                    ],
                  ),

                if (!widget.isFromMasterView)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.sp),
                    child: const GradientDivider(),
                  ),

                if (widget.isFromMasterView) SizedBox(height: 20.sp),

                // All reviews
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
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
                                padding: EdgeInsets.only(top: 25.h),
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
                                              style: theme.textTheme.titleMedium!.copyWith(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontFamily: "Inter",
                                              ),
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
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        : PortraitReviewView(
            reviews: widget.reviews,
            avgRating: widget.avgRating,
            isFromMasterView: widget.isFromMasterView,
          );
  }
}

class AverageReviewsCount extends ConsumerWidget {
  final String count;
  final double avgRating;

  const AverageReviewsCount({
    Key? key,
    required this.count,
    required this.avgRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          (AppLocalizations.of(context)?.averageRating ?? "Average Rating").toCapitalized(),
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
            color: isLightTheme ? Colors.black : Colors.white,
            fontFamily: "Inter",
          ),
        ),
        SizedBox(height: 20.sp),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              count,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: isLightTheme ? Colors.black : Colors.white,
                fontFamily: "Inter",
              ),
            ),
            SizedBox(width: 8.sp),
            BnbRatings(
              rating: avgRating,
              editable: false,
              starSize: 15.sp,
            ),
          ],
        ),
      ],
    );
  }
}

class TotalReviewsCount extends ConsumerWidget {
  final int count;
  const TotalReviewsCount({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          (AppLocalizations.of(context)?.totalReviews ?? "Total Reviews").toCapitalized(),
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
            color: isLightTheme ? Colors.black : Colors.white,
            fontFamily: "Inter",
          ),
        ),
        SizedBox(height: 20.sp),
        Text(
          '$count',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
            color: isLightTheme ? Colors.black : Colors.white,
            fontFamily: "Inter",
          ),
        ),
      ],
    );
  }
}

class PortraitReviewView extends ConsumerStatefulWidget {
  final List<ReviewModel> reviews;
  final double avgRating;
  final bool isFromMasterView;

  const PortraitReviewView({Key? key, required this.reviews, this.avgRating = 0, this.isFromMasterView = false}) : super(key: key);

  @override
  ConsumerState<PortraitReviewView> createState() => _PortraitReviewViewState();
}

class _PortraitReviewViewState extends ConsumerState<PortraitReviewView> {
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final int reviewCount = widget.reviews.length;
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!widget.isFromMasterView)
            Text(
              (AppLocalizations.of(context)?.reviews ?? "Reviews").toCapitalized(),
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: isLightTheme ? Colors.black : Colors.white,
                fontFamily: "Inter",
              ),
            ),
          if (!widget.isFromMasterView) SizedBox(height: 30.sp),

          if (!widget.isFromMasterView)
            TotalReviewsCount(
              count: widget.reviews.length,
            ),

          if (!widget.isFromMasterView)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.sp),
              child: const GradientDivider(),
            ),

          if (!widget.isFromMasterView)
            AverageReviewsCount(
              count: widget.avgRating.toStringAsFixed(1),
              avgRating: widget.avgRating,
            ),
          if (!widget.isFromMasterView)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.sp),
              child: const GradientDivider(),
            ),

          if (!widget.isFromMasterView)
            NewDistributedRating(
              allReviews: widget.reviews,
            ),

          if (!widget.isFromMasterView)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.sp),
              child: const GradientDivider(),
            ),

          if (widget.isFromMasterView) SizedBox(height: 20.sp),
          // All reviews
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
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
                          padding: EdgeInsets.only(top: 25.h),
                          child: Center(
                            child: Container(
                              width: DeviceConstraints.getResponsiveSize(context, 150, 200, 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: theme.primaryColor, // const Color(0XFF000000),
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
                                        style: theme.textTheme.titleMedium!.copyWith(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontFamily: "Inter",
                                        ),
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
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class GradientDivider extends ConsumerWidget {
  const GradientDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Container(
      width: double.infinity,
      height: 1.5.sp,
      decoration: BoxDecoration(
        color: !isLightTheme ? Colors.white : null,
        gradient: LinearGradient(
            colors: !isLightTheme
                ? [
                    const Color.fromARGB(43, 74, 74, 74),
                    const Color(0XFF4A4A4A),
                    const Color.fromARGB(43, 74, 74, 74),
                  ]
                : [
                    const Color(0XFFE0E0E0),
                    const Color(0XFFE0E0E0),
                    const Color(0XFFE0E0E0),
                  ]),
      ),
    );
  }
}

class VerticalGradientDivider extends ConsumerWidget {
  const VerticalGradientDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Container(
      height: 120.h,
      width: 1.5.sp,
      decoration: BoxDecoration(
        color: !isLightTheme ? Colors.white : null,
        gradient: LinearGradient(
          colors: !isLightTheme
              ? [
                  const Color.fromARGB(43, 74, 74, 74),
                  const Color(0XFF4A4A4A),
                  const Color.fromARGB(43, 74, 74, 74),
                ]
              : [
                  const Color(0XFFE0E0E0),
                  const Color(0XFFE0E0E0),
                  const Color(0XFFE0E0E0),
                ],
        ),
      ),
    );
  }
}
