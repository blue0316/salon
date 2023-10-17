import 'package:bbblient/src/views/themes/city_muse/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../controller/all_providers/all_providers.dart';

class CityMuseDesktopReviews extends ConsumerWidget {
  const CityMuseDesktopReviews({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100.0, right: 8.0),
          child: Text(
            (AppLocalizations.of(context)?.reviews ?? 'Reviews').toUpperCase(),
            style: GoogleFonts.openSans(
              color: _salonProfileProvider
                  .salonTheme.textTheme.displaySmall!.color,
              fontSize: 40,
              //  fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
        const Gap(20),
        Padding(
          padding: const EdgeInsets.only(left: 100.0, right: 8.0),
          child: Row(
            children: [
              Text(
                getTotalRatings(_salonProfileProvider.salonReviews)
                    .toStringAsFixed(1)
                    .toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: _salonProfileProvider
                      .salonTheme.textTheme.displaySmall!.color,
                  fontSize: 16,
                  //   fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              RatingBar.builder(
                initialRating: getTotalRatings(
                    _salonProfileProvider.salonReviews), // reviewStars ?? 5,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemSize: 15,
                itemCount: 5,
                updateOnDrag: true,
                unratedColor: Colors.grey,
                onRatingUpdate: (rating) {},
                itemBuilder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: ShapeDecoration(
                        color: _salonProfileProvider
                            .salonTheme.colorScheme.secondary,
                        // color:
                        //Color(0xFFE980B2),
                        shape: const StarBorder(
                          points: 5,
                          innerRadiusRatio: 0.38,
                          pointRounding: 0.70,
                          valleyRounding: 0,
                          rotation: 0,
                          squash: 0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const Gap(20),
        Padding(
          padding: const EdgeInsets.only(left: 100.0, right: 18.0),
          child: SizedBox(
            height: 300,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _salonProfileProvider.salonReviews.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Container(
                      width: 500,
                      height: 163,
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: _salonProfileProvider
                                  .salonTheme.colorScheme.secondary
                              //color: Color(0xFFE980B2)

                              ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _salonProfileProvider
                                    .salonReviews[index].customerName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                  color: _salonProfileProvider
                                      .salonTheme.colorScheme.secondary,
                                  // color: const Color(0xFFE980B2),
                                  fontSize: 20,
                                  //  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(width: 36),
                              RatingBar.builder(
                                initialRating: _salonProfileProvider
                                    .salonReviews[index]
                                    .rating, // reviewStars ?? 5,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemSize: 15,
                                itemCount: 5,
                                updateOnDrag: true,
                                unratedColor: Colors.grey,
                                onRatingUpdate: (rating) {},
                                itemBuilder: (context, _) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: ShapeDecoration(
                                        // color: Color(0xFFE980B2),
                                        color: _salonProfileProvider
                                            .salonTheme.colorScheme.secondary,
                                        shape: const StarBorder(
                                          points: 5,
                                          innerRadiusRatio: 0.38,
                                          pointRounding: 0.70,
                                          valleyRounding: 0,
                                          rotation: 0,
                                          squash: 0,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              _salonProfileProvider.salonReviews[index].review,
                              style: GoogleFonts.openSans(
                                color: _salonProfileProvider
                                    .salonTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
