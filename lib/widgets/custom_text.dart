import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String value;
  const CustomText(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
