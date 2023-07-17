import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/cat_sub_service/services_model.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceTile extends ConsumerWidget {
  final ServiceModel service;

  const ServiceTile({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    ThemeType themeType = _salonProfileProvider.themeType;
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
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
                        (service.translations?[AppLocalizations.of(context)?.localeName ?? 'en'] ?? service.translations?['en']).toUpperCase(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: serviceNameColor(themeType, theme),
                          fontSize: 20.sp,
                        ),
                      ),
                      if (_createAppointmentProvider.isAdded(
                        serviceModel: service,
                      ))
                        SizedBox(width: DeviceConstraints.getResponsiveSize(context, 5, 5, 30)),
                      Icon(
                        Icons.check,
                        size: 20.sp,
                        color: _createAppointmentProvider.isAdded(
                          serviceModel: service,
                        )
                            ? serviceNameColor(themeType, theme)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                Text(
                  service.isFixedPrice ? "\$${service.priceAndDuration!.price}" : "\$${service.priceAndDuration!.price} - \$${service.priceAndDurationMax!.price}",
                  // service.isFixedPrice ? "${service.priceAndDuration!.price}${Keys.uah}" : "${service.priceAndDuration!.price}${Keys.uah} - ${service.priceAndDurationMax!.price}${Keys.uah}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: priceColor(themeType, theme), // (themeType == ThemeType.GlamLight) ? Colors.black : Colors.white,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(
              color: theme.primaryColor,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

Color priceColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamLight:
      return Colors.black;

    case ThemeType.GlamMinimalLight:
      return Colors.black;

    default:
      return Colors.white;
  }
}

Color serviceNameColor(ThemeType themeType, ThemeData theme) {
  switch (themeType) {
    case ThemeType.GlamLight:
      return Colors.black;

    case ThemeType.GlamMinimalLight:
      return Colors.black;

    case ThemeType.GlamBarbershop:
      return Colors.white;

    case ThemeType.Barbershop:
      return Colors.white;

    default:
      return theme.primaryColor;
  }
}
