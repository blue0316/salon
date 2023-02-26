import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/views/salon/booking/booking_dialog.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/views/themes/components/widgets.dart/oval_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// FORMER FILE 
class SalonPrice extends ConsumerStatefulWidget {
  final SalonModel salonModel;
  final List<CategoryModel> categories;
  final Map<String, List<ServiceModel>> categoryServicesMapNAWA;

  const SalonPrice({
    Key? key,
    required this.salonModel,
    required this.categories,
    required this.categoryServicesMapNAWA,
  }) : super(key: key);

  @override
  _SalonPriceState createState() => _SalonPriceState();
}

class _SalonPriceState extends ConsumerState<SalonPrice> with SingleTickerProviderStateMixin {
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
    final bool isSingleMaster = (widget.salonModel.ownerType == OwnerType.singleMaster);

    return DefaultTabController(
      length: _createAppointmentProvider.categoriesAvailable.length,
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 50.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 40, 60, 70),
          bottom: DeviceConstraints.getResponsiveSize(context, 20, 20, 10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isSingleMaster ? (AppLocalizations.of(context)?.price ?? 'Price') : (AppLocalizations.of(context)?.ourPrice ?? 'Our Price').toUpperCase(),
              style: theme.textTheme.headline2?.copyWith(),
            ),

            const SizedBox(height: 50),
            (_createAppointmentProvider.categoriesAvailable.isNotEmpty)
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
                          unselectedLabelColor: theme.primaryColor,
                          labelColor: Colors.black,
                          labelStyle: theme.textTheme.bodyText1?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          indicator: BoxDecoration(
                            color: theme.primaryColor,
                            border: Border(
                              bottom: BorderSide(width: 1.5, color: theme.primaryColorDark),
                            ),
                          ),
                          isScrollable: true,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 50),
                          tabs: _createAppointmentProvider.categoriesAvailable
                              .map(
                                (item) => Tab(text: item.categoryName),
                              )
                              .toList(),

                          //     const [
                          //   Tab(text: 'Haircut'),
                          //   Tab(text: 'Make up'),
                          // ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        // (AppLocalizations.of(context)?.noServicesAvailable ?? 'No services available').toUpperCase(),
                        'No services available', // TODO: -- LOCALIZATION
                        style: theme.textTheme.bodyText1?.copyWith(
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
            // -- TAB BAR VIEW
            // Expanded(
            //   flex: 0,
            //   child: Container(
            //     color: Colors.blue,
            //     // Find the longest list length to set height of tab bar view
            //     height: (_createAppointmentProvider.servicesAvailable.reduce((a, b) => a.length > b.length ? a : b).length * 220).h,
            //     // . length * 200, // 400,
            //     width: double.infinity,
            //     child: TabBarView(
            //       controller: tabController,
            //       physics: const NeverScrollableScrollPhysics(),

            //       children: _createAppointmentProvider.servicesAvailable
            //           .map(
            //             (item) => ServiceAndPrice(listOfServices: item),
            //           )
            //           .toList(),

            //       // children: [
            //       //   ServiceAndPrice(
            //       //     listOfServices: [],
            //       //   ),
            //       //   Container(
            //       //     height: 100,
            //       //     width: double.infinity,
            //       //     color: Colors.yellow,
            //       //   ),
            //       // ],
            //     ),
            //   ),
            // ),
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
                AppLocalizations.of(context)?.service ?? 'Service'.toUpperCase(),
                style: theme.textTheme.headline3?.copyWith(
                  color: theme.primaryColor,
                  fontSize: 20.sp,
                  letterSpacing: 1,
                ),
              ),
              Text(
                AppLocalizations.of(context)?.price ?? 'Price'.toUpperCase(),
                style: theme.textTheme.headline3?.copyWith(
                  color: theme.primaryColor,
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
          (_salonProfileProvider.theme == '2')
              ? SquareButton(
                  text: 'BOOK NOW',
                  height: 60.h,
                  buttonColor: theme.primaryColor,
                  borderColor: Colors.transparent,
                  onTap: () => const BookingDialogWidget().show(context),
                )
              : OvalButton(
                  width: 180.h,
                  height: 60.h,
                  textSize: 18.sp,
                  text: 'Book Now',
                  onTap: () => const BookingDialogWidget().show(context),
                )
        ],
      ),
    );
  }
}

class ServiceTile extends ConsumerWidget {
  final ServiceModel service;

  const ServiceTile({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _createAppointmentProvider.toggleService(
            serviceModel: service,
            clearChosenMaster: false,
            context: context,
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          service.translations[AppLocalizations.of(context)?.localeName ?? 'en'].toString(),
                          style: theme.textTheme.bodyText1?.copyWith(
                            color: theme.primaryColor,
                            fontSize: 20.sp,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Icon(
                          Icons.check,
                          size: 20.sp,
                          color: _createAppointmentProvider.isAdded(
                            serviceModel: service,
                          )
                              ? theme.primaryColorDark //  GlamOneTheme.deepOrange
                              : Colors.transparent,
                        ),
                      ],
                    ),
                    Text(
                      service.isFixedPrice
                          ? "${Keys.dollars}${service.priceAndDuration.price}"
                          : "${Keys.dollars}${service.priceAndDuration.price} - ${Keys.dollars}${service.priceAndDurationMax!.price}",
                      style: theme.textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: theme.primaryColor,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
