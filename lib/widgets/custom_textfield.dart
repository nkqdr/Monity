import 'package:flutter/material.dart';
import 'package:monity/widgets/newmorphic/newmorphic_box.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final Function(String)? onChanged;
  const CustomTextField({
    Key? key,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.decoration,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewmorphicBox(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: TextField(
          keyboardType: keyboardType,
          focusNode: focusNode,
          controller: controller,
          decoration: decoration,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
