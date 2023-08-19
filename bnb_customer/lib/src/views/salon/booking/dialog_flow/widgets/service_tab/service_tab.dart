import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grouped_list/grouped_list.dart';

class ServiceTab extends ConsumerStatefulWidget {
  final TabController tabController;
  final bool master;
  final MasterModel? masterModel;

  const ServiceTab({
    Key? key,
    required this.tabController,
    this.master = false,
    this.masterModel,
  }) : super(key: key);

  @override
  ConsumerState<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends ConsumerState<ServiceTab> {
  final PageController _pageController = PageController();
  // final PageController _masterPageController = PageController();
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonSearchProvider = ref.watch(salonSearchProvider);

    final ThemeData theme = _salonProfileProvider.salonTheme;

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
          ? _createAppointmentProvider.selectedItems.isEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.zero,
                            child: SizedBox(
                              height: 45.sp, // DeviceConstraints.getResponsiveSize(context, 35.h, 35.h, 35.h),
                              child: ListView.builder(
                                itemCount: _createAppointmentProvider.categoriesAvailable.length + 1,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (_, index) {
                                  List<CategoryModel> catList = [
                                    CategoryModel(
                                      categoryName: 'All',
                                      categoryId: 'all',
                                      translations: {
                                        'en': 'All',
                                        'es': 'Toda',
                                        'pt': 'Todos',
                                        'ro': 'Toate',
                                        'uk': 'все',
                                        'fr': 'Tout',
                                      },
                                    ),
                                    ..._createAppointmentProvider.categoriesAvailable,
                                  ];

                                  // bool isServiceAddedBelogingToCategory = _createAppointmentProvider.isCategoryServiceAdded(
                                  //   categoryModel: catList[index],
                                  // );

                                  // Color selectedColor = theme.primaryColor; // defaultTheme ? (Colors.grey[400]!) : theme.colorScheme.tertiary;

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
                                          // color: isServiceAddedBelogingToCategory ? selectedColor : Colors.transparent,
                                          border: Border.all(
                                            color: _activeTab == index ? theme.primaryColor : const Color(0XFF4A4A4A),
                                            width: 1,
                                          ),

                                          // isServiceAddedBelogingToCategory
                                          //     ? null
                                          //     : Border.all(
                                          //         color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
                                          //         width: DeviceConstraints.getResponsiveSize(context, 1, 1, 1.4),
                                          //       ),

                                          color: _activeTab == index ? theme.primaryColor : theme.dialogBackgroundColor,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: DeviceConstraints.getResponsiveSize(context, 25.w, 15.w, 10.w),
                                            ),
                                            child: Text(
                                              catList[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? catList[index].translations['en'],
                                              style: theme.textTheme.bodyLarge!.copyWith(
                                                color: _activeTab == index ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //  isServiceAddedBelogingToCategory ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
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
                          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 30.h)),
                          // SERVICES FOR SALON
                          ExpandablePageView(
                            controller: _pageController,
                            onPageChanged: (i) {
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

                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5.sp),
                                      child: Column(
                                        children: [
                                          Theme(
                                            data: ThemeData().copyWith(dividerColor: Colors.transparent),
                                            child: ExpansionTile(
                                              iconColor: const Color(0XFFACACAC), // borderColor(themeType, theme),
                                              collapsedIconColor: const Color(0XFFACACAC), // borderColor(themeType, theme),
                                              tilePadding: EdgeInsets.zero,
                                              childrenPadding: EdgeInsets.zero,
                                              onExpansionChanged: (bool expanded) {
                                                setState(() {
                                                  isExpanded = expanded;
                                                });
                                              },
                                              title: Text(
                                                categoryModel.categoryName,
                                                style: theme.textTheme.bodyLarge!.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  // fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                                  fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                                                  color: theme.colorScheme.tertiary, //defaultTheme ? AppTheme.textBlack : Colors.white,
                                                ),
                                              ),
                                              children: services.map(
                                                (ServiceModel service) {
                                                  List<ServiceModel> subItems = services;
                                                  bool isAdded = _createAppointmentProvider.isAdded(serviceModel: service);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _createAppointmentProvider.toggleCookings(
                                                        serviceModel: service,
                                                        subItems: services,
                                                        selected: () {
                                                          _createAppointmentProvider.selectedItems.clear();
                                                          _createAppointmentProvider.selectedSubItems.clear();
                                                          _createAppointmentProvider.selectedItems.add(service);
                                                          _createAppointmentProvider.getServiceMasters();
                                                          _createAppointmentProvider.totalSelectedSubItems.add(service);
                                                        },
                                                        unselected: () {
                                                          _createAppointmentProvider.selectedSubItems.remove(service);
                                                          _createAppointmentProvider.selectedItems.remove(service);
                                                          _createAppointmentProvider.totalSelectedSubItems.remove(service);
                                                          _createAppointmentProvider.selectedItems.removeWhere((item) => subItems.contains(item));
                                                        },
                                                      );
                                                    },
                                                    child: ServiceCard(
                                                      isAdded: isAdded,
                                                      service: service,
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                          // if (isExpanded == false) SizedBox(height: 4.sp),
                                          if (isExpanded == false)
                                            const Divider(
                                              thickness: 1,
                                              color: Color(0XFF323232),
                                            ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),

                              // Other Page views
                              ..._createAppointmentProvider.servicesAvailable.map(
                                (services) {
                                  List<ServiceModel> subItems = services;

                                  return Column(
                                    children: services
                                        .map(
                                          (service) => GestureDetector(
                                            onTap: () {
                                              _createAppointmentProvider.toggleCookings(
                                                serviceModel: service,
                                                subItems: services,
                                                selected: () {
                                                  _createAppointmentProvider.selectedItems.clear();
                                                  _createAppointmentProvider.selectedSubItems.clear();
                                                  _createAppointmentProvider.selectedItems.add(service);
                                                  _createAppointmentProvider.getServiceMasters();
                                                  _createAppointmentProvider.totalSelectedSubItems.add(service);
                                                },
                                                unselected: () {
                                                  _createAppointmentProvider.selectedSubItems.remove(service);
                                                  _createAppointmentProvider.selectedItems.remove(service);
                                                  _createAppointmentProvider.totalSelectedSubItems.remove(service);
                                                  _createAppointmentProvider.selectedItems.removeWhere((item) => subItems.contains(item));
                                                },
                                              );
                                            },
                                            child: ServiceCard(
                                              isAdded: _createAppointmentProvider.isAdded(serviceModel: service),
                                              service: service,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ).toList(),
                              // ..._createAppointmentProvider.servicesAvailable
                              //     .map(
                              //       (services) => ServiceList(services: services),
                              //     )
                              //     .toList(),
                            ],
                          ),
                          const Spacer(),
                          DefaultButton(
                            borderRadius: 60,
                            onTap: () {
                              if (_createAppointmentProvider.chosenServices.isEmpty) {
                                showToast(
                                  AppLocalizations.of(context)?.pleaseSelectOneService ?? "Please select at least one service",
                                );
                                return;
                              }
                              _createAppointmentProvider.initMastersAndTime(isSingleMaster: _salonProfileProvider.isSingleMaster);

                              // _createAppointmentProvider.initTimeOfDay();
                              // _createAppointmentProvider.onDateChange(date);

                              // Go to Date and Time
                              _createAppointmentProvider.changeBookingFlowIndex();
                              widget.tabController.animateTo(1);
                            },
                            color: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor, // defaultTheme ? Colors.black : theme.primaryColor,
                            borderColor: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor,
                            textColor: loaderColor(themeType),
                            height: 60.sp,
                            label: _createAppointmentProvider.chosenServices.isEmpty ? AppLocalizations.of(context)?.book ?? "Book" : '${AppLocalizations.of(context)?.book ?? "Book"} ${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(context)?.services ?? "services"}',
                            fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                            fontWeight: FontWeight.w500,
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: loaderColor(themeType),
                              size: 18.sp,
                            ),
                            noBorder: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        height: 45.sp, // DeviceConstraints.getResponsiveSize(context, 35.h, 35.h, 35.h),
                        child: ListView.builder(
                          itemCount: _createAppointmentProvider.categoriesAvailable.length + 1,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (_, index) {
                            List<CategoryModel> catList = [
                              CategoryModel(
                                categoryName: 'All',
                                categoryId: 'all',
                                translations: {
                                  'en': 'All',
                                  'es': 'Toda',
                                  'pt': 'Todos',
                                  'ro': 'Toate',
                                  'uk': 'все',
                                  'fr': 'Tout',
                                },
                              ),
                              ..._createAppointmentProvider.categoriesAvailable,
                            ];

                            // bool isServiceAddedBelogingToCategory = _createAppointmentProvider.isCategoryServiceAdded(
                            //   categoryModel: catList[index],
                            // );

                            // Color selectedColor = theme.primaryColor; // defaultTheme ? (Colors.grey[400]!) : theme.colorScheme.tertiary;
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
                                    // color: isServiceAddedBelogingToCategory ? selectedColor : Colors.transparent,
                                    border: Border.all(
                                      color: _activeTab == index ? theme.primaryColor : const Color(0XFF4A4A4A),
                                      width: 1,
                                    ),

                                    // isServiceAddedBelogingToCategory
                                    //     ? null
                                    //     : Border.all(
                                    //         color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
                                    //         width: DeviceConstraints.getResponsiveSize(context, 1, 1, 1.4),
                                    //       ),

                                    color: _activeTab == index ? theme.primaryColor : theme.dialogBackgroundColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: DeviceConstraints.getResponsiveSize(context, 25.w, 15.w, 10.w),
                                      ),
                                      child: Text(
                                        catList[index].translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? catList[index].translations['en'],
                                        style: theme.textTheme.bodyLarge!.copyWith(
                                          color: _activeTab == index ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //  isServiceAddedBelogingToCategory ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
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
                    SizedBox(height: DeviceConstraints.getResponsiveSize(context, 30.h, 30.h, 30.h)),

                    if (_createAppointmentProvider.selectedItems.isNotEmpty)
                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: _createAppointmentProvider.selectedItems.length,
                            itemBuilder: (context, index) {
                              ServiceModel service = _createAppointmentProvider.selectedItems[index];
                              bool isAdded = _createAppointmentProvider.isAdded(serviceModel: service);

                              List<ServiceModel> subItems = _createAppointmentProvider.selectedSubItems;

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _createAppointmentProvider.toggleCookings(
                                        serviceModel: service,
                                        subItems: subItems,
                                        selected: () {
                                          _createAppointmentProvider.selectedItems.clear();
                                          _createAppointmentProvider.selectedSubItems.clear();
                                          _createAppointmentProvider.totalSelectedSubItems.clear();

                                          // _createAppointmentProvider!.selectedItems.add(mainItem);
                                          _createAppointmentProvider.getServiceMasters();
                                        },
                                        unselected: () {
                                          _createAppointmentProvider.selectedSubItems.remove(service);
                                          _createAppointmentProvider.totalSelectedSubItems.clear();
                                          _createAppointmentProvider.selectedItems.remove(service);
                                          _createAppointmentProvider.selectedItems.removeWhere((item) => subItems.contains(item));
                                        },
                                      );
                                    },
                                    child: ServiceCard(
                                      isAdded: isAdded,
                                      service: service,
                                    ),
                                  ),
                                  if (isAdded)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _createAppointmentProvider.selectedSubItems.length,
                                      itemBuilder: (context, index) {
                                        ServiceModel subItem = _createAppointmentProvider.selectedSubItems[index];
                                        // bool isSubAdded = _createAppointmentProvider.isAdded(serviceModel: subItem);

                                        bool isSubItemSelected = _createAppointmentProvider.totalSelectedSubItems.contains(subItem);

                                        return GestureDetector(
                                          onTap: () {
                                            _createAppointmentProvider.toggleCookings(
                                              serviceModel: subItem,
                                              subItems: subItems,
                                              selected: () {
                                                if (_createAppointmentProvider.selectedItems.isEmpty) {
                                                  _createAppointmentProvider.selectedItems.add(subItem);
                                                }
                                                _createAppointmentProvider.totalSelectedSubItems.add(subItem);
                                              },
                                              unselected: () {
                                                _createAppointmentProvider.selectedItems.remove(subItem);
                                                // _createAppointmentProvider.selectedSubItems.remove(subItem);
                                                _createAppointmentProvider.totalSelectedSubItems.remove(subItem);
                                              },
                                            );
                                          },
                                          child: ServiceCard(
                                            isAdded: isSubItemSelected,
                                            service: subItem,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),

                    if (_createAppointmentProvider.selectedItems.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          child: Text(
                            AppLocalizations.of(context)?.unavailableServices ?? "Unavailable  Services",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                              color: theme.colorScheme.tertiary.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),

                    if (_createAppointmentProvider.selectedItems.isNotEmpty)
                      GroupedListView<ServiceModel, String>(
                        elements: _createAppointmentProvider.unavailableSelectedItems,
                        groupBy: (element) => element.categoryId!,
                        groupComparator: (value1, value2) => value1.compareTo(value2),
                        shrinkWrap: true,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.sp),
                          child: Text(
                            _createAppointmentProvider.getCategoryFromId(value) != null ? _createAppointmentProvider.getCategoryFromId(value)!.categoryName.toUpperCase() : AppLocalizations.of(context)?.others ?? "OTHERS",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                              color: theme.colorScheme.tertiary.withOpacity(0.6),
                            ),
                          ),
                        ),
                        itemBuilder: (c, element) {
                          return ServiceCard(
                            isAdded: false,
                            service: element,
                            disabled: true,
                          );
                        },
                      ),

                    DefaultButton(
                      borderRadius: 60,
                      onTap: () {
                        if (_createAppointmentProvider.chosenServices.isEmpty) {
                          showToast(
                            AppLocalizations.of(context)?.pleaseSelectOneService ?? "Please select at least one service",
                          );
                          return;
                        }
                        _createAppointmentProvider.initMastersAndTime(isSingleMaster: _salonProfileProvider.isSingleMaster);

                        // _createAppointmentProvider.initTimeOfDay();
                        // _createAppointmentProvider.onDateChange(date);

                        // Go to Date and Time
                        _createAppointmentProvider.changeBookingFlowIndex();
                        widget.tabController.animateTo(1);
                      },
                      color: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor, // defaultTheme ? Colors.black : theme.primaryColor,
                      borderColor: _createAppointmentProvider.chosenServices.isEmpty ? theme.primaryColor.withOpacity(0.4) : theme.primaryColor,
                      textColor: loaderColor(themeType),
                      height: 60.sp,
                      label: _createAppointmentProvider.chosenServices.isEmpty ? AppLocalizations.of(context)?.book ?? "Book" : '${AppLocalizations.of(context)?.book ?? "Book"} ${_createAppointmentProvider.chosenServices.length} ${AppLocalizations.of(context)?.services ?? "services"}',
                      fontSize: DeviceConstraints.getResponsiveSize(context, 16.sp, 20.sp, 18.sp),
                      fontWeight: FontWeight.w500,
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
