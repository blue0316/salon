
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../controller/salon/salon_profile_provider.dart';
import '../../../../models/cat_sub_service/services_model.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/currency/currency.dart';

class CityMuseServiceTab extends StatelessWidget {
  const CityMuseServiceTab({
    super.key,
    required this.serviceList,
    required SalonProfileProvider salonProfileProvider,
    required this.chosenSalon,
  }) : _salonProfileProvider = salonProfileProvider;

  final ServiceModel serviceList;
  final SalonProfileProvider _salonProfileProvider;
  final SalonModel chosenSalon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100.0, right: 100.0),
      child: Container(
        height: 59,
        width: 1199,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffD9D9D9)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              serviceList.translations?[
                      AppLocalizations.of(context)?.localeName ?? 'en'] ??
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
      ),
    );
  }
}