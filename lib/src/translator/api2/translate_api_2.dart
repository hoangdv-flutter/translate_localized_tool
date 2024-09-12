import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_google_translator/expose.dart';
import 'package:online_google_translator/src/translator/translate_api.dart';

import 'tokens/google_token_gen.dart';

class TranslateApi2 implements TranslateApi {
  final _tokenProvider = GoogleTokenGenerator();

  @override
  Future<TranslateResult?> translate(String sl, String tl, String st) async {
    try{
      final url = Uri.parse(
          "https://translate.google.com/translate_a/single?client=t&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=sos&dt=ss&dt=t&otf=1&ssel=3&tsel=0&dj=1&sl=$sl&tl=$tl&q=$st&tk=${_tokenProvider.generateToken(st)}");
      final data = await http.get(url, headers: {
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
        "charset": "UTF-8",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (data.statusCode != 200) {
        return null;
      }
      final jsonData = jsonDecode(data.body);
      return _handleData(tl, sl, st, jsonData);
    }catch(_){
      return null;
    }
  }

  TranslateResult? _handleData(
      String tl, String sl, String st, dynamic jsonData) {
    String content = jsonData['sentences'][0]['trans'];
    String romanization = jsonData['sentences'][1]['translit'] ?? "";
    String srcRomanization = jsonData['sentences'][1]['src_translit'] ?? "";
    String detectedLang = jsonData['ld_result']['srclangs']?[0] ?? "";
    return TranslateResult(
        tl: tl,
        sl: sl,
        srcContent: st,
        translateContent: content,
        romanization: romanization,
        srcRomanization: srcRomanization,
        detectedLangCode: detectedLang);
  }
}
