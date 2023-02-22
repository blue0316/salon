import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
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
        horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 20.w),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // AppLocalizations.of(context)?.availableMasters.toCapitalized() ?? 'Available masters',
                'Select a service',
                style: theme.textTheme.bodyText1!.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 30.sp),
                  color: defaultTheme ? AppTheme.textBlack : Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 45.h,
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

                      return Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pageController.jumpToPage(index);
                              _activeTab = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _activeTab == index ? const Color.fromARGB(255, 239, 239, 239) : Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  catList[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'],
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: _activeTab == index ? AppTheme.textBlack : AppTheme.lightGrey,
                                        fontWeight: _activeTab == index ? FontWeight.w500 : FontWeight.w400,
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
              SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 25.h, 35.h)),
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
                      Container(
                        // color: Colors.orangeAccent[100],
                        // height: 100,
                        child: ListView.builder(
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
                                  const SizedBox(height: 20),
                                  const Divider(color: Colors.white, thickness: 1.5),
                                  SizedBox(height: DeviceConstraints.getResponsiveSize(context, 20.h, 30.h, 40.h)),
                                  Text(
                                    categoryModel.categoryName,
                                    style: theme.textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 30.sp, 30.sp),
                                      color: defaultTheme ? AppTheme.textBlack : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: DeviceConstraints.getResponsiveSize(context, 15, 30, 30),
                                  ),
                                  ServiceList(services: services),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
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
              // Expanded(
              //   child: ExpandablePageView(
              //     padEnds: false,
              //     physics: const NeverScrollableScrollPhysics(),
              //     key: const ValueKey("exp"),
              //     controller: _pageController,
              //     onPageChanged: (i) {
              //       // _reportTabChange(i);
              //       setState(() {
              //         _activeTab = i;
              //       });
              //     },
              //     children: services.map((services) {
              //       return InkWell(
              //         onTap: () {
              //           print(_createAppointmentProvider.servicesAvailable.length);
              //           print(allServices.length);
              //         },
              //         child: Column(
              //           // height: MediaQuery.of(context).size.height,
              //           // color: Colors.blue,
              //           children: [
              //             Expanded(
              //               child: ListView.builder(
              //                 itemCount: services.length,
              //                 shrinkWrap: true,
              //                 itemBuilder: (context, index) {
              //                   final ServiceModel service = services[index];
              //                   return Padding(
              //                     padding: const EdgeInsets.symmetric(vertical: 20),
              //                     child: Text(
              //                       service.serviceName,
              //                       style: const TextStyle(
              //                         fontSize: 30,
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     }).toList(),
              //     // children: [
              //     //   Container(
              //     //     height: MediaQuery.of(context).size.height,
              //     //     color: Colors.amber,
              //     //     child: ListView(
              //     //       shrinkWrap: true,
              //     //       children: const [
              //     //         // Container(height: 300, width: 400, color: Colors.white),
              //     //         // Container(height: 300, width: 400, color: Colors.yellow),
              //     //         // Container(height: 300, width: 400, color: Colors.teal),
              //     //         // Container(height: 300, width: 400, color: Colors.black12),
              //     //       ],
              //     //     ),
              //     //   ),
              //     //   Container(
              //     //     height: MediaQuery.of(context).size.height,
              //     //     color: Colors.amber,
              //     //     child: ListView(
              //     //       shrinkWrap: true,
              //     //       children: const [
              //     //         // Container(height: 300, width: 400, color: Colors.white),
              //     //         // Container(height: 300, width: 400, color: Colors.yellow),
              //     //         // Container(height: 300, width: 400, color: Colors.teal),
              //     //         // Container(height: 300, width: 400, color: Colors.black12),
              //     //       ],
              //     //     ),
              //     //   ),
              //     //   Container(
              //     //     height: MediaQuery.of(context).size.height,
              //     //     color: Colors.amber,
              //     //     child: ListView(
              //     //       shrinkWrap: true,
              //     //       children: const [
              //     //         // Container(height: 300, width: 400, color: Colors.white),
              //     //         // Container(height: 300, width: 400, color: Colors.yellow),
              //     //         // Container(height: 300, width: 400, color: Colors.teal),
              //     //         // Container(height: 300, width: 400, color: Colors.black12),
              //     //       ],
              //     //     ),
              //     //   ),
              //     // ],
              //   ),
              // ),
            ],
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
