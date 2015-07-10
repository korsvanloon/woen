import "package:test/test.dart";
import 'package:woen/grammar_rules.dart';

List<String> ns = ["aal","aard","ad","oed","adel","af","oef","ag","oeg","ak","oek","al","oel","alf","elf","am","oem","amel","an","oen","ande","ans","arn","aruw","aar","as","at","oet","aver","bad","boed","baduw","bade","baf","boef","bal","boel","ban","boen","band","bant","bard","barn","bas","boes","bat","boet","beel","beer","bei","boei","berge","bern","bert","brecht","beur","bind","blijde","bloem","bon","bood","boog","boud","brand","brord","bruin","brunne","beurne","burg","dad","doed","daf","doef","dag","dan","den","doen","dank","degen","dein","die","diede","ding","doem","don","door","dras","drucht","druid","duur","ee","eed","eer","eg","eil","ein","eis","el","ellen","Engel","erel","erken","ermen","erp","ever","Frank","Fries","gaard","gad","goed","gal","goel","gamel","gamen","gand","gang","garuw","gaar","gast","geel","geer","geld","geve","gijzel","god","gonde","gooi","goot","goud","gouw","graad","grauw","grijm","groen","haag","haai","had","hoed","hade","haf","hoef","hag","hoeg","hal","hel","hoel","ham","hoem","han","hoen","hand","hard","has","hoes","heem","heen","heer","heid","heil","heist","helm","help","hemel","heruw","hilde","honde","hoog","houd","Huig","huin","huis","ied","ijd","ijf","ijzen","Ing","jong","kal","koel","kan","koen","kind","kunne","laak","land","lede","leef","leek","lief","lien","lind","loog","loge","luide","maar","macht","madel","mal","mam","moem","man","mark","mein","mel","menig","manig","meun","moed","mond","nan","noen","nand","neer","noer","nieuw","nijd","nood","noord","oedel","ood","oon","oor","oord","ooster","oud","ouw","ooi","raad","rand","raven","ram","rein","rijk","rijm","ring","roed","roem","ruin","Saks","schalk","schier","schoon","snel","staal","stark","steen","stil","stoud","tat","toet","teet","til","uw","ijg","vaart","vag","voeg","vager","van","voen","var","voer","vare","vas","voes","vast","veel","vein","vlaad","volk","vons","vorm","vrad","vroed","vram","vrede","vro","Waal","waar","wad","woed","wakker","wal","ward","wede","weern","wees","welp","wendel","werk","wij","wijd","wijf","wijg","wijs","wil","win","ween","wolf","wonne","wunne","worm","woud","wuld","zal","zeel","zel","zoel","zam","zoem","zan","zoen","zand","zaruw","zede","zege","zelf","zeze","zind","zoet","zonder","Zwaaf","zwaan","zwind"];


void main() {

  test("String.split() splits the string on the delimiter", () {
    var string = "aal";

    expect(applyRules(string), equals('al'));
  });

}
