import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TransactionsSettingsPage extends StatefulWidget {
  const TransactionsSettingsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsSettingsPage> createState() =>
      _TransactionsSettingsPageState();
}

class _TransactionsSettingsPageState extends State<TransactionsSettingsPage> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    categories = [
      "Test",
    ];
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return SafeArea(
      child: ListView(
        children: [
          CustomAppBar(
            title: language.transactionsSettings,
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
          const SizedBox(
            height: 20,
          ),
          CustomSection(
            title: language.monthlyLimit,
            titleSize: 18,
            titlePadding: 10,
            children: [],
          ),
          CustomSection(
            title: language.categories,
            titleSize: 18,
            titlePadding: 10,
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _handleAddCategory,
              splashRadius: 18,
            ),
            children: [
              ...categories.map(
                (e) => TransactionCategory(
                  title: e,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _handleAddCategory() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddCategoryBottomSheet(),
          );
        });
  }
}

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({Key? key}) : super(key: key);

  @override
  _AddCategoryBottomSheetState createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _categoryNameController = TextEditingController();
  late bool isButtonDisabled;

  @override
  void initState() {
    super.initState();
    isButtonDisabled = true;
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return CustomBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              language.newCategoryName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomTextField(
            controller: _categoryNameController,
            onChanged: _handleChangeTextField,
            decoration: InputDecoration.collapsed(
              hintText: language.newCategoryNameHint,
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: isButtonDisabled ? null : _handleSubmit,
              style: isButtonDisabled
                  ? ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).secondaryHeaderColor))
                  : null,
              child: Text(language.addCategoryButton),
            ),
          ),
        ],
      ),
    );
  }

  void _handleChangeTextField(String value) {
    if (value != "") {
      setState(() {
        isButtonDisabled = false;
      });
    } else {
      setState(() {
        isButtonDisabled = true;
      });
    }
  }

  void _handleSubmit() {
    Navigator.of(context).pop();
  }
}

class TransactionCategory extends StatelessWidget {
  final String title;
  const TransactionCategory({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
