import 'package:monity/backend/finances_database.dart';
import 'package:monity/helper/interfaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String tableTransaction = "transaction_base";
const String tableTransactionCategory = "transaction_category";

enum TransactionType {
  expense,
  income,
}

class TransactionFields {
  static const List<String> values = [id, description, category, amount, date, type];
  static const String id = "_id";
  static const String description = "description";
  static const String category = "category_id";
  static const String amount = "amount";
  static const String date = "date";
  static const String type = "type";
}

class TransactionCategoryFields {
  static const List<String> values = [id, name];
  static const String id = "_id";
  static const String name = "name";
}

class Transaction {
  final int? id;
  final String? description;
  final int categoryId;
  final double amount;
  final DateTime date;
  final TransactionType type;

  const Transaction({
    this.id,
    this.description,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, Object?> toJson() {
    return {
      TransactionFields.id: id,
      TransactionFields.description: description,
      TransactionFields.category: categoryId,
      TransactionFields.amount: amount,
      TransactionFields.date: date.toIso8601String(),
      TransactionFields.type: type.index,
    };
  }

  static Transaction fromJson(Map<String, Object?> json) {
    return Transaction(
      id: json[TransactionFields.id] as int?,
      description: json[TransactionFields.description] as String?,
      categoryId: json[TransactionFields.category] as int,
      amount: json[TransactionFields.amount] as double,
      date: DateTime.parse(json[TransactionFields.date] as String),
      type: TransactionType.values[json[TransactionFields.type] as int],
    );
  }

  Transaction copy({
    int? id,
    String? description,
    int? categoryId,
    double? amount,
    DateTime? date,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}

class TransactionCategory extends Category {
  const TransactionCategory({
    int? id,
    required String name,
  }) : super(id: id, name: name);

  @override
  TransactionCategory copy({int? id, String? name}) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, Object?> toJson() {
    return {
      TransactionCategoryFields.id: id,
      TransactionCategoryFields.name: name,
    };
  }

  static TransactionCategory fromJson(Map<String, Object?> json) {
    return TransactionCategory(
      id: json[TransactionCategoryFields.id] as int?,
      name: json[TransactionCategoryFields.name] as String,
    );
  }

  @override
  Future<int> updateSelf() async {
    return FinancesDatabase.instance.updateTransactionCategory(this);
  }

  @override
  Future<int> deleteSelf() async {
    if (id != null) {
      return FinancesDatabase.instance.deleteTransactionCategory(id!);
    }
    return -1;
  }

  @override
  String getDeleteMessage(AppLocalizations language) {
    return language.sureDeleteCategory;
  }
}
