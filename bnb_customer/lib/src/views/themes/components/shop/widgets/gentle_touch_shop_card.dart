import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/widgets/button.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GentleTouchShopCard extends ConsumerStatefulWidget {
  final ProductModel product;

  const GentleTouchShopCard({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<GentleTouchShopCard> createState() => _GentleTouchShopCardState();
}

class _GentleTouchShopCardState extends ConsumerState<GentleTouchShopCard> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final controller = ref.watch(themeController);

    // final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: EdgeInsets.only(right: 20.sp, top: 2, bottom: isHovered ? 0 : 100.h, left: 5),
      child: MouseRegion(
        onEnter: (event) {
          onEntered(true);
          _salonProfileProvider.setIsHovered(true);
        },
        onExit: (event) {
          onEntered(false);
          _salonProfileProvider.setIsHovered(false);
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: !isHovered ? (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black) : theme.colorScheme.secondary,
            border: Border.all(
              color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
              width: 0.3,
            ),
          ),
          // color: Colors.orange,
          width: DeviceConstraints.getResponsiveSize(
            context,
            size / 1.5.sp,
            size / 2.3.sp,
            70.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeType == ThemeType.GentleTouch ? Colors.white : Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                        width: 0.3,
                      ),
                    ),
                  ),
                  // height: 300.h,
                  width: DeviceConstraints.getResponsiveSize(
                    context,
                    size / 1.5.sp,
                    size / 2.3.sp,
                    70.w,
                  ),

                  child: (widget.product.productImageUrlList!.isNotEmpty)
                      ? CachedImage(
                          url: '${widget.product.productImageUrlList![0]}',
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          themeType == ThemeType.GentleTouch ? ThemeImages.noProduct : ThemeImages.noProductDark,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // SizedBox(height: 10.sp),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40.sp,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${widget.product.productName}'.toUpperCase(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isHovered ? Colors.white : theme.primaryColorDark,
                                fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 16.sp),
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      Text(
                        '\$${widget.product.clientPrice}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isHovered ? Colors.white : theme.primaryColorLight,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 16.sp),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isHovered)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        (widget.product.productDescription ?? '').toTitleCase(),
                        // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.primaryColorDark,
                          fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.sp),
                      Center(
                        child: SquareButton(
                          text: (AppLocalizations.of(context)?.contactUs ?? "Contact Us"),
                          buttonColor: Colors.transparent,
                          textColor: Colors.white,
                          borderColor: Colors.white,
                          textSize: 15.sp,
                          showSuffix: false,
                          weight: FontWeight.w500,
                          buttonWidth: 0.8,
                          borderRadius: 1.5,
                          // vSpacing: 2,
                          width: DeviceConstraints.getResponsiveSize(context, size / 1.5.sp, size / 2.3.sp, 70.w) / 2,
                          height: 40.h,
                          onTap: () {
                            Scrollable.ensureVisible(
                              controller.contacts.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 5.sp),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
