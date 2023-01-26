import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewDescription extends StatelessWidget {
  final bool isFirst;
  final ReviewModel review;

  const ReviewDescription({Key? key, required this.isFirst, required this.review}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.white,
          border: Border(
        // hide top border when using list View
        top: BorderSide(color: const Color(0XFF9D9D9D), width: isFirst ? 1 : 0),
        bottom: const BorderSide(color: Color(0XFF9D9D9D), width: 1),
      )),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // CircleAvatar(
                  //   radius: DeviceConstraints.getResponsiveSize(context, 26, 35, 48),
                  //   backgroundColor: AppTheme.white,
                  //   backgroundImage: review.customerPic != ''
                  //       ? NetworkImage(review.customerPic)
                  //       : const AssetImage(
                  //           AppIcons.defaultUserAvtarPNG,
                  //         ) as ImageProvider,
                  // ),
                  // SizedBox(
                  //   height: 8.h,
                  // ),
                  Text(
                    review.customerName != '' ? review.customerName : 'bnb user',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    Time().getLocaleDate2(review.createdAt, AppLocalizations.of(context)?.localeName ?? "uk"),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    review.review,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: 30.w,
            // ),
            Flexible(
              flex: 3,
              child: BnbRatings(rating: review.rating, editable: false, starSize: 15),

              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           Time().getLocaleDate2(review.createdAt, AppLocalizations.of(context)?.localeName ?? "uk"),
              //           style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12),
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         BnbRatings(rating: review.rating, editable: false, starSize: 15)
              //       ],
              //     ),
              //     SizedBox(
              //       height: 16.h,
              //     ),
              //     Text(
              //       review.review,
              //       style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400),
              //       maxLines: 6,
              //       overflow: TextOverflow.ellipsis,
              //       textAlign: TextAlign.left,
              //     )
              //   ],
              // ),
            )
          ],
        ),
      ),
    );
  }
}
