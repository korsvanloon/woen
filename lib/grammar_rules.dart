library woen.library_rules;

typedef String GrammarRule(String s);

List<GrammarRule> rules = [
  // special cases
  (String s) => s == 'diede' ? 'det' : s,
  (String s) => s == 'roed' ? 'roe' : s,
  (String s) => s == 'adel' ? 'al' : s,
  (String s) => s == 'hilde' ? 'hil' : s,
  (String s) => s == 'kunne' ? 'keune' : s,
  (String s) => s == 'saks' ? 'sas' : s,
  (String s) => s == 'vaart' ? 'ferde' : s,
  (String s) => s == 'weern' ? 'weren' : s,
  // remove specific last characters
  (String s) => s.replaceFirst(new RegExp(r'[gei]'), '', s.length-2),
  // shorten vowels
  (String s) => s.replaceFirstMapped(new RegExp(r'.*([iueoa])[jieoa].'), (m) => ''),
  // special endings
  (String s) => s.replaceFirst(new RegExp(r'uw'), '', s.length-3),
  (String s) => s.replaceFirst(new RegExp(r'nig'), 'ne', s.length-4),
  // first characters
  (String s) => s.replaceFirst(new RegExp(r'^v'), 'f'),
  (String s) => s.replaceFirst(new RegExp(r'^z'), 's'),
];

List<GrammarRule> koosNaamRules = [
// -s-, -z-, -ts- achtervoegsel waarmee koosnamen worden gevormd – in namen als Eelze, Meinze en Reinze
// -l- verkleinend achtervoegsel waarmee koosnamen werden gevormd – in namen als Andele en Goedele
// -k- verkleinend achtervoegsel waarmee koosnamen worden gevormd – in namen als Geveke, Meinke, Sipke en Willeke
];


String applyRules(String s) {
  return rules.fold(s, (v, rule) => rule(v));
}
