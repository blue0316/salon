// import 'package:easy_web_view/easy_web_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PrivacyPolicy extends ConsumerStatefulWidget {
//   static const route = "/privacy-policy";
//   const PrivacyPolicy({Key? key}) : super(key: key);

//   @override
//   _PrivacyPolicyState createState() => _PrivacyPolicyState();
// }

// class _PrivacyPolicyState extends ConsumerState<PrivacyPolicy> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: EasyWebView(
//         onLoaded: (jj) {},
//         src: htmlContent,
// // isHtml: true,
//         isMarkdown: false,
//         width: 300,
//         height: 300,
//       ),
//     );
//   }
// }

// String get htmlContent => """
// <!DOCTYPE html>
// <html>
// <head>
// <meta charset=”UTF-8">
// <meta content=”IE=Edge” http-equiv=”X-UA-Compatible”>
// </head>
// <body>
// <! — Add your custom html here →
// </body>
// </html>
// """;

import 'package:bbblient/src/theme/app_main_theme.dart';
import 'package:flutter/cupertino.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
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
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
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
                              text:
                                  "This privacy notice for Bow and Beautiful LLC "),
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
                                  html.window.open(
                                      "https://bowandbeautiful.com", "_blank");
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
                          TextSpan(
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
                          color: Color.fromARGB(255, 144, 143, 143),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40,
                    ),
                    Text(
                      "SUMMARY OF KEY POINTS",
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
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
                                  // if (controllers.hasClients) {
                                  //   if (constraints.minWidth > 1200) {
                                  //     controllers.animateTo(
                                  //       700,
                                  //       duration: Duration(seconds: 1),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   } else if (constraints.maxWidth > 800 &&
                                  //       constraints.maxWidth < 1200) {
                                  //     controllers.animateTo(
                                  //       500,
                                  //       duration: Duration(seconds: 1),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   } else {
                                  //     controllers.animateTo(
                                  //       1600,
                                  //       duration: Duration(seconds: 1),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   }
                                  // }
                                  Scrollable.ensureVisible(
                                      table.currentContext!);
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
                                  // if (controllers.hasClients) {
                                  //   if (constraints.minWidth > 1200) {
                                  //     controllers.animateTo(
                                  //       700,
                                  //       duration: Duration(seconds: 1),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   } else if (constraints.maxWidth > 800 &&
                                  //       constraints.maxWidth < 1200) {
                                  //     controllers.animateTo(
                                  //       500,
                                  //       duration: Duration(seconds: 1),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   } else {
                                  //     controllers.animateTo(
                                  //       1600,
                                  //       duration: Duration(seconds: 1),
                                  //       curve: Curves.fastOutSlowIn,
                                  //     );
                                  //   }
                                  // }
                                  Scrollable.ensureVisible(
                                      table.currentContext!);
                                },
                              text:
                                  '\n\nWhat personal information do we process? When you visit, use, or navigate our Services, we may process personal information depending on how you interact with Bow and Beautiful LLC and the Services, the choices you make, and the products and features you use. Click here to learn more.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          // TextSpan(text: tr(Keys.to)),
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
                                // fontStyle: FontStyle.italic,
                                // color: Colors.blue[800],
                                // decoration: TextDecoration.underline
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
                                  Scrollable.ensureVisible(
                                      four.currentContext!);
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
                                  Scrollable.ensureVisible(
                                      seven.currentContext!);
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
                                  Scrollable.ensureVisible(
                                      eight.currentContext!);
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
                                  Scrollable.ensureVisible(
                                      eight.currentContext!);
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
                                  Scrollable.ensureVisible(
                                      table.currentContext!);
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
                    Column(
                      children: [
                        RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "Arial",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                children: <InlineSpan>[
                              // for sectioning
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: table,
                                ),
                              ),
                              TextSpan(
                                text: "TABLE OF CONTENTS",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          one.currentContext!);
                                    },
                                  text: '1. WHAT INFORMATION DO WE COLLECT?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          two.currentContext!);
                                    },
                                  text:
                                      '\n2. HOW DO WE PROCESS YOUR INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          three.currentContext!);
                                    },
                                  text:
                                      '\n3. WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR PERSONAL INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          four.currentContext!);
                                    },
                                  text:
                                      '\n4. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          five.currentContext!);
                                    },
                                  text:
                                      '\n5. DO WE USE COOKIES AND OTHER TRACKING TECHNOLOGIES?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          six.currentContext!);
                                    },
                                  text:
                                      '\n6. HOW LONG DO WE KEEP YOUR INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          seven.currentContext!);
                                    },
                                  text:
                                      '\n7. HOW DO WE KEEP YOUR INFORMATION SAFE?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          eight.currentContext!);
                                    },
                                  text: '\n8. WHAT ARE YOUR PRIVACY RIGHTS?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          nine.currentContext!);
                                    },
                                  text:
                                      '\n9. CONTROLS FOR DO-NOT-TRACK FEATURES',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          ten.currentContext!);
                                    },
                                  text:
                                      '\n10. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          eleven.currentContext!);
                                    },
                                  text:
                                      '\n11. DO WE MAKE UPDATES TO THIS NOTICE?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          twelve.currentContext!);
                                    },
                                  text:
                                      '\n12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          thirteen.currentContext!);
                                    },
                                  text:
                                      '\n13. HOW CAN YOU REVIEW, UPDATE, OR DELETE THE DATA WE COLLECT FROM YOU?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),

                              // for sectioning
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: one,
                                ),
                              ),
                              TextSpan(
                                  text: '1. WHAT INFORMATION DO WE COLLECT?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nPersonal information you disclose to us\n\nIn Short: We collect personal information that you provide to us.\n\nWe collect personal information that you voluntarily provide to us when you register on the Services, express an interest in obtaining information about us or our products and Services, when you participate in activities on the Services, or otherwise when you contact us.\n\nPersonal Information Provided by You. The personal information that we collect depends on the context of your interactions with us and the Services, the choices you make, and the products and features you use. The personal information we collect may include the following:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'names',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'phone numbers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'email addresses',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'mailing addresses',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'contact preferences',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'contact or authentication data',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nSensitive Information. We do not process sensitive information.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nApplication Data. If you use our application(s), we also may collect the following information if you choose to provide us with access or permission:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Geolocation Information. We may request access or permission to track location- based information from your mobile device, either continuously or while you are using our mobile application(s), to provide certain location-based services. If you wish to change our access or permissions, you may do so in your device's settings.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Mobile Device Access. We may request access or permission to certain features from your mobile device, including your mobile device's camera, contacts, sms messages, and other features. If you wish to change our access or permissions, you may do so in your device's settings.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'Mobile Device Data. We automatically collect device information (such as your mobile device ID, model, and manufacturer), operating system, version information and system configuration information, device and application identification numbers, browser type and version, hardware model Internet service provider and/or mobile carrier, and Internet Protocol (IP) address (or proxy server). If you are using our application(s), we may also collect information about the phone network associated with your mobile device, your mobile device’s operating system or platform, the type of mobile device you use, your mobile device’s unique device ID, and information about the features of our application(s) you accessed.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Push Notifications. We may request to send you push notifications regarding your account or certain features of the application(s). If you wish to opt out from receiving these types of communications, you may turn them off in your device's settings.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nThis information is primarily needed to maintain the security and operation of our application(s), for troubleshooting, and for our internal analytics and reporting purposes.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\n All personal information that you provide to us must be true, complete, and accurate, and you must notify us of any changes to such personal information.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nInformation automatically collected',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nIn Short: Some information — such as your Internet Protocol (IP) address and/or browser and device characteristics — is collected automatically when you visit our Services.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nWe automatically collect certain information when you visit, use, or navigate the Services. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about how and when you use our Services, and other technical information. This information is primarily needed to maintain the security and operation of our Services, and for our internal analytics and reporting purposes.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nLike many businesses, we also collect information through cookies and similar technologies.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nThe information we collect includes:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'Log and Usage Data. Log and usage data is service-related, diagnostic, usage, and performance information our servers automatically collect when you access or use our Services and which we record in log files. Depending on how you interact with us, this log data may include your IP address, device information, browser type, and settings and information about your activity in the Services (such as the date/time stamps associated with your usage, pages and files viewed, searches, and other actions you take such as which features you use), device event information (such as system activity, error reports (sometimes called "crash dumps"), and hardware settings).',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'Device Data. We collect device data such as information about your computer, phone, tablet, or other device you use to access the Services. Depending on the device used, this device data may include information such as your IP address (or proxy server), device and application identification numbers, location, browser type, hardware model, Internet service provider and/or mobile carrier, operating system, and system configuration information.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Location Data. We collect location data such as information about your device's location, which can be either precise or imprecise. How much information we collect depends on the type and settings of the device you use to access the Services. For example, we may use GPS and other technologies to collect geolocation data that tells us your current location (based on your IP address). You can opt out of allowing us to collect this information either by refusing access to the information or by disabling your Location setting on your device. However, if you choose to opt out, you may not be able to use certain aspects of the Services.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: two,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '\n\n2. HOW DO WE PROCESS YOUR INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn Short: We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWe process your personal information for a variety of reasons, depending on how you interact with our Services, including:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'To facilitate account creation and authentication and otherwise manage user accounts. We may process your information so you can create and log in to your account, as well as keep your account in working order.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'To deliver and facilitate delivery of services to the user. We may process your information to provide you with the requested service.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'To respond to user inquiries/offer support to users. We may process your information to respond to your inquiries and solve any potential issues you might have with the requested service.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'To send administrative information to you. We may process your information to send you details about our products and services, changes to our terms and policies, and other similar information.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'To fulfill and manage your orders. We may process your information to fulfill and manage your orders, payments, returns, and exchanges made through the Services.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'To enable user-to-user communications. We may process your information if you choose to use any of our offerings that allow for communication with another user.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "To save or protect an individual's vital interest. We may process your information when necessary to save or protect an individual’s vital interest, such as to prevent harm.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: three,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '\n\n3. WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn Short: We only process your personal information when we believe it is necessary and we have a valid legal reason (i.e., legal basis) to do so under applicable law, like with your consent, to comply with laws, to provide you with services to enter into or fulfill our contractual obligations, to protect your rights, or to fulfill our legitimate business interests.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIf you are located in the EU or UK, this section applies to you.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nThe General Data Protection Regulation (GDPR) and UK GDPR require us to explain the valid legal bases we rely on in order to process your personal information. As such, we may rely on the following legal bases to process your personal information:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Consent. We may process your information if you have given us permission (i.e., consent) to use your personal information for a specific purpose. You can withdraw your consent at any time. Click here to learn more.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Performance of a Contract. We may process your personal information when we believe it is necessary to fulfill our contractual obligations to you, including providing our Services or at your request prior to entering into a contract with you.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Legal Obligations. We may process your information where we believe it is necessary for compliance with our legal obligations, such as to cooperate with a law enforcement body or regulatory agency, exercise or defend our legal rights, or disclose your information as evidence in litigation in which we are involved.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Vital Interests. We may process your information where we believe it is necessary to protect your vital interests or the vital interests of a third party, such as situations involving potential threats to the safety of any person.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIf you are located in Canada, this section applies to you.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWe may process your information if you have given us specific permission (i.e., express consent) to use your personal information for a specific purpose, or in situations where your permission can be inferred (i.e., implied consent). You can withdraw your consent at any time. Click here to learn more.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn some exceptional cases, we may be legally permitted under applicable law to process your information without your consent, including, for example:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If collection is clearly in the interests of an individual and consent cannot be obtained in a timely way",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "For investigations and fraud detection and prevention",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "For business transactions provided certain conditions are met.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If it is contained in a witness statement and the collection is necessary to assess, process, or settle an insurance claim",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "For identifying injured, ill, or deceased persons and communicating with next of kin",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If we have reasonable grounds to believe an individual has been, is, or may be victim of financial abuse",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If it is reasonable to expect collection and use with consent would compromise the availability or the accuracy of the information and the collection is reasonable for purposes related to investigating a breach of an agreement or a contravention of the laws of Canada or a province",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If disclosure is required to comply with a subpoena, warrant, court order, or rules of the court relating to the production of records",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If it was produced by an individual in the course of their employment, business, or profession and the collection is consistent with the purposes for which the information was produced",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If the collection is solely for journalistic, artistic, or literary purposes",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "If the information is publicly available and is specified by the regulations",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: four,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '\n\n4. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn Short: We may share information in specific situations described in this section and/or with the following third parties.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWe may need to share your personal information in the following situations:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Business Transfers. We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      'When we use Google Maps Platform APIs. We may share your information with certain Google Maps Platform APIs (e.g., Google Maps API, Places API). To find out more about Google’s Privacy Policy, please refer to this link. We obtain and store on your device ("cache") your location. You may revoke your consent anytime by contacting us at the contact details provided at the end of this document.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Other Users. When you share personal information (for example, by posting comments, contributions, or other content to the Services) or otherwise interact with public areas of the Services, such personal information may be viewed by all users and may be publicly made available outside the Services in perpetuity. Similarly, other users will be able to view descriptions of your activity, communicate with you within our Services, and view your profile.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: five,
                                ),
                              ),
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
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: six,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '\n\n6. HOW LONG DO WE KEEP YOUR INFORMATION?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn Short: We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWe will only keep your personal information for as long as it is necessary for the purposes set out in this privacy notice, unless a longer retention period is required or permitted by law (such as tax, accounting, or other legal requirements). No purpose in this notice will require us keeping your personal information for longer than the period of time in which users have an account with us.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWhen we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize such information, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: seven,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '\n\n7. HOW DO WE KEEP YOUR INFORMATION SAFE?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn Short: We aim to protect your personal information through a system of organizational and technical security measures.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWe have implemented appropriate and reasonable technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information. Although we will do our best to protect your personal information, transmission of personal information to and from our Services is at your own risk. You should only access the Services within a secure environment.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: eight,
                                ),
                              ),
                              TextSpan(
                                  text: '\n\n8. WHAT ARE YOUR PRIVACY RIGHTS?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nIn Short: In some regions, such as the European Economic Area (EEA), United Kingdom (UK), and Canada, you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '\n\nIn some regions (like the EEA, UK, and Canada), you have certain rights under applicable data protection laws. These may include the right (i) to request access and obtain a copy of your personal information, (ii) to request rectification or erasure; (iii) to restrict the processing of your personal information; and (iv) if applicable, to data portability. In certain circumstances, you may also have the right to object to the processing of your personal information. You can make such a request by contacting us by using the contact details provided in the section "HOW CAN YOU CONTACT US ABOUT THIS NOTICE?" below.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      "\n\nWe will consider and act upon any request in accordance with applicable data protection laws.If you are located in the EEA or UK and you believe we are unlawfully processing your personal information, you also have the right to complain to your local data protection supervisory authority. You can find their contact details here: https://ec.europa.eu/justice/data-protection/bodies/authorities/ index_en.htm.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text:
                                      '\n\nIf you are located in Switzerland, the contact details for the data protection authorities are available here: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              TextSpan(
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      html.window.open(
                                          "https://www.edoeb.admin.ch/edoeb/en/home.html.",
                                          "_blank");
                                    },
                                  text:
                                      'https://www.edoeb.admin.ch/edoeb/en/home.html.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text: '\n\nWithdrawing your consent:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                      // color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text:
                                      'If we are relying on your consent to process your personal information, which may be express and/or implied consent depending on the applicable law, you have the right to withdraw your consent at any time. You can withdraw your consent at any time by contacting us by using the contact details provided in the section ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              TextSpan(
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Scrollable.ensureVisible(
                                          eleven.currentContext!);
                                    },
                                  text:
                                      '"HOW CAN YOU CONTACT US ABOUT THIS NOTICE?" below.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text:
                                      '\n\nHowever, please note that this will not affect the lawfulness of the processing before its withdrawal nor, when applicable law allows, will it affect the processing of your personal information conducted in reliance on lawful processing grounds other than consent.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text: '\n\nAccount Information',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text:
                                      '\n\nIf you would at any time like to review or change the information in your account or terminate your account, you can:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text: "\n\n     •   ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(
                                  text:
                                      "Contact us using the contact information provided.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text:
                                      '\n\nUpon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our legal terms and/or comply with applicable legal requirements.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text:
                                      '\n\nICookies and similar technologies: Most Web browsers are set to accept cookies by default. If you prefer, you can usually choose to set your browser to remove cookies and to reject cookies. If you choose to remove cookies or reject cookies, this could affect certain features or services of our Services. To opt out of interest-based advertising by advertisers on our Services visit ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              TextSpan(
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      html.window.open(
                                          "http://www.aboutads.info/choices/",
                                          "_blank");
                                    },
                                  text: 'http://www.aboutads.info/choices/ .',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text:
                                      '\n\nIf you have questions or comments about your privacy rights, you may email us at contact@bowandbeautiful.com.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                      // color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: nine,
                                ),
                              ),
                              const TextSpan(
                                  text:
                                      '\n\n9. CONTROLS FOR DO-NOT-TRACK FEATURES',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text:
                                      '\n\nMost web browsers and some mobile operating systems and mobile applications include a Do-Not-Track ("DNT") feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. At this stage no uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this privacy notice.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                      // color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: ten,
                                ),
                              ),
                              const TextSpan(
                                  text:
                                      '\n\n10. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17,
                                    // color: Colors.blue[800],
                                    // decoration: TextDecoration.underline
                                  )),
                              const TextSpan(
                                  text:
                                      '\n\nIn Short: Yes, if you are a resident of California, you are granted specific rights regarding access to your personal information.\n\nCalifornia Civil Code Section 1798.83, also known as the "Shine The Light" law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below.\n\nIf you are under 18 years of age, reside in California, and have a registered account with Services, you have the right to request removal of unwanted data that you publicly post on the Services. To request removal of such data, please contact us using the contact information provided below and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the Services, but please be aware that the data may not be completely or comprehensively removed from all our systems (e.g., backups, etc.).\n\nCCPA Privacy Notice\n\nThe California Code of Regulations defines a "resident" as:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                      // color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                              const TextSpan(
                                  text:
                                      "\n\n     (1) every individual who is in the State of California for other than a temporary or transitory purpose and\n     (2) every individual who is domiciled in the State of California who is outside the State of California for a temporary or transitory purpose",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(
                                  text:
                                      '\n\nAll other individuals are defined as "non-residents."\n\nIf this definition of "resident" applies to you, we must adhere to certain rights and obligations regarding your personal information.\n\nWhat categories of personal information do we collect?\n\nWe have collected the following categories of personal information in the past twelve (12) months:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                      // color: Colors.blue[800],
                                      decoration: TextDecoration.underline)),
                            ])),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                      child: Container(
                          margin: EdgeInsets.all(20),
                          child: Table(
                              defaultColumnWidth: FixedColumnWidth(
                                  MediaQuery.of(context).size.width / 4.1),
                              border: TableBorder.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1),
                              children: [
                                TableRow(children: [
                                  Center(
                                    child: Text(
                                      "Category",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 76, 75, 75),
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Examples",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 76, 75, 75),
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Collected",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 76, 75, 75),
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "A. Identifiers",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Contact details, such as real name, alias, postal address, telephone or mobile contact number, unique personal identifier, online identifier, Internet Protocol address, email address, and account name",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "YES",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "B. Personal information categories listed in the California Customer Records statute",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Name, contact information, education, employment, employment history, and financial information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "YES",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "C. Protected classification characteristics under California or federal law",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Gender and date of birth",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "YES",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "D. Commercial information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Transaction information, purchase history, financial details, and payment information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "E. Biometric information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Fingerprints and voiceprints",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "F. Internet or other similar network activity",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Browsing history, search history, online behavior, interest data, and interactions with our and other websites, applications, systems, and advertisements",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "G. Geolocation data",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Device location",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "YES",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "H. Audio, electronic, visual, thermal, olfactory, or similar information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Images and audio, video or call recordings created in connection with our business activities",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "I. Professional or employment-related information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Business contact details in order to provide you our Services at a business level or job title, work history, and professional qualifications if you apply for a job with us",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "J. Education Information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Student records and directory information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    decoration: const BoxDecoration(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "K. Inferences drawn from other personal information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Inferences drawn from any of the collected personal information listed above to create a profile or summary about, for example, an individual’s preferences and characteristics",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "NO",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 76, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ]),
                              ])),
                    ),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: AppTheme.black2,
                                fontWeight: FontWeight.w400),
                            children: [
                          const TextSpan(
                              text:
                                  '\n\nWe may also collect other personal information outside of these categories through instances where you interact with us in person, online, or by phone or mail in the context of:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // fontStyle: FontStyle.italic,
                                // color: Colors.blue[800],
                                // decoration: TextDecoration.underline
                              )),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "Receiving help through our customer support channels;",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "Participation in customer surveys or contests; and",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "Facilitation in the delivery of our Services and to respond to your inquiries.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text:
                                  'How do we use and share your personal information?\n\nMore information about our data collection and sharing practices can be found in this privacy notice.\n\nYou may contact us by email at contact@bowandbeautiful.com, or by referring to the contact details at the bottom of this document.\n\nIf you are using an authorized agent to exercise your right to opt out we may deny a request if the authorized agent does not submit proof that they have been validly authorized to act on your behalf.\n\nWill your information be shared with anyone else?\n\nWe may disclose your personal information with our service providers pursuant to a written contract between us and each service provider. Each service provider is a for-profit entity that processes the information on our behalf.\n\nWe may use your personal information for our own business purposes, such as for undertaking internal research for technological development and demonstration. This is not considered to be "selling" of your personal information.\n\nBow and Beautiful LLC has not disclosed or sold any personal information to third parties for a business or commercial purpose in the preceding twelve (12) months. Bow and Beautiful LLC will not sell personal information in the future belonging to website visitors, users, and other consumers.\n\nYour rights with respect to your personal data\n\nRight to request deletion of the data — Request to delete\n\nYou can ask for the deletion of your personal information. If you ask us to delete your personal information, we will respect your request and delete your personal information, subject to certain exceptions provided by law, such as (but not limited to) the exercise by another consumer of his or her right to free speech, our compliance requirements resulting from a legal obligation, or any processing that may be required to protect against illegal activities.\n\nRight to be informed — Request to know\n\nDepending on the circumstances, you have a right to know:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "whether we collect and use your personal information;",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "the categories of personal information that we collect;",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "the purposes for which the collected personal information is used;",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "whether we sell your personal information to third parties;",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "the categories of personal information that we sold or disclosed for a business purpose;",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "the categories of third parties to whom the personal information was sold or disclosed for a business purpose; and",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "the business or commercial purpose for collecting or selling personal information.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text:
                                  "\n\nIn accordance with applicable law, we are not obligated to provide or delete consumer information that is de-identified in response to a consumer request or to re-identify individual data to verify a consumer request.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text:
                                  "\n\nRight to Non-Discrimination for the Exercise of a Consumer’s Privacy Rights\n\nWe will not discriminate against you if you exercise your privacy rights.\n\nVerification process\n\nUpon receiving your request, we will need to verify your identity to determine you are the same person about whom we have the information in our system. These verification efforts require us to ask you to provide information so that we can match it with information you have previously provided us. For instance, depending on the type of request you submit, we may ask you to provide certain information so that we can match the information you provide with the information we already have on file, or we may contact you through a communication method (e.g., phone or email) that you have previously provided to us. We may also use other verification methods as the circumstances dictate.\n\nWe will only use personal information provided in your request to verify your identity or authority to make the request. To the extent possible, we will avoid requesting additional information from you for the purposes of verification. However, if we cannot verify your identity from the information already maintained by us, we may request that you provide additional information for the purposes of verifying your identity and for security or fraud-prevention purposes. We will delete such additionally provided information as soon as we finish verifying you.\n\nOther privacy rights",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "You may object to the processing of your personal information.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "You may request correction of your personal data if it is incorrect or no longer relevant, or ask to restrict the processing of the information.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "You can designate an authorized agent to make a request under the CCPA on your behalf. We may deny a request from an authorized agent that does not submit proof that they have been validly authorized to act on your behalf in accordance with the CCPA.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: "\n\n     •   ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                                  "You may request to opt out from future selling of your personal information to third parties. Upon receiving an opt-out request, we will act upon the request as soon as feasibly possible, but no later than fifteen (15) days from the date of the request submission.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text:
                                  "\n\nTo exercise these rights, you can contact us by email at contact@bowandbeautiful.com, or by referring to the contact details at the bottom of this document. If you have a complaint about how we handle your data, we would like to hear from you.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // fontStyle: FontStyle.italic,
                                  // color: Colors.blue[800],
                                  decoration: TextDecoration.underline)),
                          WidgetSpan(
                            child: SizedBox.fromSize(
                              size: Size.zero,
                              key: eleven,
                            ),
                          ),
                          const TextSpan(
                              text:
                                  '\n\n11. DO WE MAKE UPDATES TO THIS NOTICE?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
                                // color: Colors.blue[800],
                                // decoration: TextDecoration.underline
                              )),
                          const TextSpan(
                              text:
                                  '\n\nIn Short: Yes, we will update this notice as necessary to stay compliant with relevant laws.\n\nWe may update this privacy notice from time to time. The updated version will be indicated by an updated "Revised" date and the updated version will be effective as soon as it is accessible. If we make material changes to this privacy notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this privacy notice frequently to be informed of how we are protecting your information.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                          WidgetSpan(
                            child: SizedBox.fromSize(
                              size: Size.zero,
                              key: twelve,
                            ),
                          ),
                          const TextSpan(
                              text:
                                  '\n\n12. HOW CAN YOU CONTACT US ABOUT THIS NOTICE?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
                                // color: Colors.blue[800],
                                // decoration: TextDecoration.underline
                              )),
                          const TextSpan(
                              text:
                                  "\n\nIf you have questions or comments about this notice, you may email us at contact@bowandbeautiful.com or by post to:\n\nBow and Beautiful LLC\nPirogovskoho Oleksandra St, Building 19 Corpus 6\nKyiv, Kyiv 03110\nUkraine",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                          WidgetSpan(
                            child: SizedBox.fromSize(
                              size: Size.zero,
                              key: thirteen,
                            ),
                          ),
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
                              recognizer: new TapGestureRecognizer()
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
                  ],
                ),
              );
            }),
      );
    });
    // return EasyWebView(
    //   src: htmlContent,

    //   // isHtml: false, // Use Html syntax
    //   isMarkdown: false, // Use markdown syntax
    //   convertToWidgets: true,
    // );
  }
}

String get htmlContent => """
<!DOCTYPE html>
<html>
<head>
<meta charset=”UTF-8">
<meta content=”IE=Edge” http-equiv=”X-UA-Compatible”>
</head>
<body>
<! — Add your custom html here →
</body>
</html>
""";
