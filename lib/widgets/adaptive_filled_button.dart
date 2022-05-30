import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveFilledButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  const AdaptiveFilledButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: CupertinoButton.filled(
              child: child,
              onPressed: onPressed,
            ),
          )
        : ElevatedButton(onPressed: onPressed, child: child);
  }
}
