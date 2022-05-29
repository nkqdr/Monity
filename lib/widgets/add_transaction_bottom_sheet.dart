import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({Key? key}) : super(key: key);

  @override
  _AddTransactionBottomSheetState createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TransactionType? _transactionType;
  TransactionCategory? _transactionCategory;
  bool _showTransactionTypeHint = false;
  final Future<List<TransactionCategory>> _categories =
      FinancesDatabase.instance.readAllTransactionCategories();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future _handleAddTransaction() async {
    int category = _transactionCategory!.id!;
    var amountString = _amountController.text.replaceAll(",", ".");
    double newAmount;
    try {
      newAmount = double.parse(amountString);
    } catch (e) {
      return;
    }
    FinancesDatabase.instance.createTransaction(Transaction(
      amount: newAmount,
      date: DateTime.now(),
      type: _transactionType ?? TransactionType.expense,
      categoryId: category,
      description: _descriptionController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return CustomBottomSheet(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Text(
                  language.addTransaction,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Category for transaction
            FutureBuilder<List<TransactionCategory>>(
              future: _categories,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      if (snapshot.data!.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(minHeight: 50),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonFormField<TransactionCategory>(
                            hint: Text(language.selectCategoryForTransaction),
                            borderRadius: BorderRadius.circular(15),
                            menuMaxHeight: 300,
                            alignment: Alignment.center,
                            value: _transactionCategory,
                            enableFeedback: true,
                            isExpanded: true,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            autovalidateMode: AutovalidateMode.disabled,
                            items: snapshot.data!
                                .map<DropdownMenuItem<TransactionCategory>>(
                                    (e) {
                              return DropdownMenuItem<TransactionCategory>(
                                value: e,
                                child: Text(e.name),
                              );
                            }).toList(),
                            onChanged: (TransactionCategory? cat) {
                              setState(() => _transactionCategory = cat);
                            },
                            validator: (TransactionCategory? cat) {
                              if (!snapshot.data!.contains(cat) ||
                                  cat == null) {
                                return language.invalidInput;
                              }
                              return null;
                            },
                          ),
                        )
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
                    ],
                  );
                }
                return const Center(child: AdaptiveProgressIndicator());
              }),
            ),

            // Type of transaction
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(
                          () => _transactionType = TransactionType.expense);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _transactionType == TransactionType.expense
                              ? Colors.red
                              : Colors.grey),
                    ),
                    child: Text(language.expense),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _transactionType = TransactionType.income);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _transactionType == TransactionType.income
                              ? Colors.green
                              : Colors.grey),
                    ),
                    child: Text(language.income),
                  ),
                ],
              ),
            ),
            if (_showTransactionTypeHint)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    language.selectTransactionType,
                    style: TextStyle(
                        color: Theme.of(context).errorColor, fontSize: 12),
                  ),
                ),
              ),

            // Amount of transaction
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                controller: _amountController,
                decoration: const InputDecoration.collapsed(hintText: "0,00"),
                validator: (String? val) {
                  double x = 0;
                  if (val == null || val == "") {
                    return language.invalidInput;
                  }
                  try {
                    x = double.parse(val);
                  } catch (e) {
                    return language.invalidInput;
                  }
                  if (x < 0) {
                    return language.invalidInput;
                  }
                  return null;
                },
              ),
            ),

            // Optional description
            CustomTextField(
              controller: _descriptionController,
              decoration: InputDecoration.collapsed(
                  hintText: language.optionalDescription),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    bool isValid = _formKey.currentState!.validate();
                    if (_transactionType == null) {
                      setState(() => _showTransactionTypeHint = true);
                      return;
                    } else {
                      setState(() => _showTransactionTypeHint = false);
                    }
                    if (isValid) {
                      _handleAddTransaction();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(language.saveButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
