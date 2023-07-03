import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalonSearchCard extends StatelessWidget {
  final SalonModel salonModel;
  final ServiceModel serviceModel;
  const SalonSearchCard({Key? key, required this.salonModel, required this.serviceModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            children: [
              SizedBox(
                height: 75.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 28.w,
                      backgroundColor: Colors.blue,
                      backgroundImage: (salonModel.profilePics.isNotEmpty
                          ? NetworkImage(
                              salonModel.profilePics[0],
                            )
                          : const AssetImage(AppIcons.saloonJPG)) as ImageProvider<Object>?,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              salonModel.salonName,
                              style: AppTheme.bodyText1,
                            ),
                            Text(
                              salonModel.address,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                            ),
                            Row(
                              children: [
                                BnbRatings(
                                  editable: false,
                                  rating: salonModel.rating,
                                  starSize: 15,
                                  onRatingUpdate: () {},
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18.w,
                                      color: AppTheme.lightGrey,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      '24',
                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${salonModel.distanceFromCenter} km",
                          style: AppTheme.headLine3.copyWith(color: AppTheme.lightGrey, fontSize: 18.sp),
                        ),
                        // Container(
                        //   height: 30.h,
                        //   width: 63.w,
                        //   decoration:
                        //       BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.circular(40)),
                        //   child: Center(
                        //       child: Text(
                        //     "Book",
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .headline5!
                        //         .copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                        //   )),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: AppTheme.lightGrey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      serviceModel.serviceName ?? '',
                      style: AppTheme.bodyText1.copyWith(fontSize: 14),
                    ),
                    Text(
                      "${Keys.dollars}${serviceModel.priceAndDuration!.price}",
                      style: AppTheme.bodyText1.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SalonOnlySearchCard extends StatelessWidget {
  final SalonModel salonModel;
  const SalonOnlySearchCard({
    Key? key,
    required this.salonModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(
            children: [
              SizedBox(
                height: 75.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 28.w,
                      backgroundColor: Colors.blue,
                      backgroundImage: (salonModel.profilePics.isNotEmpty
                          ? NetworkImage(
                              salonModel.profilePics[0],
                            )
                          : const AssetImage(AppIcons.saloonJPG)) as ImageProvider<Object>?,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              salonModel.salonName,
                              style: AppTheme.bodyText1,
                            ),
                            Text(
                              salonModel.address,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                            ),
                            Row(
                              children: [
                                BnbRatings(
                                  editable: false,
                                  rating: salonModel.rating,
                                  starSize: 15,
                                  onRatingUpdate: () {},
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18.w,
                                      color: AppTheme.lightGrey,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      '24',
                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${salonModel.distanceFromCenter ?? "-"} km",
                          style: AppTheme.headLine3.copyWith(color: AppTheme.lightGrey, fontSize: 18.sp),
                        ),
                        // Container(
                        //   height: 30.h,
                        //   width: 63.w,
                        //   decoration:
                        //       BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.circular(40)),
                        //   child: Center(
                        //       child: Text(
                        //     "Book",
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .headline5!
                        //         .copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                        //   )),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
