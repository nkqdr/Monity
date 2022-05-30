import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcase extends StatelessWidget {
  final Widget child;
  final GlobalKey showcaseKey;
  final String? title;
  final void Function()? onTargetClick;
  final bool? disposeOnTap;
  final String description;
  final bool disableBackdropClick;
  final EdgeInsets overlayPadding;

  const CustomShowcase({
    Key? key,
    required this.child,
    required this.description,
    required this.showcaseKey,
    this.onTargetClick,
    this.disposeOnTap,
    this.title,
    this.disableBackdropClick = false,
    this.overlayPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      child: child,
      onTargetClick: onTargetClick,
      disposeOnTap: disposeOnTap,
      showcaseBackgroundColor: Colors.green,
      textColor: Colors.white,
      contentPadding: const EdgeInsets.all(10),
      overlayPadding: overlayPadding,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
      blurValue: 0.5,
      disableBackdropClick: disableBackdropClick,
    );
  }
}
