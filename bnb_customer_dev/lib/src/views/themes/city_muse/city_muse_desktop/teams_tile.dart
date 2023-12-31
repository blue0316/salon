import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';
import '../../../../models/salon_master/master.dart';
import '../../../widgets/image.dart';
import '../../images.dart';
import '../../utils/theme_type.dart';

class TeamWidget extends ConsumerWidget {
  final MasterModel? masterModel;
  final int index;
  const TeamWidget({super.key, this.masterModel, required this.index});

  @override
  Widget build(BuildContext contex, ref) {
    final salonProfile = ref.watch(salonProfileProvider);
    return GestureDetector(
      onTap: () {
        salonProfile.changeShowMenu(true);
        salonProfile.getWidgetForDesktop("masters");
        salonProfile.changeCurrentIndex(index);
        salonProfile.changeSelectedMasterView(masterModel);
        salonProfile.changeCurrentIndex(index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
              child: (masterModel!.profilePicUrl != null &&
                      masterModel!.profilePicUrl != '')
                  ? CachedImage(
                      url: '${masterModel!.profilePicUrl}',
                      width: 381,
                      height: 400,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.asset(
                      salonProfile.themeType == ThemeType.CityMuseLight
                          ? ThemeImages.noTeamMemberLightCityMuse
                          : ThemeImages.noTeamMemberDarkCityMuse,
                      //ThemeImages.noTeamMember,
                      width: 381,
                      height: 400,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          const Gap(20),
          SizedBox(
            height: 20,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 8.0),
              child: Row(
                children: [
                  Text(
                    '${masterModel?.personalInfo?.firstName} ${masterModel?.personalInfo?.lastName}'
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      color: index == salonProfile.teamHoveredIndex
                          ? salonProfile.salonTheme.colorScheme.secondary
                          : salonProfile
                              .salonTheme.textTheme.displaySmall!.color,
                      // color:
                      // const Color(0xFFE980B2),
                      fontSize: 20,
                      // fontFamily: 'Open Sans',ss
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  const Gap(10),
                  if (index == salonProfile.teamHoveredIndex)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset('assets/test_assets/book_arrow.png',
                          height: 24,
                          width: 24,
                          color: salonProfile.salonTheme.colorScheme.secondary),
                    ),
                ],
              ),
            ),
          ),
          const Gap(1),
          if (masterModel?.title != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 8.0),
              child: Text(
                '${masterModel?.title}',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: const Color(0xff868686),
                  fontSize: 16,
                  //fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
