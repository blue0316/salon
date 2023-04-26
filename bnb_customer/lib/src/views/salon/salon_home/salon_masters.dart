import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/master/master_profile.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/salon_master/master.dart';
import '../../../models/salon_master/salon.dart';
import '../../../theme/app_main_theme.dart';
import '../widgets/person_avtar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaloonMasters extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SaloonMasters({Key? key, required this.salonModel}) : super(key: key);
  @override
  _SaloonMastersState createState() => _SaloonMastersState();
}

class _SaloonMastersState extends ConsumerState<SaloonMasters> {
  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    return ConstrainedContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (AppTheme.margin * 2).h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Text(
              (AppLocalizations.of(context)?.localeName == 'uk') ? saloonDetailsTitlesUK[2] : saloonDetailsTitles[2].toCapitalized(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppTheme.textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 30.sp,
                  ),
            ),
            const Space(factor: 2),
            const Divider(color: Color(0XFF9D9D9D), thickness: 1),
            const SizedBox(height: AppTheme.margin * 0.6),
            ListView.builder(
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
                              Container(
                                height: DeviceConstraints.getResponsiveSize(context, 40.h, 55.h, 55.h),
                                width: DeviceConstraints.getResponsiveSize(context, 40.h, 55.h, 55.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color.fromARGB(255, 239, 239, 239),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Center(
                                    child: Image.asset(
                                      AppIcons.getPngIconFromCategoryId(id: _salonSearchProvider.categories[index].categoryId),
                                      height: DeviceConstraints.getResponsiveSize(context, 20, 35, 40),
                                    ),
                                  ),
                                ),
                              ),
                              SpaceHorizontal(
                                width: DeviceConstraints.getResponsiveSize(context, 15, 30, 30),
                              ),
                              Text(
                                _salonSearchProvider.categories[index].translations[AppLocalizations.of(context)?.localeName],
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp, //  DeviceConstraints.getResponsiveSize(context, 15.sp, 18.sp, 18.sp),
                                    ),
                              ),
                              SpaceHorizontal(
                                width: DeviceConstraints.getResponsiveSize(context, 10, 25, 25),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 239, 239, 239),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                  child: Text(
                                    " (${_filteredMasters.length}) masters ",
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontSize: 13.sp,
                                          // fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Space(factor: 1.5),

                          /// --- MASTER AVATAR ----
                          Container(
                            height: DeviceConstraints.getResponsiveSize(context, 110, 140, 170),
                            alignment: Alignment.centerLeft,
                            child: ListView.builder(
                                itemCount: _filteredMasters.length,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 12.w), // (left: 40.0.w, right: 8.w),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      key: const ValueKey("tap-master"),
                                      onTap: () {
                                        _createAppointmentProvider.setMaster(
                                          masterModel: _filteredMasters[index],
                                          categories: _salonSearchProvider.categories,
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MasterProfile(
                                              salonModel: widget.salonModel,
                                              masterModel: _filteredMasters[index],
                                              categories: const [],
                                            ),
                                          ),
                                        );
                                      },
                                      child: PersonAvtar(
                                        personImageUrl: _filteredMasters[index].profilePicUrl,
                                        personName: Utils().getNameMaster(_filteredMasters[index].personalInfo),
                                        radius: DeviceConstraints.getResponsiveSize(context, 25, 35, 50),
                                        showBorder: false,
                                        showRating: true,
                                        rating: _filteredMasters[index].avgRating,
                                        starSize: 15,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const Space(factor: 0.2),
                          const Divider(color: Color(0XFF9D9D9D), thickness: 1),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }
}
