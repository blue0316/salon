import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/customer_web_settings.dart';
import '../../../../models/salon_master/salon.dart';
import '../../utils/theme_type.dart';
import '../city_muse_desktop/app_bar.dart';

class MenuSection extends ConsumerWidget {
  const MenuSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(themeController);
    final salonProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final DisplaySettings? displaySettings =
        salonProvider.themeSettings?.displaySettings;
    final SalonModel chosenSalon = salonProvider.chosenSalon;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(50),
              if (chosenSalon.description.isNotEmpty &&
                  displaySettings!.showAbout)
                MobileAppBarMenu(
                  title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.about.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              if (chosenSalon.photosOfWorks != null &&
                  chosenSalon.photosOfWorks!.isNotEmpty &&
                  displaySettings!.showPhotosOfWork) ...[
                const Gap(20),
                MobileAppBarMenu(
                  title: AppLocalizations.of(context)?.portfolio ?? 'Portfolio',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.works.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (displaySettings!.services.showServices) ...[
                const Gap(20),
                MobileAppBarMenu(
                    title: AppLocalizations.of(context)?.services ?? 'Services',
                    action: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.price.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    }),
              ],
              if (displaySettings.product.showProduct &&
                  salonProvider.allProducts.isNotEmpty) ...[
                const Gap(20),
                MobileAppBarMenu(
                  title: AppLocalizations.of(context)?.products ?? 'Products',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.shop.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (displaySettings.showTeam &&
                  _createAppointmentProvider.salonMasters.isNotEmpty) ...[
                const Gap(20),
                MobileAppBarMenu(
                  title: (AppLocalizations.of(context)?.team ?? 'Team'),
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.team.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (salonProvider.salonReviews.isNotEmpty &&
                  displaySettings.reviews.showReviews) ...[
                const Gap(20),
                MobileAppBarMenu(
                    title:
                        (AppLocalizations.of(context)?.reviews ?? 'Reviews')),
                const Gap(20),
                MobileAppBarMenu(
                  title: 'Contacts',
                  action: () {
                    salonProvider.changeShowMenuMobile(false);
                    Scrollable.ensureVisible(
                      controller.contacts.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              const Gap(20),
              MobileAppBarMenu(
                title: 'Book now',
                action: () {
                  salonProvider.changeShowMenuMobile(false);
                },
              ),
              const Gap(20),
              Image.asset(
                  salonProvider.themeType == ThemeType.CityMuseLight
                      ? "assets/test_assets/logo_dark.png"
                      : "assets/test_assets/logo_light.png",
                  height: 29,
                  width: 78),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
