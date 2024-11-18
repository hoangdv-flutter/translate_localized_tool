import 'dart:io';

import 'package:online_google_translator/expose.dart';
import 'package:xml/xml.dart';

void main(){
  final dirPath = "translate_for_android";
  final dirRoot = Directory("lib/$dirPath/file");
  var count = 0;
  final data = <String, List<String>>{};
  for(final dir in dirRoot.listSync()){
    if(dir is Directory){
      final xml = XmlDocument.parse(File(dir.path+"/strings.xml").readAsStringSync());
      printCyan("found at ${dir.path.split('/').last}");
      final elements = xml.findAllElements("string");
      var found = false;
      final list = <String>[];
      for(final e in elements){
        final key = e.getAttribute("name");
        if(key == "str_premium_txt_2"){
          list.add(e.getAttribute("name")!);
          found = true;
          printGreen("key match: ${e.getAttribute("name")}");
        }
      }
      if(found) count++;
    }
  }
  printYellow("found in $count files");
}