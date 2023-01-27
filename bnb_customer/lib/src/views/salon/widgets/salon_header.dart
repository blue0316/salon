import 'dart:ui';

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/bnb/bnb_provider.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/chat/chat_screen.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/salon_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/salon_master/salon.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaloonHeader extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SaloonHeader({Key? key, required this.salonModel}) : super(key: key);

  @override
  _SaloonHeaderState createState() => _SaloonHeaderState();
}

class _SaloonHeaderState extends ConsumerState<SaloonHeader> {
  int _current = 0;
  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : showToast('Could not launch $url');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 511.h,
          // decoration: const BoxDecoration(color:   AppTheme.lightBlack),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                child: (widget.salonModel.profilePics.isNotEmpty)
                    ? widget.salonModel.profilePics.length == 1
                        ? Stack(
                            children: [
                              SizedBox(
                                height: 414.h,
                                width: 1.sw,
                                child: CachedNetworkImage(
                                  imageUrl: widget.salonModel.profilePics[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  bottom: 100,
                                  left: 20.w,
                                  child: SalonRecognitionContainer(
                                    padding: EdgeInsets.zero,
                                    salon: widget.salonModel,
                                    withText: true,
                                  )),
                            ],
                          )
                        : Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              SizedBox(
                                height: 420.h,
                                width: 1.sw,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 420.h,
                                    aspectRatio: 1,
                                    viewportFraction: 1,
                                    autoPlay: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    },
                                    autoPlayInterval: const Duration(seconds: 10),
                                    autoPlayCurve: Curves.easeInOutCubic,
                                  ),
                                  items: widget.salonModel.profilePics.map((i) {
                                    return Builder(builder: (BuildContext context) {
                                      return CachedImage(url: i, height: 420.h, width: 1.sw);
                                    });
                                  }).toList(),
                                ),
                              ),
                              Positioned(
                                bottom: 100,
                                left: 40.w,
                                child: Container(
                                  height: DeviceConstraints.getResponsiveSize(context, 95.h, 140.h, 140.h), // TODO: TAB HEIGHT??
                                  width: DeviceConstraints.getResponsiveSize(context, 95.h, 140.h, 140.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1.3),
                                  ),
                                  child: Image.asset(AppIcons.logoBnbPNG, fit: BoxFit.fill), // CachedImage(url: widget.salonModel.)
                                ),
                                // child: SalonRecognitionContainer(
                                //   padding: EdgeInsets.zero,
                                //   salon: widget.salonModel,
                                //   withText: true,
                                // ),
                              ),
                              Positioned(
                                  bottom: 72,
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
                                            itemCount: widget.salonModel.profilePics.length,
                                            itemBuilder: (context, index) {
                                              return Opacity(
                                                opacity: 0.6,
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: Padding(
                                                    padding: EdgeInsets.all((index == _current) ? 0 : 5.0),
                                                    child: SvgPicture.asset(index == _current ? AppIcons.dotActiveSVG : AppIcons.dotInactiveSVG),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  )),
                            ],
                          )
                    : SizedBox(
                        height: 414.h,
                        width: 1.sw,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(52)),
                            child: SvgPicture.asset(
                              AppIcons.salonPlaceHolder,
                              fit: BoxFit.cover,
                            )),
                      ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 97.h,
                          width: 1.sw,
                          child: Padding(
                              padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 10.h, bottom: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          widget.salonModel.salonName,
                                          style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 25.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Space(factor: 0.8),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.mapPin2WhiteSVG,
                                              height: 15.sp,
                                              // color: Colors.black,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              widget.salonModel.address,
                                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0.h),
                                          child: BnbRatings(rating: widget.salonModel.rating, editable: false, starSize: 9.sp),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Utils().launchCaller(widget.salonModel.phoneNumber.replaceAll("-", ""));
                                        },
                                        child: Container(
                                          // height: DeviceConstraints.getResponsiveSize(context, 20, 25, 40),
                                          // width: DeviceConstraints.getResponsiveSize(context, 20, 25, 40),
                                          height: 35.h,
                                          width: 35.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(color: Colors.white, width: 1.3),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                AppIcons.phoneWhiteSVG,
                                                height: DeviceConstraints.getResponsiveSize(context, 40, 50, 70),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          if ((widget.salonModel.position?.geoPoint?.latitude ?? 0) == 0 && (widget.salonModel.position?.geoPoint?.longitude ?? 0) == 0) {
                                            BnbProvider _bnbProvider = ref.read(bnbProvider);
                                            _bnbProvider.getLocale.toString() == "en" ? showToast("Salon's Location Not Added") : showToast("Місцезнаходження салону не додано");
                                          } else {
                                            if (kIsWeb) {
                                              _launchURL("https://maps.google.com/maps?q=${widget.salonModel.position?.geoPoint?.latitude ?? 0},${widget.salonModel.position?.geoPoint?.longitude ?? 0}&");
                                            } else {
                                              Utils().launchMaps(
                                                coordinates: Coordinates(widget.salonModel.position?.geoPoint?.latitude ?? 0, widget.salonModel.position?.geoPoint?.longitude ?? 0),
                                                label: widget.salonModel.address,
                                                context: context,
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 35.h,
                                          width: 35.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(color: Colors.white, width: 1.3),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                AppIcons.send,
                                                height: DeviceConstraints.getResponsiveSize(context, 40, 50, 70), // height: 40.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}



class SalonHeader extends ConsumerStatefulWidget {
  const SalonHeader({Key? key}) : super(key:key );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalonHeaderState();
}

class _SalonHeaderState extends ConsumerState<SalonHeader> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

