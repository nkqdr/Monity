import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/adaptive_text_button.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({Key? key}) : super(key: key);

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  String validationString = "";
  late int databaseSize;
  late int transactionsCount;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshDatabaseSize();
  }

  Future _refreshDatabaseSize() async {
    setState(() => isLoading = true);
    databaseSize = await FinancesDatabase.instance.getDatabaseSize();
    transactionsCount =
        (await FinancesDatabase.instance.readAllTransactions()).length;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.system,
        left: IconButton(
          icon: const Icon(
            Icons.chevron_left,
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
          title: language.dataTitle,
          subtitle: language.dataSectionDescription,
          children: [
            // Registered transactions
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15),
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
            ),
            // Used storage
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15),
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
            ),
            Center(
              child: AdaptiveTextButton(
                onPressed: _handleDeleteData,
                isDescructive: true,
                text: language.deleteAllData,
              ),
            )
          ],
        ),
      ],
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1000, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  String _getRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhiJjKkLMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));
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
      _refreshDatabaseSize();
    }
  }
}
