
class TranslateResult {
  String tl;
  String sl;
  String srcContent;
  String translateContent;
  String romanization;
  String srcRomanization;
  String detectedLangCode;
  int time = 0;

  static const tableName = "translate_result";

  // TranslateResult.empty()
  //     : sl = "",
  //       tl = "",
  //       srcContent = "",
  //       translateContent = "",
  //       romanization = "",
  //       srcRomanization = "",
  //       detectedLangCode = "";

  TranslateResult({
    required this.tl,
    required this.sl,
    required this.srcContent,
    required this.translateContent,
    required this.romanization,
    required this.srcRomanization,
    required this.detectedLangCode,
    int? time,
  }) {
    this.time = time ?? DateTime.now().millisecondsSinceEpoch;
  }

  factory TranslateResult.fromJson(Map<String, dynamic> json) =>
      TranslateResult(
        tl: json["tl"],
        sl: json["sl"],
        srcContent: json["srcContent"],
        translateContent: json["translateContent"],
        romanization: json["romanization"],
        srcRomanization: json["srcRomanization"],
        detectedLangCode: json["detectedLangCode"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "tl": tl,
        "sl": sl,
        "srcContent": srcContent,
        "translateContent": translateContent,
        "romanization": romanization,
        "srcRomanization": srcRomanization,
        "detectedLangCode": detectedLangCode,
        "time": time,
      };
}
