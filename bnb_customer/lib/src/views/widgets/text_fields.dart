import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const CustomTextField({
    Key? key,
    this.suffixIcon,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.onChange,
    this.keyBoardType,
    this.maxLength,
    this.borderColor,
    this.padding,
  }) : super(key: key);
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
        contentPadding: padding,
        counterText: '',
        suffixIcon: suffixIcon,
        hintText: hintText,
        errorText: errorText,
        focusColor: AppTheme.lightBlack,
        focusedBorder: _border,
        border: _border,
        enabledBorder: _border,
        disabledBorder: _border,
      ),
    );
  }
}

class BNBTextField extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? textColor, obscureColor, borderColor;
  final double? textSize, vPadding;
  final InputBorder? border;
  final bool obscure;
  final TextInputAction? action;
  final Function(String)? submit, onChanged;
  final String? errorText;
  final Iterable<String>? autofillHints;
  final double? borderWidth;
  final TextInputType? keyboardType;
  final int? lines;

  const BNBTextField({
    Key? key,
    required this.hint,
    this.controller,
    this.fillColor,
    this.textColor,
    this.textSize,
    this.obscureColor,
    this.borderColor,
    this.obscure = false,
    this.action,
    this.submit,
    this.errorText,
    this.autofillHints,
    this.borderWidth,
    this.keyboardType,
    this.vPadding,
    this.lines,
    this.onChanged,
    this.border,
  }) : super(key: key);

  @override
  State<BNBTextField> createState() => _BNBTextFieldState();
}

class _BNBTextFieldState extends State<BNBTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofillHints: widget.autofillHints,
      style: Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(
            color: widget.textColor ?? AppTheme.textBlack,
            fontSize: widget.textSize ?? 15.sp,
            fontWeight: FontWeight.w600,
          ),
      textInputAction: widget.action ?? TextInputAction.next,
      onFieldSubmitted: widget.submit,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      maxLines: widget.lines ?? 1,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
              color: widget.textColor ?? AppTheme.lightBlack,
              fontSize: widget.textSize ?? 15.sp,
            ),
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.vPadding ?? 12.h,
          horizontal: widget.vPadding ?? 10.w,
        ),
        fillColor: widget.fillColor,
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.black,
                width: widget.borderWidth ?? 1,
              ),
            ),
        enabledBorder: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.black,
                width: widget.borderWidth ?? 1,
              ),
            ),
        focusedBorder: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: widget.borderColor ?? Colors.black,
                width: widget.borderWidth ?? 1,
              ),
            ),
        errorMaxLines: 1,
        errorStyle: const TextStyle(fontSize: 0),
      ),
      onChanged: widget.onChanged,
    );
  }
}
