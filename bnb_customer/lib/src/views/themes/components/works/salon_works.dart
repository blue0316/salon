import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/backend_codings/owner_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/prev_and_next.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'default_works_view.dart';
import 'minimal_works_view.dart';

class SalonWorks extends ConsumerStatefulWidget {
  final SalonModel salonModel;

  const SalonWorks({Key? key, required this.salonModel}) : super(key: key);

  @override
  ConsumerState<SalonWorks> createState() => _SalonWorksState();
}

class _SalonWorksState extends ConsumerState<SalonWorks> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    // Check if Salon is a single master
    final bool isSingleMaster = (widget.salonModel.ownerType == OwnerType.singleMaster);

    ThemeType themeType = _salonProfileProvider.themeType;
    return worksThemeView(themeType, theme, widget.salonModel);
  }
}

Widget worksThemeView(ThemeType themeType, ThemeData theme, SalonModel salon) {
  switch (themeType) {
    case ThemeType.GlamMinimalDark:
      return MinimalWorksView(salonModel: salon);
    case ThemeType.GlamMinimalLight:
      return MinimalWorksView(salonModel: salon);

    default:
      return DefaultWorksView(salonModel: salon);
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
    String? themeNo = _salonProfileProvider.theme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: (themeNo != '2' && themeNo != '4')
                ? SvgPicture.asset(
                    ThemeIcons.leftArrow,
                    color: (themeNo == '1' || themeNo == '3') ? Colors.black : theme.primaryColor,
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
            child: (themeNo != '2' && themeNo != '4')
                ? SvgPicture.asset(
                    ThemeIcons.rightArrow,
                    color: (themeNo == '1' || themeNo == '3') ? Colors.black : theme.primaryColor,
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
