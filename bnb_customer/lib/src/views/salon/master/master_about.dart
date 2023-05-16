import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_reviews.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'about.dart';

class MasterAbout extends ConsumerWidget {
  final MasterModel master;
  final List<CategoryModel> categories;

  const MasterAbout({Key? key, required this.master, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return ConstrainedContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: theme.canvasColor.withOpacity(0.7),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Space(factor: 1.5),
                    Text(
                      ((AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitles[1] : masterDetailsTitles[1]).toUpperCase(),
                      style: theme.textTheme.displayLarge!.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 35.sp),
                        color: isLightTheme ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Space(factor: 2.5),
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        height: isPortrait ? null : 150.h,
                        child: isPortrait
                            ? MasterPortraitAboutHeader(
                                master: master,
                                categories: categories,
                              )
                            : MasterLandscapeAboutHeader(
                                master: master,
                                categories: categories,
                              ),
                      ),
                    ),
                    const Space(factor: 2),
                    Consumer(
                      builder: (context, ref, child) => ReviewSection(
                        reviews: ref.watch(salonProfileProvider).masterReviews,
                        avgRating: master.avgRating ?? 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
