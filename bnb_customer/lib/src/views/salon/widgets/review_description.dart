import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewDescription extends ConsumerWidget {
  final bool isFirst;
  final ReviewModel review;

  const ReviewDescription({Key? key, required this.isFirst, required this.review}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isLightTheme ? Colors.black : Colors.white,
            width: isFirst ? 0.8 : 0,
          ),
          bottom: BorderSide(
            color: isLightTheme ? Colors.black : Colors.white,
            width: 0.8,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (review.customerName != '' ? review.customerName : 'bnb user').toCapitalized(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    Time().getLocaleDate2(review.createdAt, AppLocalizations.of(context)?.localeName ?? "uk"),
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    review.review,
                    style: theme.textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.5.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: BnbRatings(
                rating: review.rating,
                editable: false,
                starSize: 10,
                color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
              ),
            )
          ],
        ),
      ),
    );
  }
}
