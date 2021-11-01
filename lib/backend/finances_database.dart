import 'package:finance_buddy/backend/models/transaction_model.dart' as model;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class FinancesDatabase {
  static final FinancesDatabase instance = FinancesDatabase._init();
  static Database? _database;

  FinancesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("finances.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${model.tableTransactionCategory} (
      ${model.TransactionCategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${model.TransactionCategoryFields.name} VARCHAR(32)
    )
    ''');
    await db.execute('''
    CREATE TABLE ${model.tableTransaction} (
      ${model.TransactionFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${model.TransactionFields.description} TEXT NOT NULL,
      ${model.TransactionFields.category} INTEGER NOT NULL,
      ${model.TransactionFields.amount} REAL NOT NULL,
      ${model.TransactionFields.date} TEXT NOT NULL,
      ${model.TransactionFields.type} INTEGER NOT NULL,
      FOREIGN KEY(${model.TransactionFields.category}) REFERENCES ${model.tableTransactionCategory}(${model.TransactionCategoryFields.id})
    )
    ''');
  }

  Future<model.Transaction> createTransaction(
      model.Transaction transaction) async {
    final db = await instance.database;
    final id = await db.insert(model.tableTransaction, transaction.toJson());
    return transaction.copy(id: id);
  }

  Future<model.Transaction?> readTransaction(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      model.tableTransaction,
      columns: model.TransactionFields.values,
      where: "${model.TransactionFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return model.Transaction.fromJson(maps.first);
    }
  }

  Future<List<model.Transaction>> readAllTransactions() async {
    final db = await instance.database;
    final result = await db.query(model.tableTransaction,
        orderBy: "${model.TransactionFields.date} ASC");
    return result.map((e) => model.Transaction.fromJson(e)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      model.tableTransaction,
      where: "${model.TransactionFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<model.TransactionCategory> createTransactionCategory(
      model.TransactionCategory category) async {
    final db = await instance.database;
    final id =
        await db.insert(model.tableTransactionCategory, category.toJson());
    return category.copy(id: id);
  }

  Future<List<model.TransactionCategory>> readAllTransactionCategories() async {
    final db = await instance.database;
    final result = await db.query(model.tableTransactionCategory,
        orderBy: "${model.TransactionCategoryFields.name} ASC");
    return result.map((e) => model.TransactionCategory.fromJson(e)).toList();
  }

  Future<int> updateTransactionCategory(
      model.TransactionCategory category) async {
    final db = await instance.database;
    return db.update(
      model.tableTransactionCategory,
      category.toJson(),
      where: '${model.TransactionCategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteTransactionCategory(int id) async {
    final db = await instance.database;
    return await db.delete(
      model.tableTransactionCategory,
      where: "${model.TransactionCategoryFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
