import 'package:flutter/material.dart';

class Content2 extends StatelessWidget {
  const Content2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '\n\n2. HOW DO WE PROCESS YOUR INFORMATION?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIn Short: We process your information to provide, improve, and administer our Services, communicate with you, for security and fraud prevention, and to comply with law. We may also process your information for other purposes with your consent.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nWe process your personal information for a variety of reasons, depending on how you interact with our Services, including:", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'To facilitate account creation and authentication and otherwise manage user accounts. We may process your information so you can create and log in to your account, as well as keep your account in working order.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'To deliver and facilitate delivery of services to the user. We may process your information to provide you with the requested service.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'To respond to user inquiries/offer support to users. We may process your information to respond to your inquiries and solve any potential issues you might have with the requested service.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'To send administrative information to you. We may process your information to send you details about our products and services, changes to our terms and policies, and other similar information.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ])),
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: <InlineSpan>[
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'To fulfill and manage your orders. We may process your information to fulfill and manage your orders, payments, returns, and exchanges made through the Services.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'To enable user-to-user communications. We may process your information if you choose to use any of our offerings that allow for communication with another user.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "To save or protect an individual's vital interest. We may process your information when necessary to save or protect an individual’s vital interest, such as to prevent harm.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ])),
    ]);
  }
}
