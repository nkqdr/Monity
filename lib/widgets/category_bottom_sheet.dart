import 'package:finance_buddy/helper/interfaces.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum CategoryBottomSheetMode {
  add,
  edit,
}

class CategoryBottomSheet extends StatefulWidget {
  final CategoryBottomSheetMode mode;
  final String? placeholder;
  final Function(String) onSubmit;
  final List<Category> categories;

  const CategoryBottomSheet({
    Key? key,
    this.placeholder,
    required this.onSubmit,
    required this.mode,
    required this.categories,
  }) : super(key: key);

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
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
              widget.mode == CategoryBottomSheetMode.add
                  ? language.newCategoryName
                  : language.editCategoryNewName,
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
              hintText: widget.placeholder ?? language.newCategoryNameHint,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
              child: ElevatedButton(
                onPressed: isButtonDisabled ? null : _handleSubmit,
                style: isButtonDisabled
                    ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).secondaryHeaderColor))
                    : null,
                child: Text(widget.mode == CategoryBottomSheetMode.add
                    ? language.addCategoryButton
                    : language.saveButton),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleChangeTextField(String value) {
    if (value.trim() != "" &&
        widget.categories
            .where((element) => element.name == value.trim())
            .isEmpty) {
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
    String value = _categoryNameController.text.trim();
    widget.onSubmit(value);
  }
}
