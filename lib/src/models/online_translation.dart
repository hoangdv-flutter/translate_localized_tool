import 'package:translator/translator.dart';

import 'online_translate_language.dart';

class OnlineTranslation {
  final String text;
  final String source;
  final OnlineTranslateLanguage targetLanguage;
  final OnlineTranslateLanguage sourceLanguage;

  OnlineTranslation(
      {required this.text,
      required this.source,
      required this.targetLanguage,
      required this.sourceLanguage});

  static OnlineTranslation fromTranslation(Translation translation) {
    return OnlineTranslation(
        text: translation.text,
        source: translation.source,
        targetLanguage: OnlineTranslateLanguage(
            code: translation.targetLanguage.code,
            name: translation.targetLanguage.name),
        sourceLanguage: OnlineTranslateLanguage(
            code: translation.sourceLanguage.code,
            name: translation.sourceLanguage.name));
  }
}
