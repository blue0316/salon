import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/master/master_profile.dart';
import '../../../models/salon_master/master.dart';
import '../widgets/person_avtar.dart';
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

    return SingleChildScrollView(
      child: Column(
        children: [
          SectionSpacer(
            title: (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[2] : saloonDetailsTitles[2],
          ),
          Container(
            // height: 1000.h,
            width: double.infinity,
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(
                      color: isLightTheme ? Colors.black : Colors.white,
                      thickness: 1,
                    ),
                    SizedBox(
                      // color: Colors.yellow,
                      width: double.infinity,
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppTheme.margin * 0.6),
                              child: Column(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_salonSearchProvider.categories[index].translations[AppLocalizations.of(context)?.localeName]}'.toUpperCase(),
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp, //  DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                              color: theme.primaryColor,
                                            ),
                                      ),
                                      SpaceHorizontal(
                                        width: DeviceConstraints.getResponsiveSize(context, 10, 25, 25),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isLightTheme ? const Color.fromARGB(255, 239, 239, 239) : theme.canvasColor,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          child: Text(
                                            "${_filteredMasters.length} masters ",
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
                                  const Space(factor: 1),

                                  /// --- MASTER AVATAR ----
                                  Container(
                                    height: DeviceConstraints.getResponsiveSize(context, 170.h, 140.h, 180.h),
                                    alignment: Alignment.centerLeft,
                                    child: ListView.builder(
                                      itemCount: _filteredMasters.length,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        List<String> masterCategoryIds = _filteredMasters[index].categoryIds!;

                                        // Find Master Service
                                        // a master might have multiple services (but I just picked the first index to show on landing page)
                                        List<CategoryModel> categories = _salonSearchProvider.categories; // All available Categories

                                        List<CategoryModel> masterCategories = [];
                                        for (String id in masterCategoryIds) {
                                          masterCategories.add(categories.firstWhere((element) => element.categoryId == id));
                                        }

                                        return Padding(
                                          padding: EdgeInsets.only(right: 12.w), // (left: 40.0.w, right: 8.w),
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            key: const ValueKey("tap-master"),
                                            onTap: () {
                                              _createAppointmentProvider.setMaster(masterModel: _filteredMasters[index]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MasterProfile(
                                                    salonModel: widget.salonModel,
                                                    masterModel: _filteredMasters[index],
                                                    categories: masterCategories,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: MasterAvatar(
                                              personImageUrl: _filteredMasters[index].profilePicUrl,
                                              personName: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                                              rating: _filteredMasters[index].avgRating,
                                              categories: masterCategories,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Space(factor: 0.2),
                                  Divider(
                                    color: isLightTheme ? Colors.black : Colors.white,
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MasterAvatar extends ConsumerWidget {
  final String? personImageUrl;
  final String? personName;
  final double? rating;
  final List<CategoryModel> categories;

  const MasterAvatar({
    Key? key,
    required this.personImageUrl,
    required this.personName,
    required this.rating,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: AppTheme.coolGrey,
            border: !isLightTheme ? Border.all(color: Colors.white, width: 1) : null,
          ),
          child: (personImageUrl != null && personImageUrl != '')
              ? Image.network(
                  personImageUrl!,
                  fit: BoxFit.cover,
                )
              : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        // Text(
        //   categories[0].translations[AppLocalizations.of(context)?.localeName], //  'Nail Professional',
        //   style: theme.textTheme.bodyLarge!.copyWith(
        //     fontWeight: FontWeight.w500,
        //     fontSize: 16.sp,
        //     color: isLightTheme ? Colors.black : theme.primaryColor,
        //   ),
        // ),
        // const SizedBox(height: 5),
        Text(
          personName ?? "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: isLightTheme ? AppTheme.textBlack : Colors.white,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        if (rating != 0) ...[
          const SizedBox(height: 7),
          BnbRatings(
            rating: rating ?? 0,
            editable: false,
            starSize: 10,
            color: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
            padding: 3.5,
          ),
        ],
      ],
    );
  }
}
