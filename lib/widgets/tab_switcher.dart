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

  const TabSwitcher({
    Key? key,
    required this.tabs,
  })  : assert(tabs.length > 1),
        super(key: key);

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: mapIndexed(
            widget.tabs,
            (i, TabElement e) => Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setState(() => currentIndex = i);
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
                            color: currentIndex == i
                                ? null
                                : Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                    ),
                    // ),
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
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.4)),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: (MediaQuery.of(context).size.width - 30) /
                  widget.tabs.length *
                  currentIndex,
              child: Container(
                height: 2,
                width: (MediaQuery.of(context).size.width - 30) /
                    widget.tabs.length,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
