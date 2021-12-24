import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
import 'package:finance_buddy/widgets/multiple_choice_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSnapshotBottomSheet extends StatefulWidget {
  const AddSnapshotBottomSheet({Key? key}) : super(key: key);

  @override
  _AddSnapshotBottomSheetState createState() => _AddSnapshotBottomSheetState();
}

class _AddSnapshotBottomSheetState extends State<AddSnapshotBottomSheet> {
  int currentIndex = 0;
  int maxIndex = 2;
  double _amount = 0;
  String _category = "";
  bool isLoading = false;
  final _amountController = TextEditingController();
  late List<InvestmentCategory> categories;
  late bool isButtonDisabled;
  late Widget currentContent;

  @override
  void initState() {
    super.initState();
    isButtonDisabled = true;
    _refreshCategories();
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    categories = await FinancesDatabase.instance.readAllInvestmentCategories();
    currentContent = _getFirstPage();
    setState(() => isLoading = false);
  }

  Future _handleAddSnapshot() async {
    int category =
        categories.where((element) => element.name == _category).first.id!;
    FinancesDatabase.instance.createInvestmentSnapshot(InvestmentSnapshot(
      categoryId: category,
      amount: _amount,
      date: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.2, 0),
                  end: const Offset(0, 0),
                ).animate(animation),
                child: child,
              );
            },
            layoutBuilder: (currentChild, _) => currentChild as Widget,
            child: isLoading
                ? const Center(
                    child: AdaptiveProgressIndicator(),
                  )
                : currentContent,
          ),
          currentIndex < maxIndex ? _getPageProgress() : Container(),
        ],
      ),
    );
  }

  Widget _getPageProgress() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Center(
        child: Text(
          "${currentIndex + 1}/${maxIndex + 1}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _getFirstPage() {
    var language = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            language.selectCategoryForSnapshot,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (categories.isNotEmpty)
          MultipleChoiceTextField(
              categories: categories,
              onSelected: (s) {
                setState(() {
                  _category = s.trim();
                  isButtonDisabled = false;
                  currentContent = _getFirstPage();
                });
              },
              onValidInput: (s) {
                setState(() {
                  isButtonDisabled = false;
                  _category = s.trim();
                  currentContent = _getFirstPage();
                });
              },
              onInvalidInput: (s) {
                setState(() {
                  isButtonDisabled = true;
                  currentContent = _getFirstPage();
                });
              })
        else
          SizedBox(
            height: 50,
            child: Center(
              child: Text(
                language.firstCreateCategories,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
        Center(
          child: ElevatedButton(
            onPressed: isButtonDisabled
                ? null
                : () {
                    setState(() {
                      currentContent = _getSecondPage();
                      currentIndex++;
                    });
                  },
            style: isButtonDisabled
                ? ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).secondaryHeaderColor))
                : null,
            child: Text(language.next),
          ),
        ),
      ],
    );
  }

  Widget _getSecondPage() {
    var language = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey<int>(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            language.enterAmountOfTransaction,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomTextField(
          keyboardType: const TextInputType.numberWithOptions(
              decimal: true, signed: false),
          controller: _amountController,
          decoration: const InputDecoration.collapsed(hintText: "0,00"),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              var amountString = _amountController.text.replaceAll(",", ".");
              double newAmount;
              try {
                newAmount = double.parse(amountString);
              } catch (e) {
                return;
              }
              setState(() {
                _amount = newAmount;
                currentContent = _getThirdPage();
                currentIndex++;
              });
            },
            child: Text(language.next),
          ),
        ),
      ],
    );
  }

  Widget _getThirdPage() {
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey<int>(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            language.review,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              language.category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(_category),
          ],
        ),
        Row(
          children: [
            Text(
              language.amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(currencyFormat.format(_amount)),
          ],
        ),
        const SizedBox(
          height: 80,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(language.abort),
            ),
            ElevatedButton(
                onPressed: () {
                  _handleAddSnapshot();
                  Navigator.of(context).pop();
                },
                child: Text(language.saveButton)),
          ],
        ),
      ],
    );
  }
}
