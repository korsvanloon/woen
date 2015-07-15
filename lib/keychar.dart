library keychar;

abstract class KeyBoardChar {
  String stave;
  String keyChar;
  String sound;
}

class LatinChar implements KeyBoardChar {
  LatinChar(char) : this.keyChar = char, this.stave = char, this.sound = char;

  String stave, keyChar, sound;
}

class Rune implements KeyBoardChar {
  Rune(this.sound, this.stave, this.keyChar, [this.name, this.nameTranslation, this.meaning]);

  String sound;
  String stave;
  String keyChar;
  String name;
  String nameTranslation;
  String meaning;

  toString() => stave;
}

const staves = "ᚪᚫᛉᚨᛒᛍᛣᛤᚳᛢᛑᛞᛛᛀᛔᛂᛠᛖᚶᚧᚠᚵᚸᚷᛄᚻᚺᛨᛝᛜᛡᛁᛇᛃᚴᚲᛚᛅᚼᛘᚬᛦᛗᚾᚮᚯᚰᛕᚩᛟᛈᛩᚱᛆᛓᚽᛙᚿᚭᛌᛐᛧᛋᛊᛥᚦᛏᚢᚡᚥᚹᛪᚤᚣᛎ᛬᛫ᛮᛯᛰ᛭";

const keyboardEn = const[r"qwertyuiop[", r"asdfghjkl;'", r"zxcvbnm,.", r" "];
const keyboardDe = const[r"qwertzuiopü", r"asdfghjklöä", r"yxcvbnm,.", r" "];
const keyboardFr = const[r"azertyuiop^", r"qsdfghjklm'", r"wxcvbn,;:", r" "];

charToCode(char, [keyboard=keyboardEn]) {
  for (int i = 0; i < keyboard.length; i++) {
    for (int j = 0; j < keyboard[i].length; j++) {
      if (keyboard[i][j] == char) {
        return keyboardCodes[i][j];
      }
    }
  }
  return null;
}

codeToChar(code, [keyboard=keyboardEn]) {
  for (int i = 0; i < keyboard.length; i++) {
    for (int j = 0; j < keyboard[i].length; j++) {
      if (keyboardCodes[i][j] == code) {
        return keyboard[i][j];
      }
    }
  }
  return null;
}

var keyboardCodes = [
  ['KeyQ', 'KeyW', 'KeyE', 'KeyR', 'KeyT', 'KeyY', 'KeyU', 'KeyI', 'KeyO', 'KeyP', 'BracketLeft'],
  ['KeyA', 'KeyS', 'KeyD', 'KeyF', 'KeyG', 'KeyH', 'KeyJ', 'KeyK', 'KeyL', 'Semicolon', 'Quote'],
  ['KeyZ', 'KeyX', 'KeyC', 'KeyV', 'KeyB', 'KeyN', 'KeyM', 'Comma', 'Point'],
  ['Space']];

var latin = <LatinChar>[
  new LatinChar('q'),
  new LatinChar('w'),
  new LatinChar('e'),
  new LatinChar('r'),
  new LatinChar('t'),
  new LatinChar('y'),
  new LatinChar('u'),
  new LatinChar('i'),
  new LatinChar('o'),
  new LatinChar('p'),
  new LatinChar('['),
  new LatinChar(']'),
  new LatinChar('a'),
  new LatinChar('s'),
  new LatinChar('d'),
  new LatinChar('f'),
  new LatinChar('g'),
  new LatinChar('h'),
  new LatinChar('j'),
  new LatinChar('k'),
  new LatinChar('l'),
  new LatinChar(';'),
  new LatinChar("'"),
  new LatinChar(r'\'),
  new LatinChar('`'),
  new LatinChar('z'),
  new LatinChar('x'),
  new LatinChar('c'),
  new LatinChar('v'),
  new LatinChar('b'),
  new LatinChar('n'),
  new LatinChar('m'),
  new LatinChar(','),
  new LatinChar('.'),
  new LatinChar('/'),
];

var elderFuthark = <Rune>[
  new Rune('f', 'ᚠ', 'KeyF', 'fehu', 'vee', 'rijkdom'),
  new Rune('u', 'ᚢ', 'KeyU', 'uruz', 'oeros', 'wilskracht'),
  new Rune('þ', 'ᚦ', 'KeyV', 'thurisaz', 'deurs (reus)', 'instinctieve kracht'),
  new Rune('a', 'ᚨ', 'KeyA', 'ansuz', 'ans (god)', 'voorspoed, vitaliteit'),
  new Rune('r', 'ᚱ', 'KeyR', 'raidho', 'rit', 'groei, beweging'),
  new Rune('k', 'ᚲ', 'KeyK', 'kaunan', 'kanker (gezwel)', 'sterfelijkheid, pijn'),
  new Rune('g', 'ᚷ', 'KeyG', 'gebo', 'gift', 'vrijgevigheid'),
  new Rune('w', 'ᚹ', 'KeyW', 'wunjo', 'vreugde', 'lol, ecstase'),
  new Rune('h', 'ᚺ', 'KeyH', 'hagalaz', 'hagel', 'vernietiging, chaos'),
  new Rune('n', 'ᚾ', 'KeyN', 'naudhiz', 'nood', 'onvervulde wens, moeilijke situatie'),
  new Rune('i', 'ᛁ', 'KeyI', 'isa', 'ijs', 'stagnatie, stilstand'),
  new Rune('j', 'ᛃ', 'KeyJ', 'jera', 'jaar', 'oogst, beloning'),
  new Rune('ï', 'ᛇ', 'KeyY', 'eiwaz', 'ijf (taxus)', 'kracht, stabiliteit'),
  new Rune('p', 'ᛈ', 'KeyP', 'perdhro', 'perenboom', ''),
  new Rune('z', 'ᛉ', 'KeyZ', 'elhaz', 'eland', 'bescherming, verdediging'),
  new Rune('s', 'ᛊ', 'KeyS', 'sowulo', 'zon', 'succes, troost'),
  new Rune('t', 'ᛏ', 'KeyT', 'tiwaz', 'Tuw (een godheid)', 'overwinning, heil, eer'),
  new Rune('b', 'ᛒ', 'KeyB', 'berkana', 'berk', 'vruchtbaarheid, groei, voortduren'),
  new Rune('e', 'ᛖ', 'KeyE', 'ehwaz', 'edel dier (paard)', 'vertrouwen, betrouwbaarheid, gezelschap'),
  new Rune('m', 'ᛗ', 'KeyM', 'mannaz', 'mens', 'toename, ondersteuning'),
  new Rune('l', 'ᛚ', 'KeyL', 'laguz', 'laak (stroom, rivier)', 'vormloosheid, potentie, chaos'),
  new Rune('ŋ', 'ᛜ', 'KeyX', 'ingwaz', 'Ing (een godheid)', 'bevruchting, het begin, actualisatie van potentie'),
  new Rune('d', 'ᛞ', 'KeyD', 'dagaz', 'dag', 'hoop, blijdschap'),
  new Rune('o', 'ᛟ', 'KeyO', 'othala', 'oedel (erfgoed)', 'erfgoed, traditie, de adel'),

  new Rune('.', '᛭', 'Point', 'point'),
  new Rune(' ', '᛫', 'Space', 'space'),
  new Rune(',', '᛬', 'Comma', 'comma'),
];

var youngerFuthark = <Rune>[
  new Rune('f', 'ᚠ', 'KeyF', 'fe'),
  new Rune('u', 'ᚢ', 'KeyU', 'ur'),
  new Rune('þ', 'ᚦ', 'KeyV', 'thurs'),
  new Rune('ą', 'ᚬ', 'KeyA', 'as'),
  new Rune('r', 'ᚱ', 'KeyR', 'reidh'),
  new Rune('k', 'ᚴ', 'KeyK', 'kaun'),

  new Rune('h', 'ᚼ', 'KeyH', 'hagall'),
  new Rune('n', 'ᚾ', 'KeyN', 'naudhr'),
  new Rune('i', 'ᛁ', 'KeyI', 'isa'),
  new Rune('a', 'ᛅ', 'KeyJ', 'ar'),
  new Rune('s', 'ᛋ', 'KeyS', 'sol'),

  new Rune('t', 'ᛏ', 'KeyT', 'tyr'),
  new Rune('b', 'ᛒ', 'KeyB', 'bjarken'),
  new Rune('m', 'ᛘ', 'KeyM', 'madhr'),
  new Rune('l', 'ᛚ', 'KeyL', 'logr'),
  new Rune('ʀ', 'ᛦ', 'KeyY', 'yr'),

  new Rune('.', '᛭', 'Point', 'point'),
  new Rune(' ', '᛫', 'Space', 'space'),
  new Rune(',', '᛬', 'Comma', 'comma'),
];

var angloFuthorc = <Rune>[
  new Rune('f', 'ᚠ', 'KeyF', 'feoh'),
  new Rune('u', 'ᚢ', 'KeyU', 'ur'),
  new Rune('þ', 'ᚦ', 'KeyV', 'thorn'),
  new Rune('a', 'ᚪ', 'KeyA', 'ac'), //
  new Rune('r', 'ᚱ', 'KeyR', 'rad'),
  new Rune('k', 'ᚳ', 'KeyK', 'cen'),
  new Rune('g', 'ᚷ', 'KeyG', 'gyfu'),
  new Rune('w', 'ᚹ', 'KeyW', 'wyn'),

  new Rune('h', 'ᚻ', 'KeyH', 'haegl'),
  new Rune('n', 'ᚾ', 'KeyN', 'nyd'),
  new Rune('i', 'ᛁ', 'KeyI', 'is'),
  new Rune('j', 'ᛄ', 'KeyJ', 'ger'),
  new Rune('y', 'ᚣ', 'KeyY', 'yr'),
  new Rune('p', 'ᛈ', 'KeyP', 'peordh'),
  new Rune('x', 'ᛉ', 'KeyZ', 'eolh'),
  new Rune('s', 'ᛋ', 'KeyS', 'sigel'),

  new Rune('t', 'ᛏ', 'KeyT', 'tir'),
  new Rune('b', 'ᛒ', 'KeyB', 'beorc'),
  new Rune('e', 'ᛖ', 'KeyE', 'eh'),
  new Rune('m', 'ᛗ', 'KeyM', 'mann'),
  new Rune('l', 'ᛚ', 'KeyL', 'lagu'),
  new Rune('ŋ', 'ᛝ', 'KeyX', 'ing'),
  new Rune('d', 'ᛞ', 'KeyD', 'daeg'),
  new Rune('o', 'ᚩ', 'KeyO', 'os'),

  new Rune('ø', 'ᛇ', 'KeyZ', 'eoh'),
  new Rune('œ', 'ᛟ', 'KeyQ', 'ethel'),
  new Rune('æ', 'ᚫ', 'BracketLeft', 'aesc'), //
  new Rune('ô', 'ᛡ', 'Semicolon', 'ior'), //
  new Rune('å', 'ᛠ', "Quote", 'ear'), //

  new Rune('.', '᛭', 'Point', 'point'),
  new Rune(' ', '᛫', 'Space', 'space'),
  new Rune(',', '᛬', 'Comma', 'comma'),
];

//A	B	C	D	Ð	E	F	G	H	I	K	L	M	N	O	P	Q	R	S	T	U	V	W	X	Y	Z	Þ	Æ/Ä	Ø/Ö
//ᛆ	ᛒ	ᛍ	ᛑ	ᚧ	ᛂ	ᚠ	ᚵ	ᚼ	ᛁ	ᚴ	ᛚ	ᛘ	ᚿ	ᚮ	ᛔ ᛩ	ᚱ	ᛋ	ᛐ	ᚢ	ᚡ ᚥ	ᛪ	ᛦ ᛎ	ᚦ	ᛅ/ᛆ	ᚯ

var medievalRunes = <Rune>[
  new Rune('q', 'ᛩ', 'KeyQ'),
  new Rune('w', 'ᚥ', 'KeyW'),
  new Rune('e', 'ᛂ', 'KeyE'),
  new Rune('r', 'ᚱ', 'KeyR'),
  new Rune('t', 'ᛐ', 'KeyT'),
  new Rune('y', 'ᛦ', 'KeyY'),
  new Rune('u', 'ᚢ', 'KeyU'),
  new Rune('i', 'ᛁ', 'KeyI'),
  new Rune('o', 'ᚮ', 'KeyO'),
  new Rune('p', 'ᛔ', 'KeyP'),
  new Rune('þ', 'ᚦ', 'BracketLeft'),
  new Rune('a', 'ᛆ', 'KeyA'),
  new Rune('s', 'ᛋ', 'KeyS'),
  new Rune('d', 'ᛑ', 'KeyD'),
  new Rune('f', 'ᚠ', 'KeyF'),
  new Rune('g', 'ᚵ', 'KeyG'),
  new Rune('h', 'ᚼ', 'KeyH'),
  new Rune('ð', 'ᚧ', 'KeyJ'),
  new Rune('k', 'ᚴ', 'KeyK'),
  new Rune('l', 'ᛚ', 'KeyL'),
  new Rune('ä', 'ᛅ', 'Semicolon'),
  new Rune('ö', 'ᚯ', "Quote"),
  new Rune('z', 'ᛎ', 'KeyZ'),
  new Rune('x', 'ᛪ', 'KeyX'),
  new Rune('c', 'ᛍ', 'KeyC'),
  new Rune('v', 'ᚡ', 'KeyV'),
  new Rune('b', 'ᛒ', 'KeyB'),
  new Rune('n', 'ᚿ', 'KeyN'),
  new Rune('m', 'ᛘ', 'KeyM'),

  new Rune('.', '᛭', 'Point', 'point'),
  new Rune(' ', '᛫', 'Space', 'space'),
  new Rune(',', '᛬', 'Comma', 'comma'),
];

var runes = {'RUNIC LETTER AC A': 'ᚪ', 'RUNIC LETTER AESC': 'ᚫ', 'RUNIC LETTER ALGIZ EOLHX': 'ᛉ', 'RUNIC LETTER ANSUZ A': 'ᚨ', 'RUNIC LETTER BERKANAN BEORC BJARKAN B': 'ᛒ', 'RUNIC LETTER C': 'ᛍ', 'RUNIC LETTER CALC': 'ᛣ', 'RUNIC LETTER CEALC': 'ᛤ', 'RUNIC LETTER CEN': 'ᚳ', 'RUNIC LETTER CWEORTH': 'ᛢ', 'RUNIC LETTER D': 'ᛑ', 'RUNIC LETTER DAGAZ DAEG D': 'ᛞ', 'RUNIC LETTER DOTTED-L': 'ᛛ', 'RUNIC LETTER DOTTED-N': 'ᛀ', 'RUNIC LETTER DOTTED-P': 'ᛔ', 'RUNIC LETTER E': 'ᛂ', 'RUNIC LETTER EAR': 'ᛠ', 'RUNIC LETTER EHWAZ EH E': 'ᛖ', 'RUNIC LETTER ENG': 'ᚶ', 'RUNIC LETTER ETH': 'ᚧ', 'RUNIC LETTER FEHU FEOH FE F': 'ᚠ', 'RUNIC LETTER G': 'ᚵ', 'RUNIC LETTER GAR': 'ᚸ', 'RUNIC LETTER GEBO GYFU G': 'ᚷ', 'RUNIC LETTER GER': 'ᛄ', 'RUNIC LETTER HAEGL H': 'ᚻ', 'RUNIC LETTER HAGLAZ H': 'ᚺ', 'RUNIC LETTER ICELANDIC-YR': 'ᛨ', 'RUNIC LETTER ING': 'ᛝ', 'RUNIC LETTER INGWAZ': 'ᛜ', 'RUNIC LETTER IOR': 'ᛡ', 'RUNIC LETTER ISAZ IS ISS I': 'ᛁ', 'RUNIC LETTER IWAZ EOH': 'ᛇ', 'RUNIC LETTER JERAN J': 'ᛃ', 'RUNIC LETTER KAUN K': 'ᚴ', 'RUNIC LETTER KAUNA': 'ᚲ', 'RUNIC LETTER LAUKAZ LAGU LOGR L': 'ᛚ', 'RUNIC LETTER LONG-BRANCH-AR AE': 'ᛅ', 'RUNIC LETTER LONG-BRANCH-HAGALL H': 'ᚼ', 'RUNIC LETTER LONG-BRANCH-MADR M': 'ᛘ', 'RUNIC LETTER LONG-BRANCH-OSS O': 'ᚬ', 'RUNIC LETTER LONG-BRANCH-YR': 'ᛦ', 'RUNIC LETTER MANNAZ MAN M': 'ᛗ', 'RUNIC LETTER NAUDIZ NYD NAUD N': 'ᚾ', 'RUNIC LETTER O': 'ᚮ', 'RUNIC LETTER OE': 'ᚯ', 'RUNIC LETTER ON': 'ᚰ', 'RUNIC LETTER OPEN-P': 'ᛕ', 'RUNIC LETTER OS O': 'ᚩ', 'RUNIC LETTER OTHALAN ETHEL O': 'ᛟ', 'RUNIC LETTER PERTHO PEORTH P': 'ᛈ', 'RUNIC LETTER Q': 'ᛩ', 'RUNIC LETTER RAIDO RAD REID R': 'ᚱ', 'RUNIC LETTER SHORT-TWIG-AR A': 'ᛆ', 'RUNIC LETTER SHORT-TWIG-BJARKAN B': 'ᛓ', 'RUNIC LETTER SHORT-TWIG-HAGALL H': 'ᚽ', 'RUNIC LETTER SHORT-TWIG-MADR M': 'ᛙ', 'RUNIC LETTER SHORT-TWIG-NAUD N': 'ᚿ', 'RUNIC LETTER SHORT-TWIG-OSS O': 'ᚭ', 'RUNIC LETTER SHORT-TWIG-SOL S': 'ᛌ', 'RUNIC LETTER SHORT-TWIG-TYR T': 'ᛐ', 'RUNIC LETTER SHORT-TWIG-YR': 'ᛧ', 'RUNIC LETTER SIGEL LONG-BRANCH-SOL S': 'ᛋ', 'RUNIC LETTER SOWILO S': 'ᛊ', 'RUNIC LETTER STAN': 'ᛥ', 'RUNIC LETTER THURISAZ THURS THORN': 'ᚦ', 'RUNIC LETTER TIWAZ TIR TYR T': 'ᛏ', 'RUNIC LETTER URUZ UR U': 'ᚢ', 'RUNIC LETTER V': 'ᚡ', 'RUNIC LETTER W': 'ᚥ', 'RUNIC LETTER WUNJO WYNN W': 'ᚹ', 'RUNIC LETTER X': 'ᛪ', 'RUNIC LETTER Y': 'ᚤ', 'RUNIC LETTER YR': 'ᚣ', 'RUNIC LETTER Z': 'ᛎ', 'RUNIC MULTIPLE PUNCTUATION': '᛬', 'RUNIC SINGLE PUNCTUATION': '᛫', 'RUNIC ARLAUG SYMBOL (golden number 17)': 'ᛮ', 'RUNIC TVIMADUR SYMBOL (golden number 18)': 'ᛯ', 'RUNIC BELGTHOR SYMBOL (golden number 19)': 'ᛰ', 'RUNIC CROSS PUNCTUATION': '᛭'};

