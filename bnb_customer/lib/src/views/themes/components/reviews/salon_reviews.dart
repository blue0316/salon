import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/components/reviews/gentle_touch_review.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'default_review_view.dart';
import 'minimal_review.dart';

class SalonReviews extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonReviews({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonReviews> createState() => _SalonReviewsState();
}

class _SalonReviewsState extends ConsumerState<SalonReviews> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    ThemeType themeType = _salonProfileProvider.themeType;

    return reviewsSectionTheme(
      context,
      themeType: themeType,
      salon: widget.salonModel,
      controller: _controller,
    );
  }
}

Widget reviewsSectionTheme(context, {required ThemeType themeType, required SalonModel salon, required CarouselController controller}) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return MinimalReviewView(salonModel: salon, controller: controller);

    case ThemeType.GlamMinimalDark:
      return MinimalReviewView(salonModel: salon, controller: controller);

    case ThemeType.GlamLight:
      return GentleTouchReviewView(salonModel: salon, controller: controller);

    default:
      return DefaultReviewsView(salonModel: salon, controller: controller);
  }
}
