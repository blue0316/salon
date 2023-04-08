import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/utils/utils.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/section_spacer.dart';
import 'package:bbblient/src/views/salon/default_profile_view/widgets/service_tile.dart';
import 'package:bbblient/src/views/salon/widgets/person_avtar.dart';
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
    bool isLightTheme = (theme == AppTheme.lightTheme);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SectionSpacer(
            title: (AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitles[0] : masterDetailsTitles[0].toCapitalized(),
          ),
          Container(
            width: double.infinity,
            color: Colors.white.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: MasterImageHeader(
                      master: widget.master,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                      itemCount: _salonSearchProvider.categories.length + 1,
                      shrinkWrap: true,
                      primary: false,
                      controller: _listViewController,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        List<ServiceModel> services = _createAppointmentProvider.mastersServicesMapAll[widget.master.masterId]?.where((element) => element.categoryId == (index).toString()).toList() ?? [];

                        if (services.isNotEmpty) {
                          return NewServiceTile(
                            services: services,
                            categoryModel: _salonSearchProvider.categories.where((element) => element.categoryId == (index).toString()).first,
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
    bool isLightTheme = (theme == AppTheme.lightTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Space(factor: 2),
        SizedBox(
          height: 180.h,
          width: 150.h,
          child: Column(
            children: [
              PersonAvtar(
                personImageUrl: master.profilePicUrl,
                personName: Utils().getNameMaster(master.personalInfo),
                radius: DeviceConstraints.getResponsiveSize(context, 25, 35, 50),
                showBorder: false,
                showRating: true,
                rating: master.avgRating,
                starSize: 10,
                ratingColor: isLightTheme ? const Color(0XFFF49071) : const Color(0XFFFFA755),
                padding: 3.5,
                height: 80,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
