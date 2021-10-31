import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../dashboard_tile.dart';

class PerformanceTile extends StatelessWidget {
  const PerformanceTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return DashboardTile(
      title: language.performanceTitle,
      subtitle: language.lastYear,
      subtitleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      width: DashboardTileWidth.half,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.arrow_upward_rounded,
              size: 60,
              color: Colors.green,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "+23,4%",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
