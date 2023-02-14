import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonShop extends ConsumerStatefulWidget {
  const SalonShop({Key? key}) : super(key: key);

  @override
  ConsumerState<SalonShop> createState() => _SalonShopState();
}

class _SalonShopState extends ConsumerState<SalonShop> with SingleTickerProviderStateMixin {
  TabController? shopTabController;

  @override
  void initState() {
    shopTabController = TabController(vsync: this, length: 3);
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

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: 10,
        bottom: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SHOP",
                style: theme.textTheme.headline2?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (_salonProfileProvider.chosenSalon.selectedTheme != 2)
                      ? SvgPicture.asset(
                          ThemeIcons.leftArrow,
                          height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                        )
                      : Icon(
                          Icons.arrow_back,
                          size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                          color: Colors.white,
                        ),
                  SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
                  (_salonProfileProvider.chosenSalon.selectedTheme != 2)
                      ? SvgPicture.asset(
                          ThemeIcons.rightArrow,
                          height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                          color: Colors.white,
                        ),
                ],
              ),
            ],
          ),
          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 50, 40, 30)),
          Expanded(
            flex: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 60.h,
                child: Theme(
                  data: theme,
                  child: TabBar(
                    controller: shopTabController,
                    // unselectedLabelColor: theme.primaryColor,
                    // labelColor: GlamOneTheme.deepOrange,
                    // labelStyle: theme.textTheme.bodyText1?.copyWith(
                    //   color: GlamOneTheme.deepOrange,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    // indicatorColor: GlamOneTheme.deepOrange,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Hair'),
                      Tab(text: 'Makeup'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 30.h),

          // -- TAB BAR VIEW
          Expanded(
            flex: 0,
            child: SizedBox(
              height: 400,
              // width: double.infinity,
              child: TabBarView(
                controller: shopTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    // height: 100,
                    width: DeviceConstraints.getResponsiveSize(context, 700.w, 500.w, 300.w),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: shopProducsts.length,
                      itemBuilder: (context, index) {
                        return ShopCard(
                          itemTitle: shopProducsts[index]['title'],
                          itemImage: shopProducsts[index]['image'],
                          itemAmount: shopProducsts[index]['price'],
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.yellow,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class ShopCard extends ConsumerWidget {
  final String itemTitle, itemImage, itemAmount;

  const ShopCard({
    Key? key,
    required this.itemTitle,
    required this.itemImage,
    required this.itemAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: DeviceConstraints.getResponsiveSize(context, 150.w, 120.w, 80.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.h,
              width: DeviceConstraints.getResponsiveSize(context, 150.w, 120.w, 80.w),
              child: Image.asset(itemImage, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemTitle,
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: theme.primaryColorDark,
                    fontSize: 14.sp,
                  ),
                ),
                // Spacer(),
                Text(
                  itemAmount,
                  style: theme.textTheme.headline3?.copyWith(
                    color: theme.primaryColorLight,
                    fontSize: 14.sp,
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

List shopProducsts = [
  {
    'title': 'Body Oil',
    'price': '\$30.50',
    'image': ThemeImages.product1,
  },
  {
    'title': 'Hand cream',
    'price': '\$15.00',
    'image': ThemeImages.product3,
  },
  {
    'title': 'Body Lotion',
    'price': '\$25.00',
    'image': ThemeImages.product2,
  },
  {
    'title': 'Gel polish',
    'price': '\$5.30',
    'image': ThemeImages.product4,
  },
];
