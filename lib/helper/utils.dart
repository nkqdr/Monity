import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  static String getCorrectTitleFromKey(
      String categoryKey, AppLocalizations language) {
    switch (categoryKey) {
      case "Invested":
        return language.invested;
      case "Saved":
        return language.saved;
      case "Liquid":
        return language.liquid;
      default:
        return "";
    }
  }
}
