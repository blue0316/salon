import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/review.dart';
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

  const ReviewSection({Key? key, required this.reviews, this.avgRating = 0}) : super(key: key);

  @override
  ConsumerState<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends ConsumerState<ReviewSection> {
  int totalReviewsToShow = 3;

  @override
  Widget build(BuildContext context) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);
    final int reviewCount = widget.reviews.length;
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.lightTheme);

    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            (AppLocalizations.of(context)?.reviews ?? "Reviews").toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
          ),
          const SizedBox(height: 20),
          if (!isTab)
            RatingGraph(
              allReviews: widget.reviews,
              avgRating: widget.avgRating,
              noOfReviews: widget.reviews.length,
            ),
          if (!isTab) const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isTab)
                Expanded(
                  flex: 2,
                  child: RatingGraph(
                    allReviews: widget.reviews,
                    avgRating: widget.avgRating,
                    noOfReviews: widget.reviews.length,
                  ),
                ),
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
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                              fontSize: 12,
                                              color: AppTheme.white,
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
