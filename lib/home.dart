import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/dashboard_page.dart';
import 'pages/wealth_page.dart';
import 'pages/transactions_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: BottomNavigationBar(
              currentIndex: _currentPage,
              unselectedItemColor: Theme.of(context).colorScheme.onBackground,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: _onItemTapped,
              backgroundColor: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.5), // Theme.of(context).bottomAppBarColor,
              selectedFontSize: 12,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.compare_arrows_rounded,
                  ),
                  label: language.transactionsTitle,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.bar_chart_rounded,
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
