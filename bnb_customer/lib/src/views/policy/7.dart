// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Content7 extends StatelessWidget {
  const Content7({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '\n\n7. HOW DO WE KEEP YOUR INFORMATION SAFE?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIn Short: We aim to protect your personal information through a system of organizational and technical security measures.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text:
                "\n\nWe have implemented appropriate and reasonable technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information. Although we will do our best to protect your personal information, transmission of personal information to and from our Services is at your own risk. You should only access the Services within a secure environment.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
