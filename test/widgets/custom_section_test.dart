import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BorderRadius for grouped sections is calculated correctly', () {
    const section = CustomSection(children: []);
    const topElementRadius = BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15));
    const onlyElementRadius = BorderRadius.all(Radius.circular(15));
    const bottomElementRadius = BorderRadius.only(
        bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15));

    expect(section.getBorderRadius(0, 1), onlyElementRadius);
    expect(section.getBorderRadius(0, 2), topElementRadius);
    expect(section.getBorderRadius(1, 2), bottomElementRadius);
    expect(section.getBorderRadius(0, 3), topElementRadius);
    expect(section.getBorderRadius(1, 3), null);
    expect(section.getBorderRadius(2, 3), bottomElementRadius);
    expect(section.getBorderRadius(0, 0), null);
    expect(section.getBorderRadius(-1, 6), null);
    expect(section.getBorderRadius(3, -1), null);
  });
}
