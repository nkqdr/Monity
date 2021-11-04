import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/helper/interfaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String tableInvestmentCategory = "investment_category";
const String tableInvestmentSnapshot = "investment_snapshot";

class InvestmentCategoryFields {
  static const List<String> values = [
    id,
    name,
  ];
  static const String id = "_id";
  static const String name = "name";
}

class InvestmentCategory extends Category {
  const InvestmentCategory({
    int? id,
    required String name,
  }) : super(id: id, name: name);

  Map<String, Object?> toJson() {
    return {
      InvestmentCategoryFields.id: id,
      InvestmentCategoryFields.name: name,
    };
  }

  static InvestmentCategory fromJson(Map<String, Object?> json) {
    return InvestmentCategory(
      id: json[InvestmentCategoryFields.id] as int?,
      name: json[InvestmentCategoryFields.name] as String,
    );
  }

  @override
  InvestmentCategory copy({
    int? id,
    String? name,
  }) {
    return InvestmentCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Future<int> updateSelf() {
    return FinancesDatabase.instance.updateInvestmentCategory(this);
  }

  @override
  Future<int> deleteSelf() async {
    if (id != null) {
      return FinancesDatabase.instance.deleteInvestmentCategory(id!);
    }
    return -1;
  }

  @override
  String getDeleteMessage(AppLocalizations language) {
    return language.sureDeleteInvestmentCategory;
  }
}

class InvestmentSnapshotFields {
  static const List<String> values = [
    id,
    amount,
    date,
  ];
  static const String id = "_id";
  static const String amount = "amount";
  static const String date = "date";
  static const String categoryId = "category_id";
}

class InvestmentSnapshot {
  final int? id;
  final double amount;
  final DateTime date;
  final int categoryId;

  const InvestmentSnapshot({
    this.id,
    required this.amount,
    required this.date,
    required this.categoryId,
  });

  InvestmentSnapshot copy({
    int? id,
    double? amount,
    DateTime? date,
    int? categoryId,
  }) {
    return InvestmentSnapshot(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, Object?> toJson() {
    return {
      InvestmentSnapshotFields.id: id,
      InvestmentSnapshotFields.amount: amount,
      InvestmentSnapshotFields.date: date,
    };
  }

  static InvestmentSnapshot fromJson(Map<String, Object?> json) {
    return InvestmentSnapshot(
      id: json[InvestmentSnapshotFields.id] as int?,
      amount: json[InvestmentSnapshotFields.amount] as double,
      date: DateTime.parse(json[InvestmentSnapshotFields.date] as String),
      categoryId: json[InvestmentSnapshotFields.categoryId] as int,
    );
  }
}
