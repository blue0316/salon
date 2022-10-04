import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/views/salon/salon_home/salon_about.dart';
import 'package:bbblient/src/views/salon/widgets/rating_graph.dart';
import 'package:bbblient/src/views/salon/widgets/working_hours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../../../utils/read_more_widget.dart';
import '../widgets/review_description.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterAbout extends StatelessWidget {
  final MasterModel master;

  const MasterAbout({Key? key, required this.master}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (master.personalInfo != null &&
            master.personalInfo!.description != null &&
            master.personalInfo!.description != "") ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: 300.h),
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    ReadMoreText(
                      master.personalInfo?.description ?? '',
                      trimLines: 4,
                      colorClickableText: AppTheme.textBlack,
                      trimMode: TrimMode.Line,
                      trimCollapsedText:
                          " ...${AppLocalizations.of(context)?.readMore ?? 'Read More'}",
                      trimExpandedText:
                          "  ${AppLocalizations.of(context)?.less ?? 'Less'}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w400),
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
        )
      ],
    );
  }
}
