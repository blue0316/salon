import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonShop extends ConsumerStatefulWidget {
  const SalonShop({Key? key}) : super(key: key);

  @override
  ConsumerState<SalonShop> createState() => _SalonShopState();
}

class _SalonShopState extends ConsumerState<SalonShop> with SingleTickerProviderStateMixin {
  TabController? shopTabController;

  @override
  void initState() {
    // shopTabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    shopTabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final List<ProductModel> allProducts = _salonProfileProvider.allProducts;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 30.h, 50.h, 50.h),
        bottom: 50,
      ),
      child: DefaultTabController(
        // Adding 1 because of the 'All' tab
        length: 1 + _salonProfileProvider.tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (AppLocalizations.of(context)?.shop ?? 'Shop').toUpperCase(),
                  style: theme.textTheme.headline2?.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                  ),
                ),
                // PrevAndNext(salonProfileProvider: _salonProfileProvider),
              ],
            ),
            SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 40, 30)),
            _salonProfileProvider.tabs.isNotEmpty
                ? Expanded(
                    flex: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 60.h,
                        child: TabBar(
                          controller: shopTabController,
                          unselectedLabelColor: theme.primaryColorLight,
                          labelColor: theme.primaryColorDark, // GlamOneTheme.deepOrange,
                          labelStyle: theme.textTheme.bodyText1?.copyWith(
                            color: theme.primaryColorDark, // GlamOneTheme.deepOrange,
                            fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 25.sp),
                            fontWeight: FontWeight.w600,
                          ),

                          indicator: shopTabBarTheme(themeType, theme),

                          // indicatorColor: theme.primaryColorDark, //  deepOrange,
                          indicatorSize: TabBarIndicatorSize.label,

                          isScrollable: true,
                          tabs: [
                            // ALL PRODUCTS
                            const Tab(text: 'All'),

                            // FILTERED PRODUCTS
                            ..._salonProfileProvider.tabs.entries
                                .map(
                                  (entry) => Tab(
                                    text: entry.key.toCapitalized(),
                                  ),
                                )
                                .toList(),

                            // Tab(text: 'Hair'),
                            // Tab(text: 'Makeup'),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        (AppLocalizations.of(context)?.noItemsAvailable ?? 'No items available for sale').toUpperCase(),
                        style: theme.textTheme.bodyText1?.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                        ),
                      ),
                    ),
                  ),

            SizedBox(height: 30.h),

            // -- TAB BAR VIEW
            _salonProfileProvider.tabs.isNotEmpty
                ? Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5, // 400,
                      // width: double.infinity,
                      child: TabBarView(
                        controller: shopTabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // ALL PRODUCTS
                          SizedBox(
                            // height: 100,
                            width: DeviceConstraints.getResponsiveSize(context, 700.w, 500.w, 300.w),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allProducts.length,
                              itemBuilder: (context, index) {
                                final ProductModel product = allProducts[index];
                                return ShopCard(product: product);
                              },
                            ),
                          ),

                          // FILTERED PRODUCTS
                          // FILTERED PRODUCTS
                          ..._salonProfileProvider.tabs.entries.map(
                            (entry) {
                              return SizedBox(
                                width: DeviceConstraints.getResponsiveSize(context, 700.w, 500.w, 300.w),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: entry.value.length,
                                  itemBuilder: (context, index) {
                                    final ProductModel product = entry.value[index];

                                    return ShopCard(product: product);
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),

            // Section Divider

            if (themeType == ThemeType.GlamLight)
              Space(
                factor: DeviceConstraints.getResponsiveSize(context, 3, 4, 6),
              ),

            if (themeType == ThemeType.GlamLight)
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),

            // SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class ShopCard extends ConsumerWidget {
  final ProductModel product;

  const ShopCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size.width;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    // final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: DeviceConstraints.getResponsiveSize(
          context,
          size / 1.5,
          size / 2.5,
          100.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child: SizedBox(
                // height: 300.h,
                width: DeviceConstraints.getResponsiveSize(
                  context,
                  size / 1.5,
                  size / 2.5,
                  100.w,
                ),
                child: (product.productImageUrlList!.isNotEmpty)
                    ? CachedImage(
                        url: '${product.productImageUrlList![0]}',
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          'Photo N/A',
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.primaryColorDark,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product.productName}',
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: theme.primaryColorDark,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                  ),
                ),
                // Spacer(),
                Text(
                  '\$${product.clientPrice}',
                  style: theme.textTheme.headline3?.copyWith(
                    color: theme.primaryColorLight,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration shopTabBarTheme(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamLight:
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );

    default:
      return BoxDecoration(
        color: theme.primaryColor,
        border: Border(
          bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
        ),
      );
  }
}
