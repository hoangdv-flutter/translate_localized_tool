import 'dart:convert';
import 'dart:io';

import 'package:online_google_translator/expose.dart';

final targetLang = ["es", 'pl', 'ro', 'tr'];

Future<void> main() async {
  final translation = TranslationDataSource.newInstance();
  final contentSourceJson = await File("lib/src/file/en.json").readAsString();

  final Map<String, dynamic> contentSource = jsonDecode(contentSourceJson);

  final directory = Directory("lib/src/file/result");
  if (!directory.existsSync()) directory.createSync(recursive: true);

  for (var lang in targetLang) {
    var resultJson = "{}";
    try {
      resultJson = await File("lib/src/file/result/$lang.json").readAsString();
    } catch (e) {}
    try {
      final Map<String, dynamic> result = jsonDecode(resultJson);
      for (final entry in contentSource.entries) {
        if (result.containsKey(entry.key)) continue;
        result[entry.key] =
            (await translation.translate("en", lang, entry.value))
                ?.translateContent;
        printGreen("${entry.value} --> ${result[entry.key]}");
      }
      printCyan("translated $lang.json successfully!");
      File("lib/src/file/result/$lang.json").writeAsString(jsonEncode(result));
    } catch (_) {}
  }
}
