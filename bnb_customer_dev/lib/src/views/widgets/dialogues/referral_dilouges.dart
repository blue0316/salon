import 'package:bbblient/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../buttons.dart';
import 'dialogue_function.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showSuccessDialog({required BuildContext context, required String message,onTap}) {
  showMyDialog(
    barrierDismissible: true,
      context: context,
      child: SizedBox(
        height: 250.h,
        width: 250.w,
        child: Stack(
          children: [
            Image.asset(
              AppIcons.congratsfGif,
              fit: BoxFit.cover,
              height: 250.h,
              width: 250.w,
            ),
            Positioned(
              bottom: 10,
              child: SizedBox(
                width: 250.w,
                height: 250.h,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BnbMaterialButton(
                            onTap: () {
                              Navigator.pop(context);
                              onTap();
                            },
                            title:AppLocalizations.of(context)?.okey ?? 'ok',
                            minWidth: 100),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ));
}

showErrorDialog({required BuildContext context, required String message}) {
  showMyDialog(
      context: context,
      child: SizedBox(
        height: 250.h,
        width: 250.w,
        child: Column(
          children: [
            Image.asset(
              AppIcons.errorGif,
              fit: BoxFit.cover,
              height: 100.h,
              width: 100.w,
            ),
            Expanded(
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BnbMaterialButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: 'Okey',
                    minWidth: 100),
              ],
            ),
          ],
        ),
      ));
}
