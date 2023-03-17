import 'package:flutter/material.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    this.padding,
    this.shape,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.margin,
    this.onTap,
    this.width,
    this.height,
    this.text,
    this.prefixWidget,
    this.suffixWidget,
  });

  ButtonPadding? padding;

  ButtonShape? shape;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;

  double? height;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        (width ?? 0),
        (height ?? 0),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      default:
        return EdgeInsets.all(15);
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.OutlineWhiteA700_1:
        return ColorConstant.black90033;
      case ButtonVariant.FillOrange200:
        return ColorConstant.orange200;
      case ButtonVariant.FillDeeporange300:
        return ColorConstant.deepOrange300;
      default:
        return null;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineWhiteA700_1:
        return BorderSide(
          color: ColorConstant.whiteA700,
          width: 1.00,
        );
      case ButtonVariant.FillOrange200:
      case ButtonVariant.FillDeeporange300:
        return null;
      default:
        return BorderSide(
          color: ColorConstant.whiteA700,
          width: 1.00,
        );
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(25.00);
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.PoppinsSemibold16:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        );
      default:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
    }
  }
}

enum ButtonPadding {
  PaddingAll15,
}

enum ButtonShape {
  Square,
  RoundedBorder25,
}

enum ButtonVariant {
  OutlineWhiteA700,
  OutlineWhiteA700_1,
  FillOrange200,
  FillDeeporange300,
}

enum ButtonFontStyle {
  PoppinsMedium16,
  PoppinsSemibold16,
}
