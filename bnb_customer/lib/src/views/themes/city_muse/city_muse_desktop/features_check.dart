import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';

class DesktopFeaturesCheck extends ConsumerWidget {
  final String? title;
  const DesktopFeaturesCheck({super.key, this.title});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return IntrinsicWidth(
      child: SizedBox(
        //  width: 250,
        height: 70,
        //MediaQuery.of(context).size.width * (8/30),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 10),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/test_assets/check.svg",
                  color: theme.colorScheme.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$title',
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
    );
  }
}
