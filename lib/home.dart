import 'dart:ui';

import 'package:finance_buddy/helper/showcase_keys_provider.dart';
import 'package:finance_buddy/widgets/adaptive_filled_button.dart';
import 'package:finance_buddy/widgets/adaptive_text_button.dart';
import 'package:finance_buddy/widgets/custom_bottom_sheet.dart';
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
    var showcaseProvider =
        Provider.of<ShowcaseProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (showcaseProvider.showShowcase) {
        await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            builder: (context) {
              return const _WelcomePage();
            });
      }
      if (showcaseProvider.userWantsTour) {
        showcaseProvider
            .startTourIfNeeded(context, [showcaseProvider.settingsKey]);
      }
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

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showcaseProvider =
        Provider.of<ShowcaseProvider>(context, listen: false);
    return CustomBottomSheet(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: const Text(
              'Welcome!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const Text(
              'It seems like this is your first time using Monity. Would you like to take a quick tour?'),
          const Spacer(),
          Center(
            child: AdaptiveFilledButton(
              child: Text('Yes, please!'),
              onPressed: () {
                showcaseProvider.setUserWantsTour(true);
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
            child: Center(
              child: AdaptiveTextButton(
                text: 'No thanks, I know my way around.',
                onPressed: () async {
                  await showcaseProvider.setShowcase();
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}
