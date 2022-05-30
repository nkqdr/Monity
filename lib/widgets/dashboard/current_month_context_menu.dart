import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../custom_cupertino_context_menu_action.dart';

class CurrentMonthContextMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
    bool showRemainingGraphic = false;
    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
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
            height: max(MediaQuery.of(context).size.height / 3, 280),
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
                  monthlyLimit != null
                      ? Flexible(
                          fit: FlexFit.loose,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language.remainingDays +
                                          " $daysRemaining",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
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
                                                remainingAmount! >= 0
                                                    ? "+" +
                                                        currencyFormat.format(
                                                            remainingAmount)
                                                    : currencyFormat.format(
                                                        remainingAmount),
                                                style: TextStyle(
                                                  color: remainingAmount! >= 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    const SizedBox(height: 50),
                                    if (remainingAmount! > monthlyLimit!)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          language
                                              .percentageHighBecauseOfOverflow,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              showRemainingGraphic
                                  ? Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) /
                                              3,
                                      height: max(
                                          MediaQuery.of(context).size.height /
                                                  4 -
                                              20,
                                          180),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.green,
                                              Theme.of(context).cardColor
                                            ],
                                            stops: remainingAmount! <= 0
                                                ? [0, 0]
                                                : [
                                                    (remainingAmount! /
                                                        monthlyLimit!),
                                                    (remainingAmount! /
                                                        monthlyLimit!)
                                                  ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: remainingAmount! <= 0
                                                  ? Colors.red
                                                  : Colors.green,
                                              width: 4)),
                                      child: Center(
                                        child: Text(
                                          "${(max((remainingAmount! / monthlyLimit!) * 100, 0)).toStringAsFixed(0)}%",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            language.noMonthlyLimit,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                ],
              )),
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
        child: child,
      ),
    );
  }
}
