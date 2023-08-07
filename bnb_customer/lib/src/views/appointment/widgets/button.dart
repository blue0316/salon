import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/models/enums/device_screen_type.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends ConsumerWidget {
  final String text;
  final VoidCallback onTap;
  final Color? buttonColor, textColor, loaderColor, borderColor;
  final bool isLoading;

  const Button({
    Key? key,
    required this.text,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.isLoading = false,
    this.loaderColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPortrait = (DeviceConstraints.getDeviceType(MediaQuery.of(context)) == DeviceScreenType.portrait);

    final _appointmentProvider = ref.watch(appointmentProvider);
    ThemeData theme = _appointmentProvider.salonTheme ?? AppTheme.customLightTheme;

    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: !isPortrait ? 300 : double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(
              color: borderColor ?? Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(color: loaderColor ?? Colors.white),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: (textColor != null)
                              ? textColor
                              : isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
