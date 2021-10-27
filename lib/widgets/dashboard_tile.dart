import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';

enum DashboardTileWidth {
  half,
  full,
}

class DashboardTile extends StatelessWidget {
  final DashboardTileWidth? width;
  final double? height;
  final String? title;
  final Widget? child;
  final Color? titleColor;
  final double? titleSize;

  const DashboardTile({
    Key? key,
    this.title,
    this.width,
    this.height,
    this.child,
    this.titleColor,
    this.titleSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              height: height ?? 200,
              width: width == DashboardTileWidth.half
                  ? screenSize.width * 0.5 - 20
                  : screenSize.width,
              color: Theme.of(context).cardColor,
              child: Stack(
                children: [
                  child ?? Container(),
                  title != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: CustomText(
                            title == null ? "" : title as String,
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize ?? 16,
                            color: titleColor ??
                                Theme.of(context).secondaryHeaderColor,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
