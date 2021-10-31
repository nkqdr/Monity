import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  const CustomBottomSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(blurRadius: 10),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20.0), child: child),
    );
  }
}
