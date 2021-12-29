import 'package:finance_buddy/widgets/adaptive_text_button.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  static const String appVersion = "1.0";
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.help,
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
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/icon.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("Version $appVersion"),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("© 2021, Niklas Kuder"),
            ),
            AdaptiveTextButton(
              text: "niklas-kuder.de",
              onPressed: _openWebsite,
            ),
          ],
        )
      ],
    );
  }

  Future _openWebsite() async {
    if (!await launch('https://niklas-kuder.de')) {
      return;
    }
  }
}
