import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO: Implement different languages for FAQ Page.
class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.faq,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: const [
            CustomSection(
              title: 'General',
              titlePadding: 10,
              children: [
                _CustomExpansionTile(
                  title: 'Is my data stored securely?',
                  leading: '🔒',
                  children: [
                    ListTile(
                      title: Text('Some Answer'),
                    ),
                  ],
                ),
              ],
            ),
            CustomSection(
              title: 'Wealth Page',
              titlePadding: 10,
              children: [
                _CustomExpansionTile(
                  title: 'Some Question',
                  leading: '💸',
                  children: [
                    ListTile(
                      title: Text('Some Answer'),
                    ),
                    ListTile(
                      title: Text('Some Answer'),
                    )
                  ],
                ),
                _CustomExpansionTile(
                  title: 'Some Question',
                  children: [
                    ListTile(
                      title: Text('Some Answer'),
                    ),
                  ],
                ),
              ],
            ),
            CustomSection(
              title: 'Transactions Page',
              titlePadding: 10,
              children: [
                _CustomExpansionTile(
                  title: 'Some Question',
                  leading: '💸',
                  children: [
                    ListTile(
                      title: Text('Some Answer'),
                    ),
                    ListTile(
                      title: Text('Some Answer'),
                    )
                  ],
                ),
                _CustomExpansionTile(
                  title: 'Some Question',
                  children: [
                    ListTile(
                      title: Text('Some Answer'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _CustomExpansionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final String? leading;

  const _CustomExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Theme.of(context).cardColor,
      backgroundColor: Theme.of(context).cardColor,
      textColor: Colors.green,
      iconColor: Colors.green,
      title: Text(title),
      leading: leading != null
          ? Text(
              leading!,
              style: const TextStyle(fontSize: 22),
            )
          : null,
      children: children,
    );
  }
}
