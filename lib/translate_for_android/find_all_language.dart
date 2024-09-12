import 'dart:convert';
import 'dart:io';

void main() {
  final rootDirPath = "translate_for_android";
  final dir = Directory("lib/$rootDirPath/file");
  final dirs = dir.listSync();
  final listLang = [];
  for (final dir in dirs) {
    if (dir is Directory) {
      final dirName = dir.path.replaceAll("\\", "/").split("/").last;
      if(dirName == "values" || !dirName.startsWith("values-")) continue;
      listLang.add(dirName.replaceAll("values-", "").replaceAll("-r", "-"));
    }
  }
  final r= jsonEncode(listLang);
  final file = File("lib/$rootDirPath/file/target_lang.json");
  if(!file.parent.existsSync()){
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(r);
}
