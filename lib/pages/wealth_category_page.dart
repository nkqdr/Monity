import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_cupertino_context_menu_action.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WealthCategoryPage extends StatefulWidget {
  final InvestmentCategory category;
  const WealthCategoryPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _WealthCategoryPageState createState() => _WealthCategoryPageState();
}

class _WealthCategoryPageState extends State<WealthCategoryPage> {
  late List<InvestmentSnapshot> snapshots;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshSnapshots();
  }

  Future _refreshSnapshots() async {
    setState(() => isLoading = true);
    snapshots = await FinancesDatabase.instance
        .readInvestmentSnapshotFor(widget.category.id!);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    DateFormat dateFormatter;
    if (provider.locale == null) {
      dateFormatter =
          DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    } else {
      dateFormatter = DateFormat.yMMMMd(provider.locale!.languageCode);
    }
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: widget.category.name,
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
      children: isLoading
          ? const [AdaptiveProgressIndicator()]
          : (snapshots.isEmpty
              ? [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2 + 150,
                    child: Center(
                      child: Text(
                        language.noSnapshotsYet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  )
                ]
              : [
                  ...snapshots.reversed.map((e) {
                    return CupertinoContextMenu(
                      actions: [
                        CustomCupertinoContextMenuAction(
                          child: Text(language.delete),
                          trailingIcon: CupertinoIcons.delete,
                          isDestructiveAction: true,
                          onPressed: () => _handleDeleteSnapshot(e),
                        )
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Material(
                          color: Theme.of(context).cardColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateFormatter.format(e.date),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currencyFormat.format(e.amount),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                ]),
    );
  }

  Future _handleDeleteSnapshot(InvestmentSnapshot snapshot) async {
    var language = AppLocalizations.of(context)!;
    var result = await showOkCancelAlertDialog(
        context: context,
        title: language.deleteSnapshot,
        message: language.sureDeleteSnapshot,
        isDestructiveAction: true);
    if (result == OkCancelResult.ok) {
      await FinancesDatabase.instance.deleteInvestmentSnapshot(snapshot.id!);
      _refreshSnapshots();
      Navigator.pop(context);
    }
  }
}
