import 'package:online_google_translator/expose.dart';

abstract class TranslationDataSource {
  static TranslationDataSource newInstance() => TranslationDataSourceImpl();

  Future<TranslateResult?> translate(String sl, String tl, String content);
}
