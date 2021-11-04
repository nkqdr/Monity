import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Category {
  final int? id;
  final String name;

  const Category({this.id, required this.name});

  Category copy({int? id, String? name});
  String getDeleteMessage(AppLocalizations language);

  Future<int> updateSelf();
  Future<int> deleteSelf();
}
