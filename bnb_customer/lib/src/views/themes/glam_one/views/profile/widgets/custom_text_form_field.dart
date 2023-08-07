import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/controller/salon/salon_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class CustomTextFormField extends ConsumerWidget {
  CustomTextFormField({
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.validator,
    this.contentPadding,
  });

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;
  double? contentPadding;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SalonProfileProvider _salonProfileProvider = ref.watch(salonProfileProvider);
    final ThemeData theme = _salonProfileProvider.salonTheme;

    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(theme),
          )
        : _buildTextFormFieldWidget(theme);
  }

  _buildTextFormFieldWidget(ThemeData theme) {
    return Container(
      // width: (width ?? 0),
      margin: margin,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: theme.inputDecorationTheme.labelStyle, // _setFontStyle(theme),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(theme),
        validator: validator,
      ),
    );
  }

  _buildDecoration(ThemeData theme) {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: theme.inputDecorationTheme.hintStyle, // _setFontStyle(theme),
      border: theme.inputDecorationTheme.border, //  _setBorderStyle(),
      enabledBorder: theme.inputDecorationTheme.enabledBorder, // _setBorderStyle(),
      focusedBorder: theme.inputDecorationTheme.focusedBorder, // _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      filled: _setFilled(),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: contentPadding ?? 15, horizontal: contentPadding ?? 15),
    );
  }

  _setFontStyle(ThemeData theme) {
    switch (fontStyle) {
      default:
        return TextStyle(
          color: ColorConstant.blueGray900,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(23.00);
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.black900,
            width: 1,
          ),
        );
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBlack900:
        return false;
      case TextFormFieldVariant.None:
        return false;
      default:
        return false;
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder23,
}

enum TextFormFieldPadding {
  PaddingAll13,
}

enum TextFormFieldVariant {
  None,
  OutlineBlack900,
}

enum TextFormFieldFontStyle {
  PoppinsMedium14,
}
