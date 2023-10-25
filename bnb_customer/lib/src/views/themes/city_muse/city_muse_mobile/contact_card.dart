import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../widgets/widgets.dart';
import '../../glam_one/views/app_bar.dart';

class CityMuseContactCard extends ConsumerWidget {
  final String? contactTitle;
  final String? contactDescription;
  final String? contactAsset;
  final bool contactAssetList;
  final String? contactInfo;
  final double width;
  final double titleFontSize;
  final double descriptionFontSize;
  final double infoFontSize;
  final Function()? contactAction;
  const CityMuseContactCard(
      {Key? key,
      this.contactAsset,
      this.titleFontSize = 16,
      this.infoFontSize = 14,
      this.descriptionFontSize = 14,
      this.width = double.infinity,
      this.contactAssetList = false,
      this.contactDescription,
      this.contactInfo,
      this.contactAction,
      this.contactTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    final SalonModel chosenSalon = ref.watch(salonProfileProvider).chosenSalon;
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
      child: Container(
        width: width,
        height: 142,
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 14,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.5,
              color: theme.textTheme.displayLarge!.color!,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/test_assets/$contactAsset',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$contactTitle',
                      style: GoogleFonts.openSans(
                        color: theme.textTheme.headlineSmall!.color,
                        fontSize: titleFontSize,
                        // fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '$contactDescription',
                    style: GoogleFonts.openSans(
                      color: theme.textTheme.headlineSmall!.color,
                      fontSize: descriptionFontSize,
                      // fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            if (contactInfo != '') const SizedBox(height: 20),
            if (contactInfo != '')
              GestureDetector(
                onTap: contactAction,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$contactInfo',
                        style: GoogleFonts.openSans(
                          // decorationThickness: 2, // Optional: specify underline thickness

                          //decoration: TextDecoration.underline,
                          color: theme.textTheme.headlineSmall!.color,
                          fontSize: infoFontSize,
                          //  fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          //   textDecoration: TextDecoration.underline,
                          height: 0,
                        ),
                      ),
                      Container(
                        height: 1.5,
                        color: theme.textTheme.headlineSmall!.color,
                      )
                    ],
                  ),
                ),
              ),
              if(contactAssetList)...[
                 const Gap(10),
          
            Row(children: [
              if(chosenSalon.links?.facebook != null &&  chosenSalon.links!.facebook.isNotEmpty)
               GestureDetector(
                 onTap: () async {
        Uri uri = Uri.parse(socialLinks('facebook',chosenSalon.links!.facebook  ?? ''));

        // debugPrint("launching Url: $uri");

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          showToast("Social Link is not available");
        }
      },

                 child: SvgPicture.asset(
                                'assets/test_assets/facebook.svg'),
               ),
               Gap(4.0),

                               if(chosenSalon.links?.instagram != null &&  chosenSalon.links!.instagram.isNotEmpty)
               GestureDetector(
                onTap: () async {
        Uri uri = Uri.parse(socialLinks('instagram',chosenSalon.links!.instagram  ?? ''));

        // debugPrint("launching Url: $uri");

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          showToast("Social Link is not available");
        }
      },

                 child: SvgPicture.asset(
                                'assets/test_assets/instagram.svg'),
               ),  Gap(4.0),
                               if(chosenSalon.links?.tiktok != null &&  chosenSalon.links!.tiktok.isNotEmpty)
               GestureDetector(
                onTap: () async {
        Uri uri = Uri.parse(socialLinks('tiktok',chosenSalon.links!.tiktok ?? ''));

        // debugPrint("launching Url: $uri");

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          showToast("Social Link is not available");
        }
      },

                 child: SvgPicture.asset(
                                'assets/test_assets/tiktok.svg'),
               ),  Gap(4.0)
                        
            ],)
              ]
           
            // if (contactAssetList != null && contactAssetList!.isNotEmpty)
            //   SizedBox(
            //     height: 50,
            //     child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         shrinkWrap: true,
            //         itemCount: contactAssetList!.length,
            //         itemBuilder: (context, index) => Padding(
            //               padding: const EdgeInsets.all(4.0),
            //               child: 
            // SvgPicture.asset(
            //                   'assets/test_assets/${contactAssetList![index]}'),
            //             )),
            //   )
          ],
        ),
      ),
    );
  }
}
