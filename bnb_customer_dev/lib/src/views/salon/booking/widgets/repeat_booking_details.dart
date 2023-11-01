import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RepeatBookingDetails extends StatelessWidget {
  const RepeatBookingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 102.h,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.creamBrownLight,
                    ),
                    height: 44,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Woman's haircut length 1",
                            style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(AppIcons.hairdressingSVG),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    height: 58,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kurbasova Alina",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 12,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                "30 min 450 UAH",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Container(
                            height: 30,
                            width: 116,
                            decoration: BoxDecoration(
                              color: AppTheme.creamBrown,
                              borderRadius: BorderRadius.circular(
                                50,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Book",
                                style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
