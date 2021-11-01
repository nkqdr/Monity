import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/controller/transactions_api.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
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

  @override
  void initState() {
    super.initState();
    currentContent = _getFirstPage();
    isButtonDisabled = true;
    _refreshCategories();
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

  void _handleAddExpense() {
    print("Adding expense...");
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
    return Column(
      key: const ValueKey<int>(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "What kind of transaction do you want to enter?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
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
              child: Text('Expense'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentContent = _getSecondPage();
                  currentIndex++;
                });
              },
              child: Text('Income'),
            ),
          ],
        )
      ],
    );
  }

  Widget _getSecondPage() {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    return Column(
      key: const ValueKey<int>(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "Select a category for this transaction:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditValue) {
            if (textEditValue.text == '') {
              return const Iterable<String>.empty();
            }
            return categories.map((e) => e.name).where((String option) {
              var lowOption = option.toLowerCase();
              return lowOption.contains(textEditValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            print('You just selected $selection');
            setState(() {
              _category = selection;
            });
          },
          optionsViewBuilder: (context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: 300,
                  height: 120,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(
                              option,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            return CustomTextField(
              focusNode: fieldFocusNode,
              controller: fieldTextEditingController,
              decoration:
                  const InputDecoration.collapsed(hintText: "Start typing..."),
            );
          },
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              print("Selected category is: $_category");
              setState(() {
                currentContent = _getThirdPage();
                currentIndex++;
              });
            },
            child: Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _getThirdPage() {
    return Column(
      key: const ValueKey<int>(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "Enter the amount of this transaction:",
            style: TextStyle(
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
              print("Selected amount is: $_amount");
            },
            child: Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _getFourthPage() {
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    return Column(
      key: const ValueKey<int>(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "Review:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              'Type:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(isExpense ? "Expense" : "Income"),
          ],
        ),
        Row(
          children: [
            Text(
              'Category:',
              style: TextStyle(
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
              'Amount:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(currencyFormat.format(_amount)),
          ],
        ),
        CustomTextField(
          decoration:
              InputDecoration.collapsed(hintText: "Description (Optional)"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Abort"),
            ),
            ElevatedButton(
                onPressed: () {
                  _handleAddExpense();
                  Navigator.of(context).pop();
                },
                child: Text("Add")),
          ],
        ),
      ],
    );
  }
}
