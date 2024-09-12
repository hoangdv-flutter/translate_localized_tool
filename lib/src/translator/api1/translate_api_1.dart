import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:online_google_translator/expose.dart';
import 'package:online_google_translator/src/translator/translate_api.dart';

class TranslateApi1 implements TranslateApi {
  @override
  Future<TranslateResult?> translate(String sl, String tl, String st) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch;
      final content =
          "translate,sl:$sl,tl:$tl,st:${Uri.encodeComponent(st)},id:$time,qc:true,ac:false,_id:tw-async-translate,_pms:s,_fmt:pc";
      final response =
      await http.post(Uri.parse("https://www.google.com/async/translate"),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
            'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
            'Cookie':
            'NID=146=p-KPB8sQ6nqjr8I56LiEJzjdcsk7Wh91oDwr0jU0rfwOfN4Y_l9T4j_5uaSDg_6tDMSEXmPdhueoxwYM4w6meuHTK1R-Mej8-9Fm4kiEb8kFw8wVPnrgtaefkgNPq3W9ro81wpyImN-QtPVKILiNYq5UN07oTQWarcfgEXHOl0w6PR7uE4Xh14o; 1P_JAR=2018-11-12-04; OGP=-5061451:; DV=AwAhS-7BuJMeYH8oIYu_J3hJpKxjcBY'
          },
          body: {'async': content},
          encoding: Encoding.getByName("UTF-8"));

      if (response.statusCode != 200) return null;
      return _handleData(sl, tl, st, response.body);
    } catch (_) {
      return null;
    }
  }

  TranslateResult? _handleData(
      String sl, String tl, String srcContent, String data) {
    final content =
        _findData(r'<span\s+id="tw-answ-target-text".*?>(.*?)</.*?>', data);
    if (content == null) return null;
    final romanization =
        _findData(r'<span\s+id="tw-answ-romanization".*?>(.*?)</.*?>', data);
    final srcRomanization = _findData(
        r'<span\s+id="tw-answ-source-romanization".*?>(.*?)</.*?>', data);
    final detectedLangCode =
        _findData(r'<span\s+id="tw-answ-detected-sl".*?>(.*?)</.*?>', data);
    return TranslateResult(
        tl: tl,
        sl: sl,
        srcContent: srcContent,
        translateContent: content,
        romanization: romanization ?? "",
        srcRomanization: srcRomanization ?? "",
        detectedLangCode: detectedLangCode ?? "");
  }

  String? _findData(String expr, String data) {
    final regex = RegExp(expr);
    final match = regex.firstMatch(data);
    if (match == null) return null;
    return match.group(1);
  }
}
