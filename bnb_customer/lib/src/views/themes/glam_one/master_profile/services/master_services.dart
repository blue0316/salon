import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/service_tile.dart';
import 'widgets/widgets.dart';

class MasterPriceUnique extends ConsumerStatefulWidget {
  final MasterModel masterModel;
  final List<CategoryModel> categories;
  final Map<String, List<ServiceModel>> categoryServicesMapNAWA;

  const MasterPriceUnique({
    Key? key,
    required this.masterModel,
    required this.categories,
    required this.categoryServicesMapNAWA,
  }) : super(key: key);

  @override
  _MasterPriceUniqueState createState() => _MasterPriceUniqueState();
}

class _MasterPriceUniqueState extends ConsumerState<MasterPriceUnique> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int _selectedTabbar = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.read(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return DefaultTabController(
      length: _createAppointmentProvider.masterCategoryAndServices.length,
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
          // bottom: DeviceConstraints.getResponsiveSize(context, 20, 20, 10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              (AppLocalizations.of(context)?.price ?? 'Price').toUpperCase(),
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 40.sp, 40.sp, 50.sp),
              ),
            ),
            const SizedBox(height: 50),
            (_createAppointmentProvider.masterCategoryAndServices.isNotEmpty)
                ? Expanded(
                    flex: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 60.h,
                        child: TabBar(
                          onTap: (index) {
                            setState(() {
                              _selectedTabbar = index;
                            });
                          },
                          controller: tabController,
                          unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor,

                          labelColor: labelColorTheme(themeType, theme), // theme.tabBarTheme.labelColor,
                          labelStyle: theme.textTheme.bodyLarge?.copyWith(
                            color: labelColorTheme(themeType, theme), // theme.tabBarTheme.labelColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                          unselectedLabelStyle: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.tabBarTheme.unselectedLabelColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                          ),
                          indicator: servicesTabBarTheme(themeType, theme),
                          //  BoxDecoration(
                          //   color: theme.primaryColor,
                          //   border: Border(
                          //     bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
                          //   ),
                          // ),
                          isScrollable: true,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 50),
                          tabs: _createAppointmentProvider.masterCategoryAndServices.keys
                              .map(
                                (category) => Tab(text: category.categoryName),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        (AppLocalizations.of(context)?.noServicesAvailable ?? 'No services available').toUpperCase(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 30.h),
            (_createAppointmentProvider.masterCategoryAndServices.isNotEmpty)
                ? Builder(
                    builder: (_) {
                      for (List<ServiceModel> serviceList in _createAppointmentProvider.masterServicesAvailable) {
                        if (_selectedTabbar == _createAppointmentProvider.masterServicesAvailable.indexOf(serviceList)) {
                          return ServiceAndPrice(listOfServices: serviceList);
                        }
                      }

                      return const SizedBox.shrink();
                    },
                  )
                : const SizedBox.shrink(),

            // ListView.builder(
            //     itemCount: _salonSearchProvider.categories.length + 1,
            //     shrinkWrap: true,
            //     primary: false,
            //     // controller: _listViewController,
            //     padding: const EdgeInsets.all(0),
            //     itemBuilder: (context, index) {
            //       List<ServiceModel> services = _createAppointmentProvider.mastersServicesMapAll[widget.masterModel.masterId]
            //               ?.where(
            //                 (element) => element.categoryId == (index).toString(),
            //               )
            //               .toList() ??
            //           [];

            //       if (services.isNotEmpty) {
            //         // return InkWell(
            //         //   onTap: () {
            //         //     print(services);

            //         //     // print(_createAppointmentProvider.mastersServicesMapAll[widget.masterModel.masterId]);

            //         //     // print(_salonSearchProvider.categories.where((element) => element.categoryId == (index).toString()).first.categoryName);

            //         //     print(_createAppointmentProvider.masterCategoryAndServices);
            //         //     _createAppointmentProvider.masterCategoryAndServices.forEach((key, value) {
            //         //       print(key.categoryName);
            //         //       for (ServiceModel model in value) {
            //         //         print(model.serviceName);
            //         //       }

            //         //       print('-----++++++++-------');
            //         //     });
            //         //   },
            //         //   child: Container(
            //         //     height: 100,
            //         //     width: 400,
            //         //     color: Colors.blue,
            //         //   ),
            //         // );
            //         return ServiceAndPrice(listOfServices: services);
            //       } else {
            //         return const SizedBox();
            //       }
            //     }),

            // Section Divider

            if (themeType == ThemeType.GentleTouch)
              Space(
                factor: DeviceConstraints.getResponsiveSize(context, 8, 8, 10),
              ),
            if (themeType == ThemeType.GentleTouch)
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
          ],
        ),
      ),
    );
  }
}

class ServiceAndPrice extends ConsumerWidget {
  final List<ServiceModel> listOfServices;
  const ServiceAndPrice({Key? key, required this.listOfServices}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    return SizedBox(
      // height: 100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (AppLocalizations.of(context)?.service ?? 'Service').trim().toUpperCase(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColorDark,
                  fontSize: 20.sp,
                  letterSpacing: 1,
                ),
              ),
              Text(
                (AppLocalizations.of(context)?.price ?? 'Price').toUpperCase(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColorDark,
                  fontSize: 20.sp,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            flex: 0,
            child: ListView.builder(
              itemCount: listOfServices.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final ServiceModel service = listOfServices[index];
                return ServiceTile(service: service);
              },
            ),
          ),
          const SizedBox(height: 35),
          bookNowButtonTheme(
            context,
            themeType: themeType,
            theme: theme,
          ),
        ],
      ),
    );
  }
}
