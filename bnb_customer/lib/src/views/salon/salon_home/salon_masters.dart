import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.margin*2),
            primary: false,
            shrinkWrap: true,
            itemCount: _salonSearchProvider.categories.length,
            itemBuilder: (context, index) {
              List<MasterModel> _filteredMasters = _createAppointmentProvider
                  .salonMasters
                  .where((element) => element.categoryIds!.contains(
                      _salonSearchProvider.categories[index].categoryId))
                  .toList();

              if (_filteredMasters.isNotEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30.0.w, right: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  AppIcons.getIconFromCategoryId(
                                      id: _salonSearchProvider
                                          .categories[index].categoryId),
                                  color: AppTheme.lightGrey,
                                ),
                              ),
                              const SpaceHorizontal(),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: _salonSearchProvider
                                                .categories[index].translations[
                                            AppLocalizations.of(context)
                                                ?.localeName],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    TextSpan(
                                        text: " (${_filteredMasters.length})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Space(factor: 1.5),
                    Container(
                      height: DeviceConstraints.getResponsiveSize(
                          context, 100, 150, 200),
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                          itemCount: _filteredMasters.length,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: 40.0.w, right: 8.w),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                key: const ValueKey("tap-master"),
                                onTap: () {
                                  _createAppointmentProvider.setMaster(
                                      masterModel: _filteredMasters[index]);
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
                                  personImageUrl:
                                      _filteredMasters[index].profilePicUrl,
                                  personName: Utils().getNameMaster(
                                      _filteredMasters[index].personalInfo),
                                  radius: DeviceConstraints.getResponsiveSize(
                                      context, 25, 35, 50),
                                  showBorder: false,
                                  showRating: true,
                                  rating: _filteredMasters[index].avgRating,
                                  starSize: 15,
                                ),
                              ),
                            );
                          }),
                    ),
                    const Space(
                      factor: 2,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
        SizedBox(
          height: 100.h,
        ),
      ],
    );
  }
}
