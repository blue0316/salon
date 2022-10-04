import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/service_expension_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Column(
      children: [

        SizedBox(
          height: 8.h,
        ),
        ListView.builder(
            itemCount: _salonSearchProvider.categories.length + 1,
            shrinkWrap: true,
            primary: false,
            controller: _listViewController,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              List<ServiceModel> services = _createAppointmentProvider.mastersServicesMapAll[widget.master.masterId]
                      ?.where((element) => element.categoryId == (index).toString())
                      .toList() ??
                  [];
              

              if (services.isNotEmpty) {
                return ServiceTile(
                  services: services,
                  categoryModel:
                      _salonSearchProvider.categories.where((element) => element.categoryId == (index).toString()).first,
                  listViewController: _listViewController,
                  initiallyExpanded: false,
                );
              } else {
                return const SizedBox();
              }
            }),
        SizedBox(
          height: 200.h,
        )
      ],
    );
  }
}
