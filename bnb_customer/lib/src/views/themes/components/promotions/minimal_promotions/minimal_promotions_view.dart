import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MiniamlPromotionView extends ConsumerStatefulWidget {
  final List<PromotionModel> salonPromotionsList;

  const MiniamlPromotionView({Key? key, required this.salonPromotionsList}) : super(key: key);

  @override
  ConsumerState<MiniamlPromotionView> createState() => _MiniamlPromotionViewState();
}

class _MiniamlPromotionViewState extends ConsumerState<MiniamlPromotionView> {
  late PromotionModel initialPromotion;
  @override
  void initState() {
    setInitialPromotion();
    super.initState();
  }

  setInitialPromotion() {
    setState(() {
      initialPromotion = widget.salonPromotionsList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    // List<PromotionModel> salonPromotionsList = widget.salonPromotionsList;

    ThemeType themeType = _salonProfileProvider.themeType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (AppLocalizations.of(context)?.promotions ?? 'Promotions').toUpperCase(),
              style: theme.textTheme.displayMedium?.copyWith(
                // fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 60.sp),
              ),
            ),
            PrevAndNextButtons(
              backOnTap: () {},
              forwardOnTap: () {},
            ),
          ],
        ),
        SizedBox(
          height: DeviceConstraints.getResponsiveSize(context, 15.h, 20.h, 30.h),
        ),
        (widget.salonPromotionsList.isNotEmpty)
            ? (isPortrait)
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8, // 700.h,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Expanded(
                          flex: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  height: 200.h,
                                  width: double.infinity,
                                  child: CachedImage(
                                    url: '${initialPromotion.promotionImage}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${initialPromotion.promotionTitle}".toUpperCase(),
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 20.sp, 25.sp),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${initialPromotion.promotionDescription}',
                                maxLines: 4,
                                overflow: TextOverflow.clip,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35, // 300.h,
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.35, // 300.h,
                                  // color: Colors.blue,
                                  child: ListView.separated(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) => const SizedBox(width: 30),
                                    itemCount: widget.salonPromotionsList.length,
                                    itemBuilder: ((context, index) {
                                      final PromotionModel promotion = widget.salonPromotionsList.reversed.toList()[index];
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              initialPromotion = promotion;
                                            });
                                          },
                                          child: SizedBox(
                                            // height: MediaQuery.of(context).size.height * 0.17, // 150.h,
                                            width: MediaQuery.of(context).size.width - 40.w,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 200.sp,
                                                  width: double.infinity,
                                                  child: CachedImage(
                                                    url: '${promotion.promotionImage}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "${promotion.promotionTitle}".toUpperCase(), //  ${initialPromotion.discountUnit}
                                                      style: theme.textTheme.displaySmall?.copyWith(
                                                        fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 22.sp),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      '${promotion.promotionDescription}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.clip,
                                                      style: theme.textTheme.bodyMedium?.copyWith(
                                                        color: theme.primaryColor,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    // const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SquareButton(
                              width: 200.sp,
                              text: 'GET A DISCOUNT',
                              borderColor: theme.primaryColor, // black
                              // textColor: (themeType == ThemeType.GlamMinimalLight) ? Colors.black : Colors.white, // black
                              // buttonColor: (themeType == ThemeType.GlamMinimalLight) ? Colors.white : Colors.black,
                              buttonColor: theme.cardColor,
                              textColor: theme.primaryColor,

                              showSuffix: false,
                              textSize: 16.sp, buttonWidth: 1,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 600.h,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    // height: 300,
                                    width: double.infinity,

                                    child: CachedImage(
                                      url: '${initialPromotion.promotionImage}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  ("${AppLocalizations.of(context)?.discounts ?? "Discounts}"} ${initialPromotion.promotionDiscount}%").toUpperCase(), //  ${initialPromotion.discountUnit}
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontSize: DeviceConstraints.getResponsiveSize(context, 17.sp, 20.sp, 25.sp),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '${initialPromotion.promotionDescription}',
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.primaryColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SquareButton(
                                      text: 'GET A DISCOUNT',
                                      borderColor: theme.primaryColor, // black
                                      textColor: (themeType == ThemeType.GlamMinimalLight) ? Colors.black : Colors.white, // black
                                      buttonColor: (themeType == ThemeType.GlamMinimalLight) ? Colors.white : Colors.black,
                                      showSuffix: false,
                                      textSize: 16.sp,
                                      width: 200.sp,
                                      buttonWidth: 1,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          flex: 2,
                          child: ListView.separated(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const SizedBox(height: 30),
                            itemCount: widget.salonPromotionsList.length,
                            itemBuilder: ((context, index) {
                              final PromotionModel promotion = widget.salonPromotionsList.reversed.toList()[index];
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      initialPromotion = promotion;
                                    });
                                  },
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.17, // 150.h,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.17,
                                            child: CachedImage(
                                              url: '${promotion.promotionImage}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "${promotion.promotionTitle}".toUpperCase(),
                                                style: theme.textTheme.displaySmall?.copyWith(
                                                  fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 22.sp),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                '${promotion.promotionDescription}',
                                                maxLines: 4,
                                                overflow: TextOverflow.clip,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: theme.primaryColor,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              // const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  )

            // NO PROMOTIONS
            : NoSectionYet(
                text: AppLocalizations.of(context)?.noPromotions ?? 'No promotions at the moment',
                color: theme.colorScheme.secondary,
              ),
      ],
    );
  }
}
