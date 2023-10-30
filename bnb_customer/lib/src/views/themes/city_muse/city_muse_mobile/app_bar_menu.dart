import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controller/all_providers/all_providers.dart';

class AppBarMenu extends ConsumerWidget {
  final String? title;
  final Function()? action;
  final int index;
  const AppBarMenu(
      {super.key, this.title = 'About Us', this.action, this.index = 0});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(salonProfileProvider).salonTheme;
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: MouseRegion(
          onEnter: (event) => _salonProfileProvider.onEnterAppbar(index),
          onExit: (event) => _salonProfileProvider.onExitAppbar(index),
          child: Text(
            '$title',
            style: GoogleFonts.openSans(
                fontWeight: _salonProfileProvider.appbarHoveredIndex == index
                    ? FontWeight.w600
                    : null,
                color: _salonProfileProvider.appbarHoveredIndex == index
                    ? theme.colorScheme.secondary
                    : theme.textTheme.displaySmall!.color),
          ),
        ),
      ),
    );
  }
}
