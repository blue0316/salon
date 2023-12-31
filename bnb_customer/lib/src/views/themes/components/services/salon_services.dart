import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/services/widgets/gentle_touch_service_tile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/service_tile.dart';
import 'widgets/widgets.dart';

class SalonPrice222 extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final List<CategoryModel> categories;
  final Map<String, List<ServiceModel>> categoryServicesMapNAWA;

  const SalonPrice222({
    Key? key,
    required this.salonModel,
    required this.categories,
    required this.categoryServicesMapNAWA,
  }) : super(key: key);

  @override
  _SalonPrice222State createState() => _SalonPrice222State();
}

class _SalonPrice222State extends ConsumerState<SalonPrice222> with SingleTickerProviderStateMixin {
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

    // Check if Salon is a single master
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    ThemeType themeType = _salonProfileProvider.themeType;

    return DefaultTabController(
      length: _createAppointmentProvider.categoriesAvailable.length,
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: (themeType == ThemeType.VintageCraft) ? 30.h : DeviceConstraints.getResponsiveSize(context, 90.h, 100.h, 120.h),
          bottom: DeviceConstraints.getResponsiveSize(context, 20, 20, 10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (themeType == ThemeType.VintageCraft)
                ? Text(
                    (AppLocalizations.of(context)?.itemsOfServices ?? 'services').toTitleCase(),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                    ),
                  )
                : Center(
                    child: Text(
                      (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark)
                          ? (AppLocalizations.of(context)?.itemsOfServices ?? 'services').toUpperCase()
                          : isSingleMaster
                              ? (AppLocalizations.of(context)?.price ?? 'Price')
                              : (AppLocalizations.of(context)?.ourPrice ?? 'Our Price').toUpperCase(),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 60.sp),
                      ),
                    ),
                  ),
            const SizedBox(height: 50),
            (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
                ? Expanded(
                    flex: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 65.sp, // MediaQuery.of(context).size.height * 0.065, // 60.h,
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
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark || themeType == ThemeType.VintageCraft) ? 15.sp : 50,
                          ),
                          tabs: _createAppointmentProvider.categoriesAvailable
                              .map(
                                (item) => Tab(
                                  text: ('${item.translations[AppLocalizations.of(context)?.localeName ?? 'en'] ?? item.categoryName}').toTitleCase(), //  .categoryName.toTitleCase(),
                                  // height: 20,
                                ),
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
            (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
                ? Builder(
                    builder: (_) {
                      for (List<ServiceModel> serviceList in _createAppointmentProvider.servicesAvailable) {
                        if (_selectedTabbar == _createAppointmentProvider.servicesAvailable.indexOf(serviceList)) {
                          return ServiceAndPrice(listOfServices: serviceList);
                        }
                      }

                      return const SizedBox.shrink();
                    },
                  )
                : const SizedBox.shrink(),
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
          if (themeType != ThemeType.GentleTouch && themeType != ThemeType.GentleTouchDark && themeType != ThemeType.VintageCraft)
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
          if (themeType != ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark) const SizedBox(height: 15),
          Expanded(
            flex: 0,
            child: ListView.builder(
              itemCount: listOfServices.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final ServiceModel service = listOfServices[index];
                return (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark || themeType == ThemeType.VintageCraft)
                    ? GentleTouchServiceTile(
                        service: service,
                      )
                    : ServiceTile(
                        service: service,
                      );
              },
            ),
          ),
          const SizedBox(height: 35),
          bookNowButtonTheme(
            context,
            themeType: themeType,
            theme: theme,
            hasGradient: _salonProfileProvider.hasThemeGradient,
          ),
        ],
      ),
    );
  }
}
