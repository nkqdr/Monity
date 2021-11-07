import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CashFlowTile extends StatelessWidget {
  const CashFlowTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return DashboardTile(
      title: language.cashFlow,
    );
  }
}
