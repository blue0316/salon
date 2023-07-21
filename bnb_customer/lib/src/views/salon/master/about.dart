import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/read_more_widget.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterLandscapeAboutHeader extends ConsumerWidget {
  final MasterModel master;
  final List<CategoryModel> categories;

  const MasterLandscapeAboutHeader({
    Key? key,
    required this.master,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: !isLightTheme ? Border.all(color: Colors.white, width: 1.2) : null,
            ),
            child: (master.profilePicUrl != null && master.profilePicUrl != '')
                ? Image.network(
                    master.profilePicUrl!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 35),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Utils().getNameMaster(master.personalInfo),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Space(factor: 0.3),
                  Container(
                    height: 1.5,
                    width: 15.w,
                    color: Colors.black,
                  ),
                  const Space(factor: 0.3),
                  Text(
                    '${master.title}',

                    // categories[0].translations[AppLocalizations.of(context)?.localeName], //  'Nail Professional',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: isLightTheme ? Colors.black : theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const Space(factor: 1),
              // Text(
              //   style: theme.textTheme.displayMedium!.copyWith(
              //     fontWeight: FontWeight.w500,
              //     fontSize: 13.sp,
              //     color: isLightTheme ? Colors.black : Colors.white,
              //   ),
              //   maxLines: 6,
              //   overflow: TextOverflow.ellipsis,
              // ),
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
                            // 'Rorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.',

                            trimLines: 4,
                            colorClickableText: AppTheme.textBlack,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: " ...${AppLocalizations.of(context)?.readMore ?? 'Read More'}",
                            trimExpandedText: "  ${AppLocalizations.of(context)?.less ?? 'Less'}",
                            style: theme.textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: isLightTheme ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class MasterPortraitAboutHeader extends ConsumerWidget {
  final MasterModel master;
  final List<CategoryModel> categories;

  const MasterPortraitAboutHeader({
    Key? key,
    required this.master,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: !isLightTheme ? Border.all(color: Colors.white, width: 1.2) : null,
          ),
          child: (master.profilePicUrl != null && master.profilePicUrl != '')
              ? Image.network(
                  master.profilePicUrl!,
                  fit: BoxFit.cover,
                )
              : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
        ),
        const Space(factor: 0.7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Utils().getNameMaster(master.personalInfo),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: isLightTheme ? Colors.black : theme.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Space(factor: 0.3),
                Container(
                  height: 1.5,
                  width: 60.w,
                  color: isLightTheme ? Colors.black : theme.primaryColor,
                ),
                const Space(factor: 0.3),
                Text(
                  '${master.title}',
                  // categories[0].translations[AppLocalizations.of(context)?.localeName], //  'Nail Professional',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: isLightTheme ? Colors.black : theme.primaryColor,
                  ),
                ),
              ],
            ),
            const Space(factor: 0.5),
            // Text(
            //   'Rorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.',
            //   style: theme.textTheme.displayMedium!.copyWith(
            //     fontWeight: FontWeight.w500,
            //     fontSize: 14.sp,
            //     color: isLightTheme ? Colors.black : Colors.white,
            //   ),
            //   maxLines: 8,
            //   overflow: TextOverflow.ellipsis,
            // ),
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
                          // 'Rorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.',

                          trimLines: 4,
                          colorClickableText: AppTheme.textBlack,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: " ...${AppLocalizations.of(context)?.readMore ?? 'Read More'}",
                          trimExpandedText: "  ${AppLocalizations.of(context)?.less ?? 'Less'}",
                          style: theme.textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: isLightTheme ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
