
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';

class AppBarMenu extends ConsumerWidget {
  final String? title;
  final Function()? action;
  const AppBarMenu({super.key, this.action, this.title});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          "$title",
          style: GoogleFonts.openSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: theme.appBarTheme.titleTextStyle!.color,
            height: 20 / 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}