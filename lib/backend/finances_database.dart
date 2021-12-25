import 'package:finance_buddy/backend/models/transaction_model.dart' as model;
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/helper/types.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

const String databaseName = "finances.db";

class FinancesDatabase {
  static final FinancesDatabase instance = FinancesDatabase._init();
  static Database? _database;

  FinancesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(databaseName);
    return _database!;
  }

  Future<int> getDatabaseSize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    File databaseFile = File(path);
    if (await databaseFile.exists()) {
      return await databaseFile.length();
    }
    return 0;
  }

  Future deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    File toDelete = File(path);
    if (await toDelete.exists()) {
      close();
      _database = null;
      await toDelete.delete();
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${model.tableTransactionCategory} (
      ${model.TransactionCategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${model.TransactionCategoryFields.name} TEXT UNIQUE
    )
    ''');
    await db.execute('''
    CREATE TABLE ${model.tableTransaction} (
      ${model.TransactionFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${model.TransactionFields.description} TEXT,
      ${model.TransactionFields.category} INTEGER NOT NULL,
      ${model.TransactionFields.amount} REAL NOT NULL,
      ${model.TransactionFields.date} TEXT NOT NULL,
      ${model.TransactionFields.type} INTEGER NOT NULL,
      FOREIGN KEY(${model.TransactionFields.category}) REFERENCES ${model.tableTransactionCategory}(${model.TransactionCategoryFields.id})
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableInvestmentCategory (
      ${InvestmentCategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${InvestmentCategoryFields.name} TEXT UNIQUE
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableInvestmentSnapshot (
      ${InvestmentSnapshotFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${InvestmentSnapshotFields.amount} REAL NOT NULL,
      ${InvestmentSnapshotFields.date} TEXT NOT NULL,
      ${InvestmentSnapshotFields.categoryId} INTEGER NOT NULL,
      FOREIGN KEY(${InvestmentSnapshotFields.categoryId}) REFERENCES $tableInvestmentCategory(${InvestmentCategoryFields.id})
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

  Future<model.TransactionCategory?> readTransactionCategory(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      model.tableTransactionCategory,
      columns: model.TransactionCategoryFields.values,
      where: "${model.TransactionCategoryFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return model.TransactionCategory.fromJson(maps.first);
    }
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
    await db.delete(model.tableTransaction,
        where: "${model.TransactionFields.category} = ?", whereArgs: [id]);
    return await db.delete(
      model.tableTransactionCategory,
      where: "${model.TransactionCategoryFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<InvestmentCategory> createInvestmentCategory(
      InvestmentCategory category) async {
    final db = await instance.database;
    final id = await db.insert(tableInvestmentCategory, category.toJson());
    return category.copy(id: id);
  }

  Future<InvestmentCategory?> readInvestmentCategory(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableInvestmentCategory,
        columns: InvestmentCategoryFields.values,
        where: "${model.TransactionCategoryFields.id} = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InvestmentCategory.fromJson(maps.first);
    }
  }

  Future<List<InvestmentCategory>> readAllInvestmentCategories() async {
    final db = await instance.database;
    final result = await db.query(tableInvestmentCategory,
        orderBy: "${InvestmentCategoryFields.name} ASC");
    return result.map((e) => InvestmentCategory.fromJson(e)).toList();
  }

  Future<int> updateInvestmentCategory(InvestmentCategory category) async {
    final db = await instance.database;
    return db.update(
      tableInvestmentCategory,
      category.toJson(),
      where: '${InvestmentCategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteInvestmentCategory(int id) async {
    final db = await instance.database;
    await db.delete(tableInvestmentSnapshot,
        where: "${InvestmentSnapshotFields.categoryId} = ?", whereArgs: [id]);
    return await db.delete(
      tableInvestmentCategory,
      where: "${InvestmentCategoryFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteInvestmentSnapshot(int id) async {
    final db = await instance.database;
    return await db.delete(tableInvestmentSnapshot,
        where: "${InvestmentSnapshotFields.id} = ?", whereArgs: [id]);
  }

  Future<List<InvestmentSnapshot>> readInvestmentSnapshotFor(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableInvestmentSnapshot,
      where: "${InvestmentSnapshotFields.categoryId} = ?",
      whereArgs: [id],
    );
    return result.map((e) => InvestmentSnapshot.fromJson(e)).toList();
  }

  Future<List<InvestmentSnapshot>> readAllInvestmentSnapshots() async {
    final db = await instance.database;
    final result = await db.query(tableInvestmentSnapshot,
        orderBy: "${InvestmentSnapshotFields.date} ASC");
    return result.map((e) => InvestmentSnapshot.fromJson(e)).toList();
  }

  Future<InvestmentSnapshot> createInvestmentSnapshot(
      InvestmentSnapshot snapshot) async {
    final db = await instance.database;
    final id = await db.insert(tableInvestmentSnapshot, snapshot.toJson());
    return snapshot.copy(id: id);
  }

  Future<InvestmentSnapshot?> readLastSnapshotFor(
      {required InvestmentCategory category}) async {
    final db = await instance.database;
    final snapshots = await db.query(tableInvestmentSnapshot,
        where: "${InvestmentSnapshotFields.categoryId} = ?",
        whereArgs: [category.id]);
    if (snapshots.isEmpty) {
      return null;
    }
    return InvestmentSnapshot.fromJson(snapshots.last);
  }

  Future<List<InvestmentSnapshot>> readAllLastSnapshots() async {
    final categories = await readAllInvestmentCategories();
    List<InvestmentSnapshot> lastSnapshots = [];
    for (var category in categories) {
      final lastSnapshot = await readLastSnapshotFor(category: category);
      if (lastSnapshot != null) {
        lastSnapshots.add(lastSnapshot);
      }
    }
    return lastSnapshots;
  }

  Future<List<WealthDataPoint>> getAllWealthDatapoints() async {
    List<WealthDataPoint> result = [];
    var snapshots = await readAllInvestmentSnapshots();
    // Get the unique dates as x values
    var uniqueDates = snapshots
        .map((e) => e.date)
        .map((e) => DateTime(e.year, e.month, e.day))
        .toSet()
        .toList();
    // Create a map with category ids as keys and the list of all snapshots for these categories as their values
    Map<int, List<InvestmentSnapshot>> snapshotsInCategories = {};
    for (var e in snapshots) {
      if (snapshotsInCategories.containsKey(e.categoryId)) {
        snapshotsInCategories.update(e.categoryId, (value) => [...value, e]);
      } else {
        snapshotsInCategories.putIfAbsent(e.categoryId, () => [e]);
      }
    }
    List<double> values = List.filled(uniqueDates.length, 0);
    for (var i = 0; i < uniqueDates.length; i++) {
      List<InvestmentSnapshot> relevantList = [];
      for (var list in snapshotsInCategories.values) {
        List<InvestmentSnapshot> listCopy = List.from(list);
        listCopy.removeWhere((e) =>
            DateTime(e.date.year, e.date.month, e.date.day)
                .isAfter(uniqueDates[i]));
        if (listCopy.isNotEmpty) {
          relevantList.add(listCopy.last);
        }
      }
      values[i] = relevantList.map((e) => e.amount).reduce((a, b) => a + b);
    }
    for (var i = 0; i < uniqueDates.length; i++) {
      result.add(WealthDataPoint(time: uniqueDates[i], value: values[i]));
    }
    return result;
  }
}
