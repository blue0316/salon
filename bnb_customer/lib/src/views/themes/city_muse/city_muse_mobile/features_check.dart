


import 'package:bbblient/src/views/themes/city_muse/city_muse_desktop/city_muse_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';

class FeaturesCheck extends ConsumerWidget {
  final String? title;
  const FeaturesCheck({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return SizedBox(
      width: double.infinity,
      height: 70,
      //MediaQuery.of(context).size.width * (8/30),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
           color: blendColors(
                              theme.colorScheme.secondary,
                              // const Color(0xffea80b2),
                              theme.scaffoldBackgroundColor,
                              0.4),
          //increaseBrightness( theme.colorScheme.secondary,40)
        ),
        child: Column(
          children: [
            const Gap(30),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 10),
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/test_assets/check.svg", color:theme.colorScheme.secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$title'.toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: theme.textTheme.displaySmall!.color,
                          fontSize: 18,
                          // fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}