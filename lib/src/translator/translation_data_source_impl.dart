import 'package:online_google_translator/expose.dart';

import 'api1/translate_api_1.dart';
import 'api2/translate_api_2.dart';
import 'api3/translate_api_3.dart';

class TranslationDataSourceImpl extends TranslationDataSource {

  late final transLogical = [TranslateApi1(), TranslateApi2(), TranslateApi3()];

  TranslationDataSourceImpl();

  @override
  Future<TranslateResult?> translate(
      String sl, String tl, String content) async {
    for (var logic in transLogical) {
      final r = await logic.translate(sl, tl, content);
      if (r != null) {
        return r;
      }
    }
    return null;
  }
}
