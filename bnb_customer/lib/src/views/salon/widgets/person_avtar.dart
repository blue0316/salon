import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';

class PersonAvtar extends StatelessWidget {
  final String? personImageUrl;
  final String? personName;
  final double radius;
  final bool showBorder;
  final bool showRating;
  final double? rating;
  final double starSize;

  const PersonAvtar({
    Key? key,
    required this.personImageUrl,
    required this.personName,
    required this.radius,
    required this.showBorder,
    required this.showRating,
    required this.rating,
    required this.starSize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (personImageUrl != null && personImageUrl != '')
            ? CircleAvatar(
                radius: radius,
                backgroundColor: AppTheme.coolGrey,
                backgroundImage: NetworkImage(personImageUrl!),
              )
            : CircleAvatar(
                radius: radius,
                backgroundColor: AppTheme.white,
                backgroundImage: const AssetImage(AppIcons.masterDefaultAvtar),
              ),
        SizedBox(
          height: 4.w,
        ),
        Text(
          personName ?? "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 9.sp),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (rating != 0) ...[
          SizedBox(
            height: 8.h,
          ),

          BnbRatings(
            rating: rating ?? 0,
            editable: false,
            starSize: starSize,
          ),
        ],
      ],
    );
  }
}
