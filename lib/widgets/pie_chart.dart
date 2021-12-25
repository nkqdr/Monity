import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const currencyFormatThreshhold = 1000000;

class PieChartColors {
  static final blue = [
    // Color(0x000d47a1),
    // Color(0x001976d2),
    // Color(0x002196f3),
    // Color(0x0064b5f6),
    // Color(0x00bbdefb),
    Colors.blue[900],
    Colors.blue[700],
    Colors.blue[500],
    Colors.blue[300],
    Colors.blue[100],
    Colors.white,
  ];
  static final red = [
    //Color(0x00b71c1c),
    // Color(0x00d32f2f),
    // Color(0x00f44336),
    // Color(0x00e57373),
    // Color(0x00ffcdd2),
    Colors.red[900],
    Colors.red[700],
    Colors.red[500],
    Colors.red[300],
    Colors.red[100],
    Colors.white,
  ];
  static final green = [
    Colors.green[900],
    Colors.green[700],
    Colors.green[500],
    Colors.green[300],
    Colors.green[100],
    Colors.white,
  ];
}

class PieChart extends StatelessWidget {
  final List<PieChartDatapoint> dataset;
  final List<Color?>? colorScheme;

  const PieChart({
    Key? key,
    required this.dataset,
    this.colorScheme,
  })  : assert(dataset.length <= 6),
        super(key: key);

  double _getSum() {
    double value = 0;
    for (var i = 0; i < dataset.length; i++) {
      value += dataset[i].amount;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    var usedColorScheme = colorScheme ?? PieChartColors.blue;
    assert(usedColorScheme.length >= 6);
    var sum = _getSum();
    var currencyFormat = sum < currencyFormatThreshhold
        ? NumberFormat.simpleCurrency(locale: "de_DE", decimalDigits: 2)
        : NumberFormat.compactCurrency(
            locale: "de_DE", decimalDigits: 2, symbol: "€");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (var category in dataset)
              PieChartCategory(
                  text: category.name,
                  color: usedColorScheme[dataset.indexOf(category)] as Color)
          ],
        ),
        SizedBox(
          height: 170,
          width: 220,
          child: Stack(
            children: [
              Center(
                child: CustomPaint(
                  child: const SizedBox.expand(),
                  painter: PieChartPainter(
                    categories: dataset,
                    width: 10,
                    colorScheme: usedColorScheme,
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Center(child: Text(currencyFormat.format(sum))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Color?> colorScheme;
  PieChartPainter({
    required this.categories,
    required this.width,
    required this.colorScheme,
  });

  final List<PieChartDatapoint> categories;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    double total = 0;
    // Calculate total amount from each category
    for (var expense in categories) {
      total += expense.amount;
    }

    // The angle/radian at 12 o'clock
    double startRadian = -pi / 2;
    for (var index = 0; index < categories.length; index++) {
      final currentCategory = categories.elementAt(index);
      final sweepRadian = currentCategory.amount / total * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..strokeWidth = width
        ..color = colorScheme.elementAt(index % categories.length) as Color;
      final rect = Rect.fromCenter(
          center: center, width: radius * 2, height: radius * 2);
      canvas.drawArc(
        rect,
        startRadian,
        sweepRadian,
        true,
        paint,
      );
      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}

class PieChartCategory extends StatelessWidget {
  final String text;
  final Color color;

  const PieChartCategory({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}

class PieChartDatapoint {
  PieChartDatapoint({
    required this.name,
    required this.amount,
  });

  final String name;
  final double amount;
}

var categoryColors = [
  Colors.blue[900],
  Colors.blue[700],
  Colors.blue[500],
  Colors.blue[300],
  Colors.blue[100],
  Colors.white,
  // Color.fromRGBO(82, 98, 255, 1),
  // Color.fromRGBO(46, 198, 255, 1),
  // Color.fromRGBO(123, 201, 82, 1),
  // Color.fromRGBO(255, 171, 67, 1),
  // Color.fromRGBO(252, 91, 57, 1),
  // Color.fromRGBO(250, 135, 130, 1),
];
