import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_main_theme.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingGraph extends ConsumerWidget {
  final double avgRating;
  final int noOfReviews;
  final List<ReviewModel> allReviews;

  const RatingGraph({Key? key, required this.avgRating, required this.noOfReviews, required this.allReviews}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    bool isLightTheme = (theme == AppTheme.customLightTheme);

    final _ratingStr = avgRating.toString();

    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                _ratingStr.length > 3 ? _ratingStr.substring(0, 3) : _ratingStr,
                style: theme.textTheme.displayMedium!.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            BnbRatings(
              rating: avgRating,
              editable: false,
              starSize: 10,
              color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
            ),
            SizedBox(height: 10.h),
            Text(
              "${noOfReviews.toInt()} ${AppLocalizations.of(context)?.reviews ?? "reviews"}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    fontSize: 14.sp,
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
            ),
          ],
        ),
        SizedBox(width: 10.w),
        DistributedRating(
          allReviews: allReviews,
        ),
      ],
    );
  }
}

class DistributedRating extends ConsumerStatefulWidget {
  final List<ReviewModel> allReviews;
  const DistributedRating({Key? key, required this.allReviews}) : super(key: key);

  @override
  ConsumerState<DistributedRating> createState() => _DistributedRatingState();
}

class _DistributedRatingState extends ConsumerState<DistributedRating> {
  //count of reviews
  int totalCount = 0;
  int reviewCount1 = 0;
  int reviewCount2 = 0;
  int reviewCount3 = 0;
  int reviewCount4 = 0;
  int reviewCount5 = 0;

  @override
  void initState() {
    super.initState();
    _computeReviews();
  }

  _computeReviews() {
    totalCount = widget.allReviews.length;

    for (ReviewModel review in widget.allReviews) {
      _incrementRating(review.rating.round());
    }
  }

  _incrementRating(int rating) {
    switch (rating) {
      case 1:
        reviewCount1++;
        break;
      case 2:
        reviewCount2++;
        break;
      case 3:
        reviewCount3++;
        break;
      case 4:
        reviewCount4++;
        break;
      case 5:
        reviewCount5++;
        break;
    }
  }

  Widget rating(String ratingLabel, rating) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ratingLabel,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 13,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
          ),
          const SpaceHorizontal(),
          Stack(
            children: [
              Container(
                height: 8,
                width: 100,
                decoration: BoxDecoration(color: isLightTheme ? Colors.white : Colors.black),
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 8,
                  width: 100.0 * (totalCount == 0 ? 0 : (rating / totalCount)),
                  decoration: BoxDecoration(
                    color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        rating("5", reviewCount5),
        rating("4", reviewCount4),
        rating("3", reviewCount3),
        rating("2", reviewCount2),
        rating("1", reviewCount1),
      ],
    );
  }
}
