// ignore_for_file: file_names
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class Content8 extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> eleven;
  const Content8({Key? key, required this.eleven}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '\n\n8. WHAT ARE YOUR PRIVACY RIGHTS?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIn Short: In some regions, such as the European Economic Area (EEA), United Kingdom (UK), and Canada, you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text:
                '\n\nIn some regions (like the EEA, UK, and Canada), you have certain rights under applicable data protection laws. These may include the right (i) to request access and obtain a copy of your personal information, (ii) to request rectification or erasure; (iii) to restrict the processing of your personal information; and (iv) if applicable, to data portability. In certain circumstances, you may also have the right to object to the processing of your personal information. You can make such a request by contacting us by using the contact details provided in the section "HOW CAN YOU CONTACT US ABOUT THIS NOTICE?" below.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text: "\n\nWe will consider and act upon any request in accordance with applicable data protection laws.If you are located in the EEA or UK and you believe we are unlawfully processing your personal information, you also have the right to complain to your local data protection supervisory authority. You can find their contact details here: https://ec.europa.eu/justice/data-protection/bodies/authorities/ index_en.htm.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(
            text: '\n\nIf you are located in Switzerland, the contact details for the data protection authorities are available here: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.italic,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                html.window.open("https://www.edoeb.admin.ch/edoeb/en/home.html.", "_blank");
              },
            text: 'https://www.edoeb.admin.ch/edoeb/en/home.html.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(
            text: '\n\nWithdrawing your consent:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // fontStyle: FontStyle.italic,
                // color: Colors.blue[800],
                decoration: TextDecoration.underline)),
        const TextSpan(
            text: 'If we are relying on your consent to process your personal information, which may be express and/or implied consent depending on the applicable law, you have the right to withdraw your consent at any time. You can withdraw your consent at any time by contacting us by using the contact details provided in the section ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.italic,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Scrollable.ensureVisible(eleven.currentContext!);
              },
            text: '"HOW CAN YOU CONTACT US ABOUT THIS NOTICE?" below.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(
            text: '\n\nHowever, please note that this will not affect the lawfulness of the processing before its withdrawal nor, when applicable law allows, will it affect the processing of your personal information conducted in reliance on lawful processing grounds other than consent.',
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
            text: '\n\nIf you would at any time like to review or change the information in your account or terminate your account, you can:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.italic,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(
            text: "Contact us using the contact information provided.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        const TextSpan(
            text: '\n\nUpon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our legal terms and/or comply with applicable legal requirements.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.italic,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        const TextSpan(
            text: '\n\nICookies and similar technologies: Most Web browsers are set to accept cookies by default. If you prefer, you can usually choose to set your browser to remove cookies and to reject cookies. If you choose to remove cookies or reject cookies, this could affect certain features or services of our Services. To opt out of interest-based advertising by advertisers on our Services visit ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.italic,
              // color: Colors.blue[800],
              // decoration: TextDecoration.underline
            )),
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                html.window.open("http://www.aboutads.info/choices/", "_blank");
              },
            text: 'http://www.aboutads.info/choices/ .',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(
            text: '\n\nIf you have questions or comments about your privacy rights, you may email us at contact@bowandbeautiful.com.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // fontStyle: FontStyle.italic,
                // color: Colors.blue[800],
                decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
