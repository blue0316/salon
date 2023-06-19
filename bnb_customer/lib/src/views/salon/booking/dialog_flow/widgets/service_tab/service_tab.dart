import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/service_tab/service_list.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'floating_button.dart';

class ServiceTab extends ConsumerStatefulWidget {
  final TabController tabController;
  final bool master;
  final MasterModel? masterModel;

  const ServiceTab({Key? key, required this.tabController, this.master = false, this.masterModel}) : super(key: key);

  @override
  ConsumerState<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends ConsumerState<ServiceTab> {
  final PageController _pageController = PageController();
  final PageController _masterPageController = PageController();
  int _activeTab = 0;
  final ScrollController _scrollController = ScrollController();

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
            child: (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.selectAService.toCapitalized() ?? 'Select a service',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                          color: theme.colorScheme.tertiary, // defaultTheme ? AppTheme.textBlack : Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      (widget.master == false)
                          ? Padding(
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                height: DeviceConstraints.getResponsiveSize(context, 45.h, 50.h, 50.h),
                                child: ListView.builder(
                                  itemCount: _createAppointmentProvider.categoriesAvailable.length + 1,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
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

                                    Color selectedColor = defaultTheme ? (Colors.grey[400]!) : theme.colorScheme.tertiary;
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
                                                    color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
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
                                                style: theme.textTheme.bodyLarge!.copyWith(
                                                  color: isServiceAddedBelogingToCategory ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
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
                            )
                          : Padding(
                              //
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                height: DeviceConstraints.getResponsiveSize(context, 45.h, 50.h, 50.h),
                                child: ListView.builder(
                                  itemCount: _createAppointmentProvider.masterCategoryAndServices.length + 1,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    List<CategoryModel> catList = [
                                      CategoryModel(
                                        categoryName: 'All',
                                        categoryId: 'all',
                                        translations: {'en': 'All'},
                                      ),
                                      ..._createAppointmentProvider.masterCategoryAndServices.keys.toList(),
                                    ];

                                    bool isServiceAddedBelogingToCategory = _createAppointmentProvider.isCategoryServiceAdded(
                                      categoryModel: catList[index],
                                    );

                                    Color selectedColor = defaultTheme ? (Colors.grey[400]!) : theme.colorScheme.tertiary;
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
                                                    color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
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
                                                style: theme.textTheme.bodyLarge!.copyWith(
                                                  color: isServiceAddedBelogingToCategory ? serviceTabCategoryColor(themeType) : theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
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
                      // SERVICES FOR SALON
                      (widget.master == false)
                          ? Expanded(
                              child: PageView(
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

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 15.h)),
                                            Divider(
                                              color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
                                              thickness: 1,
                                            ),
                                            SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 20.h)),
                                            Text(
                                              categoryModel.categoryName,
                                              style: theme.textTheme.bodyLarge!.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                                color: theme.colorScheme.tertiary, //defaultTheme ? AppTheme.textBlack : Colors.white,
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
                                ],
                              ),
                            )
                          : Expanded(
                              child: PageView(
                                controller: _masterPageController,
                                onPageChanged: (i) {
                                  setState(() {
                                    _activeTab = i;
                                  });
                                },
                                children: [
                                  // All Section
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _createAppointmentProvider.masterCategoryAndServices.length,
                                    itemBuilder: (context, index) {
                                      final CategoryModel categoryModel = _createAppointmentProvider.masterCategoryAndServices.keys.elementAt(index);
                                      final List<ServiceModel> services = _createAppointmentProvider.masterCategoryAndServices[categoryModel] ?? [];

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 15.h)),
                                          Divider(
                                            color: theme.colorScheme.tertiary, //defaultTheme ? Colors.black : Colors.white,
                                            thickness: 1,
                                          ),
                                          SizedBox(height: DeviceConstraints.getResponsiveSize(context, 15.h, 15.h, 20.h)),
                                          Text(
                                            categoryModel.categoryName,
                                            style: theme.textTheme.bodyLarge!.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                                              color: theme.colorScheme.tertiary, //defaultTheme ? AppTheme.textBlack : Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: DeviceConstraints.getResponsiveSize(context, 10.h, 10.h, 10.h),
                                          ),
                                          ServiceList(services: services),
                                        ],
                                      );
                                    },
                                  ),

                                  // Other Page views
                                  ..._createAppointmentProvider.masterServicesAvailable
                                      .map(
                                        (services) => ServiceList(services: services),
                                      )
                                      .toList(),
                                ],
                              ),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingButton(
              onTap: () {
                _createAppointmentProvider.initMastersAndTime();

                DateTime date = DateTime.now();
                _createAppointmentProvider.initTimeOfDay();
                _createAppointmentProvider.onDateChange(date);

                // Go to Date and Time
                widget.tabController.animateTo(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
