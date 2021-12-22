import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveContextMenu extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;
  const AdaptiveContextMenu({
    Key? key,
    required this.child,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      actions: actions,
      child: SingleChildScrollView(
        child: child,
      ),
    );
    // if (Platform.isIOS) {
    //   return CupertinoContextMenu(
    //     actions: actions,
    //     child: SingleChildScrollView(
    //       child: child,
    //     ),
    //   );
    // } else {
    //   return Container(
    //     child: child,
    //   );
    // }
  }
}
