import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/helper/interfaces.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/widgets/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monity/widgets/newmorphic/newmorphic_box.dart';
import 'package:provider/provider.dart';

class CategoryTile<T extends Category> extends StatelessWidget {
  final T category;

  const CategoryTile({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: NewmorphicBox(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      if (category is InvestmentCategory)
                        const SizedBox(
                          height: 10,
                        ),
                      if (category is InvestmentCategory &&
                          (category as InvestmentCategory).label != ConfigProvider.noneAssetLabel.title)
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getColorForLabel(
                                    context,
                                    (category as InvestmentCategory).label,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              Utils.getCorrectTitleFromKey((category as InvestmentCategory).label, language),
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ],
                        ),
                      if (category is InvestmentCategory &&
                          (category as InvestmentCategory).label == ConfigProvider.noneAssetLabel.title)
                        Text(
                          language.noLabel,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      child: const Icon(Icons.edit_rounded),
                      onTap: () => _handleEdit(context),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      child: const Icon(Icons.delete_rounded, color: Colors.red),
                      onTap: () => _handleDelete(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForLabel(BuildContext context, String label) {
    var allLabels = Provider.of<ConfigProvider>(context).assetAllocationCategories;
    return allLabels.where((element) => element.title == label).first.displayColor;
  }

  Future _handleEdit(BuildContext context) async {
    bool hasLabelDropdown = category is InvestmentCategory;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CategoryBottomSheet(
            mode: CategoryBottomSheetMode.edit,
            hasLabelDropdown: hasLabelDropdown,
            label: hasLabelDropdown ? (category as InvestmentCategory).label : null,
            category: category,
          ),
        );
      },
    );
  }

  Future _handleDelete(BuildContext context) async {
    var language = AppLocalizations.of(context)!;
    ListProvider categoriesListProvider;
    if (category is TransactionCategory) {
      categoriesListProvider = Provider.of<ListProvider<TransactionCategory>>(context, listen: false);
    } else if (category is InvestmentCategory) {
      categoriesListProvider = Provider.of<ListProvider<InvestmentCategory>>(context, listen: false);
    } else {
      return;
    }
    var dialogResult = await showOkCancelAlertDialog(
      context: context,
      title: language.attention,
      message: category.getDeleteMessage(language),
      isDestructiveAction: true,
      okLabel: language.delete,
      cancelLabel: language.abort,
    );
    if (dialogResult == OkCancelResult.ok) {
      categoriesListProvider.delete(category);
    }
  }
}
