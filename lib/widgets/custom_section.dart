import 'package:monity/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:monity/widgets/newmorphic/newmorphic_box.dart';

class CustomSection extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final double? titleSize;
  final double titlePadding;
  final FontWeight? titleWeight;
  final TextStyle? subtitleTextStyle;
  final Color? titleColor;
  final InkWell? trailing;
  final bool groupItems;

  const CustomSection({
    Key? key,
    required this.children,
    this.titleSize,
    this.title,
    this.subtitle,
    this.titleWeight,
    this.titleColor,
    this.titlePadding = 10,
    this.trailing,
    this.subtitleTextStyle,
    this.groupItems = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: titlePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: titleSize ?? 22,
                          fontWeight: titleWeight ?? FontWeight.bold,
                          color: titleColor ?? Theme.of(context).secondaryHeaderColor,
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
                    style: subtitleTextStyle ??
                        TextStyle(
                            color: Theme.of(context).secondaryHeaderColor, fontSize: 14, fontWeight: FontWeight.w500),
                  )
              ],
            ),
          ),
          if (groupItems)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: NewmorphicBox(
                child: Column(
                  children: [
                    ...Utils.mapIndexed(children, (index, Widget item) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: getBorderRadius(index, children.length) ?? BorderRadius.circular(0),
                            child: item,
                          ),
                          if (index < children.length - 1)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              height: 1,
                              width: double.infinity,
                              color: Theme.of(context).cardColor,
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            )
          else
            ...children
        ],
      ),
    );
  }

  @visibleForTesting
  BorderRadius? getBorderRadius(int index, int length) {
    // Get rid of edge-cases
    if (index >= length || index < 0 || length <= 0) {
      return null;
    }
    // Actual calculations
    if (index == 0) {
      if (length == 1) {
        return const BorderRadius.all(Radius.circular(15));
      }
      return const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15));
    }
    if (index == length - 1) {
      return const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15));
    }
    return null;
  }
}
