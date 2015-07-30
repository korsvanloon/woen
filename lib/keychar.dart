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

class Rule {
  Rule(this.examples, this.regExp, this.letter, this.sound, this.stave);

  List<String> examples;
  RegExp regExp;
  String sound;
  String stave;
  String letter;

  toString() => '$examples ${regExp.pattern} => $stave';
}

// stap 1. dubbele medeklinkers verwijderen
const MK = 'qwrtpsdfghjklzcvbnm';

var rules = <Rule>[
//  new Rule(['pot, stop'], new RegExp('(p)'), 'p', 'ᛈ'),
//  new Rule(['boot, heb'], new RegExp('(b)'), 'b', 'ᛒ'),
//  new Rule(['taal'], 't', 't', 'ᛏ'),
//  new Rule(['doe, hoofd'], 'd', 'd', 'ᛞ'),
//  new Rule(['kan, dank'], 'k,', 'k', 'ᚲ'),
//  new Rule(['man, kom'], 'm', 'm', 'm'),
  new Rule(['lang'], new RegExp('(ng)'), 'ng', 'ŋ', 'ᛜ'),
  new Rule(['quiz'], new RegExp('(q)'), 'q', 'k', 'ᚲ'),
  new Rule(['taxi'], new RegExp('(x)'), 'x', 'ks', 'ᚲᛊ'),
  new Rule(['cent'], new RegExp('(c)[iey]'), 'c', 's', 'ᛊ'),
  new Rule(['licht'], new RegExp('(ch)'), 'ch', 'kh', 'ᚲᚺ'),
  new Rule(['cursus'], new RegExp('(c)'), 'c', 'k', 'ᚲ'),
  new Rule(['acryl'], new RegExp('(y)'), 'y', 'i', 'ᛁ'),
//  new Rule(['nu, aan'], 'n', 'n', 'ᚾ'),
//  new Rule(['foto, hoofd'], 'f', 'f', 'ᚠ'),
  new Rule(['voor', 'over'], new RegExp('(v)'), 'v', 'fh', 'ᚠᚺ'),
//  new Rule(['sap, bussen, is'], 's', 's', 'ᛊ'),
//  new Rule(['zeg'], 'z', 'z', 'ᛉ'),
  new Rule(['gaat', 'negen'], new RegExp('(g+)'), 'g', 'gh', 'ᚷᚺ'),
//  new Rule(['heet'], 'h', 'h', 'ᚺ'),
//  new Rule(['rood, voor'], 'r', 'r', 'ᚱ'),
//  new Rule(['weg'], 'w', 'w', 'ᚹ'),
//  new Rule(['lang'], 'l', 'l', 'ᛚ'),
//  new Rule(['ja, project'], 'j', 'j', 'ᛃ'),
  new Rule(['draai', 'roei'], new RegExp(r'[aeou]{2}(i)'), 'i', 'j', 'ᛃ'),
//  new Rule(['tip, is'], 'i', 'i', 'ᛁ'),
//  new Rule(['iemand, die'], 'ie', 'ie', 'ᛁᛖ'),
//  new Rule(['gitaar', 'liter'], new RegExp('(i)[$MK][eaoui]'), 'ie', 'ᛁᛖ'),
  new Rule(['u', 'continu'], new RegExp('(?:[$MK]|^| )(u)\$'), 'u', 'ue', 'ᚢᛖ'),
  new Rule(['buren'], new RegExp('(?:[$MK]|^| )(u)[$MK][aeou]'), 'u', 'ue', 'ᚢᛖ'),

  new Rule(['uur'], new RegExp('(uu)'), 'uu', 'ue', 'ᚢᛖ'),
  new Rule(['hut', 'dun'], new RegExp('(?:[$MK]|^| )(u)[$MK](?![ueaio])'), 'u', 'uh', 'ᚢᚺ'),
  new Rule(['hoed', 'doe'], new RegExp('(oe)'), 'oe', 'u', 'ᚢ'),
//  new Rule(['deur'], new RegExp('(eu)'), 'eu', 'ᛖᚢ'),
//  new Rule(['en, bed'], 'e', 'e', 'ᛖ'),
//  new Rule(['eend, heet, mee'], 'ee', 'ee', 'ᛖᛖ'),
//  new Rule(['halen, de'], 'e', 'e', 'ᛖ'),
//  new Rule(['neus, beu'], 'eu', 'eu', 'ᚢ'),
//  new Rule(['af, bad'], 'a', 'a', 'ᚨ'),
//  new Rule(['aan, paard, ga'], 'aa', 'aa', 'ᚨᚨ'),
//  new Rule(['op, bot'], 'o', 'o', 'ᛟ'),
//  new Rule(['over, boot'], 'oo', 'oo', 'ᛟᛟ'),
//  new Rule(['door'], new RegExp('(oo)[lr]'), 'o', 'ᛟ'),
  new Rule(['ei', 'trein'], new RegExp('(ei)'), 'ei', 'eï', 'ᛖᛇ'),
  new Rule(['ij', 'bij'], new RegExp('(ij)'), 'ij', 'ï', 'ᛇ'),
  new Rule(['buit'], new RegExp('(ui)'), 'ui', 'uï', 'ᚢᛇ'),
//  new Rule(['dauw'], new RegExp('(au)'), 'au', 'ᚨᚢ'),
//  new Rule(['oud'], new RegExp('(ou)'), 'ou', 'ᛟᚢ'),

//  new Rule(['goal'], 'g', 'g', 'ᚷ'),
//  new Rule(['chef, shampoo'], 'sh', 'sj', 'ᛊᛃ'),
//  new Rule(['jungle'], 'j', 'dj', 'ᛃ'),
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
  new Rune('t', 'ᛏ', 'KeyT', 'tiwaz', 'Tuw (de godheid)', 'overwinning, heil, eer'),
  new Rune('b', 'ᛒ', 'KeyB', 'berkana', 'berk', 'vruchtbaarheid, groei, voortduren'),
  new Rune('e', 'ᛖ', 'KeyE', 'ehwaz', 'edel dier (paard)', 'vertrouwen, betrouwbaarheid, gezelschap'),
  new Rune('m', 'ᛗ', 'KeyM', 'mannaz', 'mens', 'toename, ondersteuning'),
  new Rune('l', 'ᛚ', 'KeyL', 'laguz', 'laak (stroom, rivier)', 'vormloosheid, potentie, chaos'),
  new Rune('ŋ', 'ᛜ', 'KeyX', 'ingwaz', 'Ing (een godheid)', 'bevruchting, het begin, actualisatie van potentie'),
  new Rune('d', 'ᛞ', 'KeyD', 'dagaz', 'dag', 'hoop, blijdschap'),
  new Rune('o', 'ᛟ', 'KeyO', 'othala', 'oedel (erfgoed)', 'erfgoed, traditie, de adel'),

  new Rune('.', '᛭', 'Point', 'point'),
  new Rune('\u00A0', '᛫', 'Space', 'space'),
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
  new Rune('\u00A0', '᛫', 'Space', 'space'),
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
  new Rune('\u00A0', '᛫', 'Space', 'space'),
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
  new Rune('\u00A0', '᛫', 'Space', 'space'),
  new Rune(',', '᛬', 'Comma', 'comma'),
];

var runes = {'RUNIC LETTER AC A': 'ᚪ', 'RUNIC LETTER AESC': 'ᚫ', 'RUNIC LETTER ALGIZ EOLHX': 'ᛉ', 'RUNIC LETTER ANSUZ A': 'ᚨ', 'RUNIC LETTER BERKANAN BEORC BJARKAN B': 'ᛒ', 'RUNIC LETTER C': 'ᛍ', 'RUNIC LETTER CALC': 'ᛣ', 'RUNIC LETTER CEALC': 'ᛤ', 'RUNIC LETTER CEN': 'ᚳ', 'RUNIC LETTER CWEORTH': 'ᛢ', 'RUNIC LETTER D': 'ᛑ', 'RUNIC LETTER DAGAZ DAEG D': 'ᛞ', 'RUNIC LETTER DOTTED-L': 'ᛛ', 'RUNIC LETTER DOTTED-N': 'ᛀ', 'RUNIC LETTER DOTTED-P': 'ᛔ', 'RUNIC LETTER E': 'ᛂ', 'RUNIC LETTER EAR': 'ᛠ', 'RUNIC LETTER EHWAZ EH E': 'ᛖ', 'RUNIC LETTER ENG': 'ᚶ', 'RUNIC LETTER ETH': 'ᚧ', 'RUNIC LETTER FEHU FEOH FE F': 'ᚠ', 'RUNIC LETTER G': 'ᚵ', 'RUNIC LETTER GAR': 'ᚸ', 'RUNIC LETTER GEBO GYFU G': 'ᚷ', 'RUNIC LETTER GER': 'ᛄ', 'RUNIC LETTER HAEGL H': 'ᚻ', 'RUNIC LETTER HAGLAZ H': 'ᚺ', 'RUNIC LETTER ICELANDIC-YR': 'ᛨ', 'RUNIC LETTER ING': 'ᛝ', 'RUNIC LETTER INGWAZ': 'ᛜ', 'RUNIC LETTER IOR': 'ᛡ', 'RUNIC LETTER ISAZ IS ISS I': 'ᛁ', 'RUNIC LETTER IWAZ EOH': 'ᛇ', 'RUNIC LETTER JERAN J': 'ᛃ', 'RUNIC LETTER KAUN K': 'ᚴ', 'RUNIC LETTER KAUNA': 'ᚲ', 'RUNIC LETTER LAUKAZ LAGU LOGR L': 'ᛚ', 'RUNIC LETTER LONG-BRANCH-AR AE': 'ᛅ', 'RUNIC LETTER LONG-BRANCH-HAGALL H': 'ᚼ', 'RUNIC LETTER LONG-BRANCH-MADR M': 'ᛘ', 'RUNIC LETTER LONG-BRANCH-OSS O': 'ᚬ', 'RUNIC LETTER LONG-BRANCH-YR': 'ᛦ', 'RUNIC LETTER MANNAZ MAN M': 'ᛗ', 'RUNIC LETTER NAUDIZ NYD NAUD N': 'ᚾ', 'RUNIC LETTER O': 'ᚮ', 'RUNIC LETTER OE': 'ᚯ', 'RUNIC LETTER ON': 'ᚰ', 'RUNIC LETTER OPEN-P': 'ᛕ', 'RUNIC LETTER OS O': 'ᚩ', 'RUNIC LETTER OTHALAN ETHEL O': 'ᛟ', 'RUNIC LETTER PERTHO PEORTH P': 'ᛈ', 'RUNIC LETTER Q': 'ᛩ', 'RUNIC LETTER RAIDO RAD REID R': 'ᚱ', 'RUNIC LETTER SHORT-TWIG-AR A': 'ᛆ', 'RUNIC LETTER SHORT-TWIG-BJARKAN B': 'ᛓ', 'RUNIC LETTER SHORT-TWIG-HAGALL H': 'ᚽ', 'RUNIC LETTER SHORT-TWIG-MADR M': 'ᛙ', 'RUNIC LETTER SHORT-TWIG-NAUD N': 'ᚿ', 'RUNIC LETTER SHORT-TWIG-OSS O': 'ᚭ', 'RUNIC LETTER SHORT-TWIG-SOL S': 'ᛌ', 'RUNIC LETTER SHORT-TWIG-TYR T': 'ᛐ', 'RUNIC LETTER SHORT-TWIG-YR': 'ᛧ', 'RUNIC LETTER SIGEL LONG-BRANCH-SOL S': 'ᛋ', 'RUNIC LETTER SOWILO S': 'ᛊ', 'RUNIC LETTER STAN': 'ᛥ', 'RUNIC LETTER THURISAZ THURS THORN': 'ᚦ', 'RUNIC LETTER TIWAZ TIR TYR T': 'ᛏ', 'RUNIC LETTER URUZ UR U': 'ᚢ', 'RUNIC LETTER V': 'ᚡ', 'RUNIC LETTER W': 'ᚥ', 'RUNIC LETTER WUNJO WYNN W': 'ᚹ', 'RUNIC LETTER X': 'ᛪ', 'RUNIC LETTER Y': 'ᚤ', 'RUNIC LETTER YR': 'ᚣ', 'RUNIC LETTER Z': 'ᛎ', 'RUNIC MULTIPLE PUNCTUATION': '᛬', 'RUNIC SINGLE PUNCTUATION': '᛫', 'RUNIC ARLAUG SYMBOL (golden number 17)': 'ᛮ', 'RUNIC TVIMADUR SYMBOL (golden number 18)': 'ᛯ', 'RUNIC BELGTHOR SYMBOL (golden number 19)': 'ᛰ', 'RUNIC CROSS PUNCTUATION': '᛭'};

var interpunctionMap = {'!': '.', '?': '.', ';': ',', ':': ',', ' ': '\u00A0'};
var numeralMap = {'1': 'e', '2': 't', '3': 'd', '4': 'f', '5': 'y', '6': 's', '7': 'z', '8': 'a', '9': 'n', '0': 'o'};

removeUnsupportedCharacters(String str) {
  return str.replaceAll(new RegExp('[^\\w\u00A0.,]|_'), '');
}

replaceInterpunction(String str) {
  return str.replaceAllMapped(new RegExp(r'[!?;: ]'), (match) => interpunctionMap[match.group(0)]);
}

replaceNumerals(String str) {
  return str.replaceAllMapped(new RegExp(r'[\d]'), (match) => numeralMap[match.group(0)]);
}

replaceDiacritics(String str) {
  return str.replaceAllMapped(new RegExp('[^\u0000-\u007E]'), (match) => diacriticsMap[match.group(0)]);
}

var diacriticsMap = {"A":"a", "Ⓐ":"a", "Ａ":"a", "À":"a", "Á":"a", "Â":"a", "Ầ":"a", "Ấ":"a", "Ẫ":"a", "Ẩ":"a", "Ã":"a", "Ā":"a", "Ă":"a", "Ằ":"a", "Ắ":"a", "Ẵ":"a", "Ẳ":"a", "Ȧ":"a", "Ǡ":"a", "Ä":"a", "Ǟ":"a", "Ả":"a", "Å":"a", "Ǻ":"a", "Ǎ":"a", "Ȁ":"a", "Ȃ":"a", "Ạ":"a", "Ậ":"a", "Ặ":"a", "Ḁ":"a", "Ą":"a", "Ⱥ":"a", "Ɐ":"a", "Ꜳ":"aa", "Æ":"ae", "Ǽ":"ae", "Ǣ":"ae", "Ꜵ":"ao", "Ꜷ":"au", "Ꜹ":"av", "Ꜻ":"av", "Ꜽ":"ay", "B":"b", "Ⓑ":"b", "Ｂ":"b", "Ḃ":"b", "Ḅ":"b", "Ḇ":"b", "Ƀ":"b", "Ƃ":"b", "Ɓ":"b", "C":"c", "Ⓒ":"c", "Ｃ":"c", "Ć":"c", "Ĉ":"c", "Ċ":"c", "Č":"c", "Ç":"c", "Ḉ":"c", "Ƈ":"c", "Ȼ":"c", "Ꜿ":"c", "D":"d", "Ⓓ":"d", "Ｄ":"d", "Ḋ":"d", "Ď":"d", "Ḍ":"d", "Ḑ":"d", "Ḓ":"d", "Ḏ":"d", "Đ":"d", "Ƌ":"d", "Ɗ":"d", "Ɖ":"d", "Ꝺ":"d", "Ǳ":"dz", "Ǆ":"dz", "ǲ":"dz", "ǅ":"dz", "E":"e", "Ⓔ":"e", "Ｅ":"e", "È":"e", "É":"e", "Ê":"e", "Ề":"e", "Ế":"e", "Ễ":"e", "Ể":"e", "Ẽ":"e", "Ē":"e", "Ḕ":"e", "Ḗ":"e", "Ĕ":"e", "Ė":"e", "Ë":"e", "Ẻ":"e", "Ě":"e", "Ȅ":"e", "Ȇ":"e", "Ẹ":"e", "Ệ":"e", "Ȩ":"e", "Ḝ":"e", "Ę":"e", "Ḙ":"e", "Ḛ":"e", "Ɛ":"e", "Ǝ":"e", "F":"f", "Ⓕ":"f", "Ｆ":"f", "Ḟ":"f", "Ƒ":"f", "Ꝼ":"f", "G":"g", "Ⓖ":"g", "Ｇ":"g", "Ǵ":"g", "Ĝ":"g", "Ḡ":"g", "Ğ":"g", "Ġ":"g", "Ǧ":"g", "Ģ":"g", "Ǥ":"g", "Ɠ":"g", "Ꞡ":"g", "Ᵹ":"g", "Ꝿ":"g", "H":"h", "Ⓗ":"h", "Ｈ":"h", "Ĥ":"h", "Ḣ":"h", "Ḧ":"h", "Ȟ":"h", "Ḥ":"h", "Ḩ":"h", "Ḫ":"h", "Ħ":"h", "Ⱨ":"h", "Ⱶ":"h", "Ɥ":"h", "I":"i", "Ⓘ":"i", "Ｉ":"i", "Ì":"i", "Í":"i", "Î":"i", "Ĩ":"i", "Ī":"i", "Ĭ":"i", "İ":"i", "Ï":"i", "Ḯ":"i", "Ỉ":"i", "Ǐ":"i", "Ȉ":"i", "Ȋ":"i", "Ị":"i", "Į":"i", "Ḭ":"i", "Ɨ":"i", "J":"j", "Ⓙ":"j", "Ｊ":"j", "Ĵ":"j", "Ɉ":"j", "K":"k", "Ⓚ":"k", "Ｋ":"k", "Ḱ":"k", "Ǩ":"k", "Ḳ":"k", "Ķ":"k", "Ḵ":"k", "Ƙ":"k", "Ⱪ":"k", "Ꝁ":"k", "Ꝃ":"k", "Ꝅ":"k", "Ꞣ":"k", "L":"l", "Ⓛ":"l", "Ｌ":"l", "Ŀ":"l", "Ĺ":"l", "Ľ":"l", "Ḷ":"l", "Ḹ":"l", "Ļ":"l", "Ḽ":"l", "Ḻ":"l", "Ł":"l", "Ƚ":"l", "Ɫ":"l", "Ⱡ":"l", "Ꝉ":"l", "Ꝇ":"l", "Ꞁ":"l", "Ǉ":"lj", "ǈ":"lj", "M":"m", "Ⓜ":"m", "Ｍ":"m", "Ḿ":"m", "Ṁ":"m", "Ṃ":"m", "Ɱ":"m", "Ɯ":"m", "N":"n", "Ⓝ":"n", "Ｎ":"n", "Ǹ":"n", "Ń":"n", "Ñ":"n", "Ṅ":"n", "Ň":"n", "Ṇ":"n", "Ņ":"n", "Ṋ":"n", "Ṉ":"n", "Ƞ":"n", "Ɲ":"n", "Ꞑ":"n", "Ꞥ":"n", "Ǌ":"nj", "ǋ":"nj", "O":"o", "Ⓞ":"o", "Ｏ":"o", "Ò":"o", "Ó":"o", "Ô":"o", "Ồ":"o", "Ố":"o", "Ỗ":"o", "Ổ":"o", "Õ":"o", "Ṍ":"o", "Ȭ":"o", "Ṏ":"o", "Ō":"o", "Ṑ":"o", "Ṓ":"o", "Ŏ":"o", "Ȯ":"o", "Ȱ":"o", "Ö":"o", "Ȫ":"o", "Ỏ":"o", "Ő":"o", "Ǒ":"o", "Ȍ":"o", "Ȏ":"o", "Ơ":"o", "Ờ":"o", "Ớ":"o", "Ỡ":"o", "Ở":"o", "Ợ":"o", "Ọ":"o", "Ộ":"o", "Ǫ":"o", "Ǭ":"o", "Ø":"o", "Ǿ":"o", "Ɔ":"o", "Ɵ":"o", "Ꝋ":"o", "Ꝍ":"o", "Ƣ":"oi", "Ꝏ":"oo", "Ȣ":"ou", "":"oe", "Œ":"oe", "":"oe", "œ":"oe", "P":"p", "Ⓟ":"p", "Ｐ":"p", "Ṕ":"p", "Ṗ":"p", "Ƥ":"p", "Ᵽ":"p", "Ꝑ":"p", "Ꝓ":"p", "Ꝕ":"p", "Q":"q", "Ⓠ":"q", "Ｑ":"q", "Ꝗ":"q", "Ꝙ":"q", "Ɋ":"q", "R":"r", "Ⓡ":"r", "Ｒ":"r", "Ŕ":"r", "Ṙ":"r", "Ř":"r", "Ȑ":"r", "Ȓ":"r", "Ṛ":"r", "Ṝ":"r", "Ŗ":"r", "Ṟ":"r", "Ɍ":"r", "Ɽ":"r", "Ꝛ":"r", "Ꞧ":"r", "Ꞃ":"r", "S":"s", "Ⓢ":"s", "Ｓ":"s", "ẞ":"s", "Ś":"s", "Ṥ":"s", "Ŝ":"s", "Ṡ":"s", "Š":"s", "Ṧ":"s", "Ṣ":"s", "Ṩ":"s", "Ș":"s", "Ş":"s", "Ȿ":"s", "Ꞩ":"s", "Ꞅ":"s", "T":"t", "Ⓣ":"t", "Ｔ":"t", "Ṫ":"t", "Ť":"t", "Ṭ":"t", "Ț":"t", "Ţ":"t", "Ṱ":"t", "Ṯ":"t", "Ŧ":"t", "Ƭ":"t", "Ʈ":"t", "Ⱦ":"t", "Ꞇ":"t", "Ꜩ":"tz", "U":"u", "Ⓤ":"u", "Ｕ":"u", "Ù":"u", "Ú":"u", "Û":"u", "Ũ":"u", "Ṹ":"u", "Ū":"u", "Ṻ":"u", "Ŭ":"u", "Ü":"u", "Ǜ":"u", "Ǘ":"u", "Ǖ":"u", "Ǚ":"u", "Ủ":"u", "Ů":"u", "Ű":"u", "Ǔ":"u", "Ȕ":"u", "Ȗ":"u", "Ư":"u", "Ừ":"u", "Ứ":"u", "Ữ":"u", "Ử":"u", "Ự":"u", "Ụ":"u", "Ṳ":"u", "Ų":"u", "Ṷ":"u", "Ṵ":"u", "Ʉ":"u", "V":"v", "Ⓥ":"v", "Ｖ":"v", "Ṽ":"v", "Ṿ":"v", "Ʋ":"v", "Ꝟ":"v", "Ʌ":"v", "Ꝡ":"vy", "W":"w", "Ⓦ":"w", "Ｗ":"w", "Ẁ":"w", "Ẃ":"w", "Ŵ":"w", "Ẇ":"w", "Ẅ":"w", "Ẉ":"w", "Ⱳ":"w", "X":"x", "Ⓧ":"x", "Ｘ":"x", "Ẋ":"x", "Ẍ":"x", "Y":"y", "Ⓨ":"y", "Ｙ":"y", "Ỳ":"y", "Ý":"y", "Ŷ":"y", "Ỹ":"y", "Ȳ":"y", "Ẏ":"y", "Ÿ":"y", "Ỷ":"y", "Ỵ":"y", "Ƴ":"y", "Ɏ":"y", "Ỿ":"y", "Z":"z", "Ⓩ":"z", "Ｚ":"z", "Ź":"z", "Ẑ":"z", "Ż":"z", "Ž":"z", "Ẓ":"z", "Ẕ":"z", "Ƶ":"z", "Ȥ":"z", "Ɀ":"z", "Ⱬ":"z", "Ꝣ":"z", "a":"a", "ⓐ":"a", "ａ":"a", "ẚ":"a", "à":"a", "á":"a", "â":"a", "ầ":"a", "ấ":"a", "ẫ":"a", "ẩ":"a", "ã":"a", "ā":"a", "ă":"a", "ằ":"a", "ắ":"a", "ẵ":"a", "ẳ":"a", "ȧ":"a", "ǡ":"a", "ä":"a", "ǟ":"a", "ả":"a", "å":"a", "ǻ":"a", "ǎ":"a", "ȁ":"a", "ȃ":"a", "ạ":"a", "ậ":"a", "ặ":"a", "ḁ":"a", "ą":"a", "ⱥ":"a", "ɐ":"a", "ꜳ":"aa", "æ":"ae", "ǽ":"ae", "ǣ":"ae", "ꜵ":"ao", "ꜷ":"au", "ꜹ":"av", "ꜻ":"av", "ꜽ":"ay", "b":"b", "ⓑ":"b", "ｂ":"b", "ḃ":"b", "ḅ":"b", "ḇ":"b", "ƀ":"b", "ƃ":"b", "ɓ":"b", "c":"c", "ⓒ":"c", "ｃ":"c", "ć":"c", "ĉ":"c", "ċ":"c", "č":"c", "ç":"c", "ḉ":"c", "ƈ":"c", "ȼ":"c", "ꜿ":"c", "ↄ":"c", "d":"d", "ⓓ":"d", "ｄ":"d", "ḋ":"d", "ď":"d", "ḍ":"d", "ḑ":"d", "ḓ":"d", "ḏ":"d", "đ":"d", "ƌ":"d", "ɖ":"d", "ɗ":"d", "ꝺ":"d", "ǳ":"dz", "ǆ":"dz", "e":"e", "ⓔ":"e", "ｅ":"e", "è":"e", "é":"e", "ê":"e", "ề":"e", "ế":"e", "ễ":"e", "ể":"e", "ẽ":"e", "ē":"e", "ḕ":"e", "ḗ":"e", "ĕ":"e", "ė":"e", "ë":"e", "ẻ":"e", "ě":"e", "ȅ":"e", "ȇ":"e", "ẹ":"e", "ệ":"e", "ȩ":"e", "ḝ":"e", "ę":"e", "ḙ":"e", "ḛ":"e", "ɇ":"e", "ɛ":"e", "ǝ":"e", "f":"f", "ⓕ":"f", "ｆ":"f", "ḟ":"f", "ƒ":"f", "ꝼ":"f", "g":"g", "ⓖ":"g", "ｇ":"g", "ǵ":"g", "ĝ":"g", "ḡ":"g", "ğ":"g", "ġ":"g", "ǧ":"g", "ģ":"g", "ǥ":"g", "ɠ":"g", "ꞡ":"g", "ᵹ":"g", "ꝿ":"g", "h":"h", "ⓗ":"h", "ｈ":"h", "ĥ":"h", "ḣ":"h", "ḧ":"h", "ȟ":"h", "ḥ":"h", "ḩ":"h", "ḫ":"h", "ẖ":"h", "ħ":"h", "ⱨ":"h", "ⱶ":"h", "ɥ":"h", "ƕ":"hv", "i":"i", "ⓘ":"i", "ｉ":"i", "ì":"i", "í":"i", "î":"i", "ĩ":"i", "ī":"i", "ĭ":"i", "ï":"i", "ḯ":"i", "ỉ":"i", "ǐ":"i", "ȉ":"i", "ȋ":"i", "ị":"i", "į":"i", "ḭ":"i", "ɨ":"i", "ı":"i", "j":"j", "ⓙ":"j", "ｊ":"j", "ĵ":"j", "ǰ":"j", "ɉ":"j", "k":"k", "ⓚ":"k", "ｋ":"k", "ḱ":"k", "ǩ":"k", "ḳ":"k", "ķ":"k", "ḵ":"k", "ƙ":"k", "ⱪ":"k", "ꝁ":"k", "ꝃ":"k", "ꝅ":"k", "ꞣ":"k", "l":"l", "ⓛ":"l", "ｌ":"l", "ŀ":"l", "ĺ":"l", "ľ":"l", "ḷ":"l", "ḹ":"l", "ļ":"l", "ḽ":"l", "ḻ":"l", "ſ":"l", "ł":"l", "ƚ":"l", "ɫ":"l", "ⱡ":"l", "ꝉ":"l", "ꞁ":"l", "ꝇ":"l", "ǉ":"lj", "m":"m", "ⓜ":"m", "ｍ":"m", "ḿ":"m", "ṁ":"m", "ṃ":"m", "ɱ":"m", "ɯ":"m", "n":"n", "ⓝ":"n", "ｎ":"n", "ǹ":"n", "ń":"n", "ñ":"n", "ṅ":"n", "ň":"n", "ṇ":"n", "ņ":"n", "ṋ":"n", "ṉ":"n", "ƞ":"n", "ɲ":"n", "ŉ":"n", "ꞑ":"n", "ꞥ":"n", "ǌ":"nj", "o":"o", "ⓞ":"o", "ｏ":"o", "ò":"o", "ó":"o", "ô":"o", "ồ":"o", "ố":"o", "ỗ":"o", "ổ":"o", "õ":"o", "ṍ":"o", "ȭ":"o", "ṏ":"o", "ō":"o", "ṑ":"o", "ṓ":"o", "ŏ":"o", "ȯ":"o", "ȱ":"o", "ö":"o", "ȫ":"o", "ỏ":"o", "ő":"o", "ǒ":"o", "ȍ":"o", "ȏ":"o", "ơ":"o", "ờ":"o", "ớ":"o", "ỡ":"o", "ở":"o", "ợ":"o", "ọ":"o", "ộ":"o", "ǫ":"o", "ǭ":"o", "ø":"o", "ǿ":"o", "ɔ":"o", "ꝋ":"o", "ꝍ":"o", "ɵ":"o", "ƣ":"oi", "ȣ":"ou", "ꝏ":"oo", "p":"p", "ⓟ":"p", "ｐ":"p", "ṕ":"p", "ṗ":"p", "ƥ":"p", "ᵽ":"p", "ꝑ":"p", "ꝓ":"p", "ꝕ":"p", "q":"q", "ⓠ":"q", "ｑ":"q", "ɋ":"q", "ꝗ":"q", "ꝙ":"q", "r":"r", "ⓡ":"r", "ｒ":"r", "ŕ":"r", "ṙ":"r", "ř":"r", "ȑ":"r", "ȓ":"r", "ṛ":"r", "ṝ":"r", "ŗ":"r", "ṟ":"r", "ɍ":"r", "ɽ":"r", "ꝛ":"r", "ꞧ":"r", "ꞃ":"r", "s":"s", "ⓢ":"s", "ｓ":"s", "ß":"s", "ś":"s", "ṥ":"s", "ŝ":"s", "ṡ":"s", "š":"s", "ṧ":"s", "ṣ":"s", "ṩ":"s", "ș":"s", "ş":"s", "ȿ":"s", "ꞩ":"s", "ꞅ":"s", "ẛ":"s", "t":"t", "ⓣ":"t", "ｔ":"t", "ṫ":"t", "ẗ":"t", "ť":"t", "ṭ":"t", "ț":"t", "ţ":"t", "ṱ":"t", "ṯ":"t", "ŧ":"t", "ƭ":"t", "ʈ":"t", "ⱦ":"t", "ꞇ":"t", "ꜩ":"tz", "u":"u", "ⓤ":"u", "ｕ":"u", "ù":"u", "ú":"u", "û":"u", "ũ":"u", "ṹ":"u", "ū":"u", "ṻ":"u", "ŭ":"u", "ü":"u", "ǜ":"u", "ǘ":"u", "ǖ":"u", "ǚ":"u", "ủ":"u", "ů":"u", "ű":"u", "ǔ":"u", "ȕ":"u", "ȗ":"u", "ư":"u", "ừ":"u", "ứ":"u", "ữ":"u", "ử":"u", "ự":"u", "ụ":"u", "ṳ":"u", "ų":"u", "ṷ":"u", "ṵ":"u", "ʉ":"u", "v":"v", "ⓥ":"v", "ｖ":"v", "ṽ":"v", "ṿ":"v", "ʋ":"v", "ꝟ":"v", "ʌ":"v", "ꝡ":"vy", "w":"w", "ⓦ":"w", "ｗ":"w", "ẁ":"w", "ẃ":"w", "ŵ":"w", "ẇ":"w", "ẅ":"w", "ẘ":"w", "ẉ":"w", "ⱳ":"w", "x":"x", "ⓧ":"x", "ｘ":"x", "ẋ":"x", "ẍ":"x", "y":"y", "ⓨ":"y", "ｙ":"y", "ỳ":"y", "ý":"y", "ŷ":"y", "ỹ":"y", "ȳ":"y", "ẏ":"y", "ÿ":"y", "ỷ":"y", "ẙ":"y", "ỵ":"y", "ƴ":"y", "ɏ":"y", "ỿ":"y", "z":"z", "ⓩ":"z", "ｚ":"z", "ź":"z", "ẑ":"z", "ż":"z", "ž":"z", "ẓ":"z", "ẕ":"z", "ƶ":"z", "ȥ":"z", "ɀ":"z", "ⱬ":"z", "ꝣ":"z"
};
