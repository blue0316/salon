import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/widgets.dart';

class IndividualMasterHeader extends StatelessWidget {
  const IndividualMasterHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
          child: Container(
            height: 511.h,
            decoration: const BoxDecoration(color: AppTheme.lightBlack),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: SizedBox(
                      height: 414.h,
                      width: 1.sw,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
                        child: Image.asset(
                          AppIcons.saloonJPG,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Positioned(
                  bottom: 175.h,
                  right: 0.5.sw - 51,
                  child: const CircleAvatar(
                    radius: 51,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/women/8.jpg",
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                          child: Container(
                            height: 62.h,
                            width: 1.sw,
                            decoration: const BoxDecoration(
                              color: Colors.white12,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "+919999999999",
                                    style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 38.h,
                                        width: 38.h,
                                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12.sp)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: SvgPicture.asset(AppIcons.phoneWhiteSVG),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.w,
                                      ),
                                      Container(
                                        height: 38.h,
                                        width: 38.h,
                                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12.sp)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: SvgPicture.asset(AppIcons.messageWhiteSVG),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 97.h,
                        width: 1.sw,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.0.w, vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Saloon Name",
                                            style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 20),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "  (speciality)",
                                            style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "salon_home address",
                                        style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0.h),
                                        child: const BnbRatings(rating: 4.1, editable: false, starSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.w,
                                  width: 20.w,
                                  child: SvgPicture.asset(AppIcons.mapPinWhiteSVG),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
