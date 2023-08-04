import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/views/salon/default_profile_view/salon_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/section_spacer.dart';
import 'widgets/service_tile.dart';

class SalonServices extends ConsumerStatefulWidget {
  const SalonServices({Key? key}) : super(key: key);

  @override
  ConsumerState<SalonServices> createState() => _SalonServicesState();
}

class _SalonServicesState extends ConsumerState<SalonServices> {
  bool choosen = false;
  final ScrollController _listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SectionSpacer(
          title: salonTitles(AppLocalizations.of(context)?.localeName ?? 'en')[0],
        ),
        SizedBox(
          // height: 1000.h,
          width: double.infinity,
          // color: Colors.white.withOpacity(0.7),
          child: ListView.builder(
            itemCount: _salonSearchProvider.categories.length,
            shrinkWrap: true,
            primary: false,
            controller: _listViewController,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              if (_createAppointmentProvider.categoryServicesMap[_salonSearchProvider.categories[index].categoryId.toString()] != null && _createAppointmentProvider.categoryServicesMap[_salonSearchProvider.categories[index].categoryId.toString()]!.isNotEmpty) {
                final CategoryModel categoryModel = _salonSearchProvider.categories
                    .where((
                      element,
                    ) =>
                        element.categoryId == _salonSearchProvider.categories[index].categoryId.toString())
                    .first;

                return NewServiceTile(
                  services: _createAppointmentProvider.categoryServicesMap[_salonSearchProvider.categories[index].categoryId.toString()] ?? [],
                  categoryModel: categoryModel,
                  listViewController: _listViewController,
                  // initiallyExpanded: true,
                  initiallyExpanded: _createAppointmentProvider.chosenServices
                      .where(
                        (element) => element.categoryId == categoryModel.categoryId,
                      )
                      .isNotEmpty,
                );
                // return Text("data");
              } else {
                return const SizedBox();
              }
              // return Text("data");
            },
          ),
        ),
      ],
    );
  }
}
