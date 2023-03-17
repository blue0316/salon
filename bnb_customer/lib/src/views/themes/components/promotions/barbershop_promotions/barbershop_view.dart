// Theme 4 - Barbershop Promotions

import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarbershopPromotions extends ConsumerStatefulWidget {
  final List<PromotionModel> salonPromotionsList;

  const BarbershopPromotions({Key? key, required this.salonPromotionsList})
      : super(key: key);

  @override
  ConsumerState<BarbershopPromotions> createState() =>
      _BarbershopPromotionsState();
}

class _BarbershopPromotionsState extends ConsumerState<BarbershopPromotions> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    List<PromotionModel> ls = [
      ...widget.salonPromotionsList,
      ...widget.salonPromotionsList
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (AppLocalizations.of(context)?.promotions ?? 'Promotions')
                  .toUpperCase(),
              style: theme.textTheme.headline2?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(
                    context, 30.sp, 40.sp, 50.sp),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _controller.previousPage(),
                  child: Icon(
                    Icons.arrow_back,
                    size: DeviceConstraints.getResponsiveSize(
                        context, 30.sp, 40.sp, 50.sp),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                    width: DeviceConstraints.getResponsiveSize(
                        context, 15, 30, 40)),
                GestureDetector(
                  onTap: () => _controller.nextPage(),
                  child: Icon(
                    Icons.arrow_forward,
                    size: DeviceConstraints.getResponsiveSize(
                        context, 30.sp, 40.sp, 50.sp),
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 55.h),
        Container(
          height: 300.h,
          // height: DeviceConstraints.getResponsiveSize(context, 280.h, 350.h, 350.h),

          width: double.infinity,
          // color: Colors.yellow,
          child: CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              // scrollPhysics: const AlwaysScrollableScrollPhysics(),
              autoPlay: false,
              pauseAutoPlayOnTouch: true,
              padEnds: false,
              enableInfiniteScroll: false,

              viewportFraction:
                  DeviceConstraints.getResponsiveSize(context, 0.8, 0.5, 0.333),
              // height: DeviceConstraints.getResponsiveSize(
              //     context, 280.h, 320, 350.h),
            ),
            items:
                ls // TODO: DUMMY LIST: CHANGE BACK TO widget.salonPromotionsList
                    .map((promotion) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            // color: Colors.red,
                            width: DeviceConstraints.getResponsiveSize(
                              context,
                              350.w,
                              (size.width / 1.5), // size.width / 2.5, // 380.w,
                              size.width / 3, // 350.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)?.discounts ?? "Discounts"} ${promotion.promotionDiscount} \$"
                                      .toUpperCase(),
                                  style: theme.textTheme.headline3?.copyWith(
                                    fontSize:
                                        DeviceConstraints.getResponsiveSize(
                                            context, 30.sp, 22.sp, 28.sp),
                                  ),
                                ),
                                // SizedBox(height: 10),
                                Text(
                                  '${promotion.promotionDescription}',
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  style: theme.textTheme.bodyText1?.copyWith(
                                    color: Colors.white,
                                    fontSize:
                                        DeviceConstraints.getResponsiveSize(
                                            context, 18.sp, 20.sp, 22.sp),
                                  ),
                                ),
                                // SizedBox(height: 15),

                                SquareButton(
                                  text: 'GET A DISCOUNT',
                                  height: 50.h,
                                  // width: isLandscape ?  : null,
                                  buttonColor: Colors.transparent,
                                  borderColor: Colors.white,
                                  textColor: Colors.white,
                                  textSize: 15.sp,
                                  onTap: () {},
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
          ),
        )
      ],
    );
  }
}


// SingleChildScrollView