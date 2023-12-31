// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/utils/device_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends ConsumerWidget {
  final String? label;
  final Function? onTap;
  final bool isLoading;
  final Color? color, textColor, borderColor, loaderColor;
  final double height;
  final double? width;
  final double? borderRadius, fontSize;
  final Widget? prefixIcon, suffixIcon;
  final FontWeight? fontWeight;
  final bool noBorder;

  const DefaultButton({
    Key? key,
    this.label,
    this.onTap,
    this.isLoading = false,
    this.color,
    this.height = 60,
    this.width = 60,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.loaderColor,
    this.fontWeight,
    this.noBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          side: noBorder ? BorderSide.none : BorderSide(color: borderColor ?? color ?? Colors.black),
        ),
        height: height,
        // size.width - 94,
        minWidth: width ?? double.infinity,
        color: color ?? AppTheme.lightBlack,
        onPressed: onTap as void Function()?,
        child: isLoading
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: loaderColor),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null)
                    Padding(
                      padding: EdgeInsets.only(right: 10.sp),
                      child: prefixIcon!,
                    ),
                  Text(
                    label ?? "Sign up",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      fontSize: fontSize ?? 20.sp,
                      fontFamily: 'Inter-Medium',
                    ),
                  ),
                  if (suffixIcon != null)
                    Padding(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: suffixIcon!,
                    ),
                ],
              ),
      ),
    );
  }
}

class DropDownObject extends StatefulWidget {
  final List<Object>? list;
  final preSelected;
  final Function? onChanged;
  final Function? child;

  const DropDownObject({Key? key, this.list, this.preSelected, this.onChanged, this.child}) : super(key: key);

  @override
  _DropDownObjectState createState() => _DropDownObjectState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropDownObjectState extends State<DropDownObject> {
  var dropdownValue;

  @override
  void initState() {
    super.initState();
    _assignInitialValue();
  }

  _assignInitialValue() {
    if (widget.preSelected == null) {
      dropdownValue = widget.list!.first;
    } else {
      dropdownValue = widget.preSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Object>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      underline: Container(
        color: Theme.of(context).primaryColor,
        height: 1,
      ),
      onChanged: (Object? val) {
        setState(() {
          dropdownValue = val;
        });
        if (widget.onChanged != null) widget.onChanged!(val);
      },
      items: widget.list!.map<DropdownMenuItem<Object>>((Object value) {
        return DropdownMenuItem<Object>(
          value: value,
          child: widget.child!(value),
        );
      }).toList(),
    );
  }
}

class BnbMaterialButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final double? minWidth;
  final EdgeInsets? padding;
  const BnbMaterialButton({Key? key, required this.onTap, required this.title, required this.minWidth, this.padding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      onPressed: onTap as void Function()?,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppTheme.creamBrown,
      minWidth: minWidth,
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

class BnbCheckCircle extends StatefulWidget {
  final bool value;
  const BnbCheckCircle({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _BnbCheckCircleState createState() => _BnbCheckCircleState();
}

class _BnbCheckCircleState extends State<BnbCheckCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      width: 24.h,
      decoration: BoxDecoration(
          border: Border.all(
            color: widget.value ? AppTheme.textBlack : AppTheme.coolGrey,
          ),
          shape: BoxShape.circle,
          color: widget.value ? AppTheme.textBlack : Colors.transparent),
      child: Icon(
        Icons.check_rounded,
        color: widget.value ? Colors.white : Colors.transparent,
        size: 18,
      ),
    );
  }
}

class ServicesBnbCheckCircle extends ConsumerStatefulWidget {
  final bool value;

  const ServicesBnbCheckCircle({Key? key, required this.value}) : super(key: key);

  @override
  _ServicesBnbCheckCircleState createState() => _ServicesBnbCheckCircleState();
}

class _ServicesBnbCheckCircleState extends ConsumerState<ServicesBnbCheckCircle> {
  @override
  Widget build(BuildContext context) {
    final _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;
    bool isLightTheme = (theme == AppTheme.customLightTheme);

    return Container(
      height: DeviceConstraints.getResponsiveSize(context, 25.h, 35.h, 35.h),
      width: DeviceConstraints.getResponsiveSize(context, 25.h, 35.h, 35.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.value ? AppTheme.textBlack : Colors.white,
      ),
      child: Center(
        child: Icon(
          Icons.add_rounded,
          color: widget.value
              ? isLightTheme
                  ? Colors.white
                  : theme.primaryColor
              : Colors.black,
          size: DeviceConstraints.getResponsiveSize(context, 18.h, 28.h, 28.h),
        ),
      ),
    );
  }
}

class BackButtonGlassMorphic extends StatelessWidget {
  const BackButtonGlassMorphic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        height: DeviceConstraints.getResponsiveSize(context, 32, 40, 48),
        width: DeviceConstraints.getResponsiveSize(context, 32, 40, 48),
        decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(DeviceConstraints.getResponsiveSize(context, 4, 6, 8)),
          child: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}

class LandingButton extends ConsumerWidget {
  final String? label;
  final Function? onTap;
  final Color? color, textColor, borderColor;
  final double height;
  final double? width;
  final double? borderRadius, fontSize;
  final FontWeight? fontWeight;

  const LandingButton({
    Key? key,
    this.label,
    this.onTap,
    this.color,
    this.height = 60,
    this.width = 60,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.borderColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label ?? "",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  fontSize: fontSize ?? 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
