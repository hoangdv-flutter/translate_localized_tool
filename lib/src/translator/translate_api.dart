import 'translate_result.dart';

abstract class TranslateApi {
  Future<TranslateResult?> translate(String sl, String tl, String st);
}
