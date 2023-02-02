import 'package:flutter/material.dart';

class Content11 extends StatelessWidget {
  const Content11({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: const TextSpan(style: TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(
            text: '\n\n11. DO WE MAKE UPDATES TO THIS NOTICE?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 17,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        TextSpan(
            text:
                '\n\nIn Short: Yes, we will update this notice as necessary to stay compliant with relevant laws.\n\nWe may update this privacy notice from time to time. The updated version will be indicated by an updated "Revised" date and the updated version will be effective as soon as it is accessible. If we make material changes to this privacy notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this privacy notice frequently to be informed of how we are protecting your information.',
            style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
