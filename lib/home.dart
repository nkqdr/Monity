import 'dart:ui';

// import 'package:finance_buddy/pages/settings.dart';
// import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'pages/dashboard.dart';
import 'pages/expenses.dart';
import 'pages/income.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black, //Colors.grey[900],
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[800],
      //   title: CustomText(
      //     _getCurrentTitle(),
      //   ),
      //   leading: _getLeading(context),
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       bottom: Radius.circular(20),
      //     ),
      //   ),
      // ),
      body: _getCurrentPage(),
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
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.blue[300],
              onTap: _onItemTapped,
              backgroundColor: const Color.fromRGBO(55, 55, 55, 0.6),
              selectedIconTheme: const IconThemeData(size: 30),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.compare_arrows_rounded,
                  ),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.bar_chart_rounded,
                    size: 0,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.attach_money_rounded,
                  ),
                  label: 'Wealth',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              _onItemTapped(1);
            },
            tooltip: 'Dashboard',
            child: const Icon(
              Icons.bar_chart_rounded,
              color: Colors.black,
              size: 30,
            ),
            backgroundColor: _currentPage == 1
                ? const Color.fromRGBO(255, 215, 0, 1)
                : Colors.white, // const Color.fromRGBO(255, 215, 0, 1),
            elevation: 4.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        return const IncomePage();
      case 1:
        return const Dashboard();
      case 2:
        return const ExpensesPage();
      default:
        return Container();
    }
  }

  // String _getCurrentTitle() {
  //   switch (_currentPage) {
  //     case 0:
  //       return 'Income';
  //     case 1:
  //       return 'Dashboard';
  //     case 2:
  //       return 'Expenses';
  //     default:
  //       return '';
  //   }
  // }

  // Widget _getLeading(BuildContext context) {
  //   switch (_currentPage) {
  //     case 0:
  //       return Container();
  //     case 1:
  //       return IconButton(
  //         icon: const Icon(
  //           Icons.settings,
  //           color: Colors.white,
  //         ),
  //         onPressed: () {
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (context) => const SettingsPage(),
  //             ),
  //           );
  //         },
  //       );
  //     case 2:
  //       return Container();
  //     default:
  //       return Container();
  //   }
  // }
}
