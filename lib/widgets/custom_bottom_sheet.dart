import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final double? height;
  const CustomBottomSheet({
    Key? key,
    this.height = 250,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [child],
        ),
      ),
    );
  }
}
