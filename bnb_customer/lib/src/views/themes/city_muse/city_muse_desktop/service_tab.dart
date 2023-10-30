import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/salon/salon_profile_provider.dart';
import '../../../../models/cat_sub_service/services_model.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/currency/currency.dart';
import '../../../widgets/image.dart';

class CityMuseServiceTab extends StatelessWidget {
  const CityMuseServiceTab(
      {super.key,
      required this.serviceList,
      required SalonProfileProvider salonProfileProvider,
      required this.chosenSalon,
      required this.index})
      : _salonProfileProvider = salonProfileProvider;

  final ServiceModel serviceList;
  final SalonProfileProvider _salonProfileProvider;
  final SalonModel chosenSalon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
      child: MouseRegion(
        onEnter: (event) => _salonProfileProvider.onEnterService(index),
        onExit: (event) => _salonProfileProvider.onExitService(index),
        child: Stack(
          children: [
            Container(
              height: 59,
              width: 1199,
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xff414036)))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        serviceList.translations?[
                                AppLocalizations.of(context)?.localeName ??
                                    'en'] ??
                            serviceList.translations?['en'] ??
                            '',
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                          fontSize: 18,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      Text(
                        (serviceList.isPriceRange)
                            ? "${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDuration!.price ?? '0'}-${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDurationMax!.price ?? '0'}"
                            : (serviceList.isPriceStartAt)
                                ? "${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDuration!.price ?? '0'}+"
                                : "${getCurrency(chosenSalon.countryCode!)}${serviceList.priceAndDuration!.price ?? '0'}",
                        style: GoogleFonts.openSans(
                          color: _salonProfileProvider
                              .salonTheme.textTheme.displaySmall!.color,
                          fontSize: 18,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                  if (serviceList.description != null &&
                      serviceList.description!.isNotEmpty &&
                      _salonProfileProvider.serviceHoveredIndex == index) ...[
                    const Gap(20),
                    Text(
                      serviceList.description.toString(),
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.titleSmall!.color,
                        fontSize: 18,
                        // fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (_salonProfileProvider.serviceHoveredIndex == index)
              if (serviceList.servicePhoto != null &&
                  serviceList.servicePhoto != '')
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.w, top: 20.sp),
                    child: SizedBox(
                      // color: Colors.blue,
                      height: 230.h,
                      width: 220.sp,
                      child: CachedImage(
                        url: serviceList.servicePhoto ?? '',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width - 40.w,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
