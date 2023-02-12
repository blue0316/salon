import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/cat_sub_service/category_service.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/keys.dart';
import 'package:bbblient/src/views/salon/booking/booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/oval_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              "${isSingleMaster ? "" : "OUR "}PRICE",
              style: GlamOneTheme.headLine2.copyWith(),
            ),

            const SizedBox(height: 50),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 60.h,
                  child: TabBar(
                    controller: tabController,
                    unselectedLabelColor: GlamOneTheme.primaryColor,
                    labelColor: Colors.black,
                    labelStyle: GlamOneTheme.bodyText1.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    indicator: const BoxDecoration(color: GlamOneTheme.primaryColor),
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
            ),

            SizedBox(height: 30.h),

            // -- TAB BAR VIEW
            Expanded(
              flex: 0,
              child: SizedBox(
                // Find the longest list length to set height of tab bar view
                height: _createAppointmentProvider.servicesAvailable.reduce((a, b) => a.length > b.length ? a : b).length * 100,
                // . length * 200, // 400,
                width: double.infinity,
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),

                  children: _createAppointmentProvider.servicesAvailable
                      .map(
                        (item) => ServiceAndPrice(listOfServices: item),
                      )
                      .toList(),

                  // children: [
                  //   ServiceAndPrice(
                  //     listOfServices: [],
                  //   ),
                  //   Container(
                  //     height: 100,
                  //     width: double.infinity,
                  //     color: Colors.yellow,
                  //   ),
                  // ],
                ),
              ),
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
    // final _salonProfileProvider = ref.watch(salonProfileProvider);
    // final _salonSearchProvider = ref.watch(salonSearchProvider);

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
                'SERVICE',
                style: GlamOneTheme.headLine3.copyWith(
                  color: GlamOneTheme.primaryColor,
                  fontSize: 20.sp,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'PRICE',
                style: GlamOneTheme.headLine3.copyWith(
                  color: GlamOneTheme.primaryColor,
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
          OvalButton(
            width: 180.h,
            height: 60.h,
            textSize: 18.sp,
            text: 'Book Now',
            onTap: () => const BookingDialogWidget().show(context),
          ),
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
                          style: GlamOneTheme.bodyText1.copyWith(
                            color: GlamOneTheme.primaryColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Icon(
                          Icons.check,
                          size: 20.sp,
                          color: _createAppointmentProvider.isAdded(serviceModel: service) ? GlamOneTheme.deepOrange : Colors.transparent,
                        ),
                      ],
                    ),
                    Text(
                      service.isFixedPrice ? "${service.priceAndDuration.price}${Keys.uah}" : "${service.priceAndDuration.price}${Keys.uah} - ${service.priceAndDurationMax!.price}${Keys.uah}",
                      style: GlamOneTheme.bodyText1.copyWith(
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: GlamOneTheme.primaryColor,
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

          // const ServiceTile(
          //   service: 'HAIR CUT',
          //   price: '\$60',
          // ),
          // const ServiceTile(
          //   service: 'SPA HAIR CUT',
          //   price: '\$85',
          // ),
          // const ServiceTile(
          //   service: 'KERATIN',
          //   price: '\$180/\$240/\$290',
          // ),