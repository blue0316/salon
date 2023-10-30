import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double getThemeHeaderHeight(context, ThemeType themeType) {
  final height = MediaQuery.of(context).size.height;
  switch (themeType) {
    case ThemeType.GentleTouchDark:
      return DeviceConstraints.getResponsiveSize(context, 830.h, 830.h, 830.h);

    case ThemeType.GentleTouch:
      return DeviceConstraints.getResponsiveSize(context, 830.h, 830.h, 830.h);

    case ThemeType.VintageCraft:
      return DeviceConstraints.getResponsiveSize(context, height - 70.h, 600.h, 650.h);

    default:
      return (height);
  }
}

class NoSectionYet extends ConsumerWidget {
  final String text;
  final Color color;

  const NoSectionYet({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: DeviceConstraints.getResponsiveSize(context, 25.sp, 25.sp, 25.sp),
            color: color,
          ),
        ),
      ),
    );
  }
}
