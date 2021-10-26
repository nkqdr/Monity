import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SettingNavButton extends StatelessWidget {
  final String name;
  const SettingNavButton({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: InkWell(
        onTap: () {
          print("Hello");
        },
        splashColor: Colors.grey[800],
        highlightColor: Colors.grey[900],
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  name,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
