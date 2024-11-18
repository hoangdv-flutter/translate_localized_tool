import 'dart:convert';
import 'dart:io';

import 'package:online_google_translator/expose.dart';
import 'package:online_google_translator/src/util/map_converter.dart';
import 'package:xml/xml.dart';

part 'translate_entry.dart';

Future<void> main() async {
  final rootDir = "translate_for_android";
  final translation = TranslationDataSource.newInstance();
  final targetLang =
      (jsonDecode(File("lib/$rootDir/file/target_lang.json").readAsStringSync())
              as List<dynamic>)
          .cast<String>();

  final inputMap = _parseStringFile("lib/$rootDir/file/values/strings.xml");

  for (var lang in targetLang) {
    try {
      final outFile = File(
          'lib/$rootDir/file/values-${lang.replaceAll("-", "-r")}/strings.xml');
      final outputMap = _parseStringFile(outFile.path);
      for (final entry in inputMap.entries) {
        if (outputMap.containsKey(entry.key)) continue;
        final content = (await translation.translate("en", lang, entry.value))
            ?.translateContent;
        if (content == null) {
          printYellow("[\"$lang\"] Translate Failed: ${entry.key}");
          continue;
        }
        printGreen("[\"$lang\"] ${entry.value} ---> ${content}");
        outputMap[entry.key] = content;
        await Future.delayed(Duration(milliseconds: 200));
      }

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element("resources", nest: () {
        for (final entry in outputMap.entries) {
          builder.element("string", nest: () {
            builder.attribute("name", entry.key);
            builder.text(StringFormat.decode(entry.value));
          });
        }
      });

      outFile.writeAsString(builder.buildDocument().toXmlString(pretty: true));
      printCyan("[$lang] wrote file \"${outFile.path}\"");
    } catch (e) {
      printRed(e);
    }
  }
}

Map<String, String> _parseStringFile(String path) {
  final file = File(path);
  final map = <String, String>{};
  if (!file.existsSync()) {
    if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
    return map;
  }
  final xmlOutput = XmlDocument.parse(file.readAsStringSync());
  final elements = xmlOutput.findAllElements("string");
  for (final e in elements) {
    if (e.getAttribute("translatable") == "false") continue;
    final key = e.getAttribute("name");
    if (key == null) continue;
    map[key] =StringFormat.encode(e.innerText);
  }
  return map;
}
