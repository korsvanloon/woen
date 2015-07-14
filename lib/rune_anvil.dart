import 'package:polymer/polymer.dart';
import 'package:woen/keychar.dart';
import 'package:stream_ext/stream_ext.dart';
import 'package:browser_detect/browser_detect.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'dart:html';
import 'dart:async';

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

  attached() {
    super.attached();
    keyboard = toObservable(keyboardCodes);
    languages = [
      new Language('Elder Futhark', elderFuthark),
      new Language('Anglo Futhorc', angloFuthorc),
      new Language('Younger Futhark', youngerFuthark),
      new Language('Medieval Runes', medievalRunes),
    ];
    language = languages.first;
  }

  useCustomCaret(TextAreaElement inputElement) {
    var caret = inputElement.parent.querySelector('.caret') as SpanElement;

    inputElement.onFocus.listen((_) => caret.style.display = 'inline');
    inputElement.onBlur.listen((_) => caret.style.display = 'none');

    var direction$ = inputElement.onKeyDown
    .where((e) => [KeyCode.LEFT, KeyCode.RIGHT, KeyCode.UP, KeyCode.DOWN].contains(e.keyCode));

    [inputElement.onInput, direction$, inputElement.onClick, inputElement.onSelectStart]
    .reduce(StreamExt.merge)
    .listen((e) {
      var adjustX = -1;
      if (e.type == 'keydown' && e.keyCode == KeyCode.LEFT && inputElement.selectionStart != 0) {
        adjustX = -2;
      } else if (e.type == 'keydown' && e.keyCode == KeyCode.RIGHT && inputElement.selectionStart != inputElement.value.length) {
        adjustX = 0;
      }

      var adjustY = 0;
      var row = (inputElement.selectionStart / 24).floor();
      if (e.type == 'keydown' && e.keyCode == KeyCode.UP && row != 0) {
        adjustY = -1;
      } else if (e.type == 'keydown' && e.keyCode == KeyCode.DOWN && row != (inputElement.value.length / 24).floor()) {
        adjustY = 1;
      }
      caret.style.left = '${((inputElement.selectionStart % 23) + adjustX) * 14.4 + 34}px';
      caret.style.top = '${(row + adjustY) * 25 + 16 - inputElement.scrollTop}px';
    });
  }

  subscribeToKeyboard(DivElement keyboardDiv) {
    return keyboardDiv.querySelectorAll("paper-button")
    .map((k) => k.onClick.map((e) => k.id))
    .reduce(StreamExt.merge)
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

    var languageChoser = keyboardDiv.querySelector('select') as SelectElement;

    languageChoser.onChange.listen((e) {
      var languageName = languageChoser.selectedOptions.first.value;
      language = languages.firstWhere((l) => l.name == languageName);
      keyCodeSubscription.cancel();
      keyboard = toObservable(keyboardCodes);
      input = '';
      new Timer(new Duration(milliseconds:100), () {
        keyCodeSubscription = subscribeToKeyboard(keyboardDiv);
      });
    });
  }

  prepareInput(TextAreaElement inputElement) {
    var translationElement = inputElement.parent.querySelector('.translation') as TextAreaElement;
    inputElement.spellcheck = false;
    translationElement.spellcheck = false;


    inputElement.onKeyPress // filter
    .where((e) => e.which == KeyCode.ENTER
    || (!_isValid(e) && ![KeyCode.BACKSPACE, KeyCode.LEFT, KeyCode.UP, KeyCode.DOWN, KeyCode.RIGHT].contains(e.keyCode)))
    .listen((e) => e.preventDefault());

    inputElement.onKeyPress // highlight
    .where(_isValid)
    .listen((e) {
      var code = charToCode(new String.fromCharCode(e.which), keyboards[keyboardChoice]);
      var button = shadowRoot.querySelector('#$code') as PaperButton;
      button.className = 'highlight';
    });

    inputElement.onKeyUp // remove highlight
    .listen((e) {
      if (shadowRoot.querySelector('.highlight') != null)
        shadowRoot.querySelector('.highlight').classes.remove('highlight');
    });

    inputElement.onScroll // sync scrolling
    .listen((e) {
      translationElement.scrollTop = inputElement.scrollTop;
    });

    var buttons = inputElement.parent.querySelectorAll('core-icon-button');

    StreamExt.merge(
        inputElement.onKeyPress.where((e) => e.which == KeyCode.C && (e.ctrlKey || e.metaKey)),
        buttons.first.onClick
    ).listen((UIEvent e) {
      e.preventDefault();

      if(!browser.isChrome) {
        var dialog = shadowRoot.querySelector('paper-dialog') as PaperDialog;
        dialog.open();
        var dialogInput = dialog.querySelector('input') as InputElement;
        new Timer(new Duration(milliseconds:100), () {
          dialogInput.value = translationElement.value;
          dialogInput.select();
        });
      }
      else {
        translationElement.select();
        document.execCommand('copy', null, null);
        translationElement.blur();
      }
    });
  }

  domReady() {
    super.domReady();

    var phoneticInput = shadowRoot.querySelector('#phonetics .input') as TextAreaElement;
    var runesInput = shadowRoot.querySelector('#runes .input') as TextAreaElement;

    prepareInput(phoneticInput);
    prepareInput(runesInput);

    prepareKeyboard(shadowRoot.querySelector('#keyboard') as DivElement);

    if(browser.isFirefox) {
      useCustomCaret(phoneticInput);
      useCustomCaret(runesInput);
    }

    if(TouchEvent.supported) {
      phoneticInput.disabled = true;
      runesInput.disabled = true;
      shadowRoot.querySelector('#keyboard-choice').hidden = true;
    }

  }

  Rune findRune(String key) {
    return language.characters.firstWhere((c) => c.keyChar == key, orElse:() => null);
  }

  String translateText(String text, [hint=false]) {
    if (language == null) return '';
    return text.split('').map((char) {
      var rune = findRune(charToCode(char, keyboards[keyboardChoice]));
      return hint ? rune.sound : rune.stave;
    }).join();
  }

  bool _isValid(e) {
    var char = new String.fromCharCode(e.which);
    var inKeyboard = findRune(charToCode(char, keyboards[keyboardChoice])) != null;
    return inKeyboard;
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
