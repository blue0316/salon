import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_main_theme.dart';
import '../../../utils/icons.dart';
import '../buttons.dart';
import '../widgets.dart';

class LogOutDialogue extends StatelessWidget {
  final Function? onConfirm;
  final Function? onSkip;
  final String? svg;
  final String? text;
  final String? buttonText;
  final String? skipText;

  const LogOutDialogue({
    Key? key,
    this.onConfirm,
    this.onSkip,
    this.svg,
    this.text,
    this.buttonText,
    this.skipText,
  }) : super(key: key);

  final TextStyle _style =
      const TextStyle(fontFamily: "Montserrat", fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textBlack);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svg ?? AppIcons.askLocation,
          ),
          const Space(
            factor: 2,
          ),
          Text(text ?? "Are you sure you\nwant to Log Out?", textAlign: TextAlign.center, style: _style),
          const Space(
            factor: 4,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onSkip != null) onSkip!();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    skipText ?? "Cancel",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              const SpaceHorizontal(),
              Expanded(
                child: DefaultButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) onConfirm!();
                  },
                  label: buttonText ?? "Logout",
                  color: Theme.of(context).primaryColor,
                  height: 52,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
