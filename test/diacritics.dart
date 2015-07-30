import 'package:woen/keychar.dart';
import 'dart:convert';

main() {

  var paragraph = "hallo; ik ben kors: de grote! of niet dan?";
  print(replaceInterpunction(paragraph));
}

removeDiacritics(String str) {
  return str.replaceAllMapped(new RegExp('[^\u0000-\u007E]'), (match) => diacriticsMap[match.toString()]);
}