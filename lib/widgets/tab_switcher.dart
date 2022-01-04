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
        Row(
          children: [
            Expanded(
              flex: currentIndex,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Theme.of(context)
                        .secondaryHeaderColor
                        .withOpacity(0.4)),
              ),
            ),
            Expanded(
              flex: 1,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            Expanded(
              flex: widget.tabs.length - currentIndex - 1,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Theme.of(context)
                        .secondaryHeaderColor
                        .withOpacity(0.4)),
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
