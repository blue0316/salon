import 'package:flutter/material.dart';

class Content1 extends StatelessWidget {
  const Content1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '1. WHAT INFORMATION DO WE COLLECT?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text:
                '\n\nPersonal information you disclose to us\n\nIn Short: We collect personal information that you provide to us.\n\nWe collect personal information that you voluntarily provide to us when you register on the Services, express an interest in obtaining information about us or our products and Services, when you participate in activities on the Services, or otherwise when you contact us.\n\nPersonal Information Provided by You. The personal information that we collect depends on the context of your interactions with us and the Services, the choices you make, and the products and features you use. The personal information we collect may include the following:',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'names', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'phone numbers', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'email addresses', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'mailing addresses', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'contact preferences', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: 'contact or authentication data', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nSensitive Information. We do not process sensitive information.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nApplication Data. If you use our application(s), we also may collect the following information if you choose to provide us with access or permission:', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Geolocation Information. We may request access or permission to track location- based information from your mobile device, either continuously or while you are using our mobile application(s), to provide certain location-based services. If you wish to change our access or permissions, you may do so in your device's settings.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Mobile Device Access. We may request access or permission to certain features from your mobile device, including your mobile device's camera, contacts, sms messages, and other features. If you wish to change our access or permissions, you may do so in your device's settings.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
      ])),
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: <InlineSpan>[
        TextSpan(
            text:
                'Mobile Device Data. We automatically collect device information (such as your mobile device ID, model, and manufacturer), operating system, version information and system configuration information, device and application identification numbers, browser type and version, hardware model Internet service provider and/or mobile carrier, and Internet Protocol (IP) address (or proxy server). If you are using our application(s), we may also collect information about the phone network associated with your mobile device, your mobile device’s operating system or platform, the type of mobile device you use, your mobile device’s unique device ID, and information about the features of our application(s) you accessed.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Push Notifications. We may request to send you push notifications regarding your account or certain features of the application(s). If you wish to opt out from receiving these types of communications, you may turn them off in your device's settings.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nThis information is primarily needed to maintain the security and operation of our application(s), for troubleshooting, and for our internal analytics and reporting purposes.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\n All personal information that you provide to us must be true, complete, and accurate, and you must notify us of any changes to such personal information.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nInformation automatically collected', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nIn Short: Some information — such as your Internet Protocol (IP) address and/or browser and device characteristics — is collected automatically when you visit our Services.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text:
                '\n\nWe automatically collect certain information when you visit, use, or navigate the Services. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about how and when you use our Services, and other technical information. This information is primarily needed to maintain the security and operation of our Services, and for our internal analytics and reporting purposes.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nLike many businesses, we also collect information through cookies and similar technologies.', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: '\n\nThe information we collect includes:', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(
            text:
                'Log and Usage Data. Log and usage data is service-related, diagnostic, usage, and performance information our servers automatically collect when you access or use our Services and which we record in log files. Depending on how you interact with us, this log data may include your IP address, device information, browser type, and settings and information about your activity in the Services (such as the date/time stamps associated with your usage, pages and files viewed, searches, and other actions you take such as which features you use), device event information (such as system activity, error reports (sometimes called "crash dumps"), and hardware settings).',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(
            text: 'Device Data. We collect device data such as information about your computer, phone, tablet, or other device you use to access the Services. Depending on the device used, this device data may include information such as your IP address (or proxy server), device and application identification numbers, location, browser type, hardware model, Internet service provider and/or mobile carrier, operating system, and system configuration information.',
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(
            text:
                "Location Data. We collect location data such as information about your device's location, which can be either precise or imprecise. How much information we collect depends on the type and settings of the device you use to access the Services. For example, we may use GPS and other technologies to collect geolocation data that tells us your current location (based on your IP address). You can opt out of allowing us to collect this information either by refusing access to the information or by disabling your Location setting on your device. However, if you choose to opt out, you may not be able to use certain aspects of the Services.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
