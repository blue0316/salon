import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Content12 extends StatelessWidget {
  const Content12({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: const TextSpan(
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "Arial",
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              children: [
            TextSpan(
                text: '\n\n12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 17,
                  // color: Colors.blue[800],
                  // decoration: TextDecoration.underline
                )),
            TextSpan(
                text:
                    "\n\nIf you have questions or comments about this notice, you may email us at contact@bowandbeautiful.com or by post to:\n\nBow and Beautiful LLC\nPirogovskoho Oleksandra St, Building 19 Corpus 6\nKyiv, Kyiv 03110\nUkraine",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
          ]))
    ]);
  }
}
