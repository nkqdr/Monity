import 'package:monity/backend/finances_database.dart';
import 'package:monity/helper/interfaces.dart';
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
  static const String label = "label";
}

class InvestmentCategory extends Category {
  final String label;
  const InvestmentCategory({
    int? id,
    required this.label,
    required String name,
  }) : super(id: id, name: name);

  @override
  bool equals(Category other) {
    if (other is! InvestmentCategory) {
      return false;
    }
    return label == other.label && id == other.id && name == other.name;
  }

  @override
  String toString() {
    return "InvestmentCategory with ID: $id, NAME: $name, LABEL: $label";
  }

  Map<String, Object?> toJson() {
    return {
      InvestmentCategoryFields.id: id,
      InvestmentCategoryFields.name: name,
      InvestmentCategoryFields.label: label,
    };
  }

  static InvestmentCategory fromJson(Map<String, Object?> json) {
    return InvestmentCategory(
      id: json[InvestmentCategoryFields.id] as int?,
      name: json[InvestmentCategoryFields.name] as String,
      label: json[InvestmentCategoryFields.label] as String,
    );
  }

  @override
  InvestmentCategory copy({
    int? id,
    String? name,
    String? label,
  }) {
    return InvestmentCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
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

  bool equals(InvestmentSnapshot other) {
    return id == other.id &&
        amount == other.amount &&
        date.isAtSameMomentAs(other.date) &&
        categoryId == other.categoryId;
  }

  @override
  String toString() {
    return "$id: Date-$date, Amount-$amount, Category-$categoryId";
  }

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
      InvestmentSnapshotFields.categoryId: categoryId,
      InvestmentSnapshotFields.amount: amount,
      InvestmentSnapshotFields.date: date.toIso8601String(),
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
