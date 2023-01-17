import 'package:bbblient/src/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_main_theme.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingGraph extends StatelessWidget {
  final double avgRating;
  final int noOfReviews;
  final List<ReviewModel> allReviews;

  const RatingGraph(
      {Key? key,
      required this.avgRating,
      required this.noOfReviews,
      required this.allReviews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ratingStr=  avgRating.toString();
    return Row(
      children: [
        Column(
          children: [
            Text(
              _ratingStr.length>3?_ratingStr.substring(0, 3):_ratingStr,
              style: AppTheme.aboutScreenStyle.copyWith(),
            ),
            SizedBox(
              height: 10.h,
            ),
            BnbRatings(rating: avgRating, editable: false, starSize: 15),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "${noOfReviews.toInt()} ${AppLocalizations.of(context)?.reviews ?? "reviews"}",
              style: AppTheme.aboutScreenStyle.copyWith(fontWeight: FontWeight.w400,fontSize: 20.sp, decoration: TextDecoration.underline),
            ),
          ],
        ),
        SizedBox(width: 40.w ,),
        DistributedRating(
          allReviews: allReviews,
        ),
      ],
    );
  }
}

class DistributedRating extends StatefulWidget {
  final List<ReviewModel> allReviews;
  const DistributedRating({Key? key, required this.allReviews})
      : super(key: key);

  @override
  State<DistributedRating> createState() => _DistributedRatingState();
}

class _DistributedRatingState extends State<DistributedRating> {
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

    return Padding(
      padding: EdgeInsets.only(bottom: 2.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ratingLabel,
            style: AppTheme.aboutScreenStyle.copyWith(fontWeight: FontWeight.w500,fontSize: 18.sp),          ),
          const SpaceHorizontal(),
          Stack(
            children: [
              Container(
                height: 8,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 8,
                  width: 160.0 * (totalCount == 0 ? 0 : (rating / totalCount)),
                  decoration: BoxDecoration(
                    color: AppTheme.bookingYellow,
                    borderRadius: BorderRadius.circular(12),
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
