// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Content6 extends StatelessWidget {
  const Content6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '\n\n6. HOW LONG DO WE KEEP YOUR INFORMATION?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIn Short: We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text: "\n\nWe will only keep your personal information for as long as it is necessary for the purposes set out in this privacy notice, unless a longer retention period is required or permitted by law (such as tax, accounting, or other legal requirements). No purpose in this notice will require us keeping your personal information for longer than the period of time in which users have an account with us.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text: "\n\nWhen we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
