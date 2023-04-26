import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/salon_master/master.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/master_profile/unique_master_profile.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'default_works_view.dart';
import 'minimal_works_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterWorksUnique extends ConsumerStatefulWidget {
  final MasterModel masterModel;

  const MasterWorksUnique({Key? key, required this.masterModel}) : super(key: key);

  @override
  ConsumerState<MasterWorksUnique> createState() => _MasterWorksUniqueState();
}

class _MasterWorksUniqueState extends ConsumerState<MasterWorksUnique> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;
    return worksThemeView(themeType, theme, widget.masterModel);
  }
}

Widget worksThemeView(ThemeType themeType, ThemeData theme, MasterModel master) {
  switch (themeType) {
    case ThemeType.GlamMinimalDark:
      return MinimalWorksView(masterModel: master);
    case ThemeType.GlamMinimalLight:
      return MinimalWorksView(masterModel: master);

    default:
      return DefaultWorksView(masterModel: master);
  }
}

class OurWorksButton extends ConsumerWidget {
  final VoidCallback backOnTap;
  final VoidCallback forwardOnTap;

  const OurWorksButton({Key? key, required this.backOnTap, required this.forwardOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    final ThemeType themeType = _salonProfileProvider.themeType;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: (themeType != ThemeType.GlamBarbershop && themeType != ThemeType.Barbershop)
                ? SvgPicture.asset(
                    ThemeIcons.leftArrow,
                    color: (themeType == ThemeType.Glam || themeType == ThemeType.GlamGradient) ? Colors.black : theme.primaryColor,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_back,
                    size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                    color: Colors.white,
                  ),
          ),
          SizedBox(width: DeviceConstraints.getResponsiveSize(context, 15, 30, 40)),
          GestureDetector(
            onTap: forwardOnTap,
            child: (themeType != ThemeType.GlamBarbershop && themeType != ThemeType.Barbershop)
                ? SvgPicture.asset(
                    ThemeIcons.rightArrow,
                    color: (themeType == ThemeType.Glam || themeType == ThemeType.GlamGradient) ? Colors.black : theme.primaryColor,
                    height: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                  )
                : Icon(
                    Icons.arrow_forward,
                    size: DeviceConstraints.getResponsiveSize(context, 30.sp, 40.sp, 50.sp),
                    color: theme.primaryColor,
                  ),
          ),
        ],
      ),
    );
  }
}
