import 'dart:ui';

import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/chat/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/widgets.dart';

class MasterHeader extends StatefulWidget {
  final MasterModel masterModel;
  const MasterHeader({
    Key? key,
    required this.masterModel,
  }) : super(key: key);

  @override
  _MasterHeaderState createState() => _MasterHeaderState();
}

class _MasterHeaderState extends State<MasterHeader> {
  int _current = 0;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
          child: Container(
            height: 400.h,
            decoration: const BoxDecoration(color: AppTheme.lightBlack),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: (widget.masterModel.photosOfWork != null && widget.masterModel.photosOfWork!.isNotEmpty)
                      ? widget.masterModel.photosOfWork!.length == 1
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
                              child: SizedBox(
                                height: 250.h,
                                width: 1.sw,
                                child: CachedNetworkImage(
                                  imageUrl: widget.masterModel.photosOfWork![0],
                                  fit: BoxFit.cover,
                                  memCacheHeight: 250,
                                  memCacheWidth: 400,
                                ),
                              ),
                            )
                          : Stack(
                            children: [
                              SizedBox(
                                height: 250.h,
                                width: 1.sw,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 250.h,
                                    aspectRatio: 1,
                                    viewportFraction: 1,
                                    autoPlay: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    },
                                    autoPlayInterval: const Duration(
                                      milliseconds: 5000,
                                    ),
                                    autoPlayCurve: Curves.easeInOutCubic,
                                  ),
                                  items: widget.masterModel.photosOfWork!.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return CachedNetworkImage(
                                          imageUrl: i,
                                          fit: BoxFit.cover,
                                          height: 414.h,
                                          width: 1.sw,
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                  bottom: 32,
                                  child: SizedBox(
                                    height: 20,
                                    width: 1.sw,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: widget.masterModel.photosOfWork!.length,
                                            itemBuilder: (context, index) {
                                              return Opacity(
                                                opacity: 0.6,
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: Padding(
                                                    padding: EdgeInsets.all((index == _current) ? 0 : 5.0),
                                                    child: SvgPicture.asset(
                                                        index == _current ? AppIcons.dotActiveSVG : AppIcons.dotInactiveSVG),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ))
                            ],
                          )
                      : SizedBox(
                          height: 250.h,
                          width: 1.sw,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
                              child: SvgPicture.asset(
                                AppIcons.salonPlaceHolder,
                                fit: BoxFit.cover,
                              ))),
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Utils().launchCaller(widget.masterModel.personalInfo!.phone);
                                    },
                                    child: Container(
                                      height: 38.h,
                                      width: 38.h,
                                      decoration:
                                          BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12.sp)),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: SvgPicture.asset(AppIcons.phoneWhiteSVG),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Chat(
                                              peerId: widget.masterModel.masterId,
                                              peerAvatar: widget.masterModel.profilePicUrl ?? '',
                                              peerName: Utils().getNameMaster(widget.masterModel.personalInfo),
                                              appointmentId: ""),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 38.h,
                                      width: 38.h,
                                      decoration:
                                          BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12.sp)),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: SvgPicture.asset(AppIcons.messageWhiteSVG),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                        width: 1.sw,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(
                              Utils().getNameMaster(widget.masterModel.personalInfo),
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                    fontSize: 24,
                                  ),
                            ),

                            // todo generate profession from category ids or define explicitly
                            // Text(
                            //   masterModel.categoryIds[0],
                            //   style: Theme.of(context).textTheme.bodyText1.copyWith(
                            //         color: Colors.white,
                            //       ),
                            // ),
                            SizedBox(
                              height: 8.h,
                            ),
                            BnbRatings(rating: widget.masterModel.avgRating ?? 0, editable: false, starSize: 11),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:   EdgeInsets.only(top: 140.h),
                    child: CircleAvatar(
                      radius: 51,
                      backgroundColor: Colors.white,
                      child: (widget.masterModel.profilePicUrl != null && widget.masterModel.profilePicUrl != '')
                          ? CircleAvatar(
                              radius: 48,
                              backgroundColor: AppTheme.creamBrownLight,
                              backgroundImage: NetworkImage(widget.masterModel.profilePicUrl ?? ''),
                            )
                          : const CircleAvatar(
                              radius: 48,
                              backgroundColor: AppTheme.white,
                              backgroundImage: AssetImage(AppIcons.masterDefaultAvtar),
                            ),
                    ),
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
