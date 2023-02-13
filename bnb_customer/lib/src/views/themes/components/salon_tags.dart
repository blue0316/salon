import 'package:bbblient/src/theme/glam_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalonTags extends StatelessWidget {
  const SalonTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50),
      child: Column(
        children: [
          const Divider(color: Color(0XFFF48B72), thickness: 2),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: tags.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          tags[index],
                          style: GlamOneTheme.bodyText1.copyWith(
                            color: const Color(0XFFF48B72),
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0XFFF48B72)),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const Divider(color: Color(0XFFF48B72), thickness: 2),
        ],
      ),
    );
  }
}

List<String> tags = [
  'Coffee/Tea',
  'Pet friendly',
  'Parking',
  'covid-19 vaccinated',
  'Medical degree',
  'instruments sterilization',
  'Disposable materials only',
  'Pet friendly',
  'Parking',
  'covid-19 vaccinated',
  'Medical degree',
  'Medical degree',
  'instruments sterilization',
  'Disposable materials only',
];
