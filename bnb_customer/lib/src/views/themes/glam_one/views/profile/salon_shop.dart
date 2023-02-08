import 'package:bbblient/src/theme/glam_one.dart';
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
      padding: EdgeInsets.only(left: 50.w, right: 50.w, bottom: 100),
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
                style: GlamOneTheme.headLine2.copyWith(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    GlamOneIcons.leftArrow,
                    height: 50.sp, // TODO: RESPONSIVE
                  ),
                  SizedBox(width: 40), // TODO: RESPONSIVE
                  SvgPicture.asset(
                    GlamOneIcons.rightArrow,
                    height: 50.sp, // TODO: RESPONSIVE
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Expanded(
            flex: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
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
            child: Container(
              height: 400, // TODO: RESPONSIVE
              // width: double.infinity,
              child: TabBarView(
                controller: shopTabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    // height: 100,
                    width: 300.w,
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
      child: Container(
        width: 80.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 300.h,
              width: 80.w,
              child: Image.asset(itemImage, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
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
