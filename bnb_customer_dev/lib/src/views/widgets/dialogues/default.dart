import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_main_theme.dart';
import '../buttons.dart';
import '../widgets.dart';

class DefaultDialogue extends StatelessWidget {
  final Function onConfirm;
  final Function onSkip;
  final String svg;
  final String text;
  final String buttonText;
  final String skipText;
  final bool showSkipButton;
  const DefaultDialogue({Key? key, required this.onConfirm, required this.onSkip, required this.svg, required this.text, required this.buttonText, required this.skipText, required this.showSkipButton}) : super(key: key);

  final TextStyle _style = const TextStyle(fontFamily: "Montserrat", fontSize: 18, fontWeight: FontWeight.w400, color: AppTheme.lightBlack, height: 1.2);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svg,
            ),
            const Space(
              factor: 2,
            ),
            Text(text, textAlign: TextAlign.center, style: _style),
            const Space(
              factor: 3,
            ),
            SizedBox(
              width: 250,
              child: DefaultButton(
                onTap: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                label: buttonText,
                textColor: Colors.black,
                color: Colors.white, //Theme.of(context).primaryColor,
                height: 52,
              ),
            ),
            if (showSkipButton)
              const Space(
                factor: 1.5,
              ),
            if (showSkipButton)
              InkWell(
                onTap: () {
                  onSkip();
                  Navigator.of(context).pop();
                },
                child: Text(
                  skipText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
