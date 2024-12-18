import 'dart:convert';
import 'dart:io';

import 'package:online_google_translator/expose.dart';

Future<void> main() async {
  final rootDir = "translate_for_flutter";
  final targetLang =
      (jsonDecode(File("lib/$rootDir/file/target_lang.json").readAsStringSync())
              as List<dynamic>)
          .cast<String>();

  final translation = TranslationDataSource.newInstance();
  final contentSourceJson =
      await File("lib/${rootDir}/file/en.json").readAsString();

  final Map<String, dynamic> contentSource = jsonDecode(contentSourceJson);

  final directory = Directory("lib/${rootDir}/file/result");
  if (!directory.existsSync()) directory.createSync(recursive: true);

  for (var lang in targetLang) {
    var resultJson = "{}";
    try {
      resultJson =
          await File("lib/${rootDir}/file/result/$lang.json").readAsString();
    } catch (e) {}
    try {
      final Map<String, dynamic> result = jsonDecode(resultJson);
      for (final entry in contentSource.entries) {
        if (result.containsKey(entry.key)) continue;
        result[entry.key] =
            (await translation.translate("en", lang, entry.value))
                ?.translateContent;
        printGreen("${entry.value} --> ${result[entry.key]}");
        await Future.delayed(Duration(milliseconds: 200));
      }
      printCyan("translated $lang.json successfully!");
      final outFile = File("lib/$rootDir/file/result/$lang.json");
      final outDir = outFile.parent;
      if (!outDir.existsSync()) outDir.createSync(recursive: true);
      await outFile.writeAsString(jsonEncode(result));
    } catch (_) {}
  }
}
