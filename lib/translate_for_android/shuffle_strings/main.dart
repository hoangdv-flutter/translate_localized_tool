import 'dart:io';

import 'package:xml/xml.dart';

String _toXml(List<Entry> entries) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  builder.element("resources", nest: () {
    for (final entry in entries) {
      builder.element("string", nest: () {
        if (!entry.translatable) {
          builder.attribute("translatable", "false");
        }
        builder.attribute("name", entry.key);
        builder.text(entry.value);
      });
    }
  });
  return builder.buildDocument().toXmlString(pretty: true);
}

List<Entry> _decode(String path) {
  final file = File(path);
  final document = XmlDocument.parse(file.readAsStringSync());
  final stringMap = <Entry>[];
  document.findAllElements("string").forEach(
    (e) {
      final key = e.getAttribute("name");
      final value = e.innerText;
      if (key == null || value.isEmpty) return;
      stringMap.add(Entry(
          key,
          value,
          (bool.tryParse(e.getAttribute("translatable") ?? "true") ?? true) ==
              true));
    },
  );
  stringMap.shuffle();
  return stringMap;
}

class Entry {
  final String key;
  final String value;
  final bool translatable;

  Entry(this.key, this.value, this.translatable);
}

void main() {
  final inputDir = Directory("p90_data/res");
  final dirs = inputDir.listSync(recursive: true);
  for (final dir in dirs) {
    if (dir is Directory) {
      final file = dir.listSync(recursive: true).firstOrNull;
      if (file == null) return;
      final decoded = _decode(file.path);
      final outFile =
      File(file.path.replaceAll("\\", "/").replaceFirst("p90_data/res/", "p90_data/result/res/"));
      final outDir = outFile.parent;
      if (!outDir.existsSync()) outDir.createSync(recursive: true);
      outFile.writeAsStringSync(_toXml(decoded));
    }
  }
}
