
   
import 'package:bbblient/src/translation/translation_api.dart';
import 'package:flutter/material.dart';

class TranslationWidget extends StatefulWidget {
  final String? message;
  // final String ?fromString;
  final String ?toLanguageCode;
  final Widget Function(String translation)? builder;

  const TranslationWidget({
    @required this.message,
    // @required this.fromString,
    @required this.toLanguageCode,
    @required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  String ? translation;
  // String ? notranslation

  @override
  Widget build(BuildContext context) {
    // final fromLanguageCode = Translations.getLanguageCode(widget.fromLanguage);
    final toLanguageCode = widget.toLanguageCode;

    return FutureBuilder(
      // future: TranslationApi.translate(widget.message, toLanguageCode),
      future: TranslationApi.translate2(
         widget.message!,  toLanguageCode!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildWaiting();
          default:
            if (snapshot.hasError) {
              translation = widget.message;
            } else {
              translation = snapshot.data;
            }
            return widget.builder!(translation!);
        }
      },
    );
  }

  Widget buildWaiting() =>
      translation == null ? widget.builder!(widget.message!) : widget.builder!(translation!);
}
