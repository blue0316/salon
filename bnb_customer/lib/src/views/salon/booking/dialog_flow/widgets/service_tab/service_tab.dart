import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'floating_button.dart';

class ServiceTab extends ConsumerStatefulWidget {
  final TabController tabController;
  const ServiceTab({Key? key, required this.tabController}) : super(key: key);

  @override
  ConsumerState<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends ConsumerState<ServiceTab> {
  final PageController _pageController = PageController();
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.lightTheme);

    // // Combine all services available into one to show in 'All' tab
    // List<ServiceModel> allServices = [];
    // for (var element in _createAppointmentProvider.servicesAvailable) {
    //   allServices = allServices + element;
    // }

    // // To populate page view children
    // List<List<ServiceModel>> services = [allServices, ..._createAppointmentProvider.servicesAvailable];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
      ),
      child: Stack(
        children: [
          Padding(
            padding: _createAppointmentProvider.chosenServices.isEmpty
                ? EdgeInsets.zero
                : EdgeInsets.only(
                    bottom: DeviceConstraints.getResponsiveSize(context, 80.h, 80.h, 80.h),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters',
                  'Select a service',
                  style: theme.textTheme.bodyText1!.copyWith(
                    fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                    color: defaultTheme ? AppTheme.textBlack : Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: DeviceConstraints.getResponsiveSize(context, 45.h, 50.h, 50.h),
                    child: ListView.builder(
                      itemCount: _createAppointmentProvider.categoriesAvailable.length + 1,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemBuilder: (_, index) {
                        List<CategoryModel> catList = [
                          CategoryModel(
                            categoryName: 'All',
                            categoryId: 'all',
                            translations: {'en': 'All'},
                          ),
                          ..._createAppointmentProvider.categoriesAvailable,
                        ];

                        bool isServiceAddedBelogingToCategory = _createAppointmentProvider.isCategoryServiceAdded(
                          categoryModel: catList[index],
                        );
                        // Color selectedColor = theme.highlightColor;
                        Color selectedColor = defaultTheme ? const Color.fromARGB(255, 239, 239, 239) : const Color(0XFF202020);

                        return Padding(
                          padding: EdgeInsets.only(
                            right: DeviceConstraints.getResponsiveSize(context, 15.w, 10.w, 7.w),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageController.jumpToPage(index);
                                _activeTab = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isServiceAddedBelogingToCategory ? selectedColor : Colors.transparent,
                                border: isServiceAddedBelogingToCategory
                                    ? null
                                    : Border.all(
                                        color: defaultTheme ? Colors.black : Colors.white,
                                        width: DeviceConstraints.getResponsiveSize(context, 1, 1, 1.4),
                                      ),

                                // color: _activeTab == index ? const Color.fromARGB(255, 239, 239, 239) : Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: DeviceConstraints.getResponsiveSize(context, 25.w, 15.w, 10.w),
                                  ),
                                  child: Text(
                                    catList[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'],
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          color: defaultTheme ? Colors.black : Colors.white,
                                          // color: Colors.white, // _activeTab == index ? AppTheme.textBlack : AppTheme.lightGrey,
                                          fontWeight: FontWeight.w400, // _activeTab == index ? FontWeight.w500 : FontWeight.w400,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 15.h)),
                Expanded(
                  child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        // _reportTabChange(i);
                        setState(() {
                          _activeTab = i;
                        });
                      },
                      children: [
                        // All Section
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _salonSearchProvider.categories.length,
                          itemBuilder: (context, index) {
                            if (_createAppointmentProvider.categoryServicesMap[_salonSearchProvider.categories[index].categoryId.toString()] != null && _createAppointmentProvider.categoryServicesMap[_salonSearchProvider.categories[index].categoryId.toString()]!.isNotEmpty) {
                              final CategoryModel categoryModel = _salonSearchProvider.categories
                                  .where((
                                    element,
                                  ) =>
                                      element.categoryId == _salonSearchProvider.categories[index].categoryId.toString())
                                  .first;

                              List<ServiceModel> services = _createAppointmentProvider.categoryServicesMap[_salonSearchProvider.categories[index].categoryId.toString()] ?? [];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 15.h)),
                                  Divider(color: defaultTheme ? Colors.black : Colors.white, thickness: 1),
                                  SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 20.h)),
                                  Text(
                                    categoryModel.categoryName,
                                    style: theme.textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: DeviceConstraints.getResponsiveSize(context, 10.h, 10.h, 10.h),
                                  ),
                                  ServiceList(services: services),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),

                        // Other Page views
                        ..._createAppointmentProvider.servicesAvailable
                            .map(
                              (services) => ServiceList(services: services),
                            )
                            .toList(),
                      ]

                      // services.map((services) {
                      //   return Column(
                      //     // height: MediaQuery.of(context).size.height,
                      //     // color: Colors.blue,
                      //     children: [
                      //       Expanded(
                      //         child: SizedBox(
                      //           child: ListView.builder(
                      //             itemCount: services.length,
                      //             shrinkWrap: true,
                      //             itemBuilder: (context, index) {
                      //               final ServiceModel service = services[index];
                      //               return Padding(
                      //                 padding: const EdgeInsets.symmetric(vertical: 20),
                      //                 child: Text(
                      //                   service.serviceName,
                      //                   style: const TextStyle(
                      //                     fontSize: 30,
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   );
                      // }).toList(),
                      ),
                ),
                // SizedBox(height: 100.h),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingButton(
              onTap: () {
                widget.tabController.animateTo(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
