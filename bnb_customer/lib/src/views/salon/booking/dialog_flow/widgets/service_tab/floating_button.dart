import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/views/salon/booking/dialog_flow/widgets/colors.dart';
import 'package:bbblient/src/views/themes/utils/theme_type.dart';
import 'package:bbblient/src/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingButton extends ConsumerWidget {
  final VoidCallback onTap;
  const FloatingButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);

    final _createAppointmentProvider = ref.watch(createAppointmentProvider);
    int noOfServices = _createAppointmentProvider.chosenServices.length;

    final ThemeData theme = _salonProfileProvider.salonTheme;
    // bool defaultTheme = (theme == AppTheme.customLightTheme);
    ThemeType themeType = _salonProfileProvider.themeType;

    return noOfServices != 0
        ? Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: DefaultButton(
                borderRadius: 60,
                onTap: onTap,
                color: dialogButtonColor(themeType, theme), // theme.dialogBackgroundColor, // defaultTheme ? Colors.black : theme.primaryColor,
                textColor: loaderColor(themeType), // theme.colorScheme.tertiary, // defaultTheme ? Colors.white : Colors.black,
                borderColor: theme.primaryColor,

                height: 60,
                label: '${AppLocalizations.of(context)?.book ?? 'Book'} $noOfServices ${AppLocalizations.of(context)?.services ?? 'Services'}',
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
