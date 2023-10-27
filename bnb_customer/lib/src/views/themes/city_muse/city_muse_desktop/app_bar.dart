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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: theme.appBarTheme.titleTextStyle!.color!,
        ))),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 5),
          child: Text(
            "$title",
            style: GoogleFonts.openSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color:title == 'Book now'?  theme.colorScheme.secondary:    theme.appBarTheme.titleTextStyle!.color,
              height: 20 / 15,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
