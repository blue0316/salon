import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/constants/theme_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/oval_button.dart';

class SalonPromotions extends StatelessWidget {
  const SalonPromotions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 50, bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PROMOTIONS", style: GlamOneTheme.headLine2),
              Row(
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

          SizedBox(height: 50.h), // TODO: RESPONSIVE
          SizedBox(
            height: 240.h, // TODO: RESPONSIVE
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discounts 15%".toUpperCase(),
                            style: GlamOneTheme.headLine3.copyWith(
                              color: GlamOneTheme.deepOrange,
                              fontSize: 35.sp,
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent.",
                            style: GlamOneTheme.bodyText2.copyWith(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          OvalButton(text: 'Get a discount'),
                        ],
                      ),
                    )),
                SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: Container(
                    // height: 200,
                    // width: 200,
                    child: ListView.builder(
                      itemCount: _samples.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 350.h, // TODO: RESPONSIVE
                                height: 210.h,
                                child: Image.asset(
                                  _samples[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                _samples[index]['title'],
                                style: GlamOneTheme.headLine3.copyWith(
                                  color: GlamOneTheme.primaryColor,
                                  fontSize: 20.sp,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> _samples = [
  {
    'image': GlamOneImages.wideLadyPic,
    'title': "DISCOUNTS 15%",
  },
  {
    'image': GlamOneImages.wideLadyPic,
    'title': "HAPPY HOURS 12:00 - 15:00",
  },
  {
    'image': GlamOneImages.wideLadyPic,
    'title': "HAPPY FRIDAY",
  },
];
