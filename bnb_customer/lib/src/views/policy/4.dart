import 'package:flutter/material.dart';

class Content4 extends StatelessWidget {
  const Content4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '\n\n4. WHEN AND WITH WHOM DO WE SHARE YOUR PERSONAL INFORMATION?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIn Short: We may share information in specific situations described in this section and/or with the following third parties.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nWe may need to share your personal information in the following situations:", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Business Transfers. We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(
            text: 'When we use Google Maps Platform APIs. We may share your information with certain Google Maps Platform APIs (e.g., Google Maps API, Places API). To find out more about Google’s Privacy Policy, please refer to this link. We obtain and store on your device ("cache") your location. You may revoke your consent anytime by contacting us at the contact details provided at the end of this document.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(
            text: "Other Users. When you share personal information (for example, by posting comments, contributions, or other content to the Services) or otherwise interact with public areas of the Services, such personal information may be viewed by all users and may be publicly made available outside the Services in perpetuity. Similarly, other users will be able to view descriptions of your activity, communicate with you within our Services, and view your profile.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
