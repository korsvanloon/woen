// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_selector.dart';
import 'package:woen/naamstam.dart';

class Betekenis {
  String term;
  int populariteit;
//  bool eerste, tweede;
}

@CustomTag('main-app')
class MainApp extends PolymerElement {
  MainApp.created() : super.created();

  @observable int selected = 0;

  @observable List<Naamstam> naamstammen = toObservable([]);
  @observable List<Betekenis> betekenissen = toObservable([]);
  @observable List<Betekenis> namen = toObservable([]);
  @observable int selectedNaamstam = 0;
  @observable List<Naamstam> keuzes;
  @observable String search = '';

  @observable List<String> suggesties = toObservable([]);

  refreshSuggesties() {
    return keuzes == null || keuzes.contains(emptyNaamstam)
      ? toObservable([])
      : toObservable(vrouwelijkeNamen.firstWhere((n)
        => n.naamstammen.contains(keuzes.first.nederlandseVormen.first.toLowerCase())
        && n.naamstammen.contains(keuzes.last.nederlandseVormen.first.toLowerCase())
    ));
  }

  @observable List<Naam> vrouwelijkeNamen = toObservable([]);
  @observable List<Naam> mannelijkeNamen = toObservable([]);
  Naamstam emptyNaamstam;
  List<Naamstam> _naamstammen = [];


  attached() async {
    super.attached();

//    vrouwelijkeNamen.addAll(await getNamen('vrouwelijke_namen.html', isMannelijk:false));
//    mannelijkeNamen.addAll(await getNamen('mannelijke_namen.html', isMannelijk:true));

//    initNaamkunst();
  }
  initNaamkunst() async {

    emptyNaamstam = new Naamstam()..nederlandseVormen = ['_'];
    keuzes = toObservable([emptyNaamstam, emptyNaamstam]);

    var string = await HttpRequest.getString('naamstammen');
    _naamstammen = toObservable(parseNaamstammen(string.split('\n')));
    naamstammen = toObservable(_naamstammen.where((n) => n.isEerste || n.isZelfstandig).toList());
  }


  chop(amount) => (list) => toObservable(new List.generate(amount, (i)=>i).map((i)
    => list.getRange(i*(list.length/amount).floor(), (i+1)*(list.length/amount).floor())));

  getNamen(String fileName, {isMannelijk: false}) async {
    var string = await HttpRequest.getString(fileName);
    var div = new Element.html(string);

    return parseNamen(div.children.where((c)
      => c is ParagraphElement).map((c)
      => c as ParagraphElement).toList(), isMannelijk);
  }

  changeNaamstammen(Event a, b, CoreSelector c) {
    if(b['isSelected']) {
      if(c.selectedIndex == 1) {
        naamstammen = _naamstammen.where((n) => n.isEerste || n.isZelfstandig).toList();
      } else {
        naamstammen = _naamstammen.where((n) => n.isMannelijk || n.isVrouwelijk).toList();
      }
    }
    refreshSuggesties();
  }
  chooseNaamstam(Event e, b, c) {
    if(b['isSelected']) {
      keuzes[selectedNaamstam] = c.selection;
    }
  }

  filter(String search) {
    return (items) {
      var terms = search.split(' ');
      var result = items.where((item) =>
      (terms.isEmpty)
      ||
      (terms.isNotEmpty && terms.any((term) => item.toString().toLowerCase().contains(term))
      )).toList();
      return toObservable(result);
    };
  }
//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanges(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).

}