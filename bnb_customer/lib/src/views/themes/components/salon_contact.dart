import 'dart:html';
import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart' as maps;

// import 'package:google_maps_flutter/google_maps_flutter.dart';

class SalonContact extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonContact({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonContact> createState() => _SalonContactState();
}

class _SalonContactState extends ConsumerState<SalonContact> with SingleTickerProviderStateMixin {
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
    final bool isSingleMaster = (widget.salonModel.ownerType == OwnerType.singleMaster);

    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        vertical: 120,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            // "${isSingleMaster ? "" : "OUR "} CONTACTS",
            isSingleMaster
                ? (AppLocalizations.of(context)?.contacts ?? 'Contacts')
                : (AppLocalizations.of(
                          context,
                        )?.ourContacts ??
                        'Our Contacts')
                    .toUpperCase(),
            style: theme.textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: DeviceConstraints.getResponsiveSize(context, 550.h, 310.h, 260.h),
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
                              ContactSection(salonModel: widget.salonModel),
                              const SizedBox(height: 10),
                              VisitUs(salonModel: widget.salonModel),
                              const SizedBox(height: 10),
                              SocialNetwork(salonModel: widget.salonModel),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        // Spacer(),

                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 400.h,
                            child: GoogleMaps(
                              salonModel: widget.salonModel,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1,
                            child: GoogleMaps(
                              salonModel: widget.salonModel,
                            )
                            // Image.asset(ThemeImages.map, fit: BoxFit.cover),
                            ),
                        const SizedBox(height: 30),
                        ContactSection(salonModel: widget.salonModel),
                        const SizedBox(height: 30),
                        VisitUs(salonModel: widget.salonModel),
                        const SizedBox(height: 30),
                        SocialNetwork(salonModel: widget.salonModel),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleMaps extends ConsumerStatefulWidget {
  final SalonModel? salonModel;
  const GoogleMaps({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends ConsumerState<GoogleMaps> {
  String htmlId = "7";

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = maps.LatLng(
        widget.salonModel!.position!.geoPoint!.latitude ?? 1.3521,
        widget.salonModel!.position!.geoPoint!.longitude ?? 103.8198,
      );

      final mapOptions = maps.MapOptions()
        ..zoom = 10
        ..maxZoom = 19
        ..center = maps.LatLng(1.3521, 103.8198);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = maps.GMap(elem, mapOptions);

      maps.Marker(maps.MarkerOptions()
            ..position = myLatlng
            ..map = map
          // ..title = 'Hello World!'
          );

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}

class ContactSection extends ConsumerWidget {
  final SalonModel salonModel;

  const ContactSection({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.contacts ?? 'Contacts'.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.headline2?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        if (salonModel.phoneNumber != '') ContactCard(icon: ThemeIcons.phone, value: salonModel.phoneNumber),
        if (salonModel.email != '') ContactCard(icon: ThemeIcons.mail, value: salonModel.email),
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
              style: theme.textTheme.bodyText1?.copyWith(color: Colors.white, fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class VisitUs extends ConsumerWidget {
  final SalonModel salonModel;

  const VisitUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          // "VISIT US",
          AppLocalizations.of(context)?.visit ?? 'Visit'.toUpperCase(),

          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.headline2?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        ContactCard(icon: ThemeIcons.mail, value: salonModel.address),
      ],
    );
  }
}

class SocialNetwork extends ConsumerWidget {
  final SalonModel salonModel;

  const SocialNetwork({Key? key, required this.salonModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          // "SOCIAL NETWORK",
          AppLocalizations.of(context)?.socialNetwork ?? 'Social Network'.toUpperCase(),

          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: theme.textTheme.headline2?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Socials(
              socialIcon: ThemeIcons.insta,
              socialUrl: salonModel.links?.instagram,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
              color: theme.dividerColor,
            ),
            const SizedBox(width: 20),
            Socials(
              socialIcon: ThemeIcons.tiktok,
              socialUrl: salonModel.links?.facebookMessenger,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
              color: theme.dividerColor,
            ),
            const SizedBox(width: 20),
            Socials(
              socialIcon: ThemeIcons.whatsapp,
              socialUrl: salonModel.links?.whatsapp,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 26.sp),
              color: theme.dividerColor,
            ),
          ],
        ),
      ],
    );
  }
}
