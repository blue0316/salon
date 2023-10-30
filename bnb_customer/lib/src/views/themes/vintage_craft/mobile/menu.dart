import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/components/drawer.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/customer_web_settings.dart';
import '../../../../models/salon_master/salon.dart';
import '../../utils/theme_type.dart';

class VintageMenuSection extends ConsumerWidget {
  const VintageMenuSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(themeController);
    final salonProvider = ref.watch(salonProfileProvider);
    final DisplaySettings? displaySettings = salonProvider.themeSettings?.displaySettings;
    final SalonModel chosenSalon = salonProvider.chosenSalon;
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 20.h),
      child: ListView(
        children: [
          IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ABOUT US
                if (chosenSalon.description.isNotEmpty && displaySettings?.showAbout == true)
                  DrawerText(
                    drawerText: isSingleMaster
                        ? (AppLocalizations.of(context)?.aboutMe ?? 'About Me')
                        : (AppLocalizations.of(
                                  context,
                                )?.aboutUs ??
                                'About Us')
                            .toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.about.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // OUR WORKS
                if (chosenSalon.photosOfWorks != null && chosenSalon.photosOfWorks!.isNotEmpty && displaySettings?.showPhotosOfWork == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.works.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // OUR PRICE
                if (displaySettings?.services.showServices == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.services ?? 'services').toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.price.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // SHOP
                if (_salonProfileProvider.allProducts.isNotEmpty && displaySettings?.product.showProduct == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.products ?? 'Products').toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.shop.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // TEAM
                if (_createAppointmentProvider.salonMasters.isNotEmpty && displaySettings?.showTeam == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.team ?? 'Team').toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.team.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // REVIEWS
                if (_salonProfileProvider.salonReviews.isNotEmpty && displaySettings?.reviews.showReviews == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.reviews ?? 'Reviews').toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.reviews.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // CONTACTS
                if (displaySettings?.showContact == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.contacts ?? 'Contacts').toCapitalized(),
                    onTap: () {
                      salonProvider.changeShowMenuMobile(false);
                      Scrollable.ensureVisible(
                        controller.contacts.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                DrawerText(
                  drawerText: (AppLocalizations.of(context)?.bookNow ?? "Book Now").toCapitalized(),
                  onTap: () {
                    salonProvider.changeShowMenuMobile(false);
                    const BookingDialogWidget222().show(context);
                  },
                ),
                SizedBox(height: 10.sp),

                Text(
                  'Powered by',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 12.sp,
                    letterSpacing: 0,
                    color: const Color(0XFF9F9F9F),
                    fontFamily: 'Inter-Light',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.sp),

                SvgPicture.asset(
                  themeType == ThemeType.GentleTouch ? ThemeIcons.glamirisLogoLight : ThemeIcons.glamirisLogoDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
