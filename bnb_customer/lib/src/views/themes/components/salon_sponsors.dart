import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalonSponsors extends ConsumerWidget {
  const SalonSponsors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // final int? themeNo = _salonProfileProvider.chosenSalon.selectedTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Divider(color: theme.dividerColor, thickness: 2),
          (_salonProfileProvider.allProductBrands.isEmpty)
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppLocalizations.of(context)?.noBrandsForThisProfile ?? "No brands available for this profile",
                    style: theme.textTheme.bodyText1?.copyWith(
                      color: theme.dividerColor,
                      fontSize: 18.sp,
                    ),
                  ),
                )
              : SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _salonProfileProvider.allProductBrands.length,
                    itemBuilder: ((context, index) {
                      final ProductBrandModel brand = _salonProfileProvider.allProductBrands[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                brand.translations![AppLocalizations.of(context)?.localeName ?? 'en'],
                                style: theme.textTheme.bodyText1?.copyWith(
                                  color: theme.dividerColor,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                            Container(
                              height: 8.h,
                              width: 8.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.dividerColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
          Divider(color: theme.dividerColor, thickness: 2),
        ],
      ),
    );
  }
}
