import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/promotions/promotion_service.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/components/promotions/glam_light_promotions/glam_light_view.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'barbershop_promotions.dart/barbershop_view.dart';
import 'default_view.dart';

class SalonPromotions extends ConsumerStatefulWidget {
  final List<PromotionModel> salonPromotionsList;
  const SalonPromotions({Key? key, required this.salonPromotionsList}) : super(key: key);

  @override
  ConsumerState<SalonPromotions> createState() => _SalonPromotionsState();
}

class _SalonPromotionsState extends ConsumerState<SalonPromotions> {
  @override
  Widget build(BuildContext context) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    ThemeType themeType = _salonProfileProvider.themeType;

    return Padding(
      padding: EdgeInsets.only(
        left: DeviceConstraints.getResponsiveSize(context, 20.w, 20.w, 50.w),
        right: DeviceConstraints.getResponsiveSize(
          context,
          20.w,
          20.w,
          themeType == ThemeType.GlamLight ? 0 : 50.w,
        ),
        top: 50,
        bottom: 50,
      ),
      child: promotionTheme(themeType, widget.salonPromotionsList),
    );
  }
}

Widget promotionTheme(ThemeType themeType, List<PromotionModel> salonPromotionsList) {
  switch (themeType) {
    case ThemeType.Barbershop:
      return BarbershopPromotions(salonPromotionsList: salonPromotionsList);

    case ThemeType.GlamLight:
      return GlamLightPromotions(salonPromotionsList: salonPromotionsList);

    default:
      return DefaultPromotionsView(salonPromotionsList: salonPromotionsList);
  }
}

class PrevAndNext extends ConsumerWidget {
  final VoidCallback backOnTap;
  final VoidCallback forwardOnTap;

  const PrevAndNext({Key? key, required this.backOnTap, required this.forwardOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          GestureDetector(
            onTap: backOnTap,
            child: (_salonProfileProvider.theme != '2')
                ? SvgPicture.asset(
                    ThemeIcons.leftArrow,
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
            child: (_salonProfileProvider.theme != '2')
                ? SvgPicture.asset(
                    ThemeIcons.rightArrow,
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
