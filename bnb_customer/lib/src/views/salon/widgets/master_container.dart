import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_main_theme.dart';
import '../../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterContainer extends StatelessWidget {
  final BuildContext context;
  final String name;
  final int category;
  final String imageUrl;
  final bool liked;
  final Function onBookTapped;
  final double rating;
  final int persons;

  const MasterContainer({
    Key? key,
    required this.context,
    required this.name,
    required this.category,
    required this.persons,
    required this.rating,
    required this.imageUrl,
    required this.liked,
    required this.onBookTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      height: 120.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Row(
        children: [
          SizedBox(
            height: 120.h,
            width: 108.w,
            child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)), child: CachedImage(url: imageUrl)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0.h, right: 16.w, left: 16.w, bottom: 8.0.h),
              child: SizedBox(
                width: size.width - 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // if (showdialogforFavToggle) {
                            //   onHeartTap();
                            // } else {
                            //   //TODO show a snackbar or toast for likes dislike on homepage
                            // }
                          },
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: liked == true ? SvgPicture.asset('assets/icons/HeartFilled.svg') : SvgPicture.asset('assets/icons/HeartEmpty.svg'),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BnbRatings(
                          editable: false,
                          rating: 4.5,
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
                              '$persons',
                              style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            onBookTapped();
                          },
                          child: Container(
                            height: 30.h,
                            width: 63.w,
                            decoration: BoxDecoration(color: AppTheme.creamBrown, borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)?.book ?? "Book",
                              style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
