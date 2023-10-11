import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/booking_dialog_2.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    // final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

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
                Align(
                  alignment: Alignment.centerRight,
                  child: MouseRegion(
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
                ),
                SizedBox(height: 25.h),

                // ABOUT US
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
