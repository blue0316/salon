// ignore_for_file: prefer_final_fields

import 'package:bbblient/src/views/themes/components/promotions/salon_promotions.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bbblient/src/views/themes/components/widgets/oval_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultPromotionsView extends ConsumerStatefulWidget {
  final List<PromotionModel> salonPromotionsList;

  const DefaultPromotionsView({Key? key, required this.salonPromotionsList}) : super(key: key);

  @override
  ConsumerState<DefaultPromotionsView> createState() => _DefaultPromotionsViewState();
}

class _DefaultPromotionsViewState extends ConsumerState<DefaultPromotionsView> {
  int _currentPage = 0;
  Timer? _timer;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        PromotionModel temp = widget.salonPromotionsList.removeAt(_currentPage);

        widget.salonPromotionsList.add(temp);
      });

      pageController.animateTo(
        _currentPage + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    //
    String promotionDiscount = _createAppointmentProvider.salonPromotions[0].promotionDiscount ?? '0';
    String discountUnit = _createAppointmentProvider.salonPromotions[0].discountUnit == "PCT(%)" ? '%' : '₴';
    String promotionDescription = '${_createAppointmentProvider.salonPromotions[0].promotionDescription}';

    pageController = PageController(viewportFraction: DeviceConstraints.getResponsiveSize(context, 0.8, 0.5, 0.35));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)?.promotions ?? 'Promotions'.toUpperCase(),
              style: theme.textTheme.headline2?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
              ),
            ),
            PrevAndNext(
              backOnTap: () {
                double? index = pageController.page;

                setState(() {
                  PromotionModel temp = widget.salonPromotionsList.removeAt(widget.salonPromotionsList.length - 1);

                  widget.salonPromotionsList.insert(index!.toInt(), temp);
                });

                pageController.animateTo(
                  index!,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
              },
              forwardOnTap: () {
                double? index = pageController.page;

                setState(() {
                  PromotionModel temp = widget.salonPromotionsList.removeAt(index!.toInt());

                  widget.salonPromotionsList.add(temp);
                });

                pageController.animateTo(
                  index! + 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
              }, // _controller.nextPage(),
            ),
          ],
        ),
        SizedBox(height: 50.h),
        if (isPortrait)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppLocalizations.of(context)?.discounts ?? "Discounts"}  $promotionDiscount $discountUnit".toUpperCase(),
                style: theme.textTheme.headline3?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 22.sp, 28.sp),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                promotionDescription,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText2?.copyWith(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
              const SizedBox(height: 10),
              (_salonProfileProvider.theme == '2' || _salonProfileProvider.theme == '4')
                  ? SquareButton(
                      text: 'GET A DISCOUNT',
                      height: 50.h,
                      // width: isLandscape ?  : null,
                      buttonColor: Colors.transparent,
                      borderColor: Colors.white,
                      textColor: Colors.white,
                      textSize: 15.sp,
                      onTap: () {},
                    )
                  : OvalButton(
                      text: 'Get a discount',
                      onTap: () {
                        // _salonProfileProvider.chosenSalon.prom;
                      },
                    ),
              const SizedBox(height: 30),
            ],
          ),
        SizedBox(
          height: 250.h,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: DeviceConstraints.getResponsiveSize(context, 0, size.width * 0.25, size.width * 0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)?.discounts ?? "Discounts"}  $promotionDiscount $discountUnit".toUpperCase(),
                      style: theme.textTheme.headline3?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 22.sp, 28.sp),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      promotionDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2?.copyWith(
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                    ),
                    const SizedBox(height: 10),
                    (_salonProfileProvider.theme == '2' || _salonProfileProvider.theme == '4')
                        ? SquareButton(
                            text: 'GET A DISCOUNT',
                            height: 50.h,
                            // width: isLandscape ?  : null,
                            buttonColor: Colors.transparent,
                            borderColor: Colors.white,
                            textColor: Colors.white,
                            textSize: 15.sp,
                            onTap: () {},
                          )
                        : OvalButton(
                            text: 'Get a discount',
                            onTap: () {
                              // _salonProfileProvider.chosenSalon.prom;
                            },
                          ),
                  ],
                ),
              ),
              if (!isPortrait) SizedBox(width: 25.w),
              Expanded(
                flex: 0,
                child: SizedBox(
                  width: DeviceConstraints.getResponsiveSize(context, size.width - 40.w, size.width * 0.55, size.width * 0.5),
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    padEnds: false,
                    // physics: NeverScrollableScrollPhysics(),

                    children: widget.salonPromotionsList.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: (widget.salonPromotionsList.indexOf(item) == 0)
                            ? LandscapePageViewElement(
                                image: '${item.promotionImage}',
                                text: getPromotionType(type: item.promotionType!),
                              )
                            : ColorFiltered(
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                                child: LandscapePageViewElement(
                                  image: '${item.promotionImage}',
                                  text: getPromotionType(type: item.promotionType!),
                                ),
                              ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LandscapePageViewElement extends ConsumerWidget {
  final String image, text;

  const LandscapePageViewElement({Key? key, required this.image, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    //
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            child: CachedImage(
              url: image,
              fit: BoxFit.cover,
              height: 200.h,
              width: 350.h,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: theme.textTheme.headline3?.copyWith(
            color: theme.primaryColor,
            fontSize: 20.sp,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
