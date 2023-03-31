import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeDrawer extends ConsumerWidget {
  const ThemeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeController);

    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);

    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);
    final bool isSingleMaster = _createAppointmentProvider.salonMasters.length <= 1;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: theme.colorScheme.background,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isPortrait ? 40.w : 20.w, vertical: 20.h),
          child: LayoutBuilder(
            builder: (context8, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
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
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.promotions.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // ABOUT US
                        DrawerText(
                          drawerText: isSingleMaster
                              ? (AppLocalizations.of(
                                    context,
                                  )?.aboutMe ??
                                  'About Me')
                              : (AppLocalizations.of(context)?.aboutUs ?? 'About Us'),
                          onTap: () {
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.about.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // OUR WORKS
                        DrawerText(
                          drawerText: (isSingleMaster
                              ? (AppLocalizations.of(
                                    context,
                                  )?.myWorks ??
                                  'My Works')
                              : (AppLocalizations.of(context)?.ourWorks ?? 'Our Works')),
                          onTap: () {
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.works.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // OUR PRICE
                        DrawerText(
                          drawerText: isSingleMaster
                              ? (AppLocalizations.of(
                                    context,
                                  )?.price ??
                                  'Price')
                              : (AppLocalizations.of(context)?.ourPrice ?? 'Our Price'),
                          onTap: () {
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.price.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // SHOP
                        DrawerText(
                          drawerText: (AppLocalizations.of(context)?.shop ?? 'Shop'),
                          onTap: () {
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.shop.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // TEAM
                        DrawerText(
                          drawerText: AppLocalizations.of(context)?.ourTeam ?? 'Our Team',
                          onTap: () {
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.team.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // REVIEWS
                        DrawerText(
                          drawerText: AppLocalizations.of(context)?.reviews ?? 'Reviews',
                          onTap: () {
                            Navigator.pop(context8);
                            Scrollable.ensureVisible(
                              controller.reviews.currentContext!,
                              duration: const Duration(seconds: 2),
                              curve: Curves.ease,
                            );
                          },
                        ),

                        // CONTACTS
                        DrawerText(
                          drawerText: isSingleMaster
                              ? (AppLocalizations.of(context)?.contacts ?? 'Contacts')
                              : (AppLocalizations.of(
                                    context,
                                  )?.contactUs ??
                                  'Contact Us'),
                          onTap: () {
                            Navigator.pop(context8);
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
                ),
              );
            },
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
              vertical: DeviceConstraints.getResponsiveSize(context, 5.h, 15.h, 15.h),
            ),
            child: Text(
              widget.drawerText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: DeviceConstraints.getResponsiveSize(context, 20.sp, 25.sp, 35.sp),
                letterSpacing: 0,
                color: textColor,
              ),
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