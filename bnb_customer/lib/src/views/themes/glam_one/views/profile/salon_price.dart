import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/oval_button.dart';

class SalonPrice extends StatefulWidget {
  const SalonPrice({Key? key}) : super(key: key);

  @override
  State<SalonPrice> createState() => _SalonPriceState();
}

class _SalonPriceState extends State<SalonPrice> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
        top: DeviceConstraints.getResponsiveSize(context, 40, 60, 70),
        bottom: DeviceConstraints.getResponsiveSize(context, 40, 60, 70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "PRICE",
            style: GlamOneTheme.headLine2.copyWith(),
          ),

          const SizedBox(height: 50),
          Expanded(
            flex: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 60.h,
                child: TabBar(
                  controller: tabController,
                  unselectedLabelColor: GlamOneTheme.primaryColor,
                  labelColor: Colors.black,
                  labelStyle: GlamOneTheme.bodyText1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  indicator: const BoxDecoration(color: GlamOneTheme.primaryColor),
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 50),
                  tabs: const [
                    Tab(text: 'Haircut'),
                    Tab(text: 'Make up'),
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
              width: double.infinity,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    // height: 100,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SERVICE',
                              style: GlamOneTheme.headLine3.copyWith(
                                color: GlamOneTheme.primaryColor,
                                fontSize: 18.sp,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'PRICE',
                              style: GlamOneTheme.headLine3.copyWith(
                                color: GlamOneTheme.primaryColor,
                                fontSize: 18.sp,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const ServiceTile(
                          service: 'HAIR CUT',
                          price: '\$60',
                        ),
                        const ServiceTile(
                          service: 'SPA HAIR CUT',
                          price: '\$85',
                        ),
                        const ServiceTile(
                          service: 'KERATIN',
                          price: '\$180/\$240/\$290',
                        ),
                        const SizedBox(height: 35),
                        OvalButton(
                          width: 180.h,
                          height: 60.h,
                          textSize: 18.sp,
                          text: 'Book Now',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String service, price;
  const ServiceTile({Key? key, required this.service, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                service,
                style: GlamOneTheme.bodyText1.copyWith(
                  color: GlamOneTheme.primaryColor,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                price,
                style: GlamOneTheme.bodyText1.copyWith(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: GlamOneTheme.primaryColor,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
