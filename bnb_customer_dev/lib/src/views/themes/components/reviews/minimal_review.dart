import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'widgets/section_title.dart';

class MinimalReviewView extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final CarouselController controller;

  const MinimalReviewView({Key? key, required this.salonModel, required this.controller}) : super(key: key);

  @override
  ConsumerState<MinimalReviewView> createState() => _MinimalReviewViewState();
}

class _MinimalReviewViewState extends ConsumerState<MinimalReviewView> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 50.h, 80.h, 100.h),
        // bottom: DeviceConstraints.getResponsiveSize(context, 140.h, 180.h, 200.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReviewSectionTitle(
            salonModel: widget.salonModel,
            controller: widget.controller,
            itemPositionsListener: itemPositionsListener,
            itemScrollController: itemScrollController,
          ),
          const SizedBox(height: 40),
          (_salonProfileProvider.salonReviews.isNotEmpty)
              ? MinimalReviewBuilder(
                  itemPositionsListener: itemPositionsListener,
                  itemScrollController: itemScrollController,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noReviews ?? 'No reviews yet').toUpperCase(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 30.h),
          // InkWell(
          //   onTap: () {
          //     print(size.width - 100.w - 20);
          //   },
          //   child: Row(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(right: 20),
          //         child: Container(
          //           height: size.height * 0.22,
          //           width: (size.width - 100.w - 60) / 3,
          //           color: Colors.red,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 20),
          //         child: Container(
          //           height: size.height * 0.22,
          //           width: (size.width - 100.w - 60) / 3,
          //           color: Colors.red,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 20),
          //         child: Container(
          //           height: size.height * 0.22,
          //           width: (size.width - 100.w - 60) / 3,
          //           color: Colors.red,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MinimalReviewBuilder extends ConsumerStatefulWidget {
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const MinimalReviewBuilder({Key? key, required this.itemPositionsListener, required this.itemScrollController}) : super(key: key);

  @override
  ConsumerState<MinimalReviewBuilder> createState() => _MinimalReviewBuilderState();
}

class _MinimalReviewBuilderState extends ConsumerState<MinimalReviewBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    return SizedBox(
      height: DeviceConstraints.getResponsiveSize(
        context,
        size.height * 0.22, // 300.h,
        size.height * 0.22, // 250.h,
        size.height * 0.22,
      ),
      width: double.infinity,
      child: ScrollablePositionedList.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _salonProfileProvider.salonReviews.length,
        itemBuilder: (context, index) {
          final ReviewModel review = _salonProfileProvider.salonReviews[index];

          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: MinimalReviewCard(review: review),
          );
        },
        scrollDirection: Axis.horizontal,
        itemScrollController: widget.itemScrollController,
        itemPositionsListener: widget.itemPositionsListener,
      ),
    );
  }
}

class MinimalReviewCard extends ConsumerWidget {
  final ReviewModel review;
  const MinimalReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.22, // 300.h,j
      // width: size.width * 0.3, // .infinity,
      width: DeviceConstraints.getResponsiveSize(
        context,
        (size.width - 40.w),
        (size.width - 100.w),
        ((size.width - 100.w - 60) / 3),
      ),

      //  isTab ? (size.width - 100.w - 60) / 3 : (size.width - 40.w),

      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80.h,
                  width: 80.h,
                  // color: Colors.green,
                  child: (review.customerPic != '')
                      ? CachedImage(
                          url: review.customerPic,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (review.customerName == '' || review.customerName.isEmpty) ? 'bnb user' : review.customerName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: 3, // reviewStars ?? 5,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemSize: 15,
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
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SvgPicture.asset(
                      ThemeIcons.leftQuote,
                      height: 15,
                      color: theme.primaryColor,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      review.review,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16.sp,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
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
          ],
        ),
      ),
    );
  }
}
