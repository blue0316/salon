import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/components/services/widgets/service_tile.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GentleTouchServiceTile extends ConsumerStatefulWidget {
  final ServiceModel service;

  const GentleTouchServiceTile({Key? key, required this.service}) : super(key: key);

  @override
  ConsumerState<GentleTouchServiceTile> createState() => _GentleTouchServiceTileState();
}

class _GentleTouchServiceTileState extends ConsumerState<GentleTouchServiceTile> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    // final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: MouseRegion(
          onEnter: (event) => onEntered(true),
          onExit: (event) => onEntered(false),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isHovered && widget.service.description != null && widget.service.description != '' && (widget.service.servicePhoto != null && widget.service.servicePhoto != ''))
                    SizedBox(
                      height: 60.sp,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          (themeType != ThemeType.GentleTouch && themeType != ThemeType.GentleTouchDark && themeType != ThemeType.VintageCraft)
                              ? '${widget.service.translations?[AppLocalizations.of(
                                        context,
                                      )?.localeName ?? 'en'] ?? widget.service.translations?['en']}'
                                  .toUpperCase()
                              : '${widget.service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? widget.service.translations?['en']}'.toTitleCase(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: serviceNameColor(themeType, theme),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.sp),
                      Text(
                        widget.service.isFixedPrice ? "${getCurrency(salonModel.countryCode!)}${widget.service.priceAndDuration!.price}" : "${getCurrency(salonModel.countryCode!)}${widget.service.priceAndDuration!.price} - ${getCurrency(salonModel.countryCode!)}${widget.service.priceAndDurationMax!.price}",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: priceColor(themeType, theme), // (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isHovered && (widget.service.description != null && widget.service.description != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 50.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${widget.service.description}',
                              // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: serviceNameColor(themeType, theme),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(flex: 1, child: SizedBox()),
                          // Expanded(
                          //   flex: 0,
                          // child: SizedBox(
                          //   height: 100.sp,
                          //   width: 200.sp,
                          //   // color: Colors.yellow,
                          //   child: CachedImage(
                          //     url: widget.service.servicePhoto ?? '',
                          //     fit: BoxFit.cover,
                          //     width: MediaQuery.of(context).size.width - 40.w,
                          //   ),
                          // ),
                          // ),
                        ],
                      ),
                    ),
                  Divider(
                    color: (themeType != ThemeType.GentleTouch) ? theme.primaryColor : const Color(0XFF9F9F9F),
                    thickness: 1,
                  ),
                ],
              ),
              if (isHovered && !isPortrait)
                if (widget.service.servicePhoto != null && widget.service.servicePhoto != '')
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 50.w, top: 20.sp),
                      child: SizedBox(
                        // color: Colors.blue,
                        height: 230.h,
                        width: 220.sp,
                        child: CachedImage(
                          url: widget.service.servicePhoto ?? '',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width - 40.w,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
