import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
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
          _salonProfileProvider.allProducts.isNotEmpty ? SizedBox(height: 70.sp) : const SizedBox(height: 50),
          (_salonProfileProvider.allProducts.isNotEmpty)
              ? isPortrait
                  ? const PortraitView()
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
                color: showTab ? Colors.black : Colors.transparent,
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

class PortraitView extends StatefulWidget {
  const PortraitView({Key? key}) : super(key: key);

  @override
  State<PortraitView> createState() => _PortraitViewState();
}

class _PortraitViewState extends State<PortraitView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
