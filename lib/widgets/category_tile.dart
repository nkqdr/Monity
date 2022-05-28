import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/helper/config_provider.dart';
import 'package:finance_buddy/helper/interfaces.dart';
import 'package:finance_buddy/helper/utils.dart';
import 'package:finance_buddy/widgets/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final Function refreshCallback;
  final List<Category> categories;

  const CategoryTile({
    Key? key,
    required this.refreshCallback,
    required this.category,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
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
                        (category as InvestmentCategory).label != null)
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
                                  (category as InvestmentCategory).label!,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            Utils.getCorrectTitleFromKey(
                                (category as InvestmentCategory).label!,
                                language),
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ],
                      ),
                    if (category is InvestmentCategory &&
                        (category as InvestmentCategory).label == null)
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
    );
  }

  Color _getColorForLabel(BuildContext context, String label) {
    var allLabels =
        Provider.of<ConfigProvider>(context).assetAllocationCategories;
    return allLabels
        .where((element) => element.title == label)
        .first
        .displayColor;
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
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CategoryBottomSheet(
              mode: CategoryBottomSheetMode.edit,
              hasLabelDropdown: hasLabelDropdown,
              label: hasLabelDropdown
                  ? (category as InvestmentCategory).label
                  : null,
              categories: categories,
              placeholder: category.name,
              onSubmit: (s) async {
                await category.copy(name: s).updateSelf();
              },
              onSubmitWithLabel: (s, l) async {
                await (category as InvestmentCategory)
                    .copy(name: s, label: l?.title)
                    .updateSelf();
              },
            ),
          );
        });
    refreshCallback();
  }

  Future _handleDelete(BuildContext context) async {
    var language = AppLocalizations.of(context)!;
    var dialogResult = await showOkCancelAlertDialog(
      context: context,
      title: language.attention,
      message: category.getDeleteMessage(language),
      isDestructiveAction: true,
      okLabel: language.delete,
      cancelLabel: language.abort,
    );
    if (dialogResult == OkCancelResult.ok) {
      await category.deleteSelf();
      refreshCallback();
    }
  }
}
