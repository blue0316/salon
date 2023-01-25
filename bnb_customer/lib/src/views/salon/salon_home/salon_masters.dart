import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/master/master_profile.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                          Padding(
                            padding: EdgeInsets.zero, // EdgeInsets.only(left: 30.0.w, right: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// --- ICON, SECTION TITLE, X MASTERS ---
                                Row(
                                  children: [
                                    Container(
                                      height: 55.h,
                                      width: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color.fromARGB(255, 239, 239, 239),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppIcons.getIconFromCategoryId(id: _salonSearchProvider.categories[index].categoryId),
                                            color: AppTheme.black,
                                            height: DeviceConstraints.getResponsiveSize(context, 25, 35, 40),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SpaceHorizontal(width: 30),

                                    Text(
                                      _salonSearchProvider.categories[index].translations[AppLocalizations.of(context)?.localeName],
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                          ),
                                    ),
                                    const SpaceHorizontal(width: 25),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 239, 239, 239),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        child: Text(
                                          " (${_filteredMasters.length}) masters",
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                fontSize: 15.sp,
                                                // fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                    // RichText(
                                    //   text: TextSpan(
                                    //     children: [
                                    //       TextSpan(
                                    //         text: _salonSearchProvider.categories[index].translations[AppLocalizations.of(context)?.localeName],
                                    //         style: Theme.of(context).textTheme.bodyText1,
                                    //       ),
                                    //       TextSpan(
                                    //           text: " (${_filteredMasters.length})",
                                    //           style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    //                 fontSize: 14,
                                    //                 fontWeight: FontWeight.w400,
                                    //               )),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Space(factor: 1.5),

                          /// --- MASTER AVATAR ----
                          Container(
                            height: DeviceConstraints.getResponsiveSize(context, 70, 120, 170),
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
                                        _createAppointmentProvider.setMaster(masterModel: _filteredMasters[index]);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MasterProfile(
                                              masterModel: _filteredMasters[index],
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
