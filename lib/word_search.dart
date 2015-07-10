import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:woen/naamstam.dart';
import 'package:core_elements/core_list_dart.dart';

@CustomTag('word-search')
class WordSearch extends PolymerElement {
  @published List<Naamstam> data = toObservable([]);
  @observable String search = '';
  @observable int filteredLength = 0;

  get selection => (shadowRoot.querySelector('core-list-dart') as CoreList).selection;

  WordSearch.created() : super.created();

  @override
  attributeChanged(name, oldvalue, newValue) {
    super.attributeChanged(name, oldvalue, newValue);
  }

  get filtered => filter(search)(data);

  filter(String search) => (items) {
    var w = search.split(' ');
    var terms = w.where((e) => !e.contains(":")).toList();
    var filters = new Map.fromIterable(w.where((e) => e.contains(":")),
      key:(i) => i.split(':')[0],
      value:(i) => i.split(':')[1]
    );
    var result = items.where((naamstam) =>
      // no query
      (terms.isEmpty && filters.isEmpty)
      ||
      // or the data should contain at least one query term
      (terms.isNotEmpty && terms.any((term) => naamstam.toString().contains(term))
      // and if there are filters, then check those
      ||
      (filters.isNotEmpty && filters.keys.every((k) => naamstam.asMap[k].toString().contains(filters[k]))
      )
    )).toList();
    filteredLength = result.length;
    return toObservable(result);
  };
}
