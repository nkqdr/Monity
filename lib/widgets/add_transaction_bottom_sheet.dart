import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
//import 'package:finance_buddy/helper/transaction.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
import 'package:finance_buddy/widgets/multiple_choice_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({Key? key}) : super(key: key);

  @override
  _AddTransactionBottomSheetState createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  bool isExpense = false;
  String _category = "";
  double _amount = 0;
  int currentIndex = 0;
  int maxIndex = 3;
  bool isLoading = false;
  late List<TransactionCategory> categories;
  late bool isButtonDisabled;
  late Widget currentContent;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isButtonDisabled = true;
    _refreshCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentContent = _getFirstPage();
  }

  Future _refreshCategories() async {
    setState(() {
      isLoading = true;
    });
    categories = await FinancesDatabase.instance.readAllTransactionCategories();
    setState(() {
      isLoading = false;
    });
  }

  void _handleAddTransaction() {
    int category =
        categories.where((element) => element.name == _category).first.id!;
    FinancesDatabase.instance.createTransaction(Transaction(
      amount: _amount,
      date: DateTime.now(),
      type: isExpense ? TransactionType.expense : TransactionType.income,
      categoryId: category,
      description: _descriptionController.text,
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
            child: currentContent,
          ),
          const SizedBox(
            height: 20,
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
      key: const ValueKey<int>(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            language.whatKindOfTransaction,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isExpense = true;
                    currentContent = _getSecondPage();
                    currentIndex++;
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: Text(language.expense),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentContent = _getSecondPage();
                    currentIndex++;
                  });
                },
                child: Text(language.income),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _getSecondPage() {
    var language = AppLocalizations.of(context)!;
    if (isLoading) {
      return const AdaptiveProgressIndicator();
    }
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            language.selectCategoryForTransaction,
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
                  currentContent = _getSecondPage();
                });
              },
              onValidInput: (s) {
                setState(() {
                  isButtonDisabled = false;
                  _category = s.trim();
                  currentContent = _getSecondPage();
                });
              },
              onInvalidInput: (s) {
                setState(() {
                  isButtonDisabled = true;
                  currentContent = _getSecondPage();
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
                      currentContent = _getThirdPage();
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

  Widget _getThirdPage() {
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
                currentContent = _getFourthPage();
                currentIndex++;
              });
            },
            child: Text(language.next),
          ),
        ),
      ],
    );
  }

  Widget _getFourthPage() {
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
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
              language.type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(isExpense ? language.expense : language.income),
          ],
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
            Flexible(child: Text(_category)),
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
        CustomTextField(
          controller: _descriptionController,
          decoration:
              InputDecoration.collapsed(hintText: language.optionalDescription),
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
                  _handleAddTransaction();
                  Navigator.of(context).pop();
                },
                child: Text(language.saveButton)),
          ],
        ),
      ],
    );
  }
}
