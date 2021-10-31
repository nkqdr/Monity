import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final Widget? left;
  final Widget? right;
  const CustomAppBar({
    Key? key,
    this.title,
    this.left,
    this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          child: left,
        ),
        Text(
          title ?? "",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 50,
          child: right,
        ),
      ],
    );
  }
}
