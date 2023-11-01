import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';

class SpecializationBox extends ConsumerWidget {
  final String? name;
  const SpecializationBox({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return IntrinsicWidth(
      child: Container(
        //  width: 95,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
        ),
        child: Center(
          child: Text(
            name ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: theme.textTheme.displaySmall!.color,
              fontSize: 14,
              //   fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}