String moneyString(double sum, {int fix = 2, bool rub = true}) {
  String str = sum.toStringAsFixed(fix);
  int len = str.length;
  int slice = fix > 0 ? fix + 1 : 0;
  String floating = str.substring(len - slice);
  str = str.substring(0, len - slice);
  int amount = (3 - (len - slice) % 3) % 3;
  for (int i = 0; i < amount; i++) str = '0' + str;
  str = str.replaceAllMapped(RegExp(r".{3}"), (match) => " ${match.group(0)}");
  return '${str.substring(amount + 1)}$floating' + (rub ? ' руб' : '');
}
