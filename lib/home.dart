import 'dart:ui';

import 'package:finance_buddy/pages/instructions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/dashboard_page.dart';
import 'pages/wealth_page.dart';
import 'pages/transactions_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final bool showInstructions;
  const HomePage({
    Key? key,
    required this.showInstructions,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    if (widget.showInstructions) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _showInstructions();
      });
    }
  }

  Future _showInstructions() async {
    double topInsets = (MediaQuery.of(context).viewPadding.top);
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 10),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: topInsets + 10,
                left: 20,
                right: 20,
              ),
              child: const InstructionsPage(
                key: Key("instructions-page-widget"),
              ),
            ),
          );
        });
  }

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
