import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  late bool enableOverflow = false;

  @override
  void initState() {
    super.initState();
    // TODO: Read correct value from database
    enableOverflow = true;
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
        appBar: CustomAppBar(
          title: language.options,
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
          // Option to carry over the remaining budget into the next month.
          CustomSection(
            subtitle: language.remainingBudgetOverflow,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          language.enableOverflow,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Switch.adaptive(
                            value: enableOverflow, onChanged: _toggleOverflow)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);
  }

  void _toggleOverflow(bool value) {
    setState(() => enableOverflow = value);
    // TODO: Save change to key value database
  }
}
