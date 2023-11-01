import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/app_main_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingFilter extends ConsumerWidget {
  const RatingFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final salonSearchController = ref.watch(salonSearchProvider);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)?.rating ?? "Rating",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          const Divider(
            color: AppTheme.coolGrey,
          ),
          ListTile(
              leading: Checkbox(
                value: salonSearchController.tempRatings.contains(5),
                onChanged: (val) => salonSearchController.onRatingChange(val, 5),
              ),
              title: BnbRatings(rating: 5, editable: false, starSize: 20.sp)),
          ListTile(
              leading: Checkbox(
                value: salonSearchController.tempRatings.contains(4),
                onChanged: (val) => salonSearchController.onRatingChange(val, 4),
              ),
              title: BnbRatings(rating: 4, editable: false, starSize: 20.sp)),
          ListTile(
              leading: Checkbox(
                value: salonSearchController.tempRatings.contains(3),
                onChanged: (val) => salonSearchController.onRatingChange(val, 3),
              ),
              title: BnbRatings(rating: 3, editable: false, starSize: 20.sp)),
          ListTile(
              leading: Checkbox(
                value: salonSearchController.tempRatings.contains(2),
                onChanged: (val) => salonSearchController.onRatingChange(val, 2),
              ),
              title: BnbRatings(rating: 2, editable: false, starSize: 20.sp)),
          ListTile(
              leading: Checkbox(
                value: salonSearchController.tempRatings.contains(1),
                onChanged: (val) => salonSearchController.onRatingChange(val, 1),
              ),
              title: BnbRatings(rating: 1, editable: false, starSize: 20.sp)),
        ],
      ),
    );
  }
}
