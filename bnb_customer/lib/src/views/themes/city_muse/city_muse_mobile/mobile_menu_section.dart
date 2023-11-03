import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/customer_web_settings.dart';
import '../../../../models/salon_master/salon.dart';
import '../../../salon/booking/dialog_flow/booking_dialog_2.dart';
import '../../../widgets/widgets.dart';
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
              Row(
                children: [
                  chosenSalon.salonLogo.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: SizedBox(
                            height: 70.h,
                            width: 100.h,
                            child: Center(
                              child: Text(chosenSalon.salonName.initials,
                                  style: TextStyle(
                                      fontFamily: "VASQUZ",
                                      color: salonProvider.salonTheme
                                          .appBarTheme.titleTextStyle!.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: CircleAvatar(
                              //radius: 5,
                              minRadius: 10,
                              maxRadius: 10,
                              //  borderRadius: BorderRadius.circular(30),
                              backgroundImage: CachedNetworkImageProvider(
                                  chosenSalon.salonLogo,
                                  maxHeight: 20,
                                  maxWidth: 20
                                  //fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      "assets/test_assets/cancel_menu.svg",
                      color: salonProvider
                          .salonTheme.appBarTheme.titleTextStyle!.color,
                    ),
                  ),
                ],
              ),
              const Gap(50),
              if (chosenSalon.description.isNotEmpty &&
                  displaySettings!.showAbout)
                MobileAppBarMenu(
                  title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
                  action: () {
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                      Navigator.pop(context);
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
                    Navigator.pop(context);

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
                    Navigator.pop(context);
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
                  title: 'Reviews',
                  action: () {
                    Navigator.pop(context);
                    Scrollable.ensureVisible(
                      controller.reviews.currentContext!,
                      duration: const Duration(seconds: 2),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
              if (displaySettings.showContact) ...[
                // MobileAppBarMenu(
                //     title:
                //         (AppLocalizations.of(context)?.contacts ?? 'Contacts')),
                const Gap(20),
                MobileAppBarMenu(
                  title: 'Contacts',
                  action: () {
                    Navigator.pop(context);
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
                  const BookingDialogWidget222().show(context);
                  salonProvider.changeShowMenuMobile(false);
                },
              ),
              const Gap(20),
              GestureDetector(
                onTap: () async {
                  Uri uri = Uri.parse('https://glmrs.space/home');

                  // debugPrint("launching Url: $uri");

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    showToast("Unable to launch Glamiris website");
                  }
                },
                child: Image.asset(
                    salonProvider.themeType == ThemeType.CityMuseLight
                        ? "assets/test_assets/logo_dark.png"
                        : "assets/test_assets/logo_light.png",
                    height: 29,
                    width: 78),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
