import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_about.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/read_more_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterAbout extends StatelessWidget {
  final MasterModel master;

  const MasterAbout({Key? key, required this.master}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ConstrainedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            (AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitles[1] : masterDetailsTitles[1].toCapitalized(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.sp,
                  letterSpacing: -1,
                ),
          ),
          const Space(factor: 2),
          // const Divider(color: Color(0XFF9D9D9D), thickness: 1.3),
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
                        // master.personalInfo?.description ?? '',
                        '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.''',

                        trimLines: 4,
                        colorClickableText: AppTheme.textBlack,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " ...${AppLocalizations.of(context)?.readMore ?? 'Read More'}",
                        trimExpandedText: "  ${AppLocalizations.of(context)?.less ?? 'Less'}",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          Consumer(
            builder: (context, ref, child) => ReviewWidget(
              reviews: ref.watch(salonProfileProvider).masterReviews,
              avgRating: master.avgRating ?? 0,
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
