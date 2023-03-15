import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewSectionTitle extends ConsumerWidget {
  final SalonModel salonModel;
  final CarouselController controller;

  const ReviewSectionTitle({Key? key, required this.salonModel, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final _ratingStr = salonModel.avgRating.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (AppLocalizations.of(context)?.reviews ?? 'Reviews').toUpperCase(),
              style: theme.textTheme.headline2?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
              ),
            ),
            PrevAndNextButtons(
              backOnTap: () => controller.previousPage(),
              forwardOnTap: () => controller.nextPage(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _ratingStr.length > 3 ? _ratingStr.substring(0, 3) : _ratingStr, // "4,5",
              style: theme.textTheme.bodyText1?.copyWith(
                fontSize: 18.sp,
              ),
            ),
            const SizedBox(width: 15),
            RatingBar.builder(
              initialRating: salonModel.avgRating,
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
      ],
    );
  }
}
