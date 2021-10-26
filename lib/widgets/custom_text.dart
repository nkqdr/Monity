import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String value;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextOverflow? overflow;
  const CustomText(
    this.value, {
    Key? key,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: color ?? Colors.white,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      overflow: overflow,
    );
  }
}
