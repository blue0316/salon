import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReviewSectionTitle extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final CarouselController? controller;
  final ItemScrollController? itemScrollController;
  final ItemPositionsListener? itemPositionsListener;

  const ReviewSectionTitle({
    Key? key,
    required this.salonModel,
    required this.controller,
    this.itemPositionsListener,
    this.itemScrollController,
  }) : super(key: key);

  @override
  ConsumerState<ReviewSectionTitle> createState() => _ReviewSectionTitleState();
}

class _ReviewSectionTitleState extends ConsumerState<ReviewSectionTitle> {
  int tabInitial = 3;
  int portraitInitial = 1;

  @override
  Widget build(BuildContext context) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final ThemeType themeType = _salonProfileProvider.themeType;

    final _ratingStr = widget.salonModel.avgRating.toString();

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
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
              ),
            ),
            PrevAndNextButtons(
              forwardColor: theme.primaryColorDark,
              backOnTap: isTab
                  ? () {
                      if (tabInitial < 3) return;
                      setState(() {
                        tabInitial -= 3;
                      });

                      widget.itemScrollController?.jumpTo(index: tabInitial);

                      // => controller!.previousPage()
                    }
                  : () {
                      if (portraitInitial < 1) return;
                      setState(() {
                        portraitInitial -= 1;
                      });

                      widget.itemScrollController?.jumpTo(index: portraitInitial);
                    },
              forwardOnTap: isTab
                  ? () {
                      widget.itemScrollController?.jumpTo(index: tabInitial);

                      setState(() {
                        tabInitial += 3;
                      });
                      //  => controller!.nextPage()
                    }
                  : () {
                      widget.itemScrollController?.jumpTo(index: portraitInitial);
                      setState(() {
                        portraitInitial += 1;
                      });
                    },
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18.sp,
                color: bottomDetailsColor(themeType, theme),
              ),
            ),
            SizedBox(
              width: DeviceConstraints.getResponsiveSize(context, 30.sp, 70.sp, 150.sp),
            ),

            // RatingBar.builder(
            //   initialRating: widget.salonModel.avgRating,
            //   minRating: 0,
            //   direction: Axis.horizontal,
            //   allowHalfRating: false,
            //   itemSize: 20,
            //   itemCount: 5,
            //   updateOnDrag: true,
            //   glowColor: Colors.yellow,
            //   glow: true,
            //   glowRadius: 10,
            //   unratedColor: Colors.grey,
            //   onRatingUpdate: (rating) {},
            //   itemBuilder: (context, _) {
            //     return Icon(
            //       Icons.star,
            //       color: theme.primaryColorDark,
            //     );
            //   },
            // ),
            // const SizedBox(width: 15),
            Text(
              "${_salonProfileProvider.salonReviews.length} ${AppLocalizations.of(context)?.reviews ?? 'Reviews'}",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 18.sp,
                decoration: TextDecoration.underline,
                color: bottomDetailsColor(themeType, theme),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Color bottomDetailsColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.Barbershop:
      return Colors.white;

    default:
      return theme.primaryColor;
  }
}
