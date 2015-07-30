import 'package:polymer/polymer.dart';
import 'package:woen/keychar.dart';
import 'package:stream_ext/stream_ext.dart';
import 'package:browser_detect/browser_detect.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_fab.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';

@CustomTag('flip-card')
class FlipCard extends PolymerElement {
  FlipCard.created() : super.created();
  DivElement get card => shadowRoot.querySelector('#card');
  @observable bool flipped = false;

  toggle() => flipped = !flipped;

  domReady() {
    onClick.listen((_) => toggle());
  }

}