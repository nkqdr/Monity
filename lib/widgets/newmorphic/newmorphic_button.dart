import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as custom;

class NewmorphpicButton extends StatefulWidget {
  final String text;
  final void Function()? onPressed;
  final bool isDestructive;
  final bool flatDown;
  final bool keepState;
  const NewmorphpicButton({
    Key? key,
    this.onPressed,
    this.isDestructive = false,
    this.flatDown = false,
    this.keepState = false,
    required this.text,
  }) : super(key: key);

  @override
  State<NewmorphpicButton> createState() => _NewmorphpicButtonState();
}

class _NewmorphpicButtonState extends State<NewmorphpicButton> {
  bool _isPressed = false;

  Widget get keepStateButton => GestureDetector(
        onTap: () => setState(() => _isPressed = !_isPressed),
        child: _NewmorphicButtonCore(
          flatDown: widget.flatDown,
          isDestructive: widget.isDestructive,
          isPressed: _isPressed,
          text: widget.text,
          onPressed: widget.onPressed,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.keepState) {
      return keepStateButton;
    }
    return Listener(
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerDown: (_) => setState(() => _isPressed = true),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapCancel: () => setState(() => _isPressed = false),
        child: _NewmorphicButtonCore(
          flatDown: widget.flatDown,
          isDestructive: widget.isDestructive,
          isPressed: _isPressed,
          text: widget.text,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}

class NewmorphicButtonGroup<T> extends StatelessWidget {
  final T value;
  final List<NewmorphicButtonConfig<T>> buttons;

  final void Function(T) onChange;

  const NewmorphicButtonGroup({
    Key? key,
    required this.onChange,
    required this.buttons,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: buttons.map((buttonConfig) {
        return Expanded(
          child: NewmorphicToggle(
            value: buttonConfig.value == value,
            text: buttonConfig.text,
            onChange: (value) {
              if (value) {
                onChange(buttonConfig.value);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class NewmorphicButtonConfig<T> {
  final String text;
  final T value;

  const NewmorphicButtonConfig({
    required this.text,
    required this.value,
  });
}

class NewmorphicToggle extends StatelessWidget {
  final bool value;
  final String text;
  final void Function(bool)? onChange;

  const NewmorphicToggle({
    Key? key,
    this.onChange,
    required this.text,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChange != null) {
          onChange!(!value);
        }
      },
      child: _NewmorphicButtonCore(
        flatDown: false,
        isDestructive: false,
        isPressed: value,
        text: text,
        onPressed: () {},
      ),
    );
  }
}

class _NewmorphicButtonCore extends StatelessWidget {
  final void Function()? onPressed;
  final bool isPressed;
  final bool isDestructive;
  final bool flatDown;
  final String text;
  const _NewmorphicButtonCore({
    Key? key,
    this.onPressed,
    required this.isDestructive,
    required this.isPressed,
    required this.flatDown,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        clipBehavior: Clip.antiAlias,
        decoration: custom.BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDestructive && !isPressed && onPressed != null
              ? Theme.of(context).errorColor
              : Theme.of(context).scaffoldBackgroundColor,
          boxShadow: _getBoxShadows(context),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getTextColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color? _getTextColor(BuildContext context) {
    if (onPressed == null) {
      return Theme.of(context).secondaryHeaderColor;
    }
    if (isDestructive) {
      if (isPressed) {
        return null;
      }
      return Colors.white;
    }
    return Theme.of(context).primaryColor;
  }

  List<custom.BoxShadow> _getBoxShadows(BuildContext context) {
    if ((!isPressed || !flatDown) && onPressed != null) {
      return [
        custom.BoxShadow(
          color: Theme.of(context).highlightColor,
          offset: const Offset(-5, -5),
          blurRadius: 8,
          inset: isPressed && !flatDown,
        ),
        custom.BoxShadow(
          color: Theme.of(context).shadowColor,
          offset: const Offset(5, 5),
          blurRadius: 8,
          inset: isPressed && !flatDown,
        ),
      ];
    }
    return [];
  }
}
