import 'package:monity/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabElement {
  final String title;
  final Function(int index)? onPressed;

  const TabElement({
    required this.title,
    this.onPressed,
  });
}

class TabSwitcher extends StatefulWidget {
  final List<TabElement> tabs;
  final int startIndex;

  const TabSwitcher({
    Key? key,
    required this.tabs,
    required this.startIndex,
  })  : assert(tabs.length > 1),
        super(key: key);

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Utils.mapIndexed(
            widget.tabs,
            (i, TabElement e) => Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _currentIndex = i);
                  if (e.onPressed != null) {
                    e.onPressed!(i);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          e.title.toUpperCase(),
                          style: TextStyle(
                            fontWeight: _currentIndex == i ? FontWeight.bold : null,
                            fontSize: 12,
                            color: _currentIndex == i ? null : Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ).toList(),
        ),
        Stack(
          children: [
            Container(
              height: 2,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(0.4)),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: (MediaQuery.of(context).size.width - 30) / widget.tabs.length * _currentIndex,
              child: Container(
                height: 2,
                width: (MediaQuery.of(context).size.width - 30) / widget.tabs.length,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
