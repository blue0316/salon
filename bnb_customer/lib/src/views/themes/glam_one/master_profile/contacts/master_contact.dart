import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbblient/src/views/themes/images.dart';

class MasterContactUnique extends ConsumerStatefulWidget {
  final MasterModel masterModel;

  const MasterContactUnique({Key? key, required this.masterModel}) : super(key: key);

  @override
  ConsumerState<MasterContactUnique> createState() => _MasterContactUniqueState();
}

class _MasterContactUniqueState extends ConsumerState<MasterContactUnique> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      decoration: themeType == ThemeType.Barbershop
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isPortrait ? ThemeImages.footerLongGradientBG : ThemeImages.footerGradientBG,
                ),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
          bottom: 100, // DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
        ),
        child: MasterContactDefaultView(masterModel: widget.masterModel),
      ),
    );
  }
}

class MasterContactDefaultView extends ConsumerWidget {
  final MasterModel masterModel;

  const MasterContactDefaultView({Key? key, required this.masterModel}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          (AppLocalizations.of(context)?.contacts ?? 'Contacts').toUpperCase(),
          style: theme.textTheme.displayMedium!.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: DeviceConstraints.getResponsiveSize(context, 550.h, 310.h, 300.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (!isPortrait) ? 10.w : 0),
            child: (!isPortrait)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ContactSection(masterModel: masterModel),
                            // const SizedBox(height: 10),
                            // VisitUs(masterModel: masterModel),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ContactSection(masterModel: masterModel),
                      // const SizedBox(height: 30),
                      // VisitUs(masterModel: masterModel),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class ContactSection extends ConsumerWidget {
  final MasterModel masterModel;

  const ContactSection({Key? key, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark) ? AppLocalizations.of(context)?.contacts ?? 'Contacts' : (AppLocalizations.of(context)?.contacts ?? 'Contacts').toUpperCase(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        if (masterModel.personalInfo?.phone != '')
          ContactCard(
            icon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.minimalPhone : ThemeIcons.phone,
            value: '${masterModel.personalInfo?.phone}',
          ),
        if (masterModel.personalInfo?.email != '')
          ContactCard(
            icon: (themeType == ThemeType.GlamMinimalLight) ? ThemeIcons.minimalMail : ThemeIcons.mail,
            value: '${masterModel.personalInfo?.email}',
          ),
      ],
    );
  }
}

class ContactCard extends ConsumerWidget {
  final String icon, value;
  const ContactCard({Key? key, required this.icon, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: DeviceConstraints.getResponsiveSize(context, 20.sp, 20.sp, 20.sp),
            color: theme.primaryColorDark,
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: iconColor(themeType), // (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color iconColor(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Colors.black;

    case ThemeType.GlamMinimalDark:
      return Colors.white;

    default:
      return (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white;
  }
}

class VisitUs extends ConsumerWidget {
  final MasterModel masterModel;

  const VisitUs({Key? key, required this.masterModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          // "VISIT US",
          (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark) ? AppLocalizations.of(context)?.visit ?? 'Visit' : (AppLocalizations.of(context)?.visit ?? 'Visit').toUpperCase(),

          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        ContactCard(
          icon: (themeType == ThemeType.GlamMinimalLight || themeType == ThemeType.GlamMinimalDark) ? ThemeIcons.minimalLocation : ThemeIcons.location,
          value: '',
        ),
      ],
    );
  }
}
