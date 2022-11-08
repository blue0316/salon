import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Content10 extends StatelessWidget {
  const Content10({Key? key}) : super(key: key);

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
                text:
                    '\n\n10. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 17,
                  // color: Colors.blue[800],
                  // decoration: TextDecoration.underline
                )),
            TextSpan(
                text:
                    '\n\nIn Short: Yes, if you are a resident of California, you are granted specific rights regarding access to your personal information.\n\nCalifornia Civil Code Section 1798.83, also known as the "Shine The Light" law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below.\n\nIf you are under 18 years of age, reside in California, and have a registered account with Services, you have the right to request removal of unwanted data that you publicly post on the Services. To request removal of such data, please contact us using the contact information provided below and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the Services, but please be aware that the data may not be completely or comprehensively removed from all our systems (e.g., backups, etc.).\n\nCCPA Privacy Notice\n\nThe California Code of Regulations defines a "resident" as:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    "\n\n     (1) every individual who is in the State of California for other than a temporary or transitory purpose and\n     (2) every individual who is domiciled in the State of California who is outside the State of California for a temporary or transitory purpose",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    '\n\nAll other individuals are defined as "non-residents."\n\nIf this definition of "resident" applies to you, we must adhere to certain rights and obligations regarding your personal information.\n\nWhat categories of personal information do we collect?\n\nWe have collected the following categories of personal information in the past twelve (12) months:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
          ])),
      Padding(
        padding: const EdgeInsets.only(top: 18.0, bottom: 18),
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Table(
                defaultColumnWidth:
                    FixedColumnWidth(MediaQuery.of(context).size.width / 4.1),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Center(
                      child: Text(
                        "Category",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Examples",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Collected",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "A. Identifiers",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Contact details, such as real name, alias, postal address, telephone or mobile contact number, unique personal identifier, online identifier, Internet Protocol address, email address, and account name",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "YES",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "B. Personal information categories listed in the California Customer Records statute",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name, contact information, education, employment, employment history, and financial information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "YES",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "C. Protected classification characteristics under California or federal law",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Gender and date of birth",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "YES",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "D. Commercial information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Transaction information, purchase history, financial details, and payment information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "E. Biometric information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Fingerprints and voiceprints",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "F. Internet or other similar network activity",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Browsing history, search history, online behavior, interest data, and interactions with our and other websites, applications, systems, and advertisements",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "G. Geolocation data",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Device location",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "YES",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "H. Audio, electronic, visual, thermal, olfactory, or similar information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Images and audio, video or call recordings created in connection with our business activities",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "I. Professional or employment-related information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Business contact details in order to provide you our Services at a business level or job title, work history, and professional qualifications if you apply for a job with us",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "J. Education Information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Student records and directory information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  TableRow(decoration: const BoxDecoration(), children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "K. Inferences drawn from other personal information",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Inferences drawn from any of the collected personal information listed above to create a profile or summary about, for example, an individual’s preferences and characteristics",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        "NO",
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: const Color.fromARGB(255, 76, 75, 75),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                ])),
      ),
      RichText(
          text: const TextSpan(
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "Arial",
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              children: [
            TextSpan(
                text:
                    '\n\nWe may also collect other personal information outside of these categories through instances where you interact with us in person, online, or by phone or mail in the context of:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic,
                  // color: Colors.blue[800],
                  // decoration: TextDecoration.underline
                )),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: "Receiving help through our customer support channels;",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: "Participation in customer surveys or contests; and",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "Facilitation in the delivery of our Services and to respond to your inquiries.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    'How do we use and share your personal information?\n\nMore information about our data collection and sharing practices can be found in this privacy notice.\n\nYou may contact us by email at contact@bowandbeautiful.com, or by referring to the contact details at the bottom of this document.\n\nIf you are using an authorized agent to exercise your right to opt out we may deny a request if the authorized agent does not submit proof that they have been validly authorized to act on your behalf.\n\nWill your information be shared with anyone else?\n\nWe may disclose your personal information with our service providers pursuant to a written contract between us and each service provider. Each service provider is a for-profit entity that processes the information on our behalf.\n\nWe may use your personal information for our own business purposes, such as for undertaking internal research for technological development and demonstration. This is not considered to be "selling" of your personal information.\n\nBow and Beautiful LLC has not disclosed or sold any personal information to third parties for a business or commercial purpose in the preceding twelve (12) months. Bow and Beautiful LLC will not sell personal information in the future belonging to website visitors, users, and other consumers.\n\nYour rights with respect to your personal data\n\nRight to request deletion of the data — Request to delete\n\nYou can ask for the deletion of your personal information. If you ask us to delete your personal information, we will respect your request and delete your personal information, subject to certain exceptions provided by law, such as (but not limited to) the exercise by another consumer of his or her right to free speech, our compliance requirements resulting from a legal obligation, or any processing that may be required to protect against illegal activities.\n\nRight to be informed — Request to know\n\nDepending on the circumstances, you have a right to know:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: "whether we collect and use your personal information;",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: "the categories of personal information that we collect;",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "the purposes for which the collected personal information is used;",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "whether we sell your personal information to third parties;",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "the categories of personal information that we sold or disclosed for a business purpose;",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "the categories of third parties to whom the personal information was sold or disclosed for a business purpose; and",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "the business or commercial purpose for collecting or selling personal information.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    "\n\nIn accordance with applicable law, we are not obligated to provide or delete consumer information that is de-identified in response to a consumer request or to re-identify individual data to verify a consumer request.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    "\n\nRight to Non-Discrimination for the Exercise of a Consumer’s Privacy Rights\n\nWe will not discriminate against you if you exercise your privacy rights.\n\nVerification process\n\nUpon receiving your request, we will need to verify your identity to determine you are the same person about whom we have the information in our system. These verification efforts require us to ask you to provide information so that we can match it with information you have previously provided us. For instance, depending on the type of request you submit, we may ask you to provide certain information so that we can match the information you provide with the information we already have on file, or we may contact you through a communication method (e.g., phone or email) that you have previously provided to us. We may also use other verification methods as the circumstances dictate.\n\nWe will only use personal information provided in your request to verify your identity or authority to make the request. To the extent possible, we will avoid requesting additional information from you for the purposes of verification. However, if we cannot verify your identity from the information already maintained by us, we may request that you provide additional information for the purposes of verifying your identity and for security or fraud-prevention purposes. We will delete such additionally provided information as soon as we finish verifying you.\n\nOther privacy rights",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "You may object to the processing of your personal information.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "You may request correction of your personal data if it is incorrect or no longer relevant, or ask to restrict the processing of the information.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "You can designate an authorized agent to make a request under the CCPA on your behalf. We may deny a request from an authorized agent that does not submit proof that they have been validly authorized to act on your behalf in accordance with the CCPA.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n\n     •   ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    "You may request to opt out from future selling of your personal information to third parties. Upon receiving an opt-out request, we will act upon the request as soon as feasibly possible, but no later than fifteen (15) days from the date of the request submission.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
            TextSpan(
                text:
                    "\n\nTo exercise these rights, you can contact us by email at contact@bowandbeautiful.com, or by referring to the contact details at the bottom of this document. If you have a complaint about how we handle your data, we would like to hear from you.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.italic,
                    // color: Colors.blue[800],
                    decoration: TextDecoration.underline)),
          ]))
    ]);
  }
}
