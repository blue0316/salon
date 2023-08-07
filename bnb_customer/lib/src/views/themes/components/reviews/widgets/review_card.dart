import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    ThemeType themeType = _salonProfileProvider.themeType;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      // height: DeviceConstraints.getResponsiveSize(context, 400.h, 400.h, 400.h),
      // width: DeviceConstraints.getResponsiveSize(context, 260.w, 260.w, 110.w),
      width: DeviceConstraints.getResponsiveSize(
        context,
        (size.width - 40.w),
        (size.width - 100.w),
        ((size.width - 100.w - 60) / 3),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                // top: DeviceConstraints.getResponsiveSize(context, 40, 40, 45),
                top: DeviceConstraints.getResponsiveSize(context, 65.h, 65.h, 70.h) / 2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                border: Border.all(color: theme.primaryColor, width: 2),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  // top: 20,
                  top: DeviceConstraints.getResponsiveSize(context, 65.h, 65.h, 70.h) / 3.5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        ((reviewUser == null || reviewUser == '' || reviewUser!.isEmpty) ? 'bnb user' : reviewUser!).toUpperCase(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5),
                    //   child: RatingBar.builder(
                    //     initialRating: reviewStars ?? 5,
                    //     minRating: 0,
                    //     direction: Axis.horizontal,
                    //     allowHalfRating: false,
                    //     itemSize: 17,
                    //     itemCount: 5,
                    //     updateOnDrag: true,
                    //     unratedColor: Colors.grey,
                    //     onRatingUpdate: (rating) {},
                    //     itemBuilder: (context, _) {
                    //       return Icon(
                    //         Icons.star,
                    //         color: theme.primaryColorDark,
                    //       );
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: SvgPicture.asset(
                              ThemeIcons.leftQuote,
                              height: DeviceConstraints.getResponsiveSize(context, 17.sp, 18.sp, 18.sp),
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
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 18.sp, 18.sp),
                                fontWeight: FontWeight.w400,
                                color: (themeType == ThemeType.GlamLight) ? Colors.black : Colors.white,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                              ThemeIcons.rightQuote,
                              height: DeviceConstraints.getResponsiveSize(context, 17.sp, 18.sp, 18.sp),
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: DeviceConstraints.getResponsiveSize(context, 65.h, 65.h, 70.h),
            width: DeviceConstraints.getResponsiveSize(context, 65.h, 65.h, 70.h),
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

class ReviewCardWithoutAvatar extends ConsumerWidget {
  final String? reviewUser, review;
  final double? reviewStars;

  const ReviewCardWithoutAvatar({
    Key? key,
    required this.reviewUser,
    required this.review,
    required this.reviewStars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      // height: DeviceConstraints.getResponsiveSize(context, 400.h, 400.h, 400.h),

      // width: DeviceConstraints.getResponsiveSize(context, 260.w, 260.w, 110.w),

      width: DeviceConstraints.getResponsiveSize(
        context,
        (size.width - 40.w),
        (size.width - 100.w),
        ((size.width - 100.w - 60) / 3),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: theme.primaryColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 0,
              child: Text(
                ((reviewUser == null || reviewUser == '' || reviewUser!.isEmpty) ? 'bnb user' : reviewUser!).toUpperCase(),
                style: theme.textTheme.bodyLarge?.copyWith(
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
            SizedBox(
              height: 120.h,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
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
                        style: theme.textTheme.titleMedium?.copyWith(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
