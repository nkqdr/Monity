import 'dart:async';

import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowcaseProvider extends ChangeNotifier {
  final GlobalKey dashboardKey = GlobalKey();
  final GlobalKey transactionsKey = GlobalKey();
  final GlobalKey settingsKey = GlobalKey();
  final GlobalKey generalSettingsKey = GlobalKey();
  final GlobalKey configurationSettingsKey = GlobalKey();
  final GlobalKey helpSettingsKey = GlobalKey();
  final GlobalKey currentMonthKey = GlobalKey();
  final GlobalKey addTransactionKey = GlobalKey();
  bool showShowcase;
  bool userWantsTour = false;

  ShowcaseProvider({
    Key? key,
    required this.showShowcase,
  });

  Future showCompletedScreen(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        builder: (context) {
          return const _ShowcaseCompletedScreen();
        });
    await setShowcase();
    notifyListeners();
  }

  Future setShowcase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(firstStartupKey, false);
    showShowcase = false;
  }

  void startTourIfNeeded(BuildContext context, List<GlobalKey> keys,
      {Duration? delay}) {
    if (!showShowcase || !userWantsTour) return;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (delay != null) {
        await Future.delayed(delay);
      }
      ShowCaseWidget.of(context)!.startShowCase(keys);
    });
  }

  void setUserWantsTour(bool value) {
    userWantsTour = value;
    notifyListeners();
  }
}

class _ShowcaseCompletedScreen extends StatefulWidget {
  const _ShowcaseCompletedScreen({Key? key}) : super(key: key);

  @override
  State<_ShowcaseCompletedScreen> createState() =>
      __ShowcaseCompletedScreenState();
}

class __ShowcaseCompletedScreenState extends State<_ShowcaseCompletedScreen> {
  final double _deltaY = 25;
  final int _animationMillis = 2000;
  late double _position;
  late Timer _timer;

  void _changeDirection(Timer t) async {
    setState(() => _position = _position == -_deltaY ? _deltaY : -_deltaY);
  }

  @override
  void initState() {
    _position = -_deltaY;
    _timer = Timer.periodic(
        Duration(milliseconds: _animationMillis), _changeDirection);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        //height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          color: Colors.green,
          boxShadow: [
            BoxShadow(blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              Text(
                language.good_job,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  language.introduction_completed,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              AnimatedContainer(
                height: MediaQuery.of(context).size.height / 3,
                duration: Duration(milliseconds: _animationMillis),
                transform: Transform.translate(
                  offset: Offset(0, _position),
                ).transform,
                child: const Center(
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.white,
                    size: 150,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Center(
                  child: Text(
                    language.swipe_down_to_continue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
