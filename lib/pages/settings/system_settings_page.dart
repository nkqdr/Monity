import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:monity/backend/database_manager.dart';
import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/key_value_database.dart';
import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/l10n/language_provider.dart';
import 'package:monity/theme/theme_provider.dart';
import 'package:monity/widgets/adaptive_progress_indicator.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/adaptive_text_button.dart';
import 'package:monity/widgets/newmorphic/newmorphic_button.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({Key? key}) : super(key: key);

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  String validationString = "";
  late int databaseSize;
  late int transactionsCount;
  late int snapshotCount;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshDatabaseSize();
  }

  Future _refreshDatabaseSize() async {
    setState(() => isLoading = true);
    databaseSize = await FinancesDatabase.instance.getDatabaseSize();
    transactionsCount = (await FinancesDatabase.instance.readAllTransactions()).length;
    snapshotCount = (await FinancesDatabase.instance.readAllInvestmentSnapshots()).length;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var configProvider = Provider.of<ConfigProvider>(context);
    var dateFormatter = Utils.getDateFormatter(context);
    return View(
      appBar: CustomAppBar(
        title: language.system,
        left: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).primaryColor,
          ),
          splashRadius: 18,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      fixedAppBar: true,
      children: [
        CustomSection(
          groupItems: true,
          title: language.dataTitle,
          subtitle: language.dataSectionDescription,
          children: [
            // Registered transactions
            Container(
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language.registeredTransactions,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    if (isLoading)
                      const AdaptiveProgressIndicator()
                    else
                      Text(
                        transactionsCount.toString(),
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ],
                ),
              ),
            ),
            // Registered snapshots
            Container(
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language.registeredSnapshots,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    if (isLoading)
                      const AdaptiveProgressIndicator()
                    else
                      Text(
                        snapshotCount.toString(),
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ],
                ),
              ),
            ),
            // Used storage
            Container(
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language.usedStorage,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    if (isLoading)
                      const AdaptiveProgressIndicator()
                    else
                      Text(
                        _formatBytes(databaseSize, 2),
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
        Center(
          child: NewmorphpicButton(
            onPressed: _handleDeleteData,
            text: language.deleteAllData,
            isDestructive: true,
            // expandWidth: true,
          ),
          // child: AdaptiveTextButton(
          //   onPressed: _handleDeleteData,
          //   isDescructive: true,
          //   text: language.deleteAllData,
          // ),
        ),
        CustomSection(
          title: language.backup,
          subtitle: language.backupDescription,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NewmorphpicButton(
                  text: language.generateBackup,
                  onPressed: () => _handleGenerateBackup(context),
                ),
                NewmorphpicButton(
                  text: language.loadBackup,
                  onPressed: () => _handleLoadBackup(context),
                ),
                // AdaptiveTextButton(
                //   onPressed: () => _handleGenerateBackup(context),
                //   text: language.generateBackup,
                // ),
                // AdaptiveTextButton(
                //   onPressed: () => _handleLoadBackup(context),
                //   text: language.loadBackup,
                // ),
              ],
            ),
            if (configProvider.lastBackupCreated != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Theme.of(context).secondaryHeaderColor,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    Text(
                      language.lastBackupCreatedOn + dateFormatter.format(configProvider.lastBackupCreated!),
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }

  Future _handleLoadBackup(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var language = AppLocalizations.of(context)!;
    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.path.split("/").last.split(".").last != DatabaseManager.instance.saveFileType) {
        await showOkAlertDialog(
          context: context,
          title: language.attention,
          message: language.backupRestoreError,
        );
        return;
      }
      String backup = file.readAsStringSync();
      try {
        await DatabaseManager.instance.restoreBackup(backup);
      } catch (e) {
        await showOkAlertDialog(
          context: context,
          title: language.attention,
          message: language.databaseAlreadyExistsError,
        );
        return;
      }
      await showOkAlertDialog(
        context: context,
        title: language.load_success,
        message: language.backupRestoredSuccessfully,
      );
      await Provider.of<ListProvider<TransactionCategory>>(context).fetchList();
      await Provider.of<ListProvider<InvestmentCategory>>(context).fetchList();
      _refreshDatabaseSize();
    } else {
      // User canceled the picker
    }
  }

  Future<List<String>> _listofFiles() async {
    String directory = "";
    if (Platform.isIOS) {
      directory = (await getApplicationDocumentsDirectory()).path;
    } else {
      directory = (await getExternalStorageDirectories(type: StorageDirectory.documents))!.first.path;
    }
    List<FileSystemEntity> files;
    try {
      files = Directory("$directory/").listSync();
    } catch (e) {
      files = [];
    }
    return files.map((e) => e.path.split("/").last).toList();
  }

  Future _handleGenerateBackup(BuildContext context) async {
    // String? outputFile = await FilePicker.platform.saveFile(
    //   dialogTitle: 'Please select an output file:',
    //   fileName: 'output-file.pdf',
    // );

    // if (outputFile == null) {
    //   // User canceled the picker
    // }
    var language = AppLocalizations.of(context)!;
    List<String> files = await _listofFiles();
    List<String> relevantFileNames = files
        .where((e) => e.split(".").last == DatabaseManager.instance.saveFileType)
        .map((e) => e.split(".").first)
        .toList();
    var dialogResult = await showTextInputDialog(
      context: context,
      title: language.attention,
      message: language.typeNameOfBackup,
      isDestructiveAction: false,
      okLabel: language.saveButton,
      cancelLabel: language.abort,
      textFields: [
        DialogTextField(validator: (s) {
          return !relevantFileNames.contains(s) ? null : language.fileAlreadyExists;
        })
      ],
    );
    if (dialogResult != null) {
      var result = await DatabaseManager.instance.generateBackup(isEncrypted: true);
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
          var permResult = await Permission.storage.request();
          if (permResult.isGranted) {
            _finishSaving(result, dialogResult.first);
          }
          return;
        }
      }
      Provider.of<ConfigProvider>(context, listen: false).setLastBackupCreated(DateTime.now());
      _finishSaving(result, dialogResult.first);
    }
  }

  Future _finishSaving(String result, String fileName) async {
    var language = AppLocalizations.of(context)!;
    String filePath = await DatabaseManager.instance.saveBackup(result, fileName);
    await showOkAlertDialog(
      context: context,
      title: language.save_success,
      message: Platform.isIOS ? language.savedTo : language.savedToAndroid + "\n" + filePath,
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1000, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  String _getRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhiJjKkLMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));
  }

  Future _handleDeleteData() async {
    var language = AppLocalizations.of(context)!;
    setState(() => validationString = _getRandomString(6));
    var dialogResult = await showTextInputDialog(
      context: context,
      title: language.attention,
      message: language.sureDeleteData + "\n\n$validationString",
      isDestructiveAction: true,
      okLabel: language.delete,
      cancelLabel: language.abort,
      textFields: [
        DialogTextField(validator: (s) {
          return s == validationString ? null : language.invalidInput;
        })
      ],
    );
    if (dialogResult != null) {
      await FinancesDatabase.instance.deleteDatabase();
      await KeyValueDatabase.deleteAllData();
      Provider.of<ListProvider<InvestmentCategory>>(context, listen: false).reset();
      Provider.of<ListProvider<TransactionCategory>>(context, listen: false).reset();
      Provider.of<LanguageProvider>(context, listen: false).reset();
      Provider.of<ConfigProvider>(context, listen: false).reset();
      Provider.of<ThemeProvider>(context, listen: false).reset();
      _refreshDatabaseSize();
    }
  }
}
