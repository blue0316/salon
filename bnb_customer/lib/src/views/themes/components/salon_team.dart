import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonTeam extends ConsumerWidget {
  final SalonModel salonModel;

  const SalonTeam({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.only(
        top: DeviceConstraints.getResponsiveSize(context, 40, 60, 70),
        bottom: DeviceConstraints.getResponsiveSize(context, 30, 40, 50),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: theme.cardColor),
        child: Padding(
          padding: EdgeInsets.only(
            left: DeviceConstraints.getResponsiveSize(context, 20.w, 30.w, 30.w),
            right: DeviceConstraints.getResponsiveSize(context, 20.w, 30.w, 30.w),
            top: DeviceConstraints.getResponsiveSize(context, 80.h, 90.h, 100.h),
            bottom: DeviceConstraints.getResponsiveSize(context, 60.h, 90.h, 100.h),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  (AppLocalizations.of(context)?.ourTeam ?? 'Our Team').toUpperCase(),
                  style: theme.textTheme.headline2?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
                  ),
                ),
              ),
              Space(factor: DeviceConstraints.getResponsiveSize(context, 0.8, 1.3, 1.5)),
              Center(
                child: Container(
                  height: 185.h,
                  alignment: Alignment.center,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: _createAppointmentProvider.salonMasters.length,
                    itemBuilder: (context, index) {
                      // Get All Salon Masters
                      List<MasterModel> _filteredMasters = _createAppointmentProvider.salonMasters;

                      // Find Master Service
                      // a master might have multiple services (but I just picked the first index to show on landing page)
                      List<CategoryModel> categories = _salonSearchProvider.categories; // All available Categories

                      // Previous implementation to show only one service
                      // String masterCategoryId = _filteredMasters[index].categoryIds![0]; // Master category id
                      // Find master category id in all categories and pick the first one to display
                      // String? masterService = categories
                      //     .firstWhere(
                      //       (item) => item.categoryId == masterCategoryId,
                      //     )
                      //     .translations[AppLocalizations.of(context)?.localeName];

                      List<String> masterCategoryIds = _filteredMasters[index].categoryIds!;
                      if (masterCategoryIds.length > 2) {
                        masterCategoryIds.removeRange(2, masterCategoryIds.length);
                      }

                      List<CategoryModel> masterCategories = [];
                      for (String id in masterCategoryIds) {
                        masterCategories.add(categories.firstWhere((element) => element.categoryId == id));
                      }

                      if (_filteredMasters.isNotEmpty) {
                        return InkWell(
                          onTap: () {
                            // print('####');
                            // print(_salonSearchProvider.categories);
                            // print(_filteredMasters[index].categoryIds);
                            print('####');
                            print(masterCategories);
                            print(masterCategories[0].categoryId);
                            print(masterCategories[1].categoryId);
                            print('####');
                          },
                          child: TeamMember(
                            name: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                            services: masterCategories, // masterService, // "Hairdresser",
                            image: _filteredMasters[index].profilePicUrl,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMember extends ConsumerWidget {
  final String? name, image;
  final List<CategoryModel> services;

  const TeamMember({
    Key? key,
    required this.name,
    required this.services,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: SizedBox(
            // height: 140.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (image != null && image != '')
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.white, // coolGrey,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedImage(url: image!, fit: BoxFit.cover),
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
                        ),
                      ),
                const SizedBox(height: 15),
                Text(
                  name ?? '',
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
                // Text(
                //   service ?? '',
                //   style: theme.textTheme.subtitle2?.copyWith(
                //     fontSize: 15.sp,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: services
              .map(
                (item) => Text(
                  item.translations[AppLocalizations.of(context)?.localeName] ?? '',
                  style: theme.textTheme.subtitle2?.copyWith(
                    fontSize: 15.sp,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
