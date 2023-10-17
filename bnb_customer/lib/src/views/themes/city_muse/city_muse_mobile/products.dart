import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../controller/salon/salon_profile_provider.dart';
import '../../../../models/salon_master/salon.dart';

class AllProductWidget extends StatelessWidget {
  const AllProductWidget(
      {super.key,
      required SalonProfileProvider salonProfileProvider,
      required this.size,
      required this.chosenSalon,
      required this.index})
      : _salonProfileProvider = salonProfileProvider;

  final SalonProfileProvider _salonProfileProvider;
  final Size size;
  final SalonModel chosenSalon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_salonProfileProvider.allProducts[index].productImageUrlList ==
                null ||
            _salonProfileProvider
                .allProducts[index].productImageUrlList!.isEmpty ||
            _salonProfileProvider.allProducts[index].productImageUrlList![0] ==
                null ||
            _salonProfileProvider
                .allProducts[index].productImageUrlList![0]!.isEmpty) ...[
          Expanded(
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
        ] else ...[
          Center(
              child: CachedImage(
            url:
                '${_salonProfileProvider.allProducts[index].productImageUrlList![0]}',
            width: size.width / 1.1,
            height: 372,
          )),
        ],
        const Gap(10),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Row(
            //    mainAxisAlignment: ,
            children: [
              Text(
                _salonProfileProvider.allProducts[index].productName ?? '',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  //   color: const Color(0xFF0D0D0E),
                  fontSize: 18,
                  // fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const Spacer(),
              Text(
                '${getCurrency(chosenSalon.countryCode!)}${_salonProfileProvider.allProducts[index].clientPrice}' ,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  //      color: const Color(0xFF868686),
                  fontSize: 18,
                  //    fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              )
            ],
          ),
        ),
        const Gap(14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 18.0),
            child: Text(
              _salonProfileProvider.allProducts[index].productDescription ?? '',
              style: GoogleFonts.openSans(
                color: _salonProfileProvider
                    .salonTheme.textTheme.titleSmall!.color,
                fontSize: 16,
                //  fontFamily: 'Steppe',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        )
      ],
    );
  }
}


class CityMuseProductTile extends StatelessWidget {
  final SalonProfileProvider salonProfileProvider;
  final Size size;
  final SalonModel chosenSalon;
  final int index;
  final String currentSelectedEntry;
  const CityMuseProductTile({super.key, required this.salonProfileProvider, required this.chosenSalon,required  this.currentSelectedEntry, required this.index, required this.size});

  @override
  Widget build(BuildContext context) {
    return  Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Center(
                                    //     child: Image.asset(
                                    //   "assets/test_assets/product.png",
                                    // )),
                                    if (salonProfileProvider
                                                .tabs[currentSelectedEntry]
                                                    ?[index]
                                                .productImageUrlList ==
                                            null ||
                                        salonProfileProvider
                                            .tabs[currentSelectedEntry]![index]
                                            .productImageUrlList!
                                            .isEmpty ||
                                        salonProfileProvider
                                                .tabs[currentSelectedEntry]![
                                                    index]
                                                .productImageUrlList![0] ==
                                            null ||
                                        salonProfileProvider
                                            .tabs[currentSelectedEntry]![index]
                                            .productImageUrlList![0]!
                                            .isEmpty) ...[
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)
                                                  ?.photoNA ??
                                              'Photo N/A',
                                          style: GoogleFonts.openSans(
                                            //   color: const Color(0xFF0D0D0E),
                                            fontSize: 18,
                                            // fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      )
                                    ] else ...[
                                      Center(
                                          child: CachedImage(
                                        url:
                                            '${salonProfileProvider.tabs[currentSelectedEntry]![index].productImageUrlList![0]}',
                                        width: size.width / 1.1,
                                        height: 372,
                                      )),
                                    ],
                                    const Gap(10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24.0, right: 24.0),
                                      child: Row(
                                        //    mainAxisAlignment: ,
                                        children: [
                                          Text(
                                            salonProfileProvider
                                                    .tabs[currentSelectedEntry]
                                                        ?[index]
                                                    .productName
                                                    .toString() ??
                                                '',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              //   color: const Color(0xFF0D0D0E),
                                              fontSize: 18,
                                              // fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${getCurrency(chosenSalon.countryCode!)}${salonProfileProvider.tabs[currentSelectedEntry]?[index].clientPrice}'
                                          ,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              //      color: const Color(0xFF868686),
                                              fontSize: 18,
                                              //    fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Gap(14),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 22.0, right: 18.0),
                                        child: Text(
                                          salonProfileProvider
                                                  .tabs[currentSelectedEntry]
                                                      ?[index]
                                                  .productDescription
                                                  .toString() ??
                                              '',
                                          style: GoogleFonts.openSans(
                                            color: salonProfileProvider
                                                .salonTheme
                                                .textTheme
                                                .titleSmall!
                                                .color,
                                            fontSize: 16,
                                            //  fontFamily: 'Steppe',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
  }
}