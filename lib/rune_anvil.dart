import 'package:polymer/polymer.dart';
import 'package:woen/keychar.dart';
import 'package:stream_ext/stream_ext.dart';
import 'package:browser_detect/browser_detect.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_fab.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'dart:convert';

@CustomTag('rune-anvil')
class RuneAnvil extends PolymerElement {
  RuneAnvil.created() : super.created();

  @observable var keyboard;
  @observable Language language;
  @observable List<Language> languages;
  @published String input = '';
  @observable bool showHint = false;
  @observable int keyboardChoice = 0;
  List keyboards = [keyboardEn, keyboardDe, keyboardFr];
  StreamSubscription keyCodeSubscription;
  @observable int width = window.innerWidth;
  Storage storage;

  @observable get showPhonetics => showHint;

  ready() {
    super.ready();
    keyboard = toObservable(keyboardCodes);
    languages = [
      new Language('Elder Futhark', elderFuthark),
      new Language('Anglo Futhorc', angloFuthorc),
      new Language('Younger Futhark', youngerFuthark),
      new Language('Medieval Runes', medievalRunes),
    ];
    language = languages.first;
  }

  domReady() {
    super.domReady();

    storage = window.localStorage;

    prepareInput(shadowRoot.querySelector('#rune-translator') as DivElement);

    prepareKeyboard(shadowRoot.querySelector('#keyboard') as DivElement);

    prepareMessages();

    if(TouchEvent.supported) {
      shadowRoot.querySelector('#keyboard-choice').hidden = true;
      shadowRoot.querySelector('#rune-translator').attributes.remove('horizontal');
    }
  }

  destroyAction(Event e, var detail, Element target) {
    messages.remove(target.attributes['detail']);
  }

  void itemsChanged() {
    if (storage != null) {
      storage['messages'] = JSON.encode(messages);
    }
  }

  toggle(Event event, var detail, var target) {
    target.toggle();
  }

  take(int n) => (List l) => l.skip(max(0, l.length - n));

  @observable List<String> messages;
  void prepareMessages() {

    messages = toObservable(storage['messages'] == null ? [] : JSON.decode(storage['messages']));
    var sendButton = shadowRoot.querySelector('paper-fab') as PaperFab;
    sendButton.onClick
    .where((_) => input != '')
    .listen((e) {
      var text = input;
      messages.add(text);
      itemsChanged();
      input = '';
      new Timer(new Duration(milliseconds:10), () { // keyboard needs to be re-rendered first
        window.scrollTo(0, document.body.scrollHeight);
      });
    });
  }

  StreamSubscription subscribeToKeyboard(DivElement keyboardDiv) {
    return
    StreamExt.merge(
      keyboardDiv.querySelectorAll("paper-button")
      .map((k) => k.onClick.map((e) => k.id))
      .reduce(StreamExt.merge),
      keyboardDiv.onKeyPress
      .map((e) => charToCode(e.which))
      .where((c) => c != null)
    )
    .listen((code) {
      if (code == 'Backspace') {
        if (input.isNotEmpty)
          input = input.substring(0, input.length - 1);
      } else {
        var char = codeToChar(code, keyboards[keyboardChoice]);
        if (findRune(code) != null)
          input += char;
      }
    });
  }

  prepareKeyboard(DivElement keyboardDiv) {

    keyCodeSubscription = subscribeToKeyboard(keyboardDiv);

    var buttons = keyboardDiv.querySelectorAll('#stave,#sound');

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

    var languageChooser = keyboardDiv.querySelector('select') as SelectElement;

    languageChooser.onChange
    .listen((e) {
      var languageName = languageChooser.selectedOptions.first.value;
      language = languages.firstWhere((l) => l.name == languageName);
      keyCodeSubscription.cancel();
      keyboard = toObservable(keyboardCodes); // redraw keyboard
      input = '';

      new Timer(new Duration(milliseconds:100), () { // keyboard needs to be re-rendered first
        keyCodeSubscription = subscribeToKeyboard(keyboardDiv);
      });
    });
  }

  prepareInput(DivElement inputElement) {

    var spanCarets = shadowRoot.querySelectorAll('.caret');
    DoubleCaret caret = new DoubleCaret(spanCarets.first, spanCarets.last);

    inputElement.onClick
    .map((e) {
      var adjustedX = (e.page.x - inputElement.offsetLeft - 20) % (inputElement.clientWidth / 2);
      var exactX = (adjustedX / DoubleCaret.width).round();

      var adjustedY = e.page.y - inputElement.offsetTop-20;
      var exactY = (adjustedY / DoubleCaret.height).round();

      var x = exactX;
      var y = exactY;


      if(x < 0) x = 0;
      if(x > caret.columns) x = caret.columns;
      if(y < 0) y = 0;
      if(y > caret.rowHeight(input)) y = caret.rowHeight(input);
      if(y == caret.rowHeight(input) && x > input.length % caret.columns) {
        x = input.length % caret.columns;
      }
      return new Point(x, y);
    })
    .listen((p) {
      caret.position = p;
    });

    inputElement.onKeyDown
    .where((e) => [KeyCode.LEFT, KeyCode.UP, KeyCode.DOWN, KeyCode.RIGHT].contains(e.which))
    .listen((e) {
      e.preventDefault();
      switch(e.which) {
        case KeyCode.LEFT:
          if(caret.length == 0) break;
          caret.moveLeft();
          break;
        case KeyCode.RIGHT:
          if(caret.length == input.length) break;
          caret.moveRight();
          break;
        case KeyCode.UP:
          if(caret.position.y == 0) break;
          caret.moveUp();
          break;
        case KeyCode.DOWN:
          if(caret.position.y == (input.length / caret.columns).floor()) break;
          caret.moveDown();
          if(caret.position.x > input.length % caret.columns)
            caret.position = new Point(input.length % caret.columns, caret.position.y);
          break;
      }
    });

    inputElement.onKeyDown
    .where((e) => e.keyCode == KeyCode.BACKSPACE && input.isNotEmpty)
    .listen((e) {
      e.preventDefault();

      var selectionStart = 0, selectionEnd = 0;

      if(browser.isChrome) {
        selectionStart = shadowRoot.getSelection().anchorOffset;
        selectionEnd = shadowRoot.getSelection().focusOffset;
      }

      if(selectionStart != selectionEnd) {
        if(selectionStart < selectionEnd)
          input = input.replaceRange(selectionStart, selectionEnd, '');
        else
          input = input.replaceRange(selectionEnd, selectionStart, '');

        caret.position = new Point(selectionStart % caret.columns, (selectionStart / caret.columns).floor());
      }
      else {
        input = input.replaceFirst(new RegExp('.'), '', caret.length-1);
        caret.moveLeft();
      }
    });

    inputElement.onKeyPress // highlight & input
    .map((e) => e..preventDefault())
    .map((e) => new String.fromCharCode(e.which))
    .where(_isValid)
    .listen((char) {
      var code = charToCode(char, keyboards[keyboardChoice]);
      var button = shadowRoot.querySelector('#$code') as PaperButton;
      button.className = 'highlight';
      input = input.replaceFirst('', char, caret.length);
      caret.moveRight();
    });

    inputElement.onKeyUp // remove highlight & input
    .listen((e) {
      if (shadowRoot.querySelector('.highlight') != null)
        shadowRoot.querySelector('.highlight').classes.remove('highlight');
    });

    var copyInput = shadowRoot.querySelector('input');
    var alert = shadowRoot.querySelector('.alert');
    var doneButton = shadowRoot.querySelector('.done');

    inputElement.onPaste
    .listen((e) {
      var text = e.clipboardData.getData('text');
      if(_isStavic(text)) {
        input = input.replaceFirst('', translateStaveToInput(text), caret.length);
      } else if(_isPhonetic(text)) {
        input = input.replaceFirst('', translatePhoneticToInput(text), caret.length);
      } else {
        alert.text = '<- Gebruik het input veld hier links om Nederlandse tekst te kopiëren.';
        alert.style.display = 'block';
      }
    });

    [copyInput.onKeyUp.where((e) => e.which == KeyCode.ENTER), doneButton.onClick]
    .reduce(StreamExt.merge)
    .listen((e) {
      var text = removeUnsupportedCharacters(replaceNumerals(replaceInterpunction(replaceDiacritics(copyInput.value.toLowerCase()))));

      // apply rules
      var result = rules.fold(text, (String p, c) {
        return p.replaceAllMapped(c.regExp, (Match m) => m.group(0).replaceFirst(m.group(1), c.sound));
      });
      alert.text = '';
      alert.style.display = 'none';

      try {
        input = translatePhoneticToInput(result);
      } catch(e) {
        alert.text = 'Ik kan deze tekst niet converteren. Probeer eerst speciale karakters en leestekens te verwijderen.';
      }
      copyInput.value = '';
    });

  }

  void destroyItemAction(e, detail) {
    messages.remove(detail);
  }

  bool _isStavic(String text) {
    return text.split('').every((char) => language.characters.any((rune) => rune.stave == char));
  }

  bool _isPhonetic(String text) {
    return text.split('').every((char) => language.characters.any((rune) => rune.sound == char));
  }

  Rune findRune(String key) {
    return language.characters.firstWhere((c) => c.keyChar == key, orElse:() => null);
  }

  String translatePhoneticToInput(String text) {
    return _translate(text, (rune) => rune.sound, (rune) => codeToChar(rune.keyChar, keyboards[keyboardChoice]));
  }

  String translateStaveToInput(String text) {
    return _translate(text, (rune) => rune.stave, (rune) => codeToChar(rune.keyChar, keyboards[keyboardChoice]));
  }

  String translateTextToPhonetic(String text) {
    return _translate(text, (rune) => codeToChar(rune.keyChar), (rune) => rune.sound);
  }

  String translateTextToStave(String text) {
    return  _translate(text, (rune) => codeToChar(rune.keyChar), (rune) => rune.stave);
  }

  String _translate(String text, from, to) {
    if (language == null) return '';
    return text.split('').map((char) {
      var rune = language.characters.firstWhere((rune) => from(rune) == char, orElse:() => null);
      return to(rune);
    }).join();
  }

  bool _isValid(char) {
    return findRune(charToCode(char, keyboards[keyboardChoice])) != null;
  }
}

class DoubleCaret {
  DoubleCaret(element1, this.element2) :
    this.element1 = element1,
    this.columns = ((element1.parent.clientWidth - 2*margin) / width).floor()
  ;
  SpanElement element1, element2;
  Point _position = new Point(0,0);
  static double width = 14.4;
  static int height = 24;
  final int columns;
  static int margin = 20;

  int get length => _position.x + _position.y*columns;

  set position(Point p) {
    element1.style.left = '${p.x * width + margin}px';
    element1.style.top = '${p.y * height + margin}px';
    element2.style.left = '${p.x * width + margin}px';
    element2.style.top = '${p.y * height + margin}px';
    _position =  p;
  }
  get position => _position;

  int rowHeight(String text) => (text.length / columns).floor();

  moveLeft() {
    if(_position.y > 0 && _position.x == 0 )
      position = new Point(columns, _position.y - 1);
    else
      position = new Point(_position.x-1, _position.y);
  }
  moveRight() {
    if(_position.x == columns-1)
      position = new Point(0, _position.y+1);
    else
      position = new Point(_position.x+1, _position.y);
  }
  moveUp() {
    position = new Point(_position.x, _position.y-1);
  }
  moveDown() {
    position = new Point(_position.x, _position.y+1);
  }
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
