import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class Content13 extends StatelessWidget {
  const Content13({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(
              style: const TextStyle(
                  fontSize: 15.0,
                  fontFamily: "Arial",
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              children: [
            const TextSpan(
                text:
                    '\n\n13. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 17,
                  // color: Colors.blue[800],
                  // decoration: TextDecoration.underline
                )),
            const TextSpan(
                text:
                    "\n\nYou have the right to request access to the personal information we collect from you, change that information, or delete it. To request to review, update, or delete your personal information, please submit a request form by clicking here.This cookie policy was created using Termly's",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    html.window.open(
                        "https://termly.io/products/cookie-consent-%20manager/",
                        "_blank");
                  },
                text: " Cookie Consent Manager.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
          ]))
    ]);
  }
}
