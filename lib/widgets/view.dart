import 'dart:ui';

import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class View extends StatelessWidget {
  final CustomAppBar? appBar;
  final List<Widget> children;
  final bool fixedAppBar;
  final bool safeAreaBottomDisabled;
  final bool safeAreaTopDisabled;
  final Color? appBarBackgroundColor;

  const View({
    Key? key,
    this.appBar,
    this.fixedAppBar = false,
    this.safeAreaBottomDisabled = false,
    this.safeAreaTopDisabled = true,
    this.appBarBackgroundColor,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle as SystemUiOverlayStyle,
          child: SafeArea(
            bottom: false, //!safeAreaBottomDisabled,
            top: !safeAreaTopDisabled,
            child: safeAreaTopDisabled
                ? Stack(
                    children: [
                      ListView.builder(
                        itemCount: fixedAppBar ? children.length + 1 : children.length + 2,
                        itemBuilder: (context, index) {
                          if (fixedAppBar) {
                            if (index == 0) {
                              return SizedBox(
                                height: MediaQuery.of(context).viewPadding.top + 30,
                              );
                            } else {
                              return children[index - 1];
                            }
                          } else {
                            if (index == 0) {
                              return appBar ?? Container();
                            } else if (index == 1) {
                              return const SizedBox(
                                height: 20,
                              );
                            } else {
                              return children[index - 2];
                            }
                          }
                        },
                      ),
                      if (fixedAppBar)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 20.0),
                            child: Container(
                              height: MediaQuery.of(context).viewPadding.top + 48,
                              color: appBarBackgroundColor ?? Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: safeAreaTopDisabled ? MediaQuery.of(context).viewPadding.top : 0,
                                  ),
                                  appBar ?? Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.bottom),
                        height: MediaQuery.of(context).viewPadding.bottom,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 20.0),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : _getColumn(),
          ),
        ),
      ),
    );
  }

  Widget _getColumn() {
    return Column(
      children: [
        if (fixedAppBar) appBar ?? Container(),
        Flexible(
          child: ListView.builder(
            itemCount: fixedAppBar ? children.length + 1 : children.length + 2,
            itemBuilder: (context, index) {
              if (fixedAppBar) {
                if (index == 0) {
                  return const SizedBox(
                    height: 20,
                  );
                }
                return children[index - 1];
              } else {
                if (index == 0) {
                  return appBar ?? Container();
                } else if (index == 1) {
                  return const SizedBox(
                    height: 20,
                  );
                } else {
                  return children[index - 2];
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
