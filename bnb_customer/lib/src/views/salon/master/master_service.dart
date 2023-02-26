import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/profile_datails_tabs.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/service_expension_tile.dart';
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
    return ConstrainedContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (AppTheme.margin * 2).h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              (AppLocalizations.of(context)?.localeName == 'uk') ? masterDetailsTitles[0] : masterDetailsTitles[0].toCapitalized(),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 30.sp,
                    letterSpacing: -1,
                  ),
            ),
            const Space(factor: 2),
            const Divider(color: Color(0XFF9D9D9D), thickness: 1.3),
            ListView.builder(
                itemCount: _salonSearchProvider.categories.length + 1,
                shrinkWrap: true,
                primary: false,
                controller: _listViewController,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  List<ServiceModel> services = _createAppointmentProvider.mastersServicesMapAll[widget.master.masterId]?.where((element) => element.categoryId == (index).toString()).toList() ?? [];

                  if (services.isNotEmpty) {
                    return ServiceTile(
                      services: services,
                      categoryModel: _salonSearchProvider.categories.where((element) => element.categoryId == (index).toString()).first,
                      listViewController: _listViewController,
                      initiallyExpanded: false,
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            SizedBox(height: 100.h)
          ],
        ),
      ),
    );
  }
}
