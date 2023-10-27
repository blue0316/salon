import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VintageHours extends ConsumerWidget {
  final SalonModel salonModel;

  const VintageHours({Key? key, required this.salonModel}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
        right: DeviceConstraints.getResponsiveSize(context, 10.w, 10.w, 30.w),
        top: 100.h,
        bottom: 20.h,
      ),
      child: SizedBox(
        height: 700.h,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            ),
            SizedBox(width: 30.w),
            Expanded(
              child: Container(
                color: Colors.orange[600],
              ),
            ),
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         (AppLocalizations.of(context)?.contacts ?? 'Contacts').toTitleCase(),
            //         style: theme.textTheme.displayMedium!.copyWith(
            //           fontSize: DeviceConstraints.getResponsiveSize(context, 50.sp, 50.sp, 50.sp),
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //       SizedBox(height: 20.sp),
            //       Text(
            //         AppLocalizations.of(context)?.connectWithUsDesc ?? 'Connect with us easily. Whether it\'s questions, collaborations, or just saying hello, we\'re here for you. Reach out via email, find us on social media, give us a call, or visit our address below.',
            //         style: theme.textTheme.displayMedium?.copyWith(
            //           fontSize: 17.sp, // DeviceConstraints.getResponsiveSize(context, 17.sp, 17.sp, 18.sp),
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //       // SizedBox(height: 20.sp),
            //       const Spacer(),
            //       Wrap(
            //         direction: Axis.horizontal,
            //         alignment: WrapAlignment.spaceBetween,
            //         runAlignment: WrapAlignment.spaceBetween,
            //         runSpacing: 15.sp,
            //         spacing: 20.sp,
            //         children: [
            //           GentleTouchContactCard(
            //             icon: Icons.message,
            //             cardTitle: (AppLocalizations.of(context)?.writeToUsTitle ?? 'Write To Us').toTitleCase(),
            //             cardDesc: AppLocalizations.of(context)?.startConversation1 ?? 'Start a conversations via email',
            //             cardValue: salonModel.email,
            //             onValueTap: () {
            //               final Uri emailLaunchUri = Uri(
            //                 scheme: 'mailto',
            //                 path: salonModel.email,
            //                 queryParameters: {'subject': 'Contact'},
            //               );
            //               launchUrl(emailLaunchUri);
            //             },
            //           ),
            //           GentleTouchContactCard(
            //             icon: Icons.call,
            //             cardTitle: AppLocalizations.of(context)?.callUs ?? 'Call Us',
            //             cardDesc: AppLocalizations.of(context)?.callUsDesc ?? 'Today from 10 am to 7 pm',
            //             cardValue: salonModel.phoneNumber,
            //             onValueTap: () {
            //               Utils().launchCaller(salonModel.phoneNumber.replaceAll("-", ""));
            //             },
            //           ),
            //           GentleTouchContactCard(
            //             isAddress: true,
            //             icon: Icons.location_pin,
            //             cardTitle: AppLocalizations.of(context)?.visitUs ?? 'Visit Us',
            //             cardDesc: salonModel.address,
            //             cardValue: (AppLocalizations.of(context)?.viewOnMap ?? 'View On The Map').toTitleCase(),
            //             onValueTap: () async {
            //               Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeFull(salonModel.address)}');

            //               if (await canLaunchUrl(uri)) {
            //                 await launchUrl(uri);
            //               } else {
            //                 showToast(AppLocalizations.of(context)?.couldNotLaunch ?? "Could not launch");
            //               }
            //             },
            //           ),
            //           GentleTouchContactCard(
            //             isSocial: true,
            //             svg: ThemeIcons.socialContact,
            //             isSvg: true,
            //             cardTitle: AppLocalizations.of(context)?.socialMedia ?? 'Social Media',
            //             cardDesc: AppLocalizations.of(context)?.discoverMoreOnSocial ?? 'Discover more on social',
            //             cardValue: '',
            //             salon: salonModel,
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 30.sp),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
