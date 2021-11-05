import 'package:finance_buddy/helper/interfaces.dart';
import 'package:finance_buddy/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MultipleChoiceTextField extends StatelessWidget {
  final List<Category> categories;
  final void Function(String) onSelected;
  final void Function(String) onValidInput;
  final void Function(String) onInvalidInput;

  const MultipleChoiceTextField({
    Key? key,
    required this.categories,
    required this.onSelected,
    required this.onValidInput,
    required this.onInvalidInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditValue) {
        if (textEditValue.text == '') {
          return const Iterable<String>.empty();
        }
        return categories.map((e) => e.name).where((String option) {
          var lowOption = option.toLowerCase();
          return lowOption.contains(textEditValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      optionsViewBuilder: (context, AutocompleteOnSelected<String> onSelected,
          Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: 300,
              height: 120,
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(
                          option,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return CustomTextField(
          focusNode: fieldFocusNode,
          controller: fieldTextEditingController,
          onChanged: (v) {
            if (_isValidCategory(v)) {
              onValidInput(v);
            } else {
              onInvalidInput(v);
            }
          },
          decoration: InputDecoration.collapsed(hintText: language.startTyping),
        );
      },
    );
  }

  bool _isValidCategory(String value) {
    return categories.where((e) => e.name == value.trim()).isNotEmpty;
  }
}
