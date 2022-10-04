import 'package:flutter/material.dart';
import '../../../theme/app_main_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showMyDialog({
  Widget? child,
  required BuildContext context,
  bool? barrierDismissible
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible??false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppTheme.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        contentPadding: const EdgeInsets.all(AppTheme.margin * 2),
        content: SizedBox(width: 250.w, child: child),
      );
    },
  );
}
