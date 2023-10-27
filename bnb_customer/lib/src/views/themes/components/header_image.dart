import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/header_height.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeHeaderImage extends ConsumerWidget {
  const ThemeHeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return SizedBox(
      height: getThemeHeaderHeight(context,
          themeType), // DeviceConstraints.getResponsiveSize(context, 1000.h, 1000.h, 1000.h),
      width: double.infinity,
      child: background(
          themeType, _salonProfileProvider.chosenSalon, _salonProfileProvider),
    );
  }
}

Widget background(ThemeType themeType, SalonModel salon,
    SalonProfileProvider salonProfileProvider) {
  switch (themeType) {
    case ThemeType.Barbershop:
      return const GradientBackground();

    case ThemeType.CityMuseDark:
      return const FilteredAssetImage(
        image: ThemeImages.minimalBackground,
        opacity: 0.5,
      );

    case ThemeType.CityMuseLight:
      return const DefaultImageBG(image: ThemeImages.minimalBackground);

    case ThemeType.GentleTouch:
      return (salonProfileProvider.themeSettings?.backgroundImage != null &&
              salonProfileProvider.themeSettings?.backgroundImage != '')
          ? BackgroundImageExists(
              salonProfileProvider: salonProfileProvider,
            )
          : const DefaultImageBG(image: ThemeImages.glamLightNaturalHue);

    case ThemeType.GentleTouchDark:
      return (salonProfileProvider.themeSettings?.backgroundImage != null &&
              salonProfileProvider.themeSettings?.backgroundImage != '')
          ? BackgroundImageExists(
              salonProfileProvider: salonProfileProvider,
            )
          : const FilteredAssetImage(image: ThemeImages.darkGentleTouch);

    default:
      return (salonProfileProvider.themeSettings?.backgroundImage != null &&
              salonProfileProvider.themeSettings?.backgroundImage != '')
          ? FilteredImage(
              salonProfileProvider: salonProfileProvider,
            )
          : const DefaultImageBG(image: ThemeImages.longBG);
  }
}

class GradientBackground extends ConsumerWidget {
  const GradientBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.asset(
      (DeviceConstraints.getDeviceType(MediaQuery.of(context)) ==
              DeviceScreenType.tab)
          ? ThemeImages.gradientBG
          : ThemeImages.longGradientBG,
      fit: BoxFit.cover,
    );
  }
}

class DefaultImageBG extends StatelessWidget {
  final String image;
  const DefaultImageBG({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(image, fit: BoxFit.cover);
  }
}

class FilteredImage extends StatelessWidget {
  const FilteredImage(
      {Key? key, required SalonProfileProvider salonProfileProvider})
      : _salonProfileProvider = salonProfileProvider,
        super(key: key);

  final SalonProfileProvider _salonProfileProvider;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
      child: CachedImage(
        url: _salonProfileProvider.themeSettings!.backgroundImage!,
        fit: BoxFit.cover,
      ),
    );
  }
}

class FilteredAssetImage extends StatelessWidget {
  final String image;
  final double? opacity;

  const FilteredAssetImage({Key? key, required this.image, this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(opacity ?? 0.3), BlendMode.dstATop),
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }
}

class BackgroundImageExists extends StatelessWidget {
  const BackgroundImageExists(
      {Key? key, required SalonProfileProvider salonProfileProvider})
      : _salonProfileProvider = salonProfileProvider,
        super(key: key);

  final SalonProfileProvider _salonProfileProvider;

  @override
  Widget build(BuildContext context) {
    return CachedImage(
      url: _salonProfileProvider.themeSettings!.backgroundImage!,
      fit: BoxFit.cover,
    );
  }
}
