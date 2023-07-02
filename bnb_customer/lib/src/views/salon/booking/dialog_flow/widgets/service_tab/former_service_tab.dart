import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/appointment/widgets/theme_colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'floating_button.dart';

class XServiceTab extends ConsumerStatefulWidget {
  final TabController tabController;
  final bool master;
  final MasterModel? masterModel;

  const XServiceTab({
    Key? key,
    required this.tabController,
    this.master = false,
    this.masterModel,
  }) : super(key: key);

  @override
  ConsumerState<XServiceTab> createState() => _XServiceTabState();
}

class _XServiceTabState extends ConsumerState<XServiceTab> {
  final PageController _pageController = PageController();
  final PageController _masterPageController = PageController();
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();

  DateTime date = DateTime.now();
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool defaultTheme = (theme == AppTheme.customLightTheme);

    // // Combine all services available into one to show in 'All' tab
    // List<ServiceModel> allServices = [];
    // for (var element in _createAppointmentProvider.servicesAvailable) {
    //   allServices = allServices + element;
    // }

    // // To populate page view children
    // List<List<ServiceModel>> services = [allServices, ..._createAppointmentProvider.servicesAvailable];
    ThemeType themeType = _salonProfileProvider.themeType;

    bool isExpanded = false;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
      ),
      child: (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    for (CategoryModel categoryModel in _createAppointmentProvider.categoriesAvailable) {
                      print(categoryModel.categoryName);
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 500,
                    color: Colors.purple,
                  ),
                ),
                // SizedBox(height: 20.h),
                Container(
                  height: 45.sp,
                  color: Colors.brown,
                  child: ListView.builder(
                    itemCount: _createAppointmentProvider.categoriesAvailable.length + 1,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CategoryModel? element;
                      // print(index);
                      if (index != 0) {
                        element = _createAppointmentProvider.categoriesAvailable[index - 1];
                      } else {
                        element = null;
                      }

                      return index != 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    _createAppointmentProvider.changeSelectedCategory(element);
                                  });

                                  _createAppointmentProvider.filteredServicesList!.clear();

                                  _createAppointmentProvider.searchablefilteredServicesList!.clear();

                                  debugPrint("filtering...");
                                  for (ServiceModel _service in _createAppointmentProvider.categoryServicesMap[element!.categoryId] ?? []) {
                                    // Populate filterable product list
                                    _createAppointmentProvider.filteredServicesList!.add(_service);
                                  }
                                  // debugPrint("filtering");
                                  // Populate searchable product list
                                  // _createAppointmentProvider.onSearchServices(_createAppointmentProvider.searchServicesControl!.text);
                                },
                                child: Container(
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: _createAppointmentProvider.selectedCat != null && _createAppointmentProvider.selectedCat!.categoryId == element!.categoryId ? theme.primaryColor : Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                                    border: Border.all(
                                      width: 0.5,
                                      color: _createAppointmentProvider.selectedCat != null && _createAppointmentProvider.selectedCat!.categoryId == element!.categoryId ? Colors.transparent : Colors.white,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          element!.categoryName.toTitleCase(),
                                          style: TextStyle(
                                            color: _createAppointmentProvider.selectedCat != null && _createAppointmentProvider.selectedCat!.categoryId == element.categoryId ? Colors.blue : Colors.white,
                                            fontFamily: "Inter",
                                            fontSize: 14.sp,
                                            fontWeight: _createAppointmentProvider.selectedCat != null && _createAppointmentProvider.selectedCat!.categoryId == element.categoryId ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    _createAppointmentProvider.selectedCat = null;
                                  });

                                  // _createAppointmentProvider.filteredServicesList!.clear();

                                  // _createAppointmentProvider.searchablefilteredServicesList!.clear();

                                  // debugPrint("filtering...");
                                  // // Populate filterable product list
                                  // _createAppointmentProvider.allSalonServices!.forEach((ServiceModel element) => _createAppointmentProvider.filteredServicesList!.add(element));

                                  // // Populate searchable product list
                                  // _createAppointmentProvider.onSearchServices(_createAppointmentProvider.searchServicesControl!.text);
                                },
                                child: Container(
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      color: _createAppointmentProvider.selectedCat == null ? theme.primaryColor : Colors.transparent,
                                      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.white,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'All',
                                          style: theme.textTheme.bodyLarge!.copyWith(
                                            color: _createAppointmentProvider.selectedCat == null ? Colors.green : Colors.white,
                                            // color: Colors.white, // _activeTab == index ? AppTheme.textBlack : AppTheme.lightGrey,
                                            fontWeight: _createAppointmentProvider.selectedCat == null ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),

                SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 30.h)),
                // SERVICES
                // _createAppointmentProvider.selectedItems.isNotEmpty
                //     ? GroupedListView<ServiceModel, String>(
                //         elements: _createAppointmentProvider.selectedItems,
                //         groupBy: (element) => element.categoryId,
                //         groupComparator: (value1, value2) => value1.compareTo(value2),
                //         shrinkWrap: true,
                //         groupSeparatorBuilder: (String value) => Padding(
                //           padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                //           child: Text(
                //             _createAppointmentProvider.getCategoryFromId(value) != null ? _createAppointmentProvider.getCategoryFromId(value)!.categoryName.toUpperCase() : 'tr(Keys.other)'.toUpperCase(),
                //             style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400),
                //           ),
                //         ),
                //         itemBuilder: (c, element) {
                //           // print(element.isSelected);
                //           // _isSelected = element.isSelected ?? false;
                //           // isFixed = element.isFixedPrice;
                //           // isRange = element.isPriceRange;
                //           // isFrom = element.isPriceStartAt;
                //           List<ServiceModel> currentItemGroup = _createAppointmentProvider.selectedSubItems;

                //           ServiceModel mainItem = element;
                //           List<ServiceModel> subItems = currentItemGroup;
                //           bool isSelected = _createAppointmentProvider.selectedItems.contains(mainItem);

                //           return GestureDetector(
                //             onTap: () {
                //               _createAppointmentProvider.toggleCookings(
                //                 serviceModel: element,
                //                 selected: () {
                //                   _createAppointmentProvider.selectedItems.clear();
                //                   _createAppointmentProvider.selectedSubItems.clear();
                //                   _createAppointmentProvider.totalSelectedSubItems.clear();

                //                   // _createAppointmentProvider!.selectedItems.add(mainItem);
                //                   _createAppointmentProvider.getServiceMasters();
                //                 },
                //                 unselected: () {
                //                   _createAppointmentProvider.selectedSubItems.remove(mainItem);
                //                   _createAppointmentProvider.totalSelectedSubItems.remove(mainItem);
                //                   _createAppointmentProvider.selectedItems.remove(mainItem);
                //                   _createAppointmentProvider.selectedItems.removeWhere((item) => subItems.contains(item));
                //                 },
                //               );
                //             },
                //             child: ServiceCard(
                //               isAdded: _isSelected,
                //               service: element,
                //             ),
                //           );
                //         },
                //       )
                //     :
                GroupedListView<ServiceModel, String>(
                  elements: _createAppointmentProvider.searchablefilteredServicesList!,
                  groupBy: (element) => element.categoryId,
                  groupComparator: (value1, value2) => value1.compareTo(value2),
                  shrinkWrap: true,
                  groupSeparatorBuilder: (String value) => Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    child: Text(
                      _createAppointmentProvider.getCategoryFromId(value) != null ? _createAppointmentProvider.getCategoryFromId(value)!.categoryName.toUpperCase() : 'tr(Keys.other)'.toUpperCase(),
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  itemBuilder: (c, element) {
                    // print(element.isSelected);
                    // _isSelected = element.isSelected ?? false;
                    // isFixed = element.isFixedPrice;
                    // isRange = element.isPriceRange;
                    // isFrom = element.isPriceStartAt;
                    List<ServiceModel> currentItemGroup = _createAppointmentProvider.searchablefilteredServicesList!;
                    ServiceModel mainItem = element;
                    List<ServiceModel> subItems = currentItemGroup;
                    bool isSelected = _createAppointmentProvider.selectedItems.contains(mainItem);

                    return GestureDetector(
                      onTap: () {
                        // _createAppointmentProvider.toggleCookings(
                        //   serviceModel: element,
                        //   selected: () {
                        //     _createAppointmentProvider.selectedItems.clear();
                        //     _createAppointmentProvider.selectedSubItems.clear();
                        //     _createAppointmentProvider.selectedItems.add(mainItem);
                        //     _createAppointmentProvider.getServiceMasters();
                        //     _createAppointmentProvider.totalSelectedSubItems.add(mainItem);
                        //   },
                        //   unselected: () {
                        //     _createAppointmentProvider.selectedSubItems.remove(mainItem);
                        //     _createAppointmentProvider.selectedItems.remove(mainItem);
                        //     _createAppointmentProvider.totalSelectedSubItems.remove(mainItem);
                        //     _createAppointmentProvider.selectedItems.removeWhere((item) => subItems.contains(item));
                        //   },
                        // );
                      },
                      child: ServiceCard(
                        isAdded: _isSelected,
                        service: element,
                      ),
                    );
                  },
                ),
                if (_createAppointmentProvider.selectedItems.isNotEmpty)
                  const Text(
                    'Unavailable  Services',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                // if (_createAppointmentProvider.selectedItems.isNotEmpty)
                //   GroupedListView<ServiceModel, String>(
                //     elements: _createAppointmentProvider.unavailableSelectedItems,
                //     groupBy: (element) => element.categoryId,
                //     groupComparator: (value1, value2) => value1.compareTo(value2),
                //     shrinkWrap: true,
                //     groupSeparatorBuilder: (String value) => Padding(
                //       padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                //       child: Text(
                //         _createAppointmentProvider.getCategoryFromId(value) != null ? _createAppointmentProvider.getCategoryFromId(value)!.categoryName.toUpperCase() : 'tr(Keys.other)'.toUpperCase(),
                //         style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //     itemBuilder: (c, element) {
                //       // print(element.isSelected);
                //       // _isSelected = element.isSelected ?? false;
                //       // isFixed = element.isFixedPrice;
                //       // isRange = element.isPriceRange;
                //       // isFrom = element.isPriceStartAt;
                //       List<ServiceModel> currentItemGroup = _createAppointmentProvider.unavailableSelectedItems;

                //       ServiceModel mainItem = element;
                //       List<ServiceModel> subItems = currentItemGroup;
                //       bool isSelected = false;

                //       return GestureDetector(
                //         onTap: () {
                //           _createAppointmentProvider.toggleCookings(
                //             serviceModel: element,
                //             unselected: () {},
                //             selected: () {},
                //           );
                //         },
                //         child: ServiceCard(
                //           isAdded: _isSelected,
                //           service: element,
                //         ),
                //       );
                //     },
                //   ),

                SizedBox(height: 50.sp),
                DefaultButton(
                  borderRadius: 60,
                  onTap: () {
                    if (_createAppointmentProvider.chosenServices.isEmpty) {
                      showToast('Please select at least one service');
                      return;
                    }
                    _createAppointmentProvider.initMastersAndTime();

                    // _createAppointmentProvider.initTimeOfDay();
                    // _createAppointmentProvider.onDateChange(date);

                    // Go to Date and Time
                    widget.tabController.animateTo(1);
                  },
                  color: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor, // defaultTheme ? Colors.black : theme.primaryColor,
                  borderColor: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor,
                  textColor: loaderColor(themeType),
                  height: 60.sp,
                  label: _createAppointmentProvider.chosenServices.isEmpty ? AppLocalizations.of(context)?.book ?? "Book" : '${AppLocalizations.of(context)?.book ?? "Book"} ${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(context)?.services ?? "services"}',
                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),

                  suffixIcon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: loaderColor(themeType),
                    size: 18.sp,
                  ),
                  noBorder: true,
                ),
              ],
            )
          : Center(
              child: Text(
                (AppLocalizations.of(context)?.noServicesAvailable ?? 'No services available').toUpperCase(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                  color: theme.colorScheme.tertiary, // defaultTheme ? Colors.black : Colors.white,
                ),
              ),
            ),
    );
  }
}

Color loaderColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.white;
    case ThemeType.GlamMinimalDark:
      return Colors.black;
    case ThemeType.GlamLight:
      return Colors.white;
    case ThemeType.Barbershop:
      return Colors.black;
    case ThemeType.DefaultLight:
      return Colors.white;

    default:
      return Colors.black;
  }
}
///
///
///
///
///
///
///
///
///
///
// ///import 'package:bbblient/src/controller/all_providers/all_providers.dart';
// import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
// import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
// import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
// import 'package:bbblient/src/models/salon_master/master.dart';
// import 'package:bbblient/src/theme/app_main_theme.dart';
// import 'package:bbblient/src/utils/device_constraints.dart';
// import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
// import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
// import 'package:bbblient/src/views/themes/utils/theme_type.dart';
// import 'package:bbblient/src/views/widgets/buttons.dart';
// import 'package:bbblient/src/views/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class ServiceTab extends ConsumerStatefulWidget {
//   final TabController tabController;
//   final bool master;
//   final MasterModel? masterModel;

//   const ServiceTab({
//     Key? key,
//     required this.tabController,
//     this.master = false,
//     this.masterModel,
//   }) : super(key: key);

//   @override
//   ConsumerState<ServiceTab> createState() => _ServiceTabState();
// }

// class _ServiceTabState extends ConsumerState<ServiceTab> {
//   final PageController _pageController = PageController();
//   final PageController _masterPageController = PageController();
//   int _activeTab = 0;
//   final ScrollController _scrollController = ScrollController();

//   DateTime date = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
//     final _createAppointmentProvider = ref.watch(createAppointmentProvider);
//     final _salonSearchProvider = ref.watch(salonSearchProvider);

//     final ThemeData theme = _salonProfileProvider.salonTheme;
//     bool defaultTheme = (theme == AppTheme.customLightTheme);

//     // // Combine all services available into one to show in 'All' tab
//     // List<ServiceModel> allServices = [];
//     // for (var element in _createAppointmentProvider.servicesAvailable) {
//     //   allServices = allServices + element;
//     // }

//     // // To populate page view children
//     // List<List<ServiceModel>> services = [allServices, ..._createAppointmentProvider.servicesAvailable];
//     ThemeType themeType = _salonProfileProvider.themeType;

//     bool isExpanded = false;

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: DeviceConstraints.getResponsiveSize(context, 17.w, 20.w, 20.w),
//       ),
//       child: (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     for (CategoryModel categoryModel in _createAppointmentProvider.categoriesAvailable) {
//                       print(categoryModel.categoryName);
//                     }
//                   },
//                   child: Container(
//                     height: 100,
//                     width: 500,
//                     color: Colors.purple,
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.zero,
//                   child: Container(
//                     color: Colors.yellow,
//                     height: DeviceConstraints.getResponsiveSize(context, 45.h, 50.h, 50.h),
//                     child: ListView.builder(
//                       itemCount: _createAppointmentProvider.masterCategoryAndServices.length + 1,
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       controller: _scrollController,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (_, index) {
//                         List<CategoryModel> catList = [
//                           CategoryModel(
//                             categoryName: 'All',
//                             categoryId: 'all',
//                             translations: {'en': 'All'},
//                           ),
//                           ..._createAppointmentProvider.masterCategoryAndServices.keys.toList(),
//                         ];

//                         bool isServiceAddedBelogingToCategory = _createAppointmentProvider.isCategoryServiceAdded(
//                           categoryModel: catList[index],
//                         );

//                         Color selectedColor = defaultTheme ? (Colors.grey[400]!) : theme.colorScheme.tertiary;
//                         return Padding(
//                           padding: EdgeInsets.only(
//                             right: DeviceConstraints.getResponsiveSize(context, 15.w, 10.w, 7.w),
//                           ),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _pageController.jumpToPage(index);
//                                 _activeTab = index;
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: isServiceAddedBelogingToCategory ? selectedColor : Colors.transparent,
//                                 border: isServiceAddedBelogingToCategory
//                                     ? null
//                                     : Border.all(
//                                         color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
//                                         width: DeviceConstraints.getResponsiveSize(context, 1, 1, 1.4),
//                                       ),

//                                 // color: _activeTab == index ? const Color.fromARGB(255, 239, 239, 239) : Theme.of(context).scaffoldBackgroundColor,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Center(
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: DeviceConstraints.getResponsiveSize(context, 25.w, 15.w, 10.w),
//                                   ),
//                                   child: Text(
//                                     catList[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'],
//                                     style: theme.textTheme.bodyLarge!.copyWith(
//                                       color: isServiceAddedBelogingToCategory ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
//                                       // color: Colors.white, // _activeTab == index ? AppTheme.textBlack : AppTheme.lightGrey,
//                                       fontWeight: FontWeight.w400, // _activeTab == index ? FontWeight.w500 : FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 30.h)),
//                 // SERVICES FOR SALON

//                 // _createAppointmentProvider.selectedItems.isEmpty
//                 //     ?
//                 Expanded(
//                   child: Container(
//                     color: Colors.red,
//                     child: PageView(
//                       controller: _masterPageController,
//                       onPageChanged: (i) {
//                         setState(() {
//                           _activeTab = i;
//                         });
//                       },
//                       children: [
//                         // All Section
//                         ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _createAppointmentProvider.masterCategoryAndServices.length,
//                           itemBuilder: (context, index) {
//                             final CategoryModel categoryModel = _createAppointmentProvider.masterCategoryAndServices.keys.elementAt(index);
//                             final List<ServiceModel> services = _createAppointmentProvider.masterCategoryAndServices[categoryModel] ?? [];

//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 15.h)),
//                                 Divider(
//                                   color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
//                                   thickness: 1,
//                                 ),
//                                 SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 20.h)),
//                                 Text(
//                                   categoryModel.categoryName,
//                                   style: theme.textTheme.bodyLarge!.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
//                                     color: theme.colorScheme.tertiary, //defaultTheme ? AppTheme.textBlack : Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: DeviceConstraints.getResponsiveSize(context, 10.h, 10.h, 10.h),
//                                 ),
//                                 ServiceList(services: services),
//                               ],
//                             );
//                           },
//                         ),

//                         // Other Page views
//                         ..._createAppointmentProvider.masterServicesAvailable
//                             .map(
//                               (services) => ServiceList(services: services),
//                             )
//                             .toList(),
//                       ],
//                     ),
//                   ),
//                 )
//                 // : Container(
//                 //     color: Colors.blue,
//                 //     height: DeviceConstraints.getResponsiveSize(context, 45.h, 50.h, 50.h),
//                 //     child: ListView.builder(
//                 //       itemCount: _createAppointmentProvider.selectedItems.length,
//                 //       scrollDirection: Axis.horizontal,
//                 //       shrinkWrap: true,
//                 //       controller: _scrollController,
//                 //       physics: const NeverScrollableScrollPhysics(),
//                 //       itemBuilder: (_, index) {
//                 //         List<ServiceModel> selectedItemServices = _createAppointmentProvider.selectedItems;
//                 //         ServiceModel mainItem = selectedItemServices[index];

//                 //         return GestureDetector(
//                 //           onTap: () {
//                 //             _createAppointmentProvider.toggleCookings(
//                 //               serviceModel: selectedItemServices[index],
//                 //               selected: () {
//                 //                 _createAppointmentProvider.selectedItems.clear();
//                 //                 _createAppointmentProvider.selectedSubItems.clear();
//                 //                 _createAppointmentProvider.selectedItems.add(mainItem);
//                 //                 _createAppointmentProvider.getServiceMasters();
//                 //                 _createAppointmentProvider.totalSelectedSubItems.add(mainItem);
//                 //               },
//                 //               unselected: () {
//                 //                 _createAppointmentProvider.selectedSubItems.remove(mainItem);
//                 //                 _createAppointmentProvider.selectedItems.remove(mainItem);
//                 //                 _createAppointmentProvider.totalSelectedSubItems.remove(mainItem);
//                 //                 // _createAppointmentProvider.selectedItems.removeWhere((item) => subItems.contains(item));
//                 //               },
//                 //             );
//                 //           },
//                 //           child: ServiceCard(
//                 //             isAdded: false,
//                 //             service: mainItem,
//                 //           ),
//                 //         );
//                 //       },
//                 //     ),
//                 //   ),

//                 // DefaultButton(
//                 //   borderRadius: 60,
//                 //   onTap: () {
//                 //     if (_createAppointmentProvider.chosenServices.isEmpty) {
//                 //       showToast('Please select at least one service');
//                 //       return;
//                 //     }
//                 //     _createAppointmentProvider.initMastersAndTime();

//                 //     // _createAppointmentProvider.initTimeOfDay();
//                 //     // _createAppointmentProvider.onDateChange(date);

//                 //     // Go to Date and Time
//                 //     widget.tabController.animateTo(1);
//                 //   },
//                 //   color: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor, // defaultTheme ? Colors.black : theme.primaryColor,
//                 //   borderColor: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor,
//                 //   textColor: loaderColor(themeType),
//                 //   height: 60.sp,
//                 //   label: _createAppointmentProvider.chosenServices.isEmpty ? AppLocalizations.of(context)?.book ?? "Book" : '${AppLocalizations.of(context)?.book ?? "Book"} ${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(context)?.services ?? "services"}',
//                 //   fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),

//                 //   suffixIcon: Icon(
//                 //     Icons.arrow_forward_ios_rounded,
//                 //     color: loaderColor(themeType),
//                 //     size: 18.sp,
//                 //   ),
//                 //   noBorder: true,
//                 // ),
//               ],
//             )
//           : Center(
//               child: Text(
//                 (AppLocalizations.of(context)?.noServicesAvailable ?? 'No services available').toUpperCase(),
//                 style: theme.textTheme.bodyLarge?.copyWith(
//                   fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
//                   color: theme.colorScheme.tertiary, // defaultTheme ? Colors.black : Colors.white,
//                 ),
//               ),
//             ),
//     );
//   }
// }

// Color loaderColor(ThemeType themeType) {
//   switch (themeType) {
//     case ThemeType.GlamMinimalLight:
//       return Colors.white;
//     case ThemeType.GlamMinimalDark:
//       return Colors.black;
//     case ThemeType.GlamLight:
//       return Colors.white;
//     case ThemeType.Barbershop:
//       return Colors.black;
//     case ThemeType.DefaultLight:
//       return Colors.white;

//     default:
//       return Colors.black;
//   }
// }
