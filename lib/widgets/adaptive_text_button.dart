import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool? isDescructive;
  const AdaptiveTextButton({
    Key? key,
    this.isDescructive,
    this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Text(
          text,
          style: TextStyle(
            color: _getColor(context),
          ),
        ),
        onPressed: onPressed,
      );
    }
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          color: _getColor(context),
        ),
      ),
      onPressed: onPressed,
    );
  }

  Color? _getColor(BuildContext context) {
    if (isDescructive != null) {
      return isDescructive! ? Theme.of(context).errorColor : null;
    }
    return null;
  }
}
