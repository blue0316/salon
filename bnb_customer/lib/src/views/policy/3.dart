import 'package:flutter/material.dart';

class Content3 extends StatelessWidget {
  const Content3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(style: const TextStyle(fontSize: 15.0, fontFamily: "Arial", color: Colors.black, fontWeight: FontWeight.w400), children: [
        TextSpan(text: '\n\n3. WHAT LEGAL BASES DO WE RELY ON TO PROCESS YOUR INFORMATION?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(
            text: "\n\nIn Short: We only process your personal information when we believe it is necessary and we have a valid legal reason (i.e., legal basis) to do so under applicable law, like with your consent, to comply with laws, to provide you with services to enter into or fulfill our contractual obligations, to protect your rights, or to fulfill our legitimate business interests.",
            style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIf you are located in the EU or UK, this section applies to you.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nThe General Data Protection Regulation (GDPR) and UK GDPR require us to explain the valid legal bases we rely on in order to process your personal information. As such, we may rely on the following legal bases to process your personal information:", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Consent. We may process your information if you have given us permission (i.e., consent) to use your personal information for a specific purpose. You can withdraw your consent at any time. Click here to learn more.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Performance of a Contract. We may process your personal information when we believe it is necessary to fulfill our contractual obligations to you, including providing our Services or at your request prior to entering into a contract with you.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Legal Obligations. We may process your information where we believe it is necessary for compliance with our legal obligations, such as to cooperate with a law enforcement body or regulatory agency, exercise or defend our legal rights, or disclose your information as evidence in litigation in which we are involved.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "Vital Interests. We may process your information where we believe it is necessary to protect your vital interests or the vital interests of a third party, such as situations involving potential threats to the safety of any person.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIf you are located in Canada, this section applies to you.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nWe may process your information if you have given us specific permission (i.e., express consent) to use your personal information for a specific purpose, or in situations where your permission can be inferred (i.e., implied consent). You can withdraw your consent at any time. Click here to learn more.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        TextSpan(text: "\n\nIn some exceptional cases, we may be legally permitted under applicable law to process your information without your consent, including, for example:", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If collection is clearly in the interests of an individual and consent cannot be obtained in a timely way", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "For investigations and fraud detection and prevention", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "For business transactions provided certain conditions are met.", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If it is contained in a witness statement and the collection is necessary to assess, process, or settle an insurance claim", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "For identifying injured, ill, or deceased persons and communicating with next of kin", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If we have reasonable grounds to believe an individual has been, is, or may be victim of financial abuse", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If it is reasonable to expect collection and use with consent would compromise the availability or the accuracy of the information and the collection is reasonable for purposes related to investigating a breach of an agreement or a contravention of the laws of Canada or a province", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If disclosure is required to comply with a subpoena, warrant, court order, or rules of the court relating to the production of records", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If it was produced by an individual in the course of their employment, business, or profession and the collection is consistent with the purposes for which the information was produced", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If the collection is solely for journalistic, artistic, or literary purposes", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
        const TextSpan(text: "\n\n     •   ", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "If the information is publicly available and is specified by the regulations", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.blue[800], decoration: TextDecoration.underline)),
      ]))
    ]);
  }
}
