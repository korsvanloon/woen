import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('rune-message')
class RuneMessage extends LIElement with Polymer, Observable {
  @published String message;

  factory RuneMessage() => new Element.tag('li', 'rune-message');
  RuneMessage.created() : super.created() { polymerCreated(); }

  destroyAction() {
    fire('td-destroy-item', detail: message);
  }
}
