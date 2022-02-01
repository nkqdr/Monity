import 'package:flutter/material.dart';

class WealthDataPoint {
  final DateTime time;
  final double value;

  const WealthDataPoint({
    required this.time,
    required this.value,
  });
}

class AssetLabel {
  final String title;
  final Color displayColor;
  final double? percentage;

  const AssetLabel({
    required this.title,
    required this.displayColor,
    this.percentage,
  });
}
