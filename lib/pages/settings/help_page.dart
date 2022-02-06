import 'package:finance_buddy/pages/instructions_page.dart';
import 'package:finance_buddy/widgets/adaptive_text_button.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  static const String appVersion = "1.0.4";
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.about,
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
        // SizedBox(
        //   height: (MediaQuery.of(context).size.height / 2) -
        //       MediaQuery.of(context).viewPadding.top -
        //       200,
        // ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/icon.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Version $appVersion"),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("© 2021 Niklas Kuder"),
            ),
          ],
        ),
        const SizedBox(
          height: 100,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: AdaptiveTextButton(
            text: language.showIntroduction,
            onPressed: _showInstructions,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: AdaptiveTextButton(
            text: language.showAdditionalLicenses,
            onPressed: _showLicenses,
          ),
        ),
      ],
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: "Monity",
      applicationVersion: appVersion,
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset('assets/icon.png'),
        ),
      ),
    );
  }

  Future _showInstructions() async {
    double topInsets = (MediaQuery.of(context).viewPadding.top);
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 10),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: topInsets + 10,
                left: 20,
                right: 20,
              ),
              child: const InstructionsPage(),
            ),
          );
        });
  }

  // Future _openWebsite() async {
  //   if (!await launch('https://niklas-kuder.de')) {
  //     return;
  //   }
  // }
}
