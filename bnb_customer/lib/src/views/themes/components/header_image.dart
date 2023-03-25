import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/models/salon_master/salon.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:bbblient/src/views/themes/images.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeHeaderImage extends ConsumerWidget {
  const ThemeHeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    ThemeType themeType = _salonProfileProvider.themeType;

    return SizedBox(
      height: DeviceConstraints.getResponsiveSize(context, 1000.h, 1000.h, 1000.h),
      width: double.infinity,
      child: background(themeType, _salonProfileProvider.chosenSalon, _salonProfileProvider),
    );
  }
}

Widget background(ThemeType themeType, SalonModel salon, SalonProfileProvider salonProfileProvider) {
  switch (themeType) {
    case ThemeType.Barbershop:
      return const GradientBackground();

    case ThemeType.GlamMinimalDark:
      return const DefaultImageBG(image: ThemeImages.minimalBackground);

    case ThemeType.GlamMinimalLight:
      return const DefaultImageBG(image: ThemeImages.minimalBackground);

    default:
      return salon.profilePics.isNotEmpty
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
    final _salonProfileProvider = ref.watch(salonProfileProvider);

    return Container(
      // child: _salonProfileProvider.chosenSalon.profilePics.isNotEmpty
      //     ? FilteredImage(salonProfileProvider: _salonProfileProvider)
      //     : const DefaultImageBG(image: ThemeImages.gradientBG),

      child: Image.asset(
        (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.tab) ? ThemeImages.gradientBG : ThemeImages.longGradientBG,
        fit: BoxFit.cover,
      ),
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
  const FilteredImage({Key? key, required SalonProfileProvider salonProfileProvider})
      : _salonProfileProvider = salonProfileProvider,
        super(key: key);

  final SalonProfileProvider _salonProfileProvider;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
      child: CachedImage(
        url: _salonProfileProvider.chosenSalon.profilePics[0],
        fit: BoxFit.cover,
      ),
    );
  }
}
