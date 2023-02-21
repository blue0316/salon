import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeHeaderImage extends ConsumerWidget {
  const ThemeHeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    return SizedBox(
      width: double.infinity,
      child: _salonProfileProvider.chosenSalon.profilePics.isNotEmpty
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
              child: CachedImage(
                url: _salonProfileProvider.chosenSalon.profilePics[0],
                fit: BoxFit.cover,
              ),
            )
          : ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
              child: Image.asset(
                ThemeImages.longBG,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
