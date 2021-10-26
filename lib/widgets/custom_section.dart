import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final double? titleSize;
  final FontWeight? titleWeight;
  final Color? titleColor;

  const CustomSection({
    Key? key,
    required this.children,
    this.titleSize,
    this.title,
    this.titleWeight,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 15.0),
          child: CustomText(
            title ?? "",
            fontSize: titleSize ?? 22,
            fontWeight: titleWeight ?? FontWeight.bold,
            color: titleColor ?? Colors.grey[300],
          ),
        ),
        ...children,
      ],
    );
  }
}
