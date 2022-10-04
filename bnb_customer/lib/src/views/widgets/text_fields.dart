import 'package:flutter/material.dart';

import '../../theme/app_main_theme.dart';

class CustomTextField extends StatelessWidget {
  final Widget? suffixIcon;
  final bool obscureText;
  final String? hintText;
  final String? errorText;
  final Function? onChange;
  final TextInputType? keyBoardType;
  final int? maxLength;
  final Color? borderColor;
  final EdgeInsets? padding;
  const CustomTextField(
      {Key? key,
      this.suffixIcon,
      this.obscureText = false,
      this.hintText,
      this.errorText,
      this.onChange,
      this.keyBoardType,
      this.maxLength,
      this.borderColor,
      this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UnderlineInputBorder _border = UnderlineInputBorder(
        borderSide: BorderSide(
      color: borderColor ?? AppTheme.lightBlack,
    ));
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChange as void Function(String)?,
      keyboardType: keyBoardType,
      maxLength: maxLength,
      decoration: InputDecoration(
          contentPadding: padding ?? null,
          counterText: '',
          suffixIcon: suffixIcon,
          hintText: hintText,
          errorText: errorText,
          focusColor: AppTheme.lightBlack,
          focusedBorder: _border,
          border: _border,
          enabledBorder: _border,
          disabledBorder: _border),
    );
  }
}
