import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/gentle_touch_shop_card.dart';

class GentleTouchShop extends ConsumerStatefulWidget {
  const GentleTouchShop({Key? key}) : super(key: key);

  @override
  ConsumerState<GentleTouchShop> createState() => _GentleTouchShopState();
}

class _GentleTouchShopState extends ConsumerState<GentleTouchShop> {
  String? currentSelectedEntry;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
        bottom: 50,
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'Products'.toUpperCase(),
              // (AppLocalizations.of(context)?.produc ?? 'Shop').toUpperCase(),
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
              ),
            ),
          ),
          _salonProfileProvider.allProducts.isNotEmpty ? SizedBox(height: 60.sp) : const SizedBox(height: 50),
          (_salonProfileProvider.allProducts.isNotEmpty)
              ? isPortrait
                  ? PortraitView(
                      items: [
                        'All',
                        ..._salonProfileProvider.tabs.keys.toList(),
                      ],
                    )
                  : Expanded(
                      flex: 0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 420.h, //  _salonProfileProvider.isHovered ? 410.h : 360.h,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ListView(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GentleTouchShopTab(
                                        title: AppLocalizations.of(context)?.all ?? 'All',
                                        showTab: currentSelectedEntry == null,
                                        onTap: () => setState(() => currentSelectedEntry = null),
                                      ),

                                      // OTHER TABS
                                      ..._salonProfileProvider.tabs.entries
                                          .map(
                                            (entry) => Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20.sp),
                                              child: GentleTouchShopTab(
                                                title: entry.key.toUpperCase(),
                                                showTab: currentSelectedEntry == entry.key,
                                                onTap: () => setState(() => currentSelectedEntry = entry.key),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 60.sp),
                                Expanded(
                                  flex: 3,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: (currentSelectedEntry == null) ? _salonProfileProvider.allProducts.length : _salonProfileProvider.tabs[currentSelectedEntry]?.length,
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      // ALL
                                      if (currentSelectedEntry == null) {
                                        final ProductModel product = _salonProfileProvider.allProducts[index];
                                        return GentleTouchShopCard(product: product);
                                      }
                                      // OTHER TABS
                                      else {
                                        final ProductModel product = _salonProfileProvider.tabs[currentSelectedEntry]![index];
                                        return GentleTouchShopCard(product: product);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.sp),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PrevAndNextButtons(
                                backOnTap: () {},
                                forwardOnTap: () {},
                                leftFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                                rightFontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 15.sp, 18.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      (AppLocalizations.of(context)?.noItemsAvailable ?? 'No items available for sale').toUpperCase(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class GentleTouchShopTab extends ConsumerWidget {
  final String title;
  final VoidCallback onTap;
  final bool showTab;

  const GentleTouchShopTab({Key? key, required this.title, required this.onTap, required this.showTab}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: Container(
                height: 1.7,
                width: 20.w,
                color: showTab ? (themeType == ThemeType.GentleTouch ? Colors.black : Colors.white) : Colors.transparent,
              ),
            ),
            SizedBox(width: 30.sp),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 15.sp, 20.sp, 40.sp),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortraitView extends ConsumerStatefulWidget {
  final List<String> items;

  const PortraitView({Key? key, required this.items}) : super(key: key);

  @override
  ConsumerState<PortraitView> createState() => _PortraitViewState();
}

class _PortraitViewState extends ConsumerState<PortraitView> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  String dropdownvalue = 'All';

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton(
          // Initial Value
          value: dropdownvalue,
          dropdownColor: themeType == ThemeType.GentleTouchDark ? Colors.black : null,
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          // Array list of itemsn
          items: widget.items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: theme.textTheme.bodyLarge?.copyWith(
                  // color: theme.primaryColorDark,
                  fontSize: 20.sp,
                  letterSpacing: 1,
                ),
              ),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
        ),
        SizedBox(height: 40.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SizedBox(
            height: 450.h,
            width: double.infinity,
            child: SizedBox(
              width: double.infinity,
              child: CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: 450.h,
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: dropdownvalue == 'All'
                    ? _salonProfileProvider.allProducts
                        .map(
                          (item) => ProductPortraitItemCard(product: item),
                        )
                        .toList()
                    : _salonProfileProvider.tabs[dropdownvalue]!
                        .map(
                          (item) => ProductPortraitItemCard(product: item),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dropdownvalue == 'All'
              ? _salonProfileProvider.allProducts.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: _current == entry.key ? 7 : 4,
                      height: _current == entry.key ? 7 : 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key
                            ? themeType == ThemeType.GentleTouch
                                ? Colors.black
                                : Colors.white
                            : const Color(0XFF8A8A8A).withOpacity(
                                _current == entry.key ? 0.9 : 0.4,
                              ),
                      ),
                    ),
                  );
                }).toList()
              : _salonProfileProvider.tabs[dropdownvalue]!.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: _current == entry.key ? 10 : 7,
                      height: _current == entry.key ? 10 : 7,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key
                            ? themeType == ThemeType.GentleTouch
                                ? Colors.black
                                : Colors.white
                            : const Color(0XFF8A8A8A).withOpacity(
                                _current == entry.key ? 0.9 : 0.4,
                              ),
                      ),
                    ),
                  );
                }).toList(),
        ),
      ],
    );
  }
}

class ProductPortraitItemCard extends ConsumerWidget {
  final ProductModel product;

  const ProductPortraitItemCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
          border: Border.all(color: (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white),
        ),
        // color: backgroundColor ?? Colors.blue,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: (themeType == ThemeType.GentleTouch) ? Colors.white : Colors.black,
                  border: const Border(bottom: BorderSide(color: Colors.black, width: 0.3)),
                ),
                // height: 300.h,
                // width: DeviceConstraints.getResponsiveSize(
                //   context,
                //   size / 1.5.sp,
                //   size / 2.3.sp,
                //   70.w,
                // ),

                child: (product.productImageUrlList!.isNotEmpty)
                    ? CachedImage(
                        url: '${product.productImageUrlList![0]}',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 20 - 40.w,
                      )
                    : Image.asset(
                        ThemeImages.noProduct,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 20 - 40.w,
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
                            '${product.productName}'.toUpperCase(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.primaryColorDark,
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
                      '\$${product.clientPrice}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.primaryColorLight,
                        fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 16.sp, 16.sp),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Image.asset(
        //   image,
        //   fit: BoxFit.cover,
        //   width: double.infinity,
        // ),
      ),
    );
  }
}
