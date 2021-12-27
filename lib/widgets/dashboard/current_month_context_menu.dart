import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../custom_cupertino_context_menu_action.dart';

class CurrentMonthContextMenu extends StatefulWidget {
  final Widget child;
  final int daysRemaining;
  final double? remainingAmount;
  final double? monthlyLimit;
  const CurrentMonthContextMenu({
    Key? key,
    required this.child,
    required this.monthlyLimit,
    required this.remainingAmount,
    required this.daysRemaining,
  }) : super(key: key);

  @override
  State<CurrentMonthContextMenu> createState() =>
      _CurrentMonthContextMenuState();
}

class _CurrentMonthContextMenuState extends State<CurrentMonthContextMenu> {
  bool showRemainingGraphic = false;
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var currencyFormat =
        NumberFormat.simpleCurrency(locale: "de_DE", decimalDigits: 2);
    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
        if (widget.monthlyLimit == null || widget.remainingAmount == null) {
          return Container();
        }
        animation.addListener(() {
          if (animation.status == AnimationStatus.reverse) {
            showRemainingGraphic = false;
          } else if (animation.status == AnimationStatus.forward &&
              animation.value > 0.3) {
            showRemainingGraphic = true;
          }
        });
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                language.remainingDays +
                                    " ${widget.daysRemaining}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    language.remainingBudget,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  showRemainingGraphic
                                      ? Text(
                                          widget.remainingAmount! >= 0
                                              ? "+" +
                                                  currencyFormat.format(
                                                      widget.remainingAmount)
                                              : currencyFormat.format(
                                                  widget.remainingAmount),
                                          style: TextStyle(
                                            color: widget.remainingAmount! >= 0
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          showRemainingGraphic
                              ? Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 40) /
                                          3,
                                  height:
                                      MediaQuery.of(context).size.height / 4 -
                                          20,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Theme.of(context).cardColor
                                        ],
                                        stops: widget.remainingAmount! <= 0
                                            ? [0, 0]
                                            : [
                                                (widget.remainingAmount! /
                                                    widget.monthlyLimit!),
                                                (widget.remainingAmount! /
                                                    widget.monthlyLimit!)
                                              ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: widget.remainingAmount! <= 0
                                              ? Colors.red
                                              : Colors.green,
                                          width: 4)),
                                  child: Center(
                                    child: Text(
                                      "${(max((widget.remainingAmount! / widget.monthlyLimit!) * 100, 0)).toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      actions: [
        CustomCupertinoContextMenuAction(
          child: Text(language.hide),
          trailingIcon: CupertinoIcons.eye_slash,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      child: SingleChildScrollView(
        child: widget.child,
      ),
    );
  }
}
