import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/header_image.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/header_height.dart';
import 'package:bbblient/src/views/themes/icons.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VintageHeader extends ConsumerWidget {
  final SalonModel salonModel;

  const VintageHeader({super.key, required this.salonModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: SizedBox(
        height: getThemeHeaderHeight(context, themeType),
        width: double.infinity,
        // color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (salonModel.salonName).toTitleCase(),
                            style: theme.textTheme.displayLarge?.copyWith(
                              // letterSpacing: 0.2,
                              fontSize: 50.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30.sp),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus.',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 40.sp),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DefaultButton(
                                width: 45.w,
                                height: 50.sp,
                                color: theme.colorScheme.secondary,
                                borderColor: theme.colorScheme.secondary,
                                label: AppLocalizations.of(context)?.bookNow ?? "Book Now",
                                textColor: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                borderRadius: 0,
                                onTap: () {},
                              ),
                              SizedBox(width: 20.sp),
                              DefaultButton(
                                width: 55.w,
                                height: 50.sp,
                                color: Colors.black,
                                borderColor: theme.colorScheme.secondary,
                                label: AppLocalizations.of(context)?.contactUs ?? "Contact Us",
                                textColor: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                borderRadius: 0,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 50.w),
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 500.sp,
                      child: (_salonProfileProvider.themeSettings?.backgroundImage != null && _salonProfileProvider.themeSettings?.backgroundImage != '')
                          ? ClipRect(
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                child: BackgroundImageExists(
                                  salonProfileProvider: _salonProfileProvider,
                                  color: Colors.grey[850],
                                  colorBlendMode: BlendMode.saturation,
                                ),
                              ),
                            )
                          : const DefaultImageBG(image: ThemeImages.vintageHeader),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60.sp),
            SizedBox(
              height: 50.sp,
              width: double.infinity,
              child: SvgPicture.asset(ThemeIcons.vintageCutter, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
