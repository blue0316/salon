import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/service_expension_tile.dart';

class SalonServices extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final List<CategoryModel> categories;

  const SalonServices(
      {Key? key, required this.salonModel, required this.categories})
      : super(key: key);
  @override
  _SaloonServicesState createState() => _SaloonServicesState();
}

class _SaloonServicesState extends ConsumerState<SalonServices> {
  bool choosen = false;
  final ScrollController _listViewController = ScrollController();
  // List<CategoryModel>? categories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);
    return Column(
      children: [
        SizedBox(
          height: 25.h,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Container(
        //       height: 32.w,
        //       width: 32.w,
        //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        //       child: Padding(
        //         padding: EdgeInsets.all(8.0.w),
        //         child: SvgPicture.asset(AppIcons.lensBlackSVG),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 16.w,
        //     ),
        //     Container(
        //       height: 32.w,
        //       width: 32.w,
        //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        //       child: Padding(
        //         padding: EdgeInsets.all(8.0.w),
        //         child: SvgPicture.asset(AppIcons.filterBlackSVG),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 28.w,
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 8.h,
        // ),
        ListView.builder(
            itemCount: _salonSearchProvider.categories.length,
            shrinkWrap: true,
            primary: false,
            controller: _listViewController,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              print("this ids the number here" +
                  _salonSearchProvider.categories.length.toString());
              if (_createAppointmentProvider.categoryServicesMap[
                          _salonSearchProvider.categories[index].categoryId
                              .toString()] !=
                      null &&
                  _createAppointmentProvider
                      .categoryServicesMap[_salonSearchProvider
                          .categories[index].categoryId
                          .toString()]!
                      .isNotEmpty) {
                final CategoryModel categoryModel = _salonSearchProvider
                    .categories
                    .where((element) =>
                        element.categoryId ==
                        _salonSearchProvider.categories[index].categoryId
                            .toString())
                    .first;
                return ServiceTile(
                  services: _createAppointmentProvider.categoryServicesMap[
                          _salonSearchProvider.categories[index].categoryId
                              .toString()] ??
                      [],
                  categoryModel: categoryModel,
                  listViewController: _listViewController,
                  // initiallyExpanded: true,
                  initiallyExpanded: _createAppointmentProvider.chosenServices
                      .where((element) =>
                          element.categoryId == categoryModel.categoryId)
                      .isNotEmpty,
                );
                // return Text("data");
              } else {
                return const SizedBox();
              }
              // return Text("data");
            }),
        SizedBox(
          height: 200.h,
        )
      ],
    );
  }
}
