import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Content5 extends StatelessWidget {
  const Content5({Key? key}) : super(key: key);

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
            TextSpan(
                text:
                    '\n\n5. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    "\n\nIn Short: We may use cookies and other tracking technologies to collect and store your information.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    "\n\nWe may use cookies and similar tracking technologies (like web beacons and pixels) to access or store information. Specific information about how we use such technologies and how you can refuse certain cookies is set out in our Cookie Notice.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
          ]))
    ]);
  }
}
