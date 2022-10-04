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
  void _launchURL(String url) async => await canLaunch(url)
      ? await launch(url)
      : showToast('Could not launch $url');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.only(bottomRight: Radius.circular(52)),
          child: Container(
            height: 511.h,
            decoration: const BoxDecoration(color: AppTheme.lightBlack),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: (widget.salonModel.profilePics.isNotEmpty)
                      ? widget.salonModel.profilePics.length == 1
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(52)),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 414.h,
                                    width: 1.sw,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.salonModel.profilePics[0],
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
                              ),
                            )
                          : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(52)),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  SizedBox(
                                    height: 414.h,
                                    width: 1.sw,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        height: 414.h,
                                        aspectRatio: 1,
                                        viewportFraction: 1,
                                        autoPlay: true,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        autoPlayInterval:
                                            const Duration(seconds: 10),
                                        autoPlayCurve: Curves.easeInOutCubic,
                                      ),
                                      items: widget.salonModel.profilePics
                                          .map((i) {
                                        return Builder(
                                            builder: (BuildContext context) {
                                          return CachedImage(
                                              url: i,
                                              height: 414.h,
                                              width: 1.sw);
                                        });
                                      }).toList(),
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
                                  Positioned(
                                      bottom: 72,
                                      child: SizedBox(
                                        height: 20,
                                        width: 1.sw,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ListView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: widget.salonModel
                                                    .profilePics.length,
                                                itemBuilder: (context, index) {
                                                  return Opacity(
                                                    opacity: 0.6,
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            (index == _current)
                                                                ? 0
                                                                : 5.0),
                                                        child: SvgPicture.asset(
                                                            index == _current
                                                                ? AppIcons
                                                                    .dotActiveSVG
                                                                : AppIcons
                                                                    .dotInactiveSVG),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )
                      : SizedBox(
                          height: 414.h,
                          width: 1.sw,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(52)),
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
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(52)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                          child: Container(
                            height: 62.h,
                            width: 1.sw,
                            decoration: const BoxDecoration(
                              color: Colors.white12,
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 20.0.w, right: 40.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.salonModel.requestSalon
                                          ? AppLocalizations.of(context)
                                                  ?.requestInfo ??
                                              "Request mode"
                                          : AppLocalizations.of(context)
                                                  ?.instantInfo ??
                                              "Instant mode",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                              fontSize: 14,
                                              color: AppTheme.white,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SpaceHorizontal(
                                    factor: 0.5,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Utils().launchCaller(widget
                                              .salonModel.phoneNumber
                                              .replaceAll("-", ""));
                                        },
                                        child: Container(
                                          height: 38.h,
                                          width: 38.h,
                                          decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(12.sp)),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: SvgPicture.asset(
                                                AppIcons.phoneWhiteSVG),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16.w,
                                      ),
                                      Consumer(
                                        builder: (context, ref, child) =>
                                            GestureDetector(
                                          onTap: () {
                                            checkUser(
                                                context,
                                                ref,
                                                () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Chat(
                                                              appointmentId: "",
                                                              peerAvatar: widget
                                                                      .salonModel
                                                                      .profilePics
                                                                      .isNotEmpty
                                                                  ? widget
                                                                      .salonModel
                                                                      .profilePics
                                                                      .first
                                                                  : "",
                                                              peerId: widget
                                                                  .salonModel
                                                                  .salonId,
                                                              peerName: widget
                                                                  .salonModel
                                                                  .salonName,
                                                            ))));
                                          },
                                          child: Container(
                                            height: 38.h,
                                            width: 38.h,
                                            decoration: BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.sp)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0.sp),
                                              child: SvgPicture.asset(
                                                  AppIcons.messageWhiteSVG),
                                            ),
                                          ),
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
                            padding: EdgeInsets.only(
                                left: 20.w,
                                right: 40.w,
                                top: 10.h,
                                bottom: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        widget.salonModel.salonName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(fontSize: 20.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.salonModel.address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0.h),
                                        child: BnbRatings(
                                            rating: widget.salonModel.rating,
                                            editable: false,
                                            starSize: 9.sp),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if ((widget.salonModel.position?.geoPoint
                                                    ?.latitude ??
                                                0) ==
                                            0 &&
                                        (widget.salonModel.position?.geoPoint
                                                    ?.longitude ??
                                                0) ==
                                            0) {
                                      BnbProvider _bnbProvider =
                                          ref.read(bnbProvider);
                                      _bnbProvider.getLocale.toString() == "en"
                                          ? showToast(
                                              "Salon's Location Not Added")
                                          : showToast(
                                              "Місцезнаходження салону не додано");
                                    } else {
                                      if (kIsWeb) {
                                        _launchURL(
                                            "https://maps.google.com/maps?q=${widget.salonModel.position?.geoPoint?.latitude ?? 0},${widget.salonModel.position?.geoPoint?.longitude ?? 0}&");
                                      } else {
                                        Utils().launchMaps(
                                          coordinates: Coordinates(
                                              widget.salonModel.position
                                                      ?.geoPoint?.latitude ??
                                                  0,
                                              widget.salonModel.position
                                                      ?.geoPoint?.longitude ??
                                                  0),
                                          label: widget.salonModel.address,
                                          context: context,
                                        );
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                    height: DeviceConstraints.getResponsiveSize(
                                        context, 20, 25, 35),
                                    width: DeviceConstraints.getResponsiveSize(
                                        context, 20, 25, 35),
                                    child: SvgPicture.asset(
                                        AppIcons.mapPinWhiteSVG),
                                  ),
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
