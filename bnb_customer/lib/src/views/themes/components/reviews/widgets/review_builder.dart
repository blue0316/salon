import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/review.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/reviews/widgets/review_card.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReviewBuilder extends ConsumerStatefulWidget {
  final CarouselController controller;
  final ItemScrollController? itemScrollController;
  final ItemPositionsListener? itemPositionsListener;

  const ReviewBuilder({
    Key? key,
    required this.controller,
    this.itemPositionsListener,
    this.itemScrollController,
  }) : super(key: key);

  @override
  ConsumerState<ReviewBuilder> createState() => _ReviewBuilderState();
}

class _ReviewBuilderState extends ConsumerState<ReviewBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

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
            child: (themeType == ThemeType.Barbershop)
                ? ReviewCardWithoutAvatar(
                    reviewUser: review.customerName != ''
                        ? review.customerName
                        : 'bnb user',
                    review: review.review,
                    reviewStars: review.rating,
                  )
                : ReviewCard(
                    avatar: review.customerPic,
                    reviewUser: review.customerName != ''
                        ? review.customerName
                        : 'bnb user', // 'Jocelyn Francis',
                    review: review
                        .review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                    reviewStars: review.rating,
                  ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemScrollController: widget.itemScrollController,
        itemPositionsListener: widget.itemPositionsListener,
      ),
    );
    // return SizedBox(
    //   height: DeviceConstraints.getResponsiveSize(
    //     context,
    //     size.height * 0.3, // 300.h,
    //     size.height * 0.3, // 250.h,
    //     size.height * 0.3,
    //   ),
    //   width: double.infinity,
    //   child: CarouselSlider(
    //     carouselController: widget.controller,
    //     options: CarouselOptions(
    //       scrollPhysics: const AlwaysScrollableScrollPhysics(),
    //       autoPlay: false,
    //       pauseAutoPlayOnTouch: true,
    //       viewportFraction: DeviceConstraints.getResponsiveSize(context, 1, 0.9, 0.4),
    //       // height: DeviceConstraints.getResponsiveSize(
    //       //     context, 280.h, 320, 350.h),
    //     ),
    //     items: _salonProfileProvider.salonReviews.map(
    //       (review) {
    //         return Padding(
    //           padding: EdgeInsets.only(right: DeviceConstraints.getResponsiveSize(context, 10, 20, 30)),
    // child: (themeType == ThemeType.Barbershop)
    //     ? ReviewCardWithoutAvatar(
    //         reviewUser: review.customerName != '' ? review.customerName : 'bnb user',
    //         review: review.review,
    //         reviewStars: review.rating,
    //       )
    //     : ReviewCard(
    //         avatar: review.customerPic,
    //         reviewUser: review.customerName != '' ? review.customerName : 'bnb user', // 'Jocelyn Francis',
    //         review: review.review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
    //         reviewStars: review.rating,
    //       ),
    //         );
    //       },
    //     ).toList(),
    //   ),
    // );
  }
}


// class MinimalReviewCard extends ConsumerWidget {
//   final ReviewModel review;
//   const MinimalReviewCard({Key? key, required this.review}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isTab = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab);

//     final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
//     final ThemeData theme = _salonProfileProvider.salonTheme;
//     final size = MediaQuery.of(context).size;

//     return Container(
//       height: size.height * 0.22, // 300.h,j
//       // width: size.width * 0.3, // .infinity,
//       width: DeviceConstraints.getResponsiveSize(
//         context,
//         (size.width - 40.w),
//         (size.width - 100.w),
//         ((size.width - 100.w - 60) / 3),
//       ),

//       //  isTab ? (size.width - 100.w - 60) / 3 : (size.width - 40.w),

//       decoration: BoxDecoration(
//         border: Border.all(color: theme.primaryColor),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 80.h,
//                   width: 80.h,
//                   // color: Colors.green,
//                   child: (review.customerPic != '')
//                       ? CachedImage(
//                           url: review.customerPic,
//                           fit: BoxFit.cover,
//                         )
//                       : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
//                 ),
//                 const SizedBox(width: 15),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       (review.customerName == '' || review.customerName.isEmpty) ? 'bnb user' : review.customerName,
//                       style: theme.textTheme.bodyText1?.copyWith(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 10),
//                     RatingBar.builder(
//                       initialRating: 3, // reviewStars ?? 5,
//                       minRating: 0,
//                       direction: Axis.horizontal,
//                       allowHalfRating: false,
//                       itemSize: 15,
//                       itemCount: 5,
//                       updateOnDrag: true,
//                       unratedColor: Colors.grey,
//                       onRatingUpdate: (rating) {},
//                       itemBuilder: (context, _) {
//                         return Icon(
//                           Icons.star,
//                           color: theme.primaryColorDark,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: SvgPicture.asset(
//                       ThemeIcons.leftQuote,
//                       height: 15,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                   Flexible(
//                     child: Text(
//                       review.review,
//                       style: theme.textTheme.bodyText1?.copyWith(
//                         fontSize: 16.sp,
//                       ),
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.clip,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: SvgPicture.asset(
//                       ThemeIcons.rightQuote,
//                       height: 15,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
