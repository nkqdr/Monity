import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/newmorphic/newmorphic_box.dart';
import 'package:monity/widgets/newmorphic/newmorphic_button.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpPage extends StatelessWidget {
  static const String appVersion = "1.1";

  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.about,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: NewmorphicBox(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/icon.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Monity",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text("Version $appVersion"),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text("© 2021-2022 Niklas Kuder"),
            ),
          ],
        ),
        const SizedBox(
          height: 100,
        ),
        const SizedBox(height: 5),
        NewmorphpicButton(
          text: language.showAdditionalLicenses,
          onPressed: () => _showLicenses(context),
        ),
      ],
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: "Monity",
      applicationVersion: appVersion,
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset('assets/icon.png'),
        ),
      ),
    );
  }
}
