import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/components/header_image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/header_height.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VintageHeader extends ConsumerWidget {
  final SalonModel chosenSalon;

  const VintageHeader({super.key, required this.chosenSalon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Container(
        height: getThemeHeaderHeight(context, themeType),
        width: double.infinity,
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.green,
                      child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                          ? BackgroundImageExists(
                              salonProfileProvider: _salonProfileProvider,
                            )
                          : const DefaultImageBG(image: ThemeImages.vintageHeader),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50.sp,
              color: Colors.blue,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
