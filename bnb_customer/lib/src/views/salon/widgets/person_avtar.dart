import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/widgets.dart';

class PersonAvtar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = theme == AppTheme.lightTheme;

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        const SizedBox(height: 8),
        Text(
          personName ?? "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: defaultTheme ? AppTheme.textBlack : Colors.white,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (rating != 0) ...[
          const SizedBox(height: 5),
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
