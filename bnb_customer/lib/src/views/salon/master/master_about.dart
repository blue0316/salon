import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_reviews.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/section_spacer.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_about.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/read_more_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'master_service.dart';

class MasterAbout extends StatelessWidget {
  final MasterModel master;

  const MasterAbout({Key? key, required this.master}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ConstrainedContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SectionSpacer(
              title: (AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitles[1] : masterDetailsTitles[1],
            ),
            Container(
              width: double.infinity,
              color: Colors.white.withOpacity(0.7),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MasterImageHeader(
                      master: master,
                    ),
                    if (master.personalInfo != null && master.personalInfo!.description != null && master.personalInfo!.description != "") ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 300.h),
                          child: Scrollbar(
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: [
                                ReadMoreText(
                                  '${master.personalInfo?.description}',
                                  trimLines: 4,
                                  colorClickableText: AppTheme.textBlack,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: " ...${AppLocalizations.of(context)?.readMore ?? 'Read More'}",
                                  trimExpandedText: "  ${AppLocalizations.of(context)?.less ?? 'Less'}",
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
