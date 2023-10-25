import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/salon/salon_profile_provider.dart';
import '../../../../models/products.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../../utils/currency/currency.dart';
import '../../../widgets/image.dart';

class CityMuseDesktopSmallerProductWidget extends StatelessWidget {
  const CityMuseDesktopSmallerProductWidget({
    super.key,
    required this.index,
    required this.product,
    required SalonProfileProvider salonProfileProvider,
    required this.chosenSalon,
  }) : _salonProfileProvider = salonProfileProvider;

  final SalonProfileProvider _salonProfileProvider;
  final ProductModel product;
  final SalonModel chosenSalon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.productImageUrlList == null ||
              product.productImageUrlList!.isEmpty ||
              _salonProfileProvider
                      .allProducts[index].productImageUrlList![0] ==
                  null ||
              product.productImageUrlList![0]!.isEmpty) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 285,
                  height: 285,
                  child: Text(
                    AppLocalizations.of(context)?.photoNA ?? 'Photo N/A',
                    style: GoogleFonts.openSans(
                      //   color: const Color(0xFF0D0D0E),
                      fontSize: 18,
                      // fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ],
            )
          ] else ...[
            product.productImageUrlList == null
                ? SizedBox(
                    width: 285,
                    height: 285,
                    child: Text(
                      AppLocalizations.of(context)?.photoNA ?? 'Photo N/A',
                      style: GoogleFonts.openSans(
                        //   color: const Color(0xFF0D0D0E),
                        fontSize: 18,
                        // fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  )
                : Center(
                    child: CachedImage(
                    url: '${product.productImageUrlList![0]}',
                    width: 285,
                    height: 285,
                    fit: BoxFit.cover,
                  )),
          ],
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only( right: 24.0),
            child: SizedBox(
              width: 285,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      product.productName ?? ''.toCapitalized(),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: GoogleFonts.openSans(
                        color: _salonProfileProvider
                            .salonTheme.textTheme.displaySmall!.color,
                        //   color: const Color(0xFF0D0D0E),
                        fontSize: 18,
                        // fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,

                        height: 1,
                      ),
                    ),
                  ),
                  // Gap(170),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text(
                      '${getCurrency(chosenSalon.countryCode!)}${product.clientPrice}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        color: const Color(0xFF868686),
                        fontSize: 18,
                        //    fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
