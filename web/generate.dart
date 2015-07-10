import 'package:woen/naamstam.dart';
//import 'dart:io';
import 'dart:convert';
import 'dart:html';


main() async {
  var string = await HttpRequest.getString('naamstammen.html');
  var div = new Element.html(string);
  var naamstammen = div.children.where((c) => c is ParagraphElement).map(parseNaamstam).toList();
  var nlVormen = naamstammen.map((ns) => ns.nederlandseVormen).reduce((v, e) => v..addAll(e)).toSet().toList();
  print(JSON.encode(nlVormen));
}