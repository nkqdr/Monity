import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/widgets/adaptive_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({Key? key}) : super(key: key);

  @override
  _InstructionsPageState createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getCurrentPage(),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom, top: 30),
            child: AdaptiveFilledButton(
              child: Text(
                pageIndex < 2 ? language.continueText : language.finish,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (pageIndex < 2) {
                  setState(() {
                    pageIndex += 1;
                  });
                } else {
                  _handleCloseIntroduction();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleCloseIntroduction() {
    Navigator.of(context).pop();
    KeyValueDatabase.setFirstStartup();
  }

  bool _isLightMode(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor == Colors.white;
  }

  Widget _getCurrentPage() {
    switch (pageIndex) {
      case 0:
        return _getFirstPage();
      case 1:
        return _getSecondPage();
      case 2:
        return _getThirdPage();
    }
    return Container();
  }

  Widget _getFirstPage() {
    var language = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              language.introductionTitle,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            GestureDetector(
              onTap: _handleCloseIntroduction,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .secondaryHeaderColor
                        .withOpacity(0.2)),
                height: 50,
                width: 50,
                child: const Icon(Icons.close),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(_isLightMode(context)
                ? 'assets/instructions/transactions_settings_light.png'
                : 'assets/instructions/transactions_settings_dark.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(language.transactionsIntroduction),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(_isLightMode(context)
                ? 'assets/instructions/transactions_view_light.png'
                : 'assets/instructions/transactions_view_dark.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(language.transactionsViewIntroduction),
        ),
      ],
    );
  }

  Widget _getSecondPage() {
    var language = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              language.introductionTitle,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            GestureDetector(
              onTap: _handleCloseIntroduction,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .secondaryHeaderColor
                        .withOpacity(0.2)),
                height: 50,
                width: 50,
                child: const Icon(Icons.close),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(_isLightMode(context)
                ? 'assets/instructions/investments_settings_light.png'
                : 'assets/instructions/investments_settings_dark.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(language.investmentIntroduction),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(_isLightMode(context)
                ? 'assets/instructions/investments_view_light.png'
                : 'assets/instructions/investments_view_dark.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(language.investmentViewIntroduction),
        ),
      ],
    );
  }

  Widget _getThirdPage() {
    var language = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              language.introductionTitle,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            GestureDetector(
              onTap: _handleCloseIntroduction,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .secondaryHeaderColor
                        .withOpacity(0.2)),
                height: 50,
                width: 50,
                child: const Icon(Icons.close),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(_isLightMode(context)
                ? 'assets/instructions/dashboard_top_light.png'
                : 'assets/instructions/dashboard_top_dark.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(_isLightMode(context)
                ? 'assets/instructions/dashboard_bot_light.png'
                : 'assets/instructions/dashboard_bot_dark.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(language.dashboardIntroduction),
        ),
      ],
    );
  }
}
