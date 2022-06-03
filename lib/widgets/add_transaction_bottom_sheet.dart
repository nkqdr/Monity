import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/widgets/custom_bottom_sheet.dart';
import 'package:monity/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  final bool isRecurring;

  const AddTransactionBottomSheet({
    Key? key,
    this.isRecurring = false,
  }) : super(key: key);

  @override
  _AddTransactionBottomSheetState createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TransactionType? _transactionType;
  TransactionCategory? _transactionCategory;
  double? _givenAmount;
  bool _showTransactionTypeHint = false;
  final _descriptionController = TextEditingController();

  Future _handleAddTransaction() async {
    int category = _transactionCategory!.id!;
    if (_givenAmount == null) {
      return;
    }
    FinancesDatabase.instance.createTransaction(
      Transaction(
        amount: _givenAmount!,
        date: DateTime.now(),
        type: _transactionType ?? TransactionType.expense,
        categoryId: category,
        description: _descriptionController.text,
      ),
      recurring: widget.isRecurring,
    );
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<ListProvider<TransactionCategory>>(context);
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
            if (categories.list.isEmpty)
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
              )
            else
              Container(
                constraints: const BoxConstraints(minHeight: 50),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonFormField<TransactionCategory>(
                  hint: Text(language.selectCategory),
                  borderRadius: BorderRadius.circular(15),
                  menuMaxHeight: 300,
                  alignment: Alignment.center,
                  value: _transactionCategory,
                  enableFeedback: true,
                  isExpanded: true,
                  decoration: const InputDecoration(border: InputBorder.none),
                  autovalidateMode: AutovalidateMode.disabled,
                  items: categories.list.map<DropdownMenuItem<TransactionCategory>>((e) {
                    return DropdownMenuItem<TransactionCategory>(
                      value: e,
                      child: Text(e.name),
                    );
                  }).toList(),
                  onChanged: (TransactionCategory? cat) {
                    setState(() => _transactionCategory = cat);
                  },
                  validator: (TransactionCategory? cat) {
                    if (!categories.list.contains(cat) || cat == null) {
                      return language.invalidInput;
                    }
                    return null;
                  },
                ),
              ),

            // Type of transaction
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _transactionType = TransactionType.expense);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _transactionType == TransactionType.expense ? Colors.red : Colors.grey),
                    ),
                    child: Text(language.expense),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _transactionType = TransactionType.income);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _transactionType == TransactionType.income ? Colors.green : Colors.grey),
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
                    style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12),
                  ),
                ),
              ),

            // Amount of transaction
            Container(
              constraints: const BoxConstraints(minHeight: 50),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                decoration: const InputDecoration.collapsed(hintText: "0,00"),
                validator: (String? val) {
                  double x = 0;
                  if (val == null || val == "") {
                    return language.invalidInput;
                  }
                  var amountString = val.replaceAll(",", ".");
                  try {
                    x = double.parse(amountString);
                    setState(() => _givenAmount = x);
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
              decoration: InputDecoration.collapsed(hintText: language.optionalDescription),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15),
              child: Center(
                child: ElevatedButton(
                  key: const Key("save-transaction-button"),
                  onPressed: categories.list.isEmpty
                      ? null
                      : () {
                          bool isValid = _formKey.currentState!.validate();
                          if (_transactionType == null) {
                            setState(() => _showTransactionTypeHint = true);
                            Utils.playErrorFeedback();
                            return;
                          } else {
                            setState(() => _showTransactionTypeHint = false);
                          }
                          if (isValid) {
                            _handleAddTransaction();
                            Navigator.of(context).pop();
                          } else {
                            Utils.playErrorFeedback();
                          }
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(categories.list.isEmpty ? Colors.grey : Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
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
