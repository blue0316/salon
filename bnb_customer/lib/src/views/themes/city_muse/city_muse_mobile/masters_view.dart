import 'package:bbblient/src/views/themes/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/salon_master/master.dart';
import '../../../widgets/image.dart';
import '../../utils/theme_type.dart';

class MastersView extends ConsumerStatefulWidget {
  const MastersView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MastersViewState();
}

class _MastersViewState extends ConsumerState<MastersView> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    final salonProvider = ref.watch(salonProfileProvider);
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    MasterModel master = _createAppointmentProvider
        .salonMasters[salonProvider.currentMasterIndex];
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    salonProvider.changeShowMenuMobile(false);
                    // getWidget("menu");
                  });
                  setState(() {
                    salonProvider.changeShowMenuMobile(false);
                  });
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/test_assets/arrow_back.svg'),
                    Text(
                      ' Back to the main page',
                      style:
                          GoogleFonts.openSans(color: const Color(0xffb4b4b4)),
                    )
                  ],
                ),
              ),
              const Gap(20),
              Text(
                '${master.personalInfo?.firstName} ${master.personalInfo?.lastName}',
                style: GoogleFonts.openSans(
                    color: theme.textTheme.displaySmall!.color,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              if (salonProvider.selectedViewMasterModel?.title != null)
                Text(
                  '${master.title}',
                  style: GoogleFonts.openSans(
                      color: const Color(0xff868686), fontSize: 20),
                ),
              const Gap(30),
              Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xff868686)),
                          right: BorderSide(color: Color(0xff868686)),
                          left: BorderSide(color: Color(0xff868686)))),
                  width: double.infinity,
                  height: 373,
                  child: Column(
                    children: [
                      (salonProvider.selectedViewMasterModel!.profilePicUrl !=
                                  null &&
                              salonProvider
                                      .selectedViewMasterModel!.profilePicUrl !=
                                  '')
                          ? Expanded(
                              child: CachedImage(
                              url: '${master.profilePicUrl}',
                              width: MediaQuery.of(context).size.width / 0.8,
                              fit: BoxFit.fitWidth,
                            ))
                          : Image.asset(
                              salonProvider.themeType ==
                                      ThemeType.GlamMinimalLight
                                  ? ThemeImages.noTeamMember
                                  : ThemeImages.noTeamMemberDark,
                              width: MediaQuery.of(context).size.width / 0.8,
                              fit: BoxFit.fitWidth,
                            ),
                      const Gap(20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/test_assets/instagram.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/facebook.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/pinterest.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/tiktok.svg',
                              height: 30,
                              width: 30,
                            ),
                            SvgPicture.asset(
                              'assets/test_assets/twitter.svg',
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                    ],
                  )),
              const Gap(30),
              Text(
                '${master.personalInfo?.description}',
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  letterSpacing: 1,
                  height: 2,
                  color: theme.textTheme.titleSmall!.color,
                ),
              ),
              const Gap(30),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        salonProvider.navigateToPreviousMaster(
                            _createAppointmentProvider.salonMasters);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/test_assets/arrow_back.svg'),
                          Text(
                            ' Previous specialist',
                            style: GoogleFonts.openSans(
                                color: const Color(0xffb4b4b4)),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        salonProvider.navigateToNextMaster(
                            _createAppointmentProvider.salonMasters);
                      },
                      child: Row(
                        children: [
                          Text(
                            ' Next specialist',
                            style: GoogleFonts.openSans(
                                color: const Color(0xffb4b4b4)),
                          ),
                          SvgPicture.asset(
                              'assets/test_assets/arrow_forward.svg'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFFB8B2A6)),
              const Gap(30),
              Center(
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Terms & Conditions',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF585858),
                          fontSize: 13,
                          //fontFamily: 'Onest',
                          fontWeight: FontWeight.w400,
                          height: 0.08,
                        ),
                      ),
                      const SizedBox(width: 22),
                      Text(
                        'Privacy Policy',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF585858),
                          fontSize: 13,
                          //   fontFamily: 'Onest',
                          fontWeight: FontWeight.w400,
                          height: 0.08,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: ' ',
                    //  style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: '© 2023 Glamiris.',
                          style: TextStyle(
                            color: Color(0xFF585858),
                          )),
                      TextSpan(
                          text: ' Powered by Glamiris!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE980B2),
                          )),
                    ],
                  ),
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
