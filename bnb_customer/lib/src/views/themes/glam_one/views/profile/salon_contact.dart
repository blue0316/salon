import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/theme/glam_one.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SalonContact extends StatefulWidget {
  final SalonModel salonModel;

  const SalonContact({Key? key, required this.salonModel}) : super(key: key);

  @override
  State<SalonContact> createState() => _SalonContactState();
}

class _SalonContactState extends State<SalonContact> with SingleTickerProviderStateMixin {
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
            "${isSingleMaster ? "" : "OUR "} CONTACTS",
            style: GlamOneTheme.headLine2.copyWith(),
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: DeviceConstraints.getResponsiveSize(context, 550.h, 500.h, 260.h),
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
                            children: const [
                              ContactSection(),
                              SizedBox(height: 10),
                              VisitUs(),
                              SizedBox(height: 10),
                              SocialNetwork(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        // Spacer(),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 400.h,
                            child: Image.asset(ThemeImages.map, fit: BoxFit.cover),
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
                          child: Image.asset(ThemeImages.map, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 30),
                        const ContactSection(),
                        const SizedBox(height: 30),
                        const VisitUs(),
                        const SizedBox(height: 30),
                        const SocialNetwork(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialNetwork extends StatelessWidget {
  const SocialNetwork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "SOCIAL NETWORK",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: GlamOneTheme.headLine4.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              ThemeIcons.insta,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
              color: GlamOneTheme.deepOrange,
            ),
            const SizedBox(width: 20),
            SvgPicture.asset(
              ThemeIcons.tiktok,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
              color: GlamOneTheme.deepOrange,
            ),
            const SizedBox(width: 20),
            SvgPicture.asset(
              ThemeIcons.whatsapp,
              height: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
              color: GlamOneTheme.deepOrange,
            ),
          ],
        ),
      ],
    );
  }
}

class VisitUs extends StatelessWidget {
  const VisitUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "VISIT US",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: GlamOneTheme.headLine4.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),
          ),
        ),
        const SizedBox(height: 10),
        const ContactCard(icon: ThemeIcons.mail, value: "500 Brickell Av, Miami Fl 33131"),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Contact",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: GlamOneTheme.headLine4.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 26.sp, 26.sp, 20.sp),

            // fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const ContactCard(icon: ThemeIcons.phone, value: "(000) 000-0000"),
        const ContactCard(icon: ThemeIcons.mail, value: "miamibeauty@gmail.com"),
      ],
    );
  }
}

class ContactCard extends StatelessWidget {
  final String icon, value;
  const ContactCard({Key? key, required this.icon, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 16.sp),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Text(
              value,
              style: GlamOneTheme.bodyText1.copyWith(
                color: Colors.white,
                fontSize: DeviceConstraints.getResponsiveSize(context, 18.sp, 18.sp, 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
