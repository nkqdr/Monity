import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/helper/interfaces.dart';
import 'package:monity/helper/types.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/widgets/custom_bottom_sheet.dart';
import 'package:monity/widgets/custom_textfield.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:monity/widgets/newmorphic/newmorphic_box.dart';
import 'package:monity/widgets/newmorphic/newmorphic_button.dart';
import 'package:provider/provider.dart';

enum CategoryBottomSheetMode {
  add,
  edit,
}

class CategoryBottomSheet<T extends Category> extends StatefulWidget {
  final CategoryBottomSheetMode mode;
  final T? category;
  final bool hasLabelDropdown;
  final String? label;

  CategoryBottomSheet({
    Key? key,
    this.category,
    this.hasLabelDropdown = false,
    this.label,
    required this.mode,
  }) : super(key: key) {
    assert(mode != CategoryBottomSheetMode.edit || category != null,
        "If you're using the .edit mode, you must provide a category to be edited!");
  }

  @override
  _CategoryBottomSheetState<T> createState() => _CategoryBottomSheetState<T>();
}

class _CategoryBottomSheetState<T extends Category> extends State<CategoryBottomSheet<T>> {
  final _categoryNameController = TextEditingController();
  late bool isButtonDisabled;
  late bool isTextFieldEmpty;
  AssetLabel? _selectedLabel;

  @override
  void initState() {
    super.initState();
    if (widget.category?.name != null) {
      _categoryNameController.text = widget.category!.name;
    }
    isButtonDisabled = true;
    isTextFieldEmpty = _categoryNameController.text == "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.label != null && widget.label != ConfigProvider.noneAssetLabel.title) {
      _selectedLabel = Provider.of<ConfigProvider>(context)
          .assetAllocationCategories
          .where((element) => element.title == widget.label)
          .first;
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    ListProvider<T> categoriesProvider = Provider.of<ListProvider<T>>(context);

    return CustomBottomSheet(
      child: Column(
        key: widget.key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              widget.mode == CategoryBottomSheetMode.add ? language.newCategoryName : language.editCategoryNewName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomTextField(
            controller: _categoryNameController,
            onChanged: (v) => _handleChangeTextField(v, categoriesProvider.list),
            decoration: InputDecoration.collapsed(
              hintText: widget.category?.name ?? language.newCategoryNameHint,
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
            Column(
              children: [
                NewmorphicBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: DropdownButton<AssetLabel?>(
                        value: _selectedLabel,
                        isExpanded: true,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(15),
                        underline: Container(),
                        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                        items:
                            Provider.of<ConfigProvider>(context).assetAllocationCategories.map(buildMenuItem).toList(),
                        onChanged: (value) {
                          setState(() => _selectedLabel = value);
                          if (!isTextFieldEmpty) {
                            setState(() => isButtonDisabled = false);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: NewmorphpicButton(
                    text: language.removeLabel,
                    isDestructive: true,
                    onPressed: _selectedLabel == null
                        ? null
                        : () {
                            setState(() => _selectedLabel = null);
                            setState(() => isButtonDisabled = _categoryNameController.text == widget.category?.name &&
                                widget.label == _selectedLabel?.title);
                          },
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
              child: NewmorphpicButton(
                onPressed: isButtonDisabled ? null : _handleSubmit,
                text: widget.mode == CategoryBottomSheetMode.add ? language.addCategoryButton : language.saveButton,
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

  void _handleChangeTextField(String value, List<Category>? categories) {
    if (value.trim() != "" &&
        categories != null &&
        categories.where((element) => element.name == value.trim()).isEmpty) {
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
    ListProvider categoriesProvider;
    if (T == TransactionCategory) {
      categoriesProvider = Provider.of<ListProvider<TransactionCategory>>(context, listen: false);
      if (widget.mode == CategoryBottomSheetMode.add) {
        categoriesProvider.insert(TransactionCategory(name: value));
      } else if (widget.mode == CategoryBottomSheetMode.edit) {
        categoriesProvider.update(widget.category!.id!, widget.category!.copy(name: value));
      }
    } else if (T == InvestmentCategory) {
      categoriesProvider = Provider.of<ListProvider<InvestmentCategory>>(context, listen: false);
      if (widget.mode == CategoryBottomSheetMode.add) {
        categoriesProvider.insert(
            InvestmentCategory(name: value, label: _selectedLabel?.title ?? ConfigProvider.noneAssetLabel.title));
      } else if (widget.mode == CategoryBottomSheetMode.edit) {
        categoriesProvider.update(
            widget.category!.id!,
            (widget.category as InvestmentCategory)
                .copy(name: value, label: _selectedLabel?.title ?? ConfigProvider.noneAssetLabel.title));
      }
    }
  }
}
