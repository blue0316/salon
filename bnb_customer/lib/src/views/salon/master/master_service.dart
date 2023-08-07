import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/service_tile.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterServices extends ConsumerStatefulWidget {
  final MasterModel master;
  const MasterServices({required this.master, Key? key}) : super(key: key);

  @override
  _MasterServicesState createState() => _MasterServicesState();
}

class _MasterServicesState extends ConsumerState<MasterServices> {
  bool choosen = false;
  final ScrollController _listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: theme.canvasColor.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  const Space(factor: 1.5),
                  Text(
                    (masterTitles(AppLocalizations.of(context)?.localeName ?? 'en')[0]).toUpperCase(),
                    style: theme.textTheme.displayLarge!.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 30.sp, 35.sp),
                      color: isLightTheme ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Space(factor: 2.5),
                  ListView.builder(
                      itemCount: _salonSearchProvider.categories.length,
                      shrinkWrap: true,
                      primary: false,
                      controller: _listViewController,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        List<ServiceModel> services = _createAppointmentProvider.mastersServicesMapAll[widget.master.masterId]
                                ?.where(
                                  (element) => element.categoryId == (_salonSearchProvider.categories[index].categoryId).toString(),
                                )
                                .toList() ??
                            [];

                        if (services.isNotEmpty) {
                          return NewServiceTile(
                            services: services,
                            categoryModel: _salonSearchProvider.categories
                                .where(
                                  (element) => element.categoryId == (_salonSearchProvider.categories[index].categoryId).toString(),
                                )
                                .first,
                            listViewController: _listViewController,
                            initiallyExpanded: false,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              ),
            ),
          ),
          // SizedBox(height: 100.h)
        ],
      ),
    );
  }
}

class MasterImageHeader extends ConsumerWidget {
  final MasterModel master;

  const MasterImageHeader({Key? key, required this.master}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool isLightTheme = (theme == AppTheme.lightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Space(factor: 0.5),
        SizedBox(
          height: 220.h,
          // width: 150.h,
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppTheme.coolGrey,
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
                child: (master.profilePicUrl != null && master.profilePicUrl != '')
                    ? Image.network(
                        master.profilePicUrl!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(AppIcons.masterDefaultAvtar, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                Utils().getNameMaster(master.personalInfo),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // isLightTheme ? AppTheme.textBlack : Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Text(
              //   Utils().getNameMaster(master.personalInfo),
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //         fontSize: 15.sp,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.white, // isLightTheme ? AppTheme.textBlack : Colors.white,
              //       ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
