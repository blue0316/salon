// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Content9 extends StatelessWidget {
  const Content9({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: const TextSpan(style: TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(
            text: '\n\n9. CONTROLS FOR DO-NOT-TRACK FEATURES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 17,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        TextSpan(
            text:
                '\n\nMost web browsers and some mobile operating systems and mobile applications include a Do-Not-Track ("DNT") feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this privacy notice.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // fontStyle: FontStyle.italic,
                // color: Colors.blue[800],
                decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
