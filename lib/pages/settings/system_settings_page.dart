import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
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

  String _getRandomString(int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
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
    }
  }
}
