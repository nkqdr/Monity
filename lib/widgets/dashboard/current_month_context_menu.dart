import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../custom_cupertino_context_menu_action.dart';

class CurrentMonthContextMenu extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;
  final int daysRemaining;
  const CurrentMonthContextMenu({
    Key? key,
    required this.child,
    required this.daysRemaining,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.currentMonthOverview,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        language.remainingDays + " $daysRemaining",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      actions: [
        CustomCupertinoContextMenuAction(
          child: const Text("Hide"),
          trailingIcon: CupertinoIcons.eye_slash,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}
