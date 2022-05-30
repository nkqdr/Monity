import 'dart:ui';

import 'package:finance_buddy/helper/showcase_keys_provider.dart';
import 'package:finance_buddy/widgets/custom_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'pages/dashboard_page.dart';
import 'pages/wealth_page.dart';
import 'pages/transactions_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    var showcaseKeys = Provider.of<ShowcaseProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showcaseKeys.startTourIfNeeded(context, [showcaseKeys.settingsKey]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var showcaseKeys = Provider.of<ShowcaseProvider>(context, listen: false);
    return Scaffold(
      extendBody: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle
            as SystemUiOverlayStyle,
        child: _getCurrentPage(),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 30.0),
            child: BottomNavigationBar(
              currentIndex: _currentPage,
              unselectedItemColor: Theme.of(context).colorScheme.onBackground,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedFontSize: 12,
              items: [
                BottomNavigationBarItem(
                  icon: CustomShowcase(
                    showcaseKey: showcaseKeys.transactionsKey,
                    title: 'Transactions',
                    description: 'Tap to view the transactions page.',
                    overlayPadding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    disableBackdropClick: true,
                    disposeOnTap: true,
                    onTargetClick: () {
                      setState(() => _currentPage = 0);
                      showcaseKeys.startTourIfNeeded(
                          context, [showcaseKeys.addTransactionKey],
                          delay: const Duration(milliseconds: 200));
                    },
                    child: const Icon(
                      Icons.compare_arrows_rounded,
                    ),
                  ),
                  label: language.transactionsTitle,
                ),
                BottomNavigationBarItem(
                  icon: CustomShowcase(
                    showcaseKey: showcaseKeys.dashboardKey,
                    title: 'Dashboard',
                    description: 'Tap to view the dashboard page.',
                    overlayPadding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    disableBackdropClick: true,
                    disposeOnTap: true,
                    onTargetClick: () async {
                      setState(() => _currentPage = 1);
                      showcaseKeys.showCompletedScreen(context);
                    },
                    child: const Icon(
                      Icons.bar_chart_rounded,
                    ),
                  ),
                  label: language.dashboardTitle,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.attach_money_rounded,
                  ),
                  label: language.wealthTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentPage) {
      case 0:
        return const TransactionsPage();
      case 1:
        return const Dashboard();
      case 2:
        return const WealthPage();
      default:
        return Container();
    }
  }
}
