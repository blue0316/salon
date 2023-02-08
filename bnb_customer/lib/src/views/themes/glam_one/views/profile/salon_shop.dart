import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalonShop extends StatefulWidget {
  const SalonShop({Key? key}) : super(key: key);

  @override
  State<SalonShop> createState() => _SalonShopState();
}

class _SalonShopState extends State<SalonShop> with SingleTickerProviderStateMixin {
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
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: 50,
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
                style: GlamOneTheme.headLine2.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    GlamOneIcons.leftArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  ),
                  SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
                  SvgPicture.asset(
                    GlamOneIcons.rightArrow,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
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
                child: TabBar(
                  controller: shopTabController,
                  unselectedLabelColor: GlamOneTheme.primaryColor,
                  labelColor: GlamOneTheme.deepOrange,
                  labelStyle: GlamOneTheme.bodyText1.copyWith(
                    color: GlamOneTheme.deepOrange,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorColor: GlamOneTheme.deepOrange,
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

class ShopCard extends StatelessWidget {
  final String itemTitle, itemImage, itemAmount;

  const ShopCard({
    Key? key,
    required this.itemTitle,
    required this.itemImage,
    required this.itemAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  style: GlamOneTheme.bodyText1.copyWith(
                    color: GlamOneTheme.deepOrange,
                    fontSize: 14.sp,
                  ),
                ),
                // Spacer(),
                Text(
                  itemAmount,
                  style: GlamOneTheme.headLine3.copyWith(
                    color: GlamOneTheme.primaryColor,
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
    'image': GlamOneImages.product1,
  },
  {
    'title': 'Hand cream',
    'price': '\$15.00',
    'image': GlamOneImages.product3,
  },
  {
    'title': 'Body Lotion',
    'price': '\$25.00',
    'image': GlamOneImages.product2,
  },
  {
    'title': 'Gel polish',
    'price': '\$5.30',
    'image': GlamOneImages.product4,
  },
];
