// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:core_elements/core_selector.dart';
import 'package:woen/naamstam.dart';
import 'package:woen/keychar.dart';


class Betekenis {
  String term;
  int populariteit;
//  bool eerste, tweede;
}
class Language {
  Language(this.name, this.characters);
  final String name;
  List<KeyBoardChar> characters;
  List<List<KeyBoardChar>> keyboard;
}
class Translation {
  Translation(this.language, this.original, this.text);
  final Language language;
  String text;
  String original;
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

  @observable String runeInput = 'typ iets en het zal direct in middeleeuwse runen verschijnen';
  @observable bool showHint = false;

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

  @observable var keyboard;
  @observable Language language;
  @observable List<Language> languages;

  attached() async {
    super.attached();

//    vrouwelijkeNamen.addAll(await getNamen('vrouwelijke_namen.html', isMannelijk:false));
//    mannelijkeNamen.addAll(await getNamen('mannelijke_namen.html', isMannelijk:true));

//    initNaamkunst();
    initRunes();
  }
  initNaamkunst() async {

    emptyNaamstam = new Naamstam()..nederlandseVormen = ['_'];
    keuzes = toObservable([emptyNaamstam, emptyNaamstam]);

    var string = await HttpRequest.getString('naamstammen');
    _naamstammen = toObservable(parseNaamstammen(string.split('\n')));
    naamstammen = toObservable(_naamstammen.where((n) => n.isEerste || n.isZelfstandig).toList());
  }

  initRunes() {
    keyboard = toObservable(keyboardCharacters.map((e) => e.split('')));
    languages = [
      new Language('Elder Futhark', elderFuthark),
      new Language('Anglo Futhorc', angloFuthorc),
      new Language('Younger Futhark', youngerFuthark),
      new Language('Medieval Runes', medievalRunes),
    ];
    language = languages.first;
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
  ready() {
    super.ready();

    var input = (shadowRoot.querySelector('#rune-input') as TextAreaElement);
    input.onKeyPress.where((e) => !_isValid(e)).listen((e) {
      e.preventDefault();
    });
    input.onKeyPress.where((e) => _isValid(e)).listen((e) {
      if(shadowRoot.querySelector('.highlight') != null)
        shadowRoot.querySelector('.highlight').classes.remove('highlight');
      shadowRoot.querySelector('#'+new String.fromCharCode(e.keyCode)).classes.add('highlight');
    });

    var buttons = shadowRoot.querySelectorAll('#stave,#sound');
    buttons.forEach((b) {
      b.onClick.listen((e) {
        var disabled = b.disabled;
        b.disabled = !disabled;
        buttons.where((o) => o != b)
          .forEach((o) => o.disabled = disabled);
        showHint = !showHint;
      });
    });
    buttons.first.disabled = true;

    var languageChoser = shadowRoot.querySelector('select') as SelectElement;
    print(languageChoser);
    languageChoser.onChange.listen((e) {
      var languageName = languageChoser.selectedOptions.first.value;
      language = languages.firstWhere((l) => l.name == languageName);
      keyboard = new ObservableList.from(keyboardCharacters.map((c)=>c.split('')));
    });

  }

  Rune findRune(String key) {
    return language.characters.firstWhere((c) => c.keyChar == key, orElse:()=>null);
  }

  String translateText(String text, [hint=false]) {
    if(language == null) return '';
    return text.split('').map((char) {
      var rune = language.characters.firstWhere((r) => r.keyChar == char);
      return hint ? rune.sound : rune.stave;
    }).join();
  }

  bool _isValid(KeyboardEvent e) {
    var charCode = e.keyCode;
    var char = new String.fromCharCode(charCode).toLowerCase();
    var inKeyboard = language.characters.map((r) => r.keyChar).contains(char);
    return inKeyboard;
  }
}