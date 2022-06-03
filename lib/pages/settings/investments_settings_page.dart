import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/helper/types.dart';
import 'package:monity/widgets/adaptive_progress_indicator.dart';
import 'package:monity/widgets/category_tile.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/category_bottom_sheet.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentsSettingsPage extends StatefulWidget {
  const InvestmentsSettingsPage({Key? key}) : super(key: key);

  @override
  State<InvestmentsSettingsPage> createState() => _InvestmentsSettingsPageState();
}

class _InvestmentsSettingsPageState extends State<InvestmentsSettingsPage> {
  bool isLoading = false;
  late List<InvestmentCategory> categories;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    categories = await FinancesDatabase.instance.readAllInvestmentCategories();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.investments,
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
      fixedAppBar: true,
      children: [
        CustomSection(
          title: language.investmentCategoriesTitle,
          subtitle: language.investmentCategoriesDescription,
          trailing: InkWell(
            borderRadius: BorderRadius.circular(15),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
            onTap: _handleAddCategory,
          ),
          children: isLoading
              ? [const Center(child: AdaptiveProgressIndicator())]
              : [
                  ...categories.map(
                    (e) => CategoryTile(
                      category: e,
                      categories: categories,
                      refreshCallback: _refreshCategories,
                    ),
                  ),
                ],
        )
      ],
    );
  }

  Future _handleAddCategory() async {
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
              mode: CategoryBottomSheetMode.add,
              categories: categories,
              hasLabelDropdown: true,
              onSubmit: (s) {
                FinancesDatabase.instance.createInvestmentCategory(InvestmentCategory(
                  name: s,
                ));
              },
              onSubmitWithLabel: (s, AssetLabel? l) {
                FinancesDatabase.instance.createInvestmentCategory(InvestmentCategory(
                  name: s,
                  label: l?.title,
                ));
              },
            ),
          );
        });
    _refreshCategories();
  }
}
