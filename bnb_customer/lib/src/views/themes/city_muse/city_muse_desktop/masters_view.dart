import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/salon_master/master.dart';
import '../../../widgets/widgets.dart';
import '../../glam_one/views/app_bar.dart';
import '../../images.dart';
import '../../utils/theme_type.dart';

class DesktopMastersView extends ConsumerStatefulWidget {
  const DesktopMastersView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DesktopMastersViewState();
}

class _DesktopMastersViewState extends ConsumerState<DesktopMastersView> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    final salonProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    MasterModel master = _createAppointmentProvider
        .salonMasters[salonProvider.currentMasterIndex];
    return Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
      ),
      child: SizedBox(
        // height: 1000,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 80,
                            //MediaQuery.of(context).size.width / 6,
                            right: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                salonProvider.changeShowMenu(false);
                                // getWidget("menu");

                                salonProvider.changeShowMenu(false);
                              },
                              child: SizedBox(
                                width: 500,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/test_assets/arrow_back.svg'),
                                    Text(
                                      ' Back to the main page',
                                      style: GoogleFonts.openSans(
                                        color: const Color(0xffb4b4b4),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(40),
                            Text(
                              '${master.personalInfo?.firstName} ${salonProvider.selectedViewMasterModel?.personalInfo?.lastName}',
                              style: GoogleFonts.openSans(
                                  color: theme.textTheme.displaySmall!.color,
                                  fontSize: 40),
                            ),
                            if (salonProvider.selectedViewMasterModel?.title !=
                                null)
                              Text(
                                '${master.title}',
                                style: GoogleFonts.openSans(
                                    color: const Color(0xff868686),
                                    fontSize: 20),
                              ),
                            const Gap(30),
                            const Gap(30),
                            SizedBox(
                              //width: 500,
                              child: Text(
                                '${master.personalInfo?.description}',
                                maxLines: 500,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.openSans(
                                  letterSpacing: 1,
                                  height: 2,
                                  fontSize: 18,
                                  color: theme.textTheme.titleSmall!.color,
                                ),
                              ),
                            ),
                            const Gap(30),
                            SizedBox(
                              height: 50,
                              //width: 100,
                              child: SizedBox(
                                width: 500,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        salonProvider.navigateToPreviousMaster(
                                            _createAppointmentProvider
                                                .salonMasters);
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/test_assets/arrow_back.svg'),
                                          const Text(
                                            ' Previous specialist',
                                            style: TextStyle(
                                                color: Color(0xffb4b4b4)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        salonProvider.navigateToNextMaster(
                                            _createAppointmentProvider
                                                .salonMasters);
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            ' Next specialist',
                                            style: TextStyle(
                                                color: Color(0xffb4b4b4)),
                                          ),
                                          SvgPicture.asset(
                                              'assets/test_assets/arrow_forward.svg'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xff868686)),
                                    right: BorderSide(color: Color(0xff868686)),
                                    left:
                                        BorderSide(color: Color(0xff868686)))),
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Column(
                              children: [
                                (master.profilePicUrl != null &&
                                        master.profilePicUrl != '')
                                    ? Expanded(
                                        child: CachedImage(
                                        url: '${master.profilePicUrl}',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        fit: BoxFit.fitWidth,
                                      ))
                                    : Expanded(
                                        child: Image.asset(
                                          salonProvider.themeType ==
                                                  ThemeType.CityMuseLight
                                              ? ThemeImages
                                                  .noTeamMemberLightCityMuse
                                              : ThemeImages
                                                  .noTeamMemberDarkCityMuse,
                                          //ThemeImages.noTeamMember,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          // height: 400,
                                          fit: BoxFit.fitWidth,
                                          height: 200,
                                        ),
                                      ),
                                const Gap(20),
                                Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (master.links?.facebook != null &&
                                        master.links!.facebook.isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          Uri uri = Uri.parse(socialLinks(
                                              'facebook',
                                              master.links?.facebook ?? ''));

                                          // debugPrint("launching Url: $uri");

                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            showToast(
                                                "Social Link is not available");
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            'assets/test_assets/facebook.svg'),
                                      ),
                                    const Gap(4.0),
                                    if (master.links?.instagram != null &&
                                        master.links!.instagram.isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          Uri uri = Uri.parse(socialLinks(
                                              'instagram',
                                              master.links?.instagram ?? ''));

                                          // debugPrint("launching Url: $uri");

                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            showToast(
                                                "Social Link is not available");
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            'assets/test_assets/instagram.svg'),
                                      ),
                                    const Gap(4.0),
                                    if (master.links?.tiktok != null &&
                                        master.links!.tiktok.isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          Uri uri = Uri.parse(socialLinks(
                                              'tiktok',
                                              master.links?.tiktok ?? ''));

                                          // debugPrint("launching Url: $uri");

                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            showToast(
                                                "Social Link is not available");
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            'assets/test_assets/tiktok.svg'),
                                      ),
                                    const Gap(4.0),
                                    if (master.links?.twitter != null &&
                                        master.links!.twitter.isNotEmpty)
                                      const Gap(4.0),
                                    if (master.links?.twitter != null &&
                                        master.links!.twitter.isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          Uri uri = Uri.parse(socialLinks(
                                              'twitter',
                                              master.links?.twitter ?? ''));

                                          // debugPrint("launching Url: $uri");

                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            showToast(
                                                "Social Link is not available");
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            'assets/test_assets/twitter.svg'),
                                      ),
                                    const Gap(4.0),
                                    if (master.links?.pinterest != null &&
                                        master.links!.pinterest.isNotEmpty)
                                      GestureDetector(
                                        onTap: () async {
                                          Uri uri = Uri.parse(socialLinks(
                                              'pinterest',
                                              master.links?.twitter ?? ''));

                                          // debugPrint("launching Url: $uri");

                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            showToast(
                                                "Social Link is not available");
                                          }
                                        },
                                        child: SvgPicture.asset(
                                            'assets/test_assets/pinterest.svg'),
                                      ),
                                    GestureDetector(
                                      onTap: () async {
                                        Uri uri = Uri.parse(socialLinks(
                                            'twitter',
                                            master.links?.twitter ?? ''));

                                        // debugPrint("launching Url: $uri");

                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          showToast(
                                              "Social Link is not available");
                                        }
                                      },
                                      child: SvgPicture.asset(
                                          'assets/test_assets/twitter.svg'),
                                    ),
                                  ],
                                )),
                                const Gap(20),
                              ],
                            )),
                        const Gap(4.0),
                      ],
                    ),
                  )
                ],
              ),
              const Gap(100),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 80,
                      //MediaQuery.of(context).size.width / 6,
                      right: 80),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 1,
                            width: double.infinity,
                            color: const Color(0xFF41403C)),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.only(
                    left: 80,
                    //MediaQuery.of(context).size.width / 6,
                    right: 80),
                child: Row(
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff868686),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Gap(70),
                    Text(
                      "Privacy Policy",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff868686),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    Text(
                      "© 2023 Glamiris.",
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        //fontWeight: FontWeight.wSymbol(figma.mixed),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Gap(5),
                    Text(
                      "Powered by GlamIris",
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: salonProvider.salonTheme.colorScheme.secondary,
                        // color: const Color(0xFFE980B2),

                        fontWeight: FontWeight.bold,
                        //fontWeight: FontWeight.wSymbol(figma.mixed),
                        height: 24 / 14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
