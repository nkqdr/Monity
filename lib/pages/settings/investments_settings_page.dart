import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/widgets/category_tile.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/category_bottom_sheet.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class InvestmentsSettingsPage extends StatelessWidget {
  const InvestmentsSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.investments,
        left: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).primaryColor,
          ),
          splashRadius: 18,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      fixedAppBar: true,
      children: [
        CustomSection(
          title: language.investmentCategoriesTitle,
          subtitle: language.investmentCategoriesDescription,
          trailing: InkWell(
            borderRadius: BorderRadius.circular(15),
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () => _handleAddCategory(context),
          ),
          children: const [
            _InvestmentCategoriesList(),
          ],
        )
      ],
    );
  }

  Future _handleAddCategory(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CategoryBottomSheet<InvestmentCategory>(
              mode: CategoryBottomSheetMode.add,
              hasLabelDropdown: true,
            ),
          );
        });
  }
}

class _InvestmentCategoriesList extends StatelessWidget {
  const _InvestmentCategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categoriesProvider = Provider.of<ListProvider<InvestmentCategory>>(context);
    return Column(
      children: [
        ...categoriesProvider.list.map(
          (e) => CategoryTile(category: e),
        ),
      ],
    );
  }
}
