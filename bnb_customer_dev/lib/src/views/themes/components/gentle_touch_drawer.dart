import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drawer.dart';

class GentleTouchDrawer extends ConsumerStatefulWidget {
  const GentleTouchDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<GentleTouchDrawer> createState() => _GentleTouchDrawerState();
}

class _GentleTouchDrawerState extends ConsumerState<GentleTouchDrawer> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(themeController);
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;

    ThemeType themeType = _salonProfileProvider.themeType;
    final DisplaySettings? displaySettings = _salonProfileProvider.themeSettings?.displaySettings;
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 20.h),
      child: ListView(
        children: [
          IntrinsicHeight(
            child: Column(
              crossAxisAlignment: isPortrait ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment: isPortrait ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 70.h,
                      width: 80.h,
                      child: Center(
                        child: (chosenSalon.salonLogo.isNotEmpty)
                            ? CachedImage(
                                url: chosenSalon.salonLogo,
                                fit: BoxFit.cover,
                              )
                            : Text(
                                chosenSalon.salonName.initials,
                                style: theme.textTheme.displayLarge!.copyWith(
                                  fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 50.sp),
                                  color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                                  fontFamily: "VASQUZ",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: themeType == ThemeType.GentleTouch ? Colors.black : Colors.white,
                          size: 30.h,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                // ABOUT US
                if (displaySettings?.showAbout == true)
                  DrawerText(
                    drawerText: isSingleMaster
                        ? (AppLocalizations.of(
                              context,
                            )?.aboutMe ??
                            'About Me')
                        : (AppLocalizations.of(context)?.aboutUs ?? 'About Us').toCapitalized(),
                    onTap: () {
                      Navigator.pop(context);
                      Scrollable.ensureVisible(
                        controller.about.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // OUR WORKS
                if (displaySettings?.showPhotosOfWork == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.portfolio ?? 'portfolio').toCapitalized(),
                    onTap: () {
                      Navigator.pop(context);
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
                      Navigator.pop(context);
                      Scrollable.ensureVisible(
                        controller.price.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // SHOP
                if (displaySettings?.product.showProduct == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.products ?? 'Products').toCapitalized(),
                    onTap: () {
                      Navigator.pop(context);
                      Scrollable.ensureVisible(
                        controller.shop.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // TEAM
                if (displaySettings?.showTeam == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.team ?? 'Team').toCapitalized(),
                    onTap: () {
                      Navigator.pop(context);
                      Scrollable.ensureVisible(
                        controller.team.currentContext!,
                        duration: const Duration(seconds: 2),
                        curve: Curves.ease,
                      );
                    },
                  ),

                // REVIEWS
                if (displaySettings?.reviews.showReviews == true)
                  DrawerText(
                    drawerText: (AppLocalizations.of(context)?.reviews ?? 'Reviews').toCapitalized(),
                    onTap: () {
                      Navigator.pop(context);
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
                      Navigator.pop(context);
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
                    Navigator.pop(context);
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
