import 'package:flutter/material.dart';

enum DashboardTileWidth {
  half,
  full,
}

class DashboardTile extends StatelessWidget {
  final DashboardTileWidth? width;
  final DashboardTileFill fill;
  final double? height;
  final String? title;
  final Widget? child;
  final Widget? sideWidget;
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
    this.sideWidget,
    this.fill = const DashboardTileFillAll(),
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
              height: height ?? 220,
              width: width == DashboardTileWidth.half
                  ? screenSize.width * 0.5 - 20
                  : screenSize.width,
              color: Theme.of(context).cardColor,
              child: fill.getChildFill(
                  context,
                  child,
                  sideWidget,
                  title,
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize ?? 16,
                    color: titleColor ?? Theme.of(context).secondaryHeaderColor,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

abstract class DashboardTileFill {
  Widget getChildFill(BuildContext context, Widget? child, Widget? sideWidget,
      String? title, TextStyle? titleStyle);
}

class DashboardTileFillAll implements DashboardTileFill {
  const DashboardTileFillAll();

  @override
  Widget getChildFill(BuildContext context, Widget? child, Widget? sideWidget,
      String? title, TextStyle? titleStyle) {
    return Stack(
      children: [
        child ?? Container(),
        title != null
            ? Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Text(
                  title,
                  style: titleStyle,
                ))
            : Container(),
      ],
    );
  }
}

class DashboardTileFillLeaveTitle implements DashboardTileFill {
  const DashboardTileFillLeaveTitle();

  @override
  Widget getChildFill(BuildContext context, Widget? child, Widget? sideWidget,
      String? title, TextStyle? titleStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: titleStyle,
                    ),
                    sideWidget ?? Container(),
                  ],
                ))
            : Container(),
        child ?? Container(),
      ],
    );
  }
}
