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

  const ReviewBuilder({Key? key, required this.controller, this.itemPositionsListener, this.itemScrollController}) : super(key: key);

  @override
  ConsumerState<ReviewBuilder> createState() => _ReviewBuilderState();
}

class _ReviewBuilderState extends ConsumerState<ReviewBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return SizedBox(
      height: DeviceConstraints.getResponsiveSize(
        context,
        size.height * 0.3, // 300.h,
        size.height * 0.3, // 250.h,
        size.height * 0.3,
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
                    reviewUser: review.customerName != '' ? review.customerName : 'bnb user',
                    review: review.review,
                    reviewStars: review.rating,
                  )
                : ReviewCard(
                    avatar: review.customerPic,
                    reviewUser: review.customerName != '' ? review.customerName : 'bnb user', // 'Jocelyn Francis',
                    review: review.review, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis.',
                    reviewStars: review.rating,
                  ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemScrollController: widget.itemScrollController,
        itemPositionsListener: widget.itemPositionsListener,
      ),
    );
  }
}
