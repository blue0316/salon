import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';

class AppBarMenu extends ConsumerWidget {
  final String? title;
  final Function()? action;
  const AppBarMenu({super.key, this.title = 'About Us', this.action});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top:8,
        //bottom: 8
        ),
        child: Text(
          '$title',
          style:
              GoogleFonts.openSans(color: theme.textTheme.displaySmall!.color),
        ),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xff9f9f9f), width: 1))),
      ),
    );
  }
}
