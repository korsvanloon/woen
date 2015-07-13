import 'package:polymer/polymer.dart';
import 'package:woen/keychar.dart';
import 'package:stream_ext/stream_ext.dart';
import 'package:browser_detect/browser_detect.dart';
import 'dart:html';

@CustomTag('rune-anvil')
class RuneAnvil extends PolymerElement {
  RuneAnvil.created() : super.created();

  @observable var keyboard;
  @observable Language language;
  @observable List<Language> languages;
  @published String input = '';
  @observable bool showHint = false;

  attached() {
    super.attached();
    keyboard = toObservable(keyboardCharacters.map((e) => e.split('')));
    languages = [
      new Language('Elder Futhark', elderFuthark),
      new Language('Anglo Futhorc', angloFuthorc),
      new Language('Younger Futhark', youngerFuthark),
      new Language('Medieval Runes', medievalRunes),
    ];
    language = languages.first;
  }



  ready() {
    super.ready();

    var input = shadowRoot.querySelector('#rune-input') as TextAreaElement;
    input.onKeyPress.where((e) => e.charCode == KeyCode.ENTER
      || (KeyCode.isCharacterKey(e.charCode) && !_isValid(e))).listen((e) {
      e.preventDefault();
    });

    input.onKeyPress.where((e) => _isValid(e)).listen((e) {
      if(shadowRoot.querySelector('.highlight') != null)
        shadowRoot.querySelector('.highlight').classes.remove('highlight');
      var key = safe(new String.fromCharCode(e.keyCode));
      shadowRoot.querySelector('#key$key').classes.add('highlight');
    });
    if(browser.isFirefox) {
      var caret = shadowRoot.querySelector('#caret') as SpanElement;
      input.onFocus.listen((_) => caret.style.display = 'inline');
      input.onBlur.listen((_) => caret.style.display = 'none');
      var direction$ = input.onKeyDown.where((e) => [KeyCode.LEFT, KeyCode.RIGHT, KeyCode.UP, KeyCode.DOWN].contains(e.keyCode));
      StreamExt.merge(input.onInput, StreamExt.merge(direction$, StreamExt.merge(input.onClick, input.onSelectStart)))
      .listen((e) {
        print(e.type);
        var adjustX = -1;
        if(e.type == 'keydown' && e.keyCode == KeyCode.LEFT && input.selectionStart != 0) {
          adjustX = -2;
        } else if(e.type == 'keydown' && e.keyCode == KeyCode.RIGHT && input.selectionStart != input.value.length) {
          adjustX = 0;
        }

        var adjustY = 0;
        var row = (input.selectionStart / 24).floor();
        if(e.type == 'keydown' && e.keyCode == KeyCode.UP && row != 0) {
          adjustY = -1;
        } else if(e.type == 'keydown' && e.keyCode == KeyCode.DOWN && row != (input.value.length / 24).floor()) {
          adjustY = 1;
        }
        caret.style.left = '${((input.selectionStart % 24)+adjustX) * 14.4 + 34}px';
        caret.style.top = '${(row+adjustY)*32 + 20 - input.scrollTop}px';
      });
    }
    input.onScroll.listen((e) {
      shadowRoot.querySelector('#rune-hint').scrollTop = input.scrollTop;
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
      var rune = language.characters.firstWhere((r) => r.keyChar == char, orElse:() => null);
      return hint ? rune.sound : rune.stave;
    }).join();
  }

  bool _isValid(KeyboardEvent e) {
    var ke = new KeyEvent.wrap(e);
    var charCode = ke.charCode;
//    var char = new String.fromCharCode(charCode).toLowerCase();
    var char = new String.fromCharCode(charCode);
    var inKeyboard = language.characters.map((r) => r.keyChar).contains(char);
    return inKeyboard;
  }

  safe(key) => key == ',' ? 'comma'
  : key == '.' ? 'point'
  : key == ' ' ? 'space'
  : key == ';' ? 'semicolon'
  : key == '[' ? 'bracket'
  : key == '`' ? 'backquote'
  : key;
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
