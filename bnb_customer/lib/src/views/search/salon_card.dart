import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/animations.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/utils/translation.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonSearchCard extends StatefulWidget {
  final SalonModel salonModel;
  final List<ServiceModel> services;
  final Function onServiceTap;
  const SalonSearchCard({Key? key, required this.salonModel, required this.services, required this.onServiceTap}) : super(key: key);

  @override
  State<SalonSearchCard> createState() => _SalonSearchCardState();
}

class _SalonSearchCardState extends State<SalonSearchCard> {
  bool isExpanded = false;

  onTap() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String _distance = widget.salonModel.distanceFromCenter != null ? "${widget.salonModel.distanceFromCenter} km" : "";

    final String _salonName = widget.salonModel.salonName;
    final String _address = widget.salonModel.address;
    final double _rating = widget.salonModel.rating;
    final String _ratingCount = widget.salonModel.reviewCount.floor().toString();
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 12.0.sp),
            child: Column(
              children: [
                SizedBox(
                  height: 75.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30.w,
                        backgroundColor: Colors.blue,
                        backgroundImage: (widget.salonModel.profilePics.isNotEmpty
                            ? NetworkImage(
                                widget.salonModel.profilePics[0],
                              )
                            : const AssetImage(AppIcons.saloonJPG)) as ImageProvider<Object>?,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _salonName,
                                style: AppTheme.bodyText1,
                              ),
                              Text(
                                _address,
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
                                    rating: _rating,
                                    starSize: 15,
                                    onRatingUpdate: () {},
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16.w,
                                        color: AppTheme.lightGrey,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        _ratingCount,
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400, fontSize: 14.sp),
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
                            _distance,
                            style: AppTheme.headLine3.copyWith(color: AppTheme.lightGrey, fontSize: 18.sp),
                          ),
                          // Container(
                          //   height: 30.h,
                          //   width: 63.w,
                          //   decoration:
                          //       BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.circular(40)),
                          //   child: Center(
                          //       child: Text(
                          //     "View",
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .headline5!
                          //         .copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                          //   )),
                          // ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: const Padding(
                          //     padding: EdgeInsets.only(right: 12.0),
                          //     child: Text(
                          //       "View",
                          //       style: TextStyle(
                          //           color: AppTheme.creamBrown,fontSize: 16,
                          //           fontWeight: FontWeight.w600),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                ExpandedSection(
                  isExpanded: isExpanded,
                  child: Column(
                    children: [
                      const Space(
                        height: 6,
                      ),
                      const Divider(
                        color: AppTheme.coolGrey,
                      ),
                      for (ServiceModel service in widget.services)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  Translation.getServiceName(service: service, langCode: Localizations.localeOf(context).languageCode),
                                  style: AppTheme.bodyText1.copyWith(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const SpaceHorizontal(),
                                  Text(
                                    "${service.priceAndDuration.price} ${Keys.uah}",
                                    style: AppTheme.bodyText1.copyWith(fontSize: 14),
                                  ),
                                  const SpaceHorizontal(),
                                  GestureDetector(
                                    onTap: () => widget.onServiceTap(service, widget.salonModel),
                                    child: Container(
                                      height: 25.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.circular(40)),
                                      child: Center(
                                          child: Text(
                                        AppLocalizations.of(context)?.book ?? "Book",
                                        style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                                      )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
