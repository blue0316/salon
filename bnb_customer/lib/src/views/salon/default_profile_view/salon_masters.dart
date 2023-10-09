import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_reviews.dart';
import 'package:bbblient/src/views/salon/master/new_master_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:bbblient/src/utils/utils.dart';
import '../../../models/salon_master/master.dart';
import 'widgets/section_spacer.dart';

class SalonMasters extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonMasters({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonMasters> createState() => _SalonMastersState();
}

class _SalonMastersState extends ConsumerState<SalonMasters> {
  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return !(_salonProfileProvider.showMasterView)
        ? Column(
            children: [
              SectionSpacer(
                title: salonTitles(AppLocalizations.of(context)?.localeName ?? 'en')[2],
              ),
              Container(
                // height: 1000.h,
                width: double.infinity,
                color: theme.canvasColor.withOpacity(!isLightTheme ? 0.7 : 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Center(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ListView.builder(
                            // padding: const EdgeInsets.symmetric(vertical: AppTheme.margin * 2),

                            primary: false,
                            shrinkWrap: true,
                            itemCount: _salonSearchProvider.categories.length,
                            itemBuilder: (context, index) {
                              List<MasterModel> _filteredMasters = _createAppointmentProvider.salonMasters
                                  .where(
                                    (element) => element.categoryIds!.contains(
                                      _salonSearchProvider.categories[index].categoryId,
                                    ),
                                  )
                                  .toList();

                              if (_filteredMasters.isNotEmpty) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: AppTheme.margin * 1),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${_salonSearchProvider.categories[index].translations[AppLocalizations.of(context)?.localeName] ?? _salonSearchProvider.categories[index].translations['en']}'.toUpperCase(),
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                    color: isLightTheme ? Colors.black : Colors.white,
                                                  ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: isLightTheme ? Colors.white : theme.canvasColor,
                                                borderRadius: BorderRadius.circular(50),
                                                border: isLightTheme ? Border.all(color: const Color(0XFFD9D9D9)) : null,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                child: Text(
                                                  "${_filteredMasters.length} ${AppLocalizations.of(context)?.serviceProvider2.toLowerCase() ?? "Service provider"}",
                                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: theme.primaryColor,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 30.h),

                                        /// --- MASTER AVATAR ----
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: DeviceConstraints.getResponsiveSize(context, 5.w, 10.w, 30.w),
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: DeviceConstraints.getResponsiveSize(context, 200.h, 200.h, 200.h),
                                              alignment: Alignment.center,
                                              child: ListView.builder(
                                                itemCount: _filteredMasters.length,
                                                physics: const ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  // List<String> masterCategoryIds = _filteredMasters[index].categoryIds!;

                                                  // // Find Master Service
                                                  // // a master might have multiple services (but I just picked the first index to show on landing page)
                                                  // List<CategoryModel> categories = _salonSearchProvider.categories; // All available Categories

                                                  // // List<CategoryModel> masterCategories = [];
                                                  // // for (String id in masterCategoryIds) {
                                                  // //   print(categories);
                                                  // //   masterCategories.add(categories.firstWhere((element) => element.categoryId == id));
                                                  // // }

                                                  return Align(
                                                    alignment: Alignment.center,
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(right: 5.w), // (left: 40.0.w, right: 8.w),
                                                        child: GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          key: const ValueKey("tap-master"),
                                                          onTap: () {
                                                            _createAppointmentProvider.setMaster(
                                                              masterModel: _filteredMasters[index],
                                                              categories: _salonSearchProvider.categories,
                                                            );
                                                            _salonProfileProvider.switchMasterView();

                                                            // Navigator.push(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //     builder: (context) => MasterProfile(
                                                            //       salonModel: widget.salonModel,
                                                            //       masterModel: _filteredMasters[index],
                                                            //       categories: masterCategories,
                                                            //     ),
                                                            //   ),
                                                            // );
                                                          },
                                                          child: MasterAvatar(
                                                            personImageUrl: _filteredMasters[index].profilePicUrl,
                                                            personName: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                                                            masterTitle: _filteredMasters[index].title,
                                                            rating: _filteredMasters[index].avgRating,
                                                            // categories: masterCategories,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Space(factor: 2.5),
                                        const GradientDivider(),
                                        const Space(factor: 2.5),
                                      ],
                                    ),
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
              const Space(factor: 2),
              const LandingBottom(),
            ],
          )
        : const SalonMasterView();
  }
}

class MasterAvatar extends ConsumerWidget {
  final String? personImageUrl;
  final String? personName, masterTitle;
  final double? rating;
  // final List<CategoryModel> categories;

  const MasterAvatar({
    Key? key,
    required this.personImageUrl,
    required this.personName,
    required this.rating,
    // required this.categories,
    required this.masterTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 85.sp,
              width: 85.sp,
              decoration: (personImageUrl != null && personImageUrl != '')
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(personImageUrl!),
                        fit: BoxFit.cover,
                      ))
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLightTheme
                          ? const Color(0XFF1A1A1A).withOpacity(0.6)
                          : const Color(
                              0XFF3D3D3D,
                            ),
                    ),
              child: !(personImageUrl != null && personImageUrl != '')
                  ? Center(
                      child: Text(
                        personName?.initials ?? '',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500,
                          color: isLightTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(height: 15.sp),
            BnbRatings(
              rating: rating ?? 0,
              editable: false,
              starSize: 13.sp,
              color: const Color(0XFFF1B81B),
              padding: 3,
            ),
            SizedBox(height: 5.sp),
            Text(
              masterTitle ?? '-',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 15.sp,
                color: isLightTheme ? Colors.black : Colors.white,
              ),
            ),
            // SizedBox(height: 5.sp),
            Text(
              personName ?? "",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0XFFA0A0A0), // isLightTheme ? AppTheme.textBlack : Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
