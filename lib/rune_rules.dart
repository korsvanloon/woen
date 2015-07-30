import 'package:polymer/polymer.dart';
import 'package:woen/keychar.dart';
import 'package:core_elements/core_dropdown.dart';

@CustomTag('rune-rules')
class RuneRules extends PolymerElement {
  RuneRules.created() : super.created();

  @observable List<Rule> ruleList = toObservable([]);
  @observable List numerals;

  attached() {
    super.attached();
    ruleList = toObservable(rules);
    numerals = toObservable(numeralMap.keys.map((k) => {
      'numeral': k,
      'sound': numeralMap[k],
      'stave': '-'
    }).toList());
    var button = shadowRoot.querySelector('paper-icon-button');
    var dropdown = shadowRoot.querySelector('core-dropdown') as CoreDropdown;

    button.onClick
    .listen((e) {
      dropdown.toggle();
    });
  }

  chop(List l) {
    return [l.getRange(0, (l.length/2).floor()), l.getRange((l.length/2).floor(), l.length)];
  }

  emphasized(Rule rule) {
    return rule.examples[0].split(rule.regExp.firstMatch(rule.examples[0]).group(1));

//    rule.examples.map((example) {
////      example.split(rule.pattern);
//      return example.replaceAllMapped(rule.pattern, (Match m) => m.group(0).replaceFirst(m.group(1), '<em>${m.group(1)}</em>'));
////      example.replaceAllMapped(rule.pattern, '<em>${rule.}');
//    });
  }
}
