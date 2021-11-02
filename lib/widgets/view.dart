import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class View extends StatelessWidget {
  final CustomAppBar? appBar;
  final List<Widget> children;
  final bool fixedAppBar;

  const View({
    Key? key,
    this.appBar,
    this.fixedAppBar = false,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle
            as SystemUiOverlayStyle,
        child: SafeArea(
            child: Column(
          children: [
            if (fixedAppBar) appBar ?? Container(),
            Flexible(
              child: ListView(
                children: fixedAppBar
                    ? [
                        const SizedBox(
                          height: 20,
                        ),
                        ...children
                      ]
                    : [
                        appBar ?? Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        ...children
                      ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
