import 'dart:html';

class Naamstam {
  String betekenis, herkomst, voorbeelden;
  List<String> nederlandseVormen, oudNederlandseVormen;
  bool isMannelijk = false;
  bool isVrouwelijk = false;
  bool isEerste = false;
  bool isZelfstandig = false;

  List<String> getVervoeging(bool isEerste) {

  }

  get asMap => {
    'n': nederlandseVormen,
    'o': oudNederlandseVormen,
    'b': betekenis,
    'h': herkomst,
    'v': voorbeelden,
  };

  static filter(Object o, List<String> terms, Map filters) {
    var naamstam = (o as Naamstam);
    return
      // no query
      (terms.isEmpty && filters.isEmpty)
      ||
      // or the data should contain at least one query term
      (terms.isNotEmpty && terms.any((term) => naamstam.toString().contains(term))
      // and if there are filters, then check those
      ||
      (filters.isNotEmpty && filters.keys.every((k) => naamstam.asMap[k].toString().contains(filters[k]))
      )
      );
  }

  toString() =>
  '\n${nederlandseVormen.join(', ')} ${oudNederlandseVormen.join(', ')},'+
  '${(betekenis != null ? ' `$betekenis`' : '')} $herkomst - $voorbeelden';
}

Naamstam parseNaamstam(ParagraphElement p) {
  var matcher = new RegExp(r'(.*) \[(.*)\] (?:[\w ]*‘([^’]+)’)?(?:[, ]+)?(.*) – (.*)');
  var match = matcher.firstMatch(p.text.replaceAll('\n', ' '));
  return new Naamstam()
    ..nederlandseVormen = p.children.first.text.split(',').map((e) => e.trim()).toList()
    ..oudNederlandseVormen = p.children.firstWhere((el) => el.nodeName == 'I').text.split(',').map((e) => e.trim()).toList()
    ..betekenis = match.group(3)
    ..herkomst = match.group(4)
    ..voorbeelden = match.group(5)
    ..isMannelijk = match.group(5).contains('mannelijk')
    ..isVrouwelijk = match.group(5).contains('vrouwelijk')
    ..isEerste = match.group(5).contains('eerste')
    ..isZelfstandig = match.group(5).contains('zelfstandig')
    ;
}

List<Naamstam> parseNaamstammen(List<String> lines) {
  var matcher = new RegExp(r'(.*) \[(.*)\] (?:[\w ]*‘([^’]+)’)?(?:[, ]+)?(.*) – (.*)');
//  var matcher = new RegExp(r'(.*) \{(.*)\} \[(.*)\] (?:[\w ]*‘([^’]+)’)?(?:[, ]+)?(.*) – (.*)');
  var naamstammen = [];
  lines.forEach((line) {
    var match = matcher.firstMatch(line);

    if(match != null) {
      naamstammen.add(new Naamstam()
        ..nederlandseVormen = match.group(1).split(',').map((s) => s.trim()).toList()
        ..oudNederlandseVormen = match.group(2).split(',').map((s) => s.trim()).toList()
        ..betekenis = match.group(3)
        ..herkomst = match.group(4)
        ..voorbeelden = match.group(5)
        ..isMannelijk = match.group(5).contains('mannelijk')
        ..isVrouwelijk = match.group(5).contains('vrouwelijk')
        ..isEerste = match.group(5).contains('eerste')
        ..isZelfstandig = match.group(5).contains('zelfstandig')
      );
    }
  });
  return naamstammen;
}

List<Naam> parseNamen(List<ParagraphElement> lines, bool isMannelijk) {
  var wordMatcher = new RegExp(r'‘([^’]*)’');
  var nevenVormen = {};
  var koosNamen = <String, List>{};
  var result = <Naam>[];

  lines.forEach((ParagraphElement line) {

    var namen = line.firstChild.text.split(',').map((e) => e.trim()).toList();

    if(line.text.contains('nevenvorm ')) {

      var Is = line.children.where((c) => c.nodeName == 'I');
      var vanVorm = Is.length > 1 ? Is.elementAt(1).text : Is.first.text;
      if(!nevenVormen.containsKey(vanVorm))
        nevenVormen[vanVorm] = [];
      nevenVormen[vanVorm].addAll(namen);

    } else {

      List dus = wordMatcher.allMatches(line.text).toList();

      var betekenis = null;
      if(dus.isEmpty && line.text.contains('brabbelnaam'))
        betekenis = 'brabbelnaam voor verwanten, ontstaan in de kindertaal';
      else if(dus.length == 3)
        betekenis = '${dus[2].group(1)} (${dus[0].group(1)} + ${dus[1].group(1)})';
      else
        betekenis = dus.map((m) => m.group(1)).join('; ');

      // parse koosnamen
      line.childNodes
        .skipWhile((c) => !c.text.contains('koosvorm'))
        .where((c) => c.nodeName == 'I' && !c.text.contains(new RegExp(r'-.-')))
        .fold([], (p, el) => p..addAll(el.text.split(new RegExp('[,/]')).map((e) => e.trim())))
        .forEach((v) {
          if(!koosNamen.containsKey(v))
            koosNamen[v] = [];
          koosNamen[v].addAll(namen);
      });

      List<String> naamstammen = line.childNodes
        .takeWhile((c) => !c.text.contains(new RegExp('(nevenvormen|koosvorm|ook|;)')))
        .where((c) => c.nodeName == 'I')
        .skip(1)
        .fold([], (p, el) => p..add(el.text.split(new RegExp('[,/]')).first.trim()))
        .toList();

      if(betekenis != '') {
        result.add(new Naam()
          ..vormen = namen
          ..naamstammen = naamstammen
          ..koosnamen = new Set()
          ..isMannelijk = isMannelijk
          ..betekenis = betekenis
        );
      }
  }
  });
  nevenVormen.forEach((k, v) {
    var naam = result.firstWhere((n) => n.vormen.contains(k), orElse:()=>null);
    if(naam != null)
      naam.vormen.addAll(v);
    else
      print('error $k $v');
  });
  koosNamen.forEach((k,v) {
    var regExp = new RegExp(k.replaceAll('-', '.*'));
    var namen = result.where((n) => n.vormen.any((i) => i.contains(regExp)));

    namen.forEach((naam) => naam.koosnamen.addAll(v));

    if(namen.isEmpty)
      print('error $k $v');
  });
  return result;
}

class Naam {
  List<String> vormen;
  String get hoofdVorm => vormen.first;
  List<String> naamstammen;
  Set<String> koosnamen;
  bool isMannelijk;
  String betekenis;
  toString() => vormen.join(' ') +' '+ naamstammen.join(' ') + ' ' + koosnamen.join(' ') + ' ' + betekenis;
}