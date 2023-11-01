import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PortraitCarousel extends ConsumerStatefulWidget {
  final CarouselController controller;
  final List<PromotionModel> salonPromotionsList;

  const PortraitCarousel({Key? key, required this.controller, required this.salonPromotionsList}) : super(key: key);

  @override
  ConsumerState<PortraitCarousel> createState() => _PortraitCarouselState();
}

class _PortraitCarouselState extends ConsumerState<PortraitCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: double.infinity,
            // color: Colors.red,
            child: GlamLightPromotionCarousel(
              controller: widget.controller,
              salonPromotionsList: widget.salonPromotionsList,
              viewportFraction: 1,
            ),
          ),
        ),
        SizedBox(height: DeviceConstraints.getResponsiveSize(context, 40, 60, 60)),
        if (widget.salonPromotionsList[0].promotionImage != '' || widget.salonPromotionsList[0].promotionImage != null)
          Expanded(
            flex: 1,
            child: OvalImage(
              image: '${widget.salonPromotionsList[0].promotionImage}',
            ),
          ),
      ],
    );
  }
}

class GlamLightPromotionCarousel extends ConsumerWidget {
  final CarouselController controller;
  final List<PromotionModel> salonPromotionsList;
  final double viewportFraction;

  const GlamLightPromotionCarousel({
    Key? key,
    required this.controller,
    required this.salonPromotionsList,
    required this.viewportFraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return CarouselSlider(
      carouselController: controller,
      options: CarouselOptions(
        scrollPhysics: const AlwaysScrollableScrollPhysics(),
        autoPlay: true,
        pauseAutoPlayOnTouch: true,
        viewportFraction: viewportFraction,
        padEnds: false,
      ),
      items: salonPromotionsList.map(
        (promotion) {
          return Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)?.discounts ?? "Discounts"}  ${promotion.promotionDiscount}%".toUpperCase(),
                      style: theme.textTheme.displayMedium?.copyWith(fontSize: 25.sp),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        '${promotion.promotionDescription}',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OvalButton(
                      text: 'Get a discount',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Container(width: 1, color: Colors.black),
              )
            ],
          );
        },
      ).toList(),
    );
  }
}

class OvalImage extends StatelessWidget {
  final String image;
  const OvalImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(200, 180)),
          child: CachedImage(
            url: image,
          ),
        ),
      ),
    );
  }
}
