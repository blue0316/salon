import 'package:flutter/material.dart';
import 'package:bbblient/src/views/themes/glam_one/core/utils/color_constant.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({this.shape, this.padding, this.variant, this.alignment, this.margin, this.width, this.height, this.child, this.onTap});

  IconButtonShape? shape;

  IconButtonPadding? padding;

  IconButtonVariant? variant;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  double? width;

  double? height;

  Widget? child;

  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildIconButtonWidget(),
          )
        : _buildIconButtonWidget();
  }

  _buildIconButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: IconButton(
        iconSize: (height ?? 0),
        padding: EdgeInsets.all(0),
        icon: Container(
          alignment: Alignment.center,
          width: (width ?? 0),
          height: (height ?? 0),
          padding: _setPadding(),
          decoration: _buildDecoration(),
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }

  _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      borderRadius: _setBorderRadius(),
    );
  }

  _setPadding() {
    switch (padding) {
      case IconButtonPadding.PaddingAll9:
        return EdgeInsets.all(9);

      default:
        return EdgeInsets.all(15);
    }
  }

  _setColor() {
    switch (variant) {
      default:
        return ColorConstant.black900E5;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(19.00);
    }
  }
}

enum IconButtonShape {
  CircleBorder19,
}

enum IconButtonPadding {
  PaddingAll15,
  PaddingAll9,
}

enum IconButtonVariant {
  FillBlack900e5,
}
