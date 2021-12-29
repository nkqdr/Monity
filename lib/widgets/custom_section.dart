import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final double? titleSize;
  final double? titlePadding;
  final FontWeight? titleWeight;
  final Color? titleColor;
  final InkWell? trailing;

  const CustomSection({
    Key? key,
    required this.children,
    this.titleSize,
    this.title,
    this.subtitle,
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
          padding: EdgeInsets.only(
              top: 30, left: 15.0, right: 15.0, bottom: titlePadding ?? 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title ?? "",
                    style: TextStyle(
                      fontSize: titleSize ?? 22,
                      fontWeight: titleWeight ?? FontWeight.bold,
                      color:
                          titleColor ?? Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  trailing ?? Container(),
                ],
              ),
              if (subtitle != null)
                const SizedBox(
                  height: 5,
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
