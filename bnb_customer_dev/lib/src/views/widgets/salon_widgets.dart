import 'dart:ui';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/registration/authenticate/login.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonContainer extends StatelessWidget {
  final EdgeInsets? padding;
  final SalonModel salon;
  final bool showDialogForFavToggle;
  final Function onBookTapped;
  final bool isFav;
  final Function onFavouriteCallback;

  const SalonContainer({
    Key? key,
    required this.salon,
    required this.showDialogForFavToggle,
    required this.onBookTapped,
    required this.onFavouriteCallback,
    this.isFav = false,
    this.padding,
  }) : super(key: key);

  onHeartTap(context) {
    if (showDialogForFavToggle) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)?.removeThisMasterSalonfromYourFavorites ?? "Remove this master/salon from your favorites?",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const Space(
                    factor: 1.5,
                  ),
                  MaterialButton(
                    onPressed: () {
                      onFavouriteCallback();
                      Navigator.pop(context);
                    },
                    minWidth: 240,
                    height: 52,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: AppTheme.creamBrown,
                    child: Text(
                      AppLocalizations.of(context)?.yes ?? "Yes",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    minWidth: 240,
                    height: 52,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: AppTheme.creamBrown, width: 1),
                    ),
                    color: Colors.white,
                    child: Text(
                      AppLocalizations.of(context)?.no ?? "No",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.creamBrown),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      onFavouriteCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String _salonName = salon.salonName;
    final String _address = salon.address;
    final String? _dp = (salon.profilePics.isNotEmpty) ? salon.profilePics[0] : null;
    final String _distance = "${salon.distanceFromCenter ?? "N/A"} Km";

    final double _rating = salon.avgRating;
    final double _ratingCount = salon.reviewCount;

    return GestureDetector(
      onTap: () {
        onBookTapped();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0.h),
        height: 120.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    child: _dp == null
                        ? SvgPicture.asset(
                            AppIcons.salonPlaceHolder,
                            fit: BoxFit.cover,
                          )
                        : CachedImage(
                            height: 120.h,
                            url: _dp,
                            placeHolder: (context, str) => SvgPicture.asset(
                              AppIcons.salonPlaceHolder,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, str, obj) => SvgPicture.asset(
                              AppIcons.salonPlaceHolder,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.h, left: 16.w, right: 8.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RequestModeBanner(requestSalon: salon.requestSalon),
                            Consumer(
                              builder: (con, ref, child) => GestureDetector(
                                onTap: () async {
                                  checkUser(context, ref, () => onHeartTap(context));
                                },
                                child: SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: isFav ? SvgPicture.asset(AppIcons.heartfilledSVG) : SvgPicture.asset(AppIcons.heartemptySVG),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6.0.h, left: 16.w, right: 8.0.h),
                        child: Text(
                          _salonName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 18.sp),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6.0.h, left: 16.w, right: 8.0.h),
                        child: Text(
                          _address,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 8.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BnbRatings(
                                    editable: false,
                                    rating: _rating,
                                    starSize: 15,
                                    onRatingUpdate: () {},
                                  ),
                                  SizedBox(
                                    width: DeviceConstraints.getResponsiveSize(context, 8, 12, 16),
                                  ),
                                  if (_ratingCount != 0) ...[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 18.h,
                                          color: AppTheme.lightGrey,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          _ratingCount.toInt().toString(),
                                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp),
                                        )
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12.h,
                                    width: 12.w,
                                    child: SvgPicture.asset(AppIcons.locationMarkerSVG),
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    _distance,
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SalonRecognitionContainer(
              salon: salon,
            )
          ],
        ),
      ),
    );
  }
}

class SalonContainerForWeb extends StatelessWidget {
  final EdgeInsets? padding;
  final SalonModel salon;
  final bool showDialogForFavToggle;
  final Function onBookTapped;
  final bool isFav;
  final Function onFavouriteCallback;

  const SalonContainerForWeb({
    Key? key,
    required this.salon,
    required this.showDialogForFavToggle,
    required this.onBookTapped,
    required this.onFavouriteCallback,
    this.isFav = false,
    this.padding,
  }) : super(key: key);

  onHeartTap(context) {
    if (showDialogForFavToggle) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)?.removeThisMasterSalonfromYourFavorites ?? "Remove this master/salon from your favorites?",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const Space(
                    factor: 1.5,
                  ),
                  MaterialButton(
                    onPressed: () {
                      onFavouriteCallback();
                      Navigator.pop(context);
                    },
                    minWidth: 240,
                    height: 52,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: AppTheme.creamBrown,
                    child: Text(
                      AppLocalizations.of(context)?.yes ?? "Yes",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    minWidth: 240,
                    height: 52,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: AppTheme.creamBrown, width: 1),
                    ),
                    color: Colors.white,
                    child: Text(
                      AppLocalizations.of(context)?.no ?? "No",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.creamBrown),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      onFavouriteCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String _salonName = salon.salonName;
    final String _address = salon.address;
    final String? _dp = (salon.profilePics.isNotEmpty) ? salon.profilePics[0] : null;
    final String _distance = "${salon.distanceFromCenter ?? "N/A"} Km";

    final double _rating = salon.avgRating;
    final double _ratingCount = salon.reviewCount;
    return GestureDetector(
      onTap: () {
        onBookTapped();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: _dp == null
                  ? SvgPicture.asset(AppIcons.salonPlaceHolder, fit: BoxFit.cover)
                  : Stack(
                      children: [
                        SizedBox(
                          width: 500,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: CachedImage(
                              //memCacheHeight: 500,
                              url: _dp,

                              placeHolder: (context, str) => SvgPicture.asset(
                                AppIcons.salonPlaceHolder,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, str, obj) => SvgPicture.asset(
                                AppIcons.salonPlaceHolder,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SalonRecognitionContainer(
                          salon: salon,
                          withText: true,
                        )
                      ],
                    ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RequestModeBanner(requestSalon: salon.requestSalon),
                        Consumer(
                          builder: (con, ref, child) => GestureDetector(
                            onTap: () async {
                              checkUser(
                                context,
                                ref,
                                () => onHeartTap(context),
                              );
                            },
                            child: SizedBox(
                              height: 17,
                              width: 20,
                              child: isFav ? SvgPicture.asset(AppIcons.heartfilledSVG) : SvgPicture.asset(AppIcons.heartemptySVG),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8.0),
                    child: Text(
                      _salonName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8.0),
                    child: Text(
                      _address,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BnbRatings(
                              editable: false,
                              rating: _rating,
                              starSize: 15,
                              onRatingUpdate: () {},
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            if (_ratingCount != 0) ...[
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 18,
                                    color: AppTheme.lightGrey,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    _ratingCount.toInt().toString(),
                                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                                  )
                                ],
                              ),
                            ],
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                              width: 12,
                              child: SvgPicture.asset(AppIcons.locationMarkerSVG),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              _distance,
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalonRecognitionContainer extends StatelessWidget {
  final SalonModel salon;
  final bool withText;
  final EdgeInsets? padding;
  const SalonRecognitionContainer({
    Key? key,
    required this.salon,
    this.padding,
    this.withText = false,
  }) : super(key: key);

  // 0 for salon
  // 1 for single master working from home
  // 2 for specialist studio
  getSalonType(_salon) {
    if (_salon.ownerType == OwnerType.salon) {
      return 0;
    }
    if (_salon.workStation == WorkStation.home) {
      return 1;
    }
    return 2;
  }

  String getIcon(int id) {
    switch (id) {
      case 0:
        return AppIcons.salon;
      case 1:
        return AppIcons.singleMasterFromHome;
      case 2:
        return AppIcons.singleMasterFromStudio;
      default:
        return AppIcons.salon;
    }
  }

  String getLabel(id, context) {
    switch (id) {
      case 0:
        return AppLocalizations.of(context)?.salon ?? "salon";
      case 1:
        return AppLocalizations.of(context)?.singleMaster ?? "singleMaster";
      case 2:
        return AppLocalizations.of(context)?.specialistStudio ?? "specialistStudio";
      default:
        return AppIcons.salon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int type = getSalonType(salon);
    final String icon = getIcon(type);
    final String label = getLabel(type, context);
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: const Color(0x80FFFFFF),
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.3)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  icon,
                  fit: BoxFit.cover,
                ),
                withText
                    ?
                    // const SizedBox(width: 7),
                    Row(
                        children: [
                          const SizedBox(width: 7),
                          Text(
                            label,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RequestModeBanner extends StatelessWidget {
  final bool requestSalon;
  const RequestModeBanner({Key? key, this.requestSalon = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // borderRadius: const BorderRadius.only(
        //     topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
        color: requestSalon ? AppTheme.lightBlack.withOpacity(0.8) : AppTheme.creamBrownLight,
      ),
      child: Text(
        requestSalon ? AppLocalizations.of(context)?.request ?? "request" : AppLocalizations.of(context)?.instant ?? "instant",
        overflow: TextOverflow.clip,
        style: const TextStyle(height: 1, color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SalonCard extends StatelessWidget {
  final SalonModel salon;
  final bool isSelected;
  final Function onTap;
  const SalonCard({
    Key? key,
    required this.salon,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _salonName = salon.salonName;
    final String _address = salon.address;
    final String _dp = (salon.profilePics.isNotEmpty) ? salon.profilePics[0] : "";
    final String _distance = "${salon.distanceFromCenter ?? "N/A"} Km";
    final double _rating = salon.avgRating;
    return ConstrainedContainer(
      margin: const EdgeInsets.all(12),
      child: Material(
        child: InkWell(
          onTap: onTap as void Function()?,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Ink(
            height: 115.h,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color: isSelected ? AppTheme.creamBrownLight : AppTheme.white, width: 2),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(14.0.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                        height: 80.sp,
                        width: 80.sp,
                        child: (salon.isProfileImage)
                            ? CachedNetworkImage(
                                imageUrl: _dp,
                                memCacheHeight: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, str) => SvgPicture.asset(
                                  AppIcons.salonPlaceHolder,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, str, obj) => SvgPicture.asset(
                                  AppIcons.salonPlaceHolder,
                                  fit: BoxFit.cover,
                                ),
                                fadeInCurve: Curves.easeInCubic,
                              )
                            : SvgPicture.asset(
                                AppIcons.salonPlaceHolder,
                                fit: BoxFit.cover,
                              )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(6.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                _salonName,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16.sp),
                                maxLines: 1,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                _distance,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppTheme.lightGrey, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          _address,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BnbRatings(rating: _rating, editable: false, starSize: 12.sp),
                                SizedBox(
                                  width: 8.w,
                                ),
                                if (salon.reviewCount != 0) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 18.h,
                                        color: AppTheme.black2,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        salon.reviewCount.toInt().toString(),
                                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp),
                                      )
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const Space(factor: 0.5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
