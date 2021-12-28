import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/helper/interfaces.dart';
import 'package:finance_buddy/widgets/category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryTile extends StatefulWidget {
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
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    child: const Icon(Icons.edit_rounded),
                    onTap: _handleEdit,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    child: const Icon(Icons.delete_rounded, color: Colors.red),
                    onTap: _handleDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _handleEdit() async {
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
              categories: widget.categories,
              placeholder: widget.category.name,
              onSubmit: (s) async {
                await widget.category.copy(name: s).updateSelf();
              },
            ),
          );
        });
    widget.refreshCallback();
  }

  Future _handleDelete() async {
    var language = AppLocalizations.of(context)!;
    var dialogResult = await showOkCancelAlertDialog(
      context: context,
      title: language.attention,
      message: widget.category.getDeleteMessage(language),
      isDestructiveAction: true,
      okLabel: language.delete,
      cancelLabel: language.abort,
    );
    if (dialogResult == OkCancelResult.ok) {
      await widget.category.deleteSelf();
      widget.refreshCallback();
    }
  }
}
