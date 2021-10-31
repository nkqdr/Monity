import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final double? titleSize;
  final double? titlePadding;
  final FontWeight? titleWeight;
  final Color? titleColor;
  final Widget? trailing;

  const CustomSection({
    Key? key,
    required this.children,
    this.titleSize,
    this.title,
    this.titleWeight,
    this.titleColor,
    this.titlePadding,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: 30, left: 15.0, bottom: titlePadding ?? 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title ?? "",
                style: TextStyle(
                  fontSize: titleSize ?? 22,
                  fontWeight: titleWeight ?? FontWeight.bold,
                  color: titleColor ?? Theme.of(context).secondaryHeaderColor,
                ),
              ),
              trailing ?? Container(),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
