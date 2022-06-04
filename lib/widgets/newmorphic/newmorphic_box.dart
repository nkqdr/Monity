import 'package:flutter/material.dart';

class NewmorphicBox extends StatelessWidget {
  final Widget child;
  const NewmorphicBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: const Offset(-5, -5),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(5, 5),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }
}
