import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'default_view.dart';
import 'minimal_view.dart';

class WriteToUs extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const WriteToUs({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<WriteToUs> createState() => _WriteToUsState();
}

class _WriteToUsState extends ConsumerState<WriteToUs> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;

    return Form(
      key: _salonProfileProvider.formKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: (themeType == ThemeType.GlamGradient) ? null : theme.cardColor,
          gradient: (themeType == ThemeType.GlamGradient)
              ? const LinearGradient(
                  colors: [
                    Color(0XFFF48B72),
                    Color(0XFFFFDA92),
                    Color(0XFF8DBBEC),
                  ],
                )
              : null,
        ),
        child: writeToUsTheme(context, themeType, widget.salonModel),
      ),
    );
  }
}

Widget writeToUsTheme(context, ThemeType themeType, SalonModel salon) {
  switch (themeType) {
    case ThemeType.GlamMinimalLight:
      return Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h),
          // bottom: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
        ),
        child: MinimalWriteToUsView(salonModel: salon),
      );

    case ThemeType.GlamMinimalDark:
      return Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h),
          // bottom: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
        ),
        child: MinimalWriteToUsView(salonModel: salon),
      );

    default:
      return Padding(
        padding: EdgeInsets.only(
          left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          right: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
          top: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
          bottom: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
          // vertical: DeviceConstraints.getResponsiveSize(context, 100.h, 120.h, 140.h), // 120,
        ),
        child: DefaultWriteToUsView(salonModel: salon),
      );
  }
}