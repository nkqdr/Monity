import 'package:flutter/material.dart';

class SettingNavButton extends StatefulWidget {
  final String name;
  final Widget? destination;
  const SettingNavButton({
    Key? key,
    required this.name,
    this.destination,
  }) : super(key: key);

  @override
  State<SettingNavButton> createState() => _SettingNavButtonState();
}

class _SettingNavButtonState extends State<SettingNavButton> {
  bool _isTapped = false;

  void _tapDown(TapDownDetails details) {
    setState(() => _isTapped = true);
  }

  void _tapUp(TapUpDetails details) {
    setState(() => _isTapped = false);
  }

  void _tapCancel() {
    setState(() => _isTapped = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: _tapCancel,
      onTap: () {
        if (widget.destination != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => widget.destination!),
          );
        }
      },
      child: AnimatedContainer(
        width: double.infinity,
        duration: const Duration(milliseconds: 100),
        color: _isTapped
            ? Theme.of(context).canvasColor
            : Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
