import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/widgets/custom_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:monity/widgets/newmorphic/newmorphic_box.dart';
import 'package:monity/widgets/newmorphic/newmorphic_button.dart';
import 'package:provider/provider.dart';

class AddSnapshotBottomSheet extends StatefulWidget {
  const AddSnapshotBottomSheet({Key? key}) : super(key: key);

  @override
  _AddSnapshotBottomSheetState createState() => _AddSnapshotBottomSheetState();
}

class _AddSnapshotBottomSheetState extends State<AddSnapshotBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InvestmentCategory? _investmentCategory;
  double? _givenAmount;

  Future _handleAddSnapshot() async {
    if (_investmentCategory == null) return;
    InvestmentSnapshot? lastSnapshot =
        await FinancesDatabase.instance.readLastSnapshotFor(category: _investmentCategory!);
    if (lastSnapshot != null &&
        lastSnapshot.date.day == DateTime.now().day &&
        lastSnapshot.date.month == DateTime.now().month &&
        lastSnapshot.date.year == DateTime.now().year) {
      await FinancesDatabase.instance.deleteInvestmentSnapshot(lastSnapshot.id!);
    }

    if (_givenAmount == null) {
      return;
    }

    await FinancesDatabase.instance.createInvestmentSnapshot(InvestmentSnapshot(
      categoryId: _investmentCategory!.id!,
      amount: _givenAmount!,
      date: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<ListProvider<InvestmentCategory>>(context);
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
                  language.addSnapshot,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
              NewmorphicBox(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonFormField<InvestmentCategory>(
                    hint: Text(language.selectCategory),
                    borderRadius: BorderRadius.circular(15),
                    menuMaxHeight: 300,
                    alignment: Alignment.center,
                    value: _investmentCategory,
                    enableFeedback: true,
                    isExpanded: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    autovalidateMode: AutovalidateMode.disabled,
                    items: categories.list.map<DropdownMenuItem<InvestmentCategory>>((e) {
                      return DropdownMenuItem<InvestmentCategory>(
                        value: e,
                        child: Text(e.name),
                      );
                    }).toList(),
                    onChanged: (InvestmentCategory? cat) {
                      setState(() => _investmentCategory = cat);
                    },
                    validator: (InvestmentCategory? cat) {
                      if (!categories.list.contains(cat) || cat == null) {
                        return language.invalidInput;
                      }
                      return null;
                    },
                  ),
                ),
              ),

            // Amount of Snapshot
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: NewmorphicBox(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      // if (x < 0) {
                      //   return language.invalidInput;
                      // }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            // Save button
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15),
              child: Center(
                child: NewmorphpicButton(
                  text: language.saveButton,
                  onPressed: categories.list.isEmpty
                      ? null
                      : () async {
                          bool isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            await _handleAddSnapshot();
                            Navigator.of(context).pop();
                          } else {
                            Utils.playErrorFeedback();
                          }
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
