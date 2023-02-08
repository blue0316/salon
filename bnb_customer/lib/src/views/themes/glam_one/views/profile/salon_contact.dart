import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SalonContact extends StatefulWidget {
  const SalonContact({Key? key}) : super(key: key);

  @override
  State<SalonContact> createState() => _SalonContactState();
}

class _SalonContactState extends State<SalonContact> with SingleTickerProviderStateMixin {
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
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "CONTACTS",
            style: GlamOneTheme.headLine2.copyWith(),
          ),

          const SizedBox(height: 50), // TODO: RESPONSIVE

          Container(
            // color: Colors.grey,
            height: 260.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 55.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      // height: 100,
                      width: 200,
                      // color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Contact(
                          //   icon: GlamOneIcons.phone,
                          //   value: "(000) 000-0000

                          //   ",
                          // ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Contact",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: GlamOneTheme.headLine4.copyWith(
                                  fontSize: 20.sp,

                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const ContactCard(icon: GlamOneIcons.phone, value: "(000) 000-0000"),
                              const ContactCard(icon: GlamOneIcons.mail, value: "miamibeauty@gmail.com"),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "VISIT US",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: GlamOneTheme.headLine4.copyWith(
                                  fontSize: 18.sp,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const ContactCard(icon: GlamOneIcons.mail, value: "500 Brickell Av, Miami Fl 33131"),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "SOCIAL NETWORK",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: GlamOneTheme.headLine4.copyWith(fontSize: 20.sp),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    GlamOneIcons.insta,
                                    height: 16.sp,
                                    color: GlamOneTheme.deepOrange,
                                  ),
                                  const SizedBox(width: 20),
                                  SvgPicture.asset(
                                    GlamOneIcons.tiktok,
                                    height: 16.sp,
                                    color: GlamOneTheme.deepOrange,
                                  ),
                                  const SizedBox(width: 20),
                                  SvgPicture.asset(
                                    GlamOneIcons.whatsapp,
                                    height: 16.sp,
                                    color: GlamOneTheme.deepOrange,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Image.asset(GlamOneImages.map, fit: BoxFit.cover),
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

class ContactCard extends StatelessWidget {
  final String icon, value;
  const ContactCard({Key? key, required this.icon, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(icon, height: 16.sp),
          const SizedBox(width: 15),
          Text(
            value,
            style: GlamOneTheme.bodyText1.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
