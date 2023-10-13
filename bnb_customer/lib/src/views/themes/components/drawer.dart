import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/customer_web_settings.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'gentle_touch_drawer.dart';

class ThemeDrawer extends ConsumerWidget {
  const ThemeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeController);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isSingleMaster = _salonProfileProvider.isSingleMaster;
    final DisplaySettings? displaySettings = _salonProfileProvider.themeSettings?.displaySettings;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: theme.colorScheme.background,
        child: Container(
          child: (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark)
              ? const GentleTouchDrawer()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: isPortrait ? 40.w : 10.w, vertical: 20.h),
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
                                    color: Colors.white,
                                    size: 40.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),

                            // PROMOTIONS
                            DrawerText(
                              drawerText: AppLocalizations.of(context)?.promotions ?? 'Promotions',
                              onTap: () {
                                Navigator.pop(context);
                                Scrollable.ensureVisible(
                                  controller.promotions.currentContext!,
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.ease,
                                );
                              },
                            ),

                            // ABOUT US
                            if (displaySettings?.showAbout == true)
                              DrawerText(
                                drawerText: isSingleMaster
                                    ? (AppLocalizations.of(
                                          context,
                                        )?.aboutMe ??
                                        'About Me')
                                    : (AppLocalizations.of(context)?.aboutUs ?? 'About Us'),
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
                                drawerText: (isSingleMaster
                                    ? (AppLocalizations.of(
                                          context,
                                        )?.myWorks ??
                                        'My Works')
                                    : (AppLocalizations.of(context)?.ourWorks ?? 'Our Works')),
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
                                drawerText: isSingleMaster
                                    ? (AppLocalizations.of(
                                          context,
                                        )?.price ??
                                        'Price')
                                    : (AppLocalizations.of(context)?.ourPrice ?? 'Our Price'),
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
                                drawerText: (AppLocalizations.of(context)?.shop ?? 'Shop'),
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
                                drawerText: AppLocalizations.of(context)?.ourTeam ?? 'Our Team',
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
                                drawerText: AppLocalizations.of(context)?.reviews ?? 'Reviews',
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
                                drawerText: isSingleMaster
                                    ? (AppLocalizations.of(context)?.contacts ?? 'Contacts')
                                    : (AppLocalizations.of(
                                          context,
                                        )?.contactUs ??
                                        'Contact Us'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Scrollable.ensureVisible(
                                    controller.contacts.currentContext!,
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class DrawerText extends ConsumerStatefulWidget {
  final String drawerText;
  final VoidCallback onTap;

  const DrawerText({Key? key, required this.drawerText, required this.onTap}) : super(key: key);

  @override
  ConsumerState<DrawerText> createState() => _DrawerTextState();
}

class _DrawerTextState extends ConsumerState<DrawerText> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    Color textColor = isHovered ? theme.primaryColorDark : theme.primaryColor;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        // onHover: () {},
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: (themeType != ThemeType.GentleTouch && themeType != ThemeType.GentleTouchDark) ? DeviceConstraints.getResponsiveSize(context, 20.h, 15.h, 15.h) : 15.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.drawerText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark) ? 17.sp : DeviceConstraints.getResponsiveSize(context, 20.sp, 25.sp, 35.sp),
                    letterSpacing: 0,
                    color: textColor,
                    fontFamily: 'Inter-Light',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (themeType == ThemeType.GentleTouch || themeType == ThemeType.GentleTouchDark)
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Divider(
                      color: Color(0XFF9F9F9F),
                      thickness: 1,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });
}
