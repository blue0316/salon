import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/views/themes/components/header_image.dart';
import 'package:bbblient/src/views/themes/glam_one/views/app_bar.dart';
import 'package:bbblient/src/views/themes/glam_one/views/header.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../glam_one/core/utils/header_height.dart';

class LandingHeader extends ConsumerWidget {
  const LandingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final SalonModel chosenSalon = _salonProfileProvider.chosenSalon;

    ThemeType themeType = _salonProfileProvider.themeType;

    return SizedBox(
      height: getThemeHeaderHeight(context, _salonProfileProvider.theme),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // TOP BACKGROUND IMAGE

          const ThemeHeaderImage(),
          SizedBox(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 25.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ThemeAppBar(salonModel: chosenSalon),
                    SizedBox(height: 70.h),
                    ThemeHeader(salonModel: chosenSalon),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
