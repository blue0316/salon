import 'package:bbblient/src/utils/extensions/exstension.dart';
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
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          onEntered(true);
          _salonProfileProvider.setIsHovered(true);
        },
        onExit: (event) {
          onEntered(false);
          _salonProfileProvider.setIsHovered(false);
        },
        child: GestureDetector(
          onTap: () => showDialog<bool>(
            context: context,
            builder: (BuildContext context) => ShowFullDesc(
              product: widget.product,
            ),
          ),
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
                                  color: isHovered ? (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black) : theme.primaryColorDark,
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
                            color: isHovered ? (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black) : theme.primaryColorLight,
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
                            color: isHovered ? (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black) : theme.primaryColorLight,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 14.sp, 14.sp, 14.sp),
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.sp),
                        Center(
                          child: GentleTouchShopButton(
                            text: (AppLocalizations.of(context)?.contactUs ?? "Contact Us"),
                            // width: DeviceConstraints.getResponsiveSize(context, size / 1.5.sp, size / 2.3.sp, 70.w) / 2,
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
      ),
    );
  }
}

class GentleTouchShopButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isGradient;

  const GentleTouchShopButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isGradient = false,
  }) : super(key: key);

  @override
  ConsumerState<GentleTouchShopButton> createState() => _GentleTouchShopButtonState();
}

class _GentleTouchShopButtonState extends ConsumerState<GentleTouchShopButton> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: ElevatedButton(
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
            color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black, // (!isHovered ? Colors.black : Colors.white) : (!isHovered ? Colors.white : Colors.black),
            fontFamily: "Inter-Light",
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150.h, 50.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.5)),
          backgroundColor: (themeType == ThemeType.GentleTouch) ? theme.colorScheme.secondary : Colors.white,
          // backgroundColor: !isHovered ? Colors.transparent : theme.colorScheme.secondary,
          side: BorderSide(
            color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
            width: 0.8,
          ),
        ),
        onPressed: widget.onTap,
      ),
    );
  }
}

class ShowFullDesc extends ConsumerWidget {
  final ProductModel product;

  const ShowFullDesc({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.secondary,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    (product.productName ?? '').toUpperCase(),
                    style: TextStyle(
                      color: (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black),
                    ),
                  ),
                ),
                const SizedBox.shrink(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.clear_rounded,
                    size: 22,
                    color: (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black),
                  ),
                )
              ],
            ),
            // const Space(),
            SizedBox(height: 20.sp),
            Text(
              (product.productDescription ?? '').toTitleCase(),
              style: TextStyle(
                color: (themeType == ThemeType.GentleTouch ? Colors.white : Colors.black),
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
