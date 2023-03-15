import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/reviews/widgets/review_card.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewBuilder extends ConsumerStatefulWidget {
  final CarouselController controller;
  const ReviewBuilder({Key? key, required this.controller}) : super(key: key);

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
      child: CarouselSlider(
        carouselController: widget.controller,
        options: CarouselOptions(
          scrollPhysics: const AlwaysScrollableScrollPhysics(),
          autoPlay: false,
          pauseAutoPlayOnTouch: true,
          viewportFraction: DeviceConstraints.getResponsiveSize(context, 1, 0.9, 0.4),
          // height: DeviceConstraints.getResponsiveSize(
          //     context, 280.h, 320, 350.h),
        ),
        items: _salonProfileProvider.salonReviews.map(
          (review) {
            return Padding(
              padding: EdgeInsets.only(right: DeviceConstraints.getResponsiveSize(context, 10, 20, 30)),
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
        ).toList(),
      ),
    );
  }
}
