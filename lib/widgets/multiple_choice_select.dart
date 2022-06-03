import 'package:monity/helper/utils.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:flutter/material.dart';

class MultipleChoiceOption<T> {
  final String name;
  final T value;

  const MultipleChoiceOption({
    required this.name,
    required this.value,
  });
}

class MultipleChoiceSection<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<MultipleChoiceOption<T>> options;
  final T value;
  final void Function(T) onChanged;

  const MultipleChoiceSection({
    Key? key,
    this.subtitle,
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MultipleChoiceSection> createState() => _MultipleChoiceSectionState<T>();
}

class _MultipleChoiceSectionState<T> extends State<MultipleChoiceSection<T>> {
  late T _currentValue;

  @override
  void initState() {
    _currentValue = widget.value;
    super.initState();
  }

  void _onChange(T newValue) {
    setState(() => _currentValue = newValue);
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSection(
      groupItems: true,
      title: widget.title,
      subtitle: widget.subtitle,
      children: Utils.mapIndexed(widget.options, (index, MultipleChoiceOption<T> item) {
        return GestureDetector(
          onTap: () => _onChange(item.value),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.value == _currentValue)
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
