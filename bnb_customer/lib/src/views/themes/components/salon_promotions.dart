import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_profile.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/oval_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonPromotions extends ConsumerStatefulWidget {
  const SalonPromotions({Key? key}) : super(key: key);

  @override
  ConsumerState<SalonPromotions> createState() => _SalonPromotionsState();
}

class _SalonPromotionsState extends ConsumerState<SalonPromotions> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isLandscape = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.landScape);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: 50,
        bottom: 50,
      ),
      child: Column(
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
                backOnTap: () => _controller.previousPage(),
                forwardOnTap: () => _controller.nextPage(),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          SizedBox(
            height: DeviceConstraints.getResponsiveSize(context, 400.h, 400.h, 300.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!isPortrait && !isLandscape)
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      // color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)?.discounts ?? "Discounts"}  ${_createAppointmentProvider.salonPromotions[0].promotionDiscount} ${_createAppointmentProvider.salonPromotions[0].discountUnit == "PCT(%)" ? '%' : '₴'}".toUpperCase(),
                            style: theme.textTheme.headline3?.copyWith(
                              // color: GlamOneTheme.deepOrange,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 25.sp, 35.sp),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${_createAppointmentProvider.salonPromotions[0].promotionDescription}',
                            style: theme.textTheme.bodyText2?.copyWith(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                  ),
                if (!isPortrait) const SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    // height: DeviceConstraints.getResponsiveSize(context, 450.h, 400.h, 450.h),
                    // width: 200,

                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        autoPlay: true,
                        pauseAutoPlayOnTouch: true,
                        viewportFraction: DeviceConstraints.getResponsiveSize(context, 0.9, 0.5, 0.35),
                        height: 450.h,
                      ),
                      items: _createAppointmentProvider.salonPromotions
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isPortrait || isLandscape)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // TODO - LOCALIZATIONS
                                          "Discounts ${item.promotionDiscount} ${item.discountUnit == "PCT(%)" ? '%' : '₴'}".toUpperCase(),
                                          style: theme.textTheme.headline3?.copyWith(
                                            // color: GlamOneTheme.deepOrange,
                                            fontSize: 30.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200.w,
                                          child: Text(
                                            '${item.promotionDescription}',
                                            style: theme.textTheme.bodyText2?.copyWith(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  SizedBox(
                                    width: 350.h,
                                    height: 200.h,
                                    // height: DeviceConstraints.getResponsiveSize(context, 210.h, 260.h, 250.h),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedImage(
                                        url: '${item.promotionImage}',
                                        fit: BoxFit.cover,
                                        height: 200.h,
                                        width: 350.h,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    getPromotionType(type: item.promotionType!),
                                    // '${_promo.promotionTitle}',
                                    style: theme.textTheme.headline3?.copyWith(
                                      color: theme.primaryColor,
                                      fontSize: 20.sp,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isPortrait) const SizedBox(height: 30),
          if (isPortrait || isLandscape)
            Center(
              child: (_salonProfileProvider.theme == '2' || _salonProfileProvider.theme == '4')
                  ? SquareButton(
                      text: 'GET A DISCOUNT',
                      height: 50.h,
                      // width: 250.h,
                      buttonColor: Colors.transparent,
                      borderColor: Colors.white,
                      textColor: Colors.white,
                      textSize: 15.sp,
                      onTap: () {},
                    )
                  : OvalButton(
                      width: 180.h,
                      height: 60.h,
                      textSize: 18.sp,
                      text: 'Get a discount',
                      onTap: () {
                        print(_createAppointmentProvider.salonPromotions);
                      },
                    ),
            ),
        ],
      ),
    );
  }
}

class PrevAndNext extends ConsumerWidget {
  final VoidCallback backOnTap;
  final VoidCallback forwardOnTap;

  const PrevAndNext({Key? key, required this.backOnTap, required this.forwardOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: (_salonProfileProvider.theme != '2')
                ? SvgPicture.asset(
                    ThemeIcons.leftArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_back,
                    size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                    color: Colors.white,
                  ),
          ),
          SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
          GestureDetector(
            onTap: forwardOnTap,
            child: (_salonProfileProvider.theme != '2')
                ? SvgPicture.asset(
                    ThemeIcons.rightArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_forward,
                    size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                    color: theme.primaryColor,
                  ),
          ),
        ],
      ),
    );
  }
}
