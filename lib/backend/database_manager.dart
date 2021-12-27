import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'dart:convert' as convert;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  final String secretKey = "2021_SECRET_KEYS";
  final String saveFileType = "account";
  DatabaseManager._init();

  final List<String> tables = [
    tableInvestmentSnapshot,
    tableInvestmentCategory,
    tableTransaction,
    tableTransactionCategory,
  ];

  Future<String> generateBackup({bool isEncrypted = true}) async {
    var dbs = await FinancesDatabase.instance.database;
    List data = [];
    List<Map<String, dynamic>> listMaps = [];
    for (var i = 0; i < tables.length; i++) {
      listMaps = await dbs.query(tables[i]);
      data.add(listMaps);
    }
    List backups = [tables, data];
    String json = convert.jsonEncode(backups);
    if (isEncrypted) {
      var key = encrypt.Key.fromUtf8(secretKey);
      var iv = encrypt.IV.fromLength(16);
      var encrypter = encrypt.Encrypter(encrypt.AES(key));
      var encrypted = encrypter.encrypt(json, iv: iv);
      return encrypted.base64;
    } else {
      return json;
    }
  }

  Future<void> restoreBackup(String backup, {bool isEncrypted = true}) async {
    var dbs = await FinancesDatabase.instance.database;
    Batch batch = dbs.batch();
    var key = encrypt.Key.fromUtf8(secretKey);
    var iv = encrypt.IV.fromLength(16);
    var encrypter = encrypt.Encrypter(encrypt.AES(key));
    List json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);
    for (var i = 0; i < json[0].length; i++) {
      for (var k = 0; k < json[1][i].length; k++) {
        batch.insert(json[0][i], json[1][i][k]);
      }
    }
    await batch.commit(continueOnError: false, noResult: true);
  }

  Future saveBackup(String backup, String fileName) async {
    File file = File(await getFilePath(fileName));
    file.writeAsString(backup);
  }

  Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$fileName.$saveFileType';
    return filePath;
  }
}
