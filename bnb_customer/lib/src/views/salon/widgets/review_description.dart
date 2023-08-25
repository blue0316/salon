import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/time.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_reviews.dart';
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
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return !isPortrait
        ? Padding(
            padding: EdgeInsets.only(bottom: 40.sp),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomerReviewName(
                      review: review,
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 120.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BnbRatings(
                                  rating: review.rating,
                                  editable: false,
                                  starSize: 14.sp,
                                  color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
                                ),
                                SizedBox(width: 20.sp),
                                Text(
                                  Time().getLocaleDate2(review.createdAt, AppLocalizations.of(context)?.localeName ?? "en"),
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 14.sp,
                                    color: !isLightTheme ? const Color(0XFF858585) : const Color(0XFF373737),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.sp),
                            Expanded(
                              child: Text(
                                review.review,
                                style: theme.textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.5.sp,
                                  color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.sp),
                  child: const GradientDivider(),
                ),
              ],
            ),
          )
        : PortraitReviewDescription(
            isFirst: isFirst,
            review: review,
          );
  }
}

class PortraitReviewDescription extends ConsumerWidget {
  final bool isFirst;
  final ReviewModel review;

  const PortraitReviewDescription({Key? key, required this.isFirst, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Padding(
      padding: EdgeInsets.only(
        bottom: review.review.isNotEmpty ? 40.sp : 20.sp,
      ),
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
                CustomerReviewName(
                  review: review,
                ),
                SizedBox(height: 15.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BnbRatings(
                      rating: review.rating,
                      editable: false,
                      starSize: 15.sp,
                      color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
                    ),
                    SizedBox(width: 20.sp),
                    Text(
                      Time().getLocaleDate2(review.createdAt, AppLocalizations.of(context)?.localeName ?? "en"),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0XFF858585),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 20.sp),
                Text(
                  review.review,
                  style: theme.textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.5.sp,
                    color: isLightTheme ? Colors.black : const Color(0XFFB1B1B1),
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerReviewName extends ConsumerWidget {
  final ReviewModel review;

  const CustomerReviewName({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50.h,
          width: 50.h,
          decoration: BoxDecoration(
            color: const Color(0XFF2D2D2D).withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              (review.customerName != '' ? review.customerName.initials : ' '),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isLightTheme ? Colors.black : Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(width: 15.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 5.sp),
            Text(
              'Name Service',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 14.sp,
                color: !isLightTheme ? const Color(0XFFB1B1B1) : const Color(0XFF373737),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
