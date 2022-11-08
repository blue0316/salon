import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:bbblient/src/views/policy/1.dart';
import 'package:bbblient/src/views/policy/10.dart';
import 'package:bbblient/src/views/policy/11.dart';
import 'package:bbblient/src/views/policy/12.dart';
import 'package:bbblient/src/views/policy/13.dart';
import 'package:bbblient/src/views/policy/2.dart';
import 'package:bbblient/src/views/policy/3.dart';
import 'package:bbblient/src/views/policy/4.dart';
import 'package:bbblient/src/views/policy/5.dart';
import 'package:bbblient/src/views/policy/6.dart';
import 'package:bbblient/src/views/policy/7.dart';
import 'package:bbblient/src/views/policy/8.dart';
import 'package:bbblient/src/views/policy/9.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class EasyWebDemo extends StatelessWidget {
  static const route = "/privacy";
  EasyWebDemo({Key? key}) : super(key: key);
  final table = GlobalKey(debugLabel: "table-content");
  final one = GlobalKey(debugLabel: "one");
  final two = GlobalKey(debugLabel: "two");
  final three = GlobalKey(debugLabel: "three");
  final four = GlobalKey(debugLabel: "four");
  final five = GlobalKey(debugLabel: "five");
  final six = GlobalKey(debugLabel: "six");
  final seven = GlobalKey(debugLabel: "seven");
  final eight = GlobalKey(debugLabel: "eight");
  final nine = GlobalKey(debugLabel: "nine");
  final ten = GlobalKey(debugLabel: "ten");
  final eleven = GlobalKey(debugLabel: "eleven");
  final twelve = GlobalKey(debugLabel: "twelve");
  final thirteen = GlobalKey(debugLabel: "thirteen");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 10,
          right: MediaQuery.of(context).size.width / 10,
          bottom: 10,
          top: 50),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PRIVACY NOTICE",
            style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppTheme.black2,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                    text: "This privacy notice for Bow and Beautiful LLC "),
                TextSpan(
                    text:
                        '("Company," "we," "us," or "our"), describes how and why we might collect, store, use, and/or share ("process") your information when you use our services ("Services"), such as when you:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // TextSpan(text: tr(Keys.to)),
                // TextSpan(
                //     text: ' $_endTime',
                //     style:
                //         TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 16.0,
                  color: AppTheme.black2,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                const TextSpan(
                    // onEnter: (enter) {

                    //   // _controller.animateTo(
                    //   //   200,
                    //   //   duration: Duration(seconds: 1),
                    //   //   curve: Curves.fastOutSlowIn,
                    //   // );
                    // },
                    text: "     •   Visit our website at ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        html.window
                            .open("https://bowandbeautiful.com", "_blank");
                      },
                    text: 'https://www.bowandbeautiful.com',
                    style: TextStyle(
                        fontFamily: "Arial",
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text:
                        ", or any website of ours that links to this privacy notice\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(
                    text:
                        '     •   Download and use our mobile application (bnb for Partners), or any other application of ours that links to this privacy notice\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(
                    text:
                        '     •   Engage with us in other related ways, including any sales, marketing, or events\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // TextSpan(text: tr(Keys.to)),
                // TextSpan(
                //     text: ' $_endTime',
                //     style:
                //         TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Text(
            "Questions or concerns? Reading this privacy notice will help you understand your privacy rights and choices. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at tarun@bowandbeautiful.com.",
            style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 16,
                color: const Color.fromARGB(255, 144, 143, 143),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          Text(
            "SUMMARY OF KEY POINTS",
            style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 15.0,
                  fontFamily: "Arial",
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                const TextSpan(
                    text:
                        "This summary provides key points from our privacy notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for.",
                    style: TextStyle(
                      fontFamily: "Arial",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(table.currentContext!);
                      },
                    text:
                        ' You can also click here to go directly to our table of contents.',
                    style: TextStyle(
                        fontFamily: "Arial",
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(table.currentContext!);
                      },
                    text:
                        '\n\nWhat personal information do we process? When you visit, use, or navigate our Services, we may process personal information depending on how you interact with Bow and Beautiful LLC and the Services, the choices you make, and the products and features you use. Click here to learn more.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text:
                        '\n\nDo we process any sensitive personal information? We do not process sensitive personal information.\n\nDo we receive any information from third parties? We do not receive any information from third parties.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    )),
                const TextSpan(
                    text:
                        '\n\nHow do we process your information? We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent. We process your information only when we have a valid legal reason to do so.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(two.currentContext!);
                      },
                    text: ' Click here to learn more.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text:
                        '\n\nIn what situations and with which parties do we share personal information? We may share information in specific situations and with specific third parties.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                      // color: Colors.blue[800],
                      // decoration: TextDecoration.underline
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(four.currentContext!);
                      },
                    text: ' Click here to learn more.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text:
                        '\n\nHow do we keep your information safe? We have organizational and technical processes and procedures in place to protect your personal information. However, no electronic transmission over the internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                      // color: Colors.blue[800],
                      // decoration: TextDecoration.underline
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(seven.currentContext!);
                      },
                    text: ' Click here to learn more.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text:
                        '\n\nWhat are your rights? Depending on where you are located geographically, the applicable privacy law may mean you have certain rights regarding your personal information.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic,
                      // color: Colors.blue[800],
                      // decoration: TextDecoration.underline
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(eight.currentContext!);
                      },
                    text: ' Click here to learn more.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(eight.currentContext!);
                      },
                    text:
                        '\n\nHow do you exercise your rights? The easiest way to exercise your rights is by filling out our data subject request form available here, ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text:
                        '\n\nor by contacting us. We will consider and act upon any request in accordance with applicable data protection laws.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // color: Colors.blue[800],
                      // decoration: TextDecoration.underline
                    )),
                const TextSpan(
                    text:
                        '\n\nWant to learn more about what Bow and Beautiful LLC does with any information we collect? Click',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // color: Colors.blue[800],
                      // decoration: TextDecoration.underline
                    )),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(table.currentContext!);
                      },
                    text: ' here ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                const TextSpan(
                    text: 'to review the notice in full.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // color: Colors.blue[800],
                      // decoration: TextDecoration.underline
                    )),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: "Arial",
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  children: [
                WidgetSpan(
                  child: SizedBox.fromSize(
                    size: Size.zero,
                    key: table,
                  ),
                ),
                TextSpan(
                  text: "TABLE OF CONTENTS",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(one.currentContext!);
                      },
                    text: '\n\n1. WHAT INFORMATION DO WE COLLECT?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(two.currentContext!);
                      },
                    text: '\n\n2. HOW DO WE PROCESS YOUR INFORMATION?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(three.currentContext!);
                      },
                    text:
                        '\n\n3. WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR PERSONAL INFORMATION?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(four.currentContext!);
                      },
                    text:
                        '\n\n4. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(five.currentContext!);
                      },
                    text:
                        '\n\n5. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(six.currentContext!);
                      },
                    text: '\n\n6. HOW LONG DO WE KEEP YOUR INFORMATION?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(seven.currentContext!);
                      },
                    text: '\n\n7. HOW DO WE KEEP YOUR INFORMATION SAFE?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(eight.currentContext!);
                      },
                    text: '\n\n8. WHAT ARE YOUR PRIVACY RIGHTS?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(nine.currentContext!);
                      },
                    text: '\n\n9. CONTROLS FOR DO-NOT-TRACK FEATURES',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
              ])),
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: "Arial",
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(ten.currentContext!);
                      },
                    text:
                        '\n\n10. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(eleven.currentContext!);
                      },
                    text: '\n\n11. DO WE MAKE UPDATES TO THIS NOTICE?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(twelve.currentContext!);
                      },
                    text: '\n\n12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scrollable.ensureVisible(thirteen.currentContext!);
                      },
                    text:
                        '\n\n13. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[800],
                        decoration: TextDecoration.underline)),

                // for sectioning
              ])),
          SizedBox.fromSize(
            size: Size.zero,
            key: one,
          ),
          const Content1(),
          SizedBox.fromSize(
            size: Size.zero,
            key: two,
          ),
          const Content2(),
          SizedBox.fromSize(
            size: Size.zero,
            key: three,
          ),
          const Content3(),
          SizedBox.fromSize(
            size: Size.zero,
            key: four,
          ),
          const Content4(),
          SizedBox.fromSize(
            size: Size.zero,
            key: five,
          ),
          const Content5(),
          SizedBox.fromSize(
            size: Size.zero,
            key: six,
          ),
          const Content6(),
          SizedBox.fromSize(
            size: Size.zero,
            key: seven,
          ),
          const Content7(),
          SizedBox.fromSize(
            size: Size.zero,
            key: eight,
          ),
          Content8(
            eleven: eleven,
          ),
          SizedBox.fromSize(
            size: Size.zero,
            key: nine,
          ),
          const Content9(),
          SizedBox.fromSize(
            size: Size.zero,
            key: ten,
          ),
          const Content10(),
          SizedBox.fromSize(
            size: Size.zero,
            key: eleven,
          ),
          const Content11(),
          SizedBox.fromSize(
            size: Size.zero,
            key: twelve,
          ),
          const Content12(),
          SizedBox.fromSize(
            size: Size.zero,
            key: thirteen,
          ),
          const Content13(),
        ],
      ),
    )));
  }
}
