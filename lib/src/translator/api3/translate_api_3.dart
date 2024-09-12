import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_google_translator/expose.dart';
import 'package:online_google_translator/src/translator/translate_api.dart';

class TranslateApi3 extends TranslateApi {
  @override
  Future<TranslateResult?> translate(String sl, String tl, String st) async {
    try {
      final url = Uri.parse(
          "https://translate.google.com/_/TranslateWebserverUi/data/batchexecute?rpcids=rPsWke&source-path=%2F&f.sid=-1493147240274621710&bl=boq_translate-webserver_20240619.08_p0&soc-app=1&soc-platform=1&soc-device=1&_reqid=3932430&rt=c");
      final response = await http.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
      }, body: {
        'f.req':
            // ignore: unnecessary_string_escapes
            '[[["MkEWBc","[[\\"$st\\",\\"$sl\\",\\"$tl\\",1],[]]",null,"generic"]]]',
        'at':
            'AFS6Qyi8NVjwCcmK4XASw2wwJsCl:${DateTime.now().millisecondsSinceEpoch}'
      });
      if (response.statusCode == 200) {
        return _handleData(sl, tl, st, response.body);
      }
    } catch (_) {}
    return null;
  }

  TranslateResult? _handleData(String sl, String tl, String st, String body) {
    final json = _findData(r"(\[.*?)\d+\[\[", body.replaceAll("\n", ""));
    if (json == null) return null;
    try {
      final root = jsonDecode(json);
      final mainJson = jsonDecode(root[0][2]);
      final content = mainJson[1][0][0][5][0][0];
      if (content == null) return null;
      final romanization = mainJson[1][0][0][1] ?? '';
      final srcRomanization = mainJson[0][0] ?? '';
      final detectedLang = mainJson[2] ?? '';
      return TranslateResult(
          tl: tl,
          sl: sl,
          srcContent: st,
          translateContent: content,
          romanization: romanization,
          srcRomanization: srcRomanization,
          detectedLangCode: detectedLang);
    } catch (_) {
      return null;
    }
  }

  String? _findData(String expr, String data) {
    final regex = RegExp(expr);
    final match = regex.firstMatch(data);
    if (match == null) return null;
    return match.group(1);
  }
}
