import 'package:finance_buddy/helper/types.dart';

import 'package:flutter/material.dart';

class Config {
  static List<AssetLabel> assetAllocationCategories = [
    AssetLabel(
      title: "Invested",
      displayColor: const Color(0xff0293ee),
    ),
    AssetLabel(
      title: "Saved",
      displayColor: const Color(0xfff8b250),
    ),
    AssetLabel(
      title: "Liquid",
      displayColor: const Color(0xff845bef),
    ),
  ];
}