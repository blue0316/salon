import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/currency/currency.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/utils/extensions/exstension.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceTile extends ConsumerStatefulWidget {
  final ServiceModel service;

  const ServiceTile({Key? key, required this.service}) : super(key: key);

  @override
  ConsumerState<ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends ConsumerState<ServiceTile> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  @override
  Widget build(BuildContext context) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider =
        ref.watch(salonProfileProvider);
    SalonModel salonModel = _salonProfileProvider.chosenSalon;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    ThemeType themeType = _salonProfileProvider.themeType;

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: MouseRegion(
          onEnter: (event) => onEntered(true),
          onExit: (event) => onEntered(false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          (themeType != ThemeType.GentleTouch)
                              ? '${widget.service.translations?[AppLocalizations.of(
                                        context,
                                      )?.localeName ?? 'en'] ?? widget.service.translations?['en']}'
                                  .toUpperCase()
                              : '${widget.service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? widget.service.translations?['en']}'
                                  .toTitleCase(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: serviceNameColor(themeType, theme),
                            fontSize: 20.sp,
                          ),
                        ),
                        if (_createAppointmentProvider.isAdded(
                          serviceModel: widget.service,
                        ))
                          SizedBox(
                              width: DeviceConstraints.getResponsiveSize(
                                  context, 5, 5, 30)),
                        Icon(
                          Icons.check,
                          size: 20.sp,
                          color: _createAppointmentProvider.isAdded(
                            serviceModel: widget.service,
                          )
                              ? serviceNameColor(themeType, theme)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.service.isFixedPrice
                        ? "${getCurrency(salonModel.countryCode!)}${widget.service.priceAndDuration!.price}"
                        : "${getCurrency(salonModel.countryCode!)}${widget.service.priceAndDuration!.price} - ${getCurrency(salonModel.countryCode!)}${widget.service.priceAndDurationMax!.price}",
                    // service.isFixedPrice ? "${service.priceAndDuration!.price}${Keys.uah}" : "${service.priceAndDuration!.price}${Keys.uah} - ${service.priceAndDurationMax!.price}${Keys.uah}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: priceColor(themeType,
                          theme), // (themeType == ThemeType.GentleTouch) ? Colors.black : Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (isHovered &&
                  (widget.service.description != null &&
                      widget.service.description != ''))
                Padding(
                  padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
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
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 0,
                        child: SizedBox(
                          height: 100.sp,
                          width: 200.sp,
                          // color: Colors.yellow,
                          child: CachedImage(
                            url: widget.service.servicePhoto ?? '',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width - 40.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Divider(
                color: (themeType != ThemeType.GentleTouch)
                    ? theme.primaryColor
                    : const Color(0XFF9F9F9F),
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color priceColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GentleTouch:
      return Colors.black;

    case ThemeType.CityMuseLight:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color serviceNameColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GentleTouch:
      return Colors.black;

    case ThemeType.CityMuseLight:
      return Colors.black;

    case ThemeType.GlamBarbershop:
      return Colors.white;

    case ThemeType.Barbershop:
      return Colors.white;

    default:
      return theme.primaryColor;
  }
}
