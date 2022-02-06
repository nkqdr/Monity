import 'package:finance_buddy/helper/config.dart';
import 'package:finance_buddy/helper/interfaces.dart';
import 'package:finance_buddy/helper/types.dart';
import 'package:finance_buddy/helper/utils.dart';
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
  final Function(String, AssetLabel)? onSubmitWithLabel;
  final List<Category> categories;
  final bool? hasLabelDropdown;
  final String? label;

  const CategoryBottomSheet({
    Key? key,
    this.placeholder,
    this.hasLabelDropdown,
    this.onSubmitWithLabel,
    this.label,
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
  late bool isTextFieldEmpty;
  AssetLabel? _selectedLabel;

  @override
  void initState() {
    super.initState();
    if (widget.placeholder != null) {
      _categoryNameController.text = widget.placeholder!;
    }
    isButtonDisabled = true;
    isTextFieldEmpty = _categoryNameController.text == "";
    if (widget.label != null) {
      _selectedLabel = Config.assetAllocationCategories
          .where((element) => element.title == widget.label)
          .first;
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return CustomBottomSheet(
      child: Column(
        key: widget.key,
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
          if (widget.hasLabelDropdown == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: Text(
                language.newCategoryLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (widget.hasLabelDropdown == true)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: DropdownButton<AssetLabel?>(
                    value: _selectedLabel,
                    isExpanded: true,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(20),
                    underline: Container(),
                    items: Config.assetAllocationCategories
                        .map(buildMenuItem)
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedLabel = value);
                      if (!isTextFieldEmpty) {
                        setState(() => isButtonDisabled = false);
                      }
                    }),
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

  DropdownMenuItem<AssetLabel> buildMenuItem(AssetLabel item) {
    var language = AppLocalizations.of(context)!;
    return DropdownMenuItem(
      value: item,
      child: Text(Utils.getCorrectTitleFromKey(item.title, language)),
    );
  }

  void _handleChangeTextField(String value) {
    if (value.trim() != "" &&
        widget.categories
            .where((element) => element.name == value.trim())
            .isEmpty) {
      setState(() => isTextFieldEmpty = false);
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
    if (!widget.hasLabelDropdown!) {
      widget.onSubmit(value);
    } else if (widget.onSubmitWithLabel != null && _selectedLabel != null) {
      widget.onSubmitWithLabel!(value, _selectedLabel!);
    } else {
      widget.onSubmit(value);
    }
  }
}
