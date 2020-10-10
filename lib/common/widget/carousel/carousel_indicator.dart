import 'package:flutter/material.dart';

const double indicatorHeight = 20;

class CarouselIndicator extends StatelessWidget {
  final Listenable controller;
  final int size;

  CarouselIndicator({@required this.controller, this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) {
        return widget;
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: _ScrollIndicator(size: size),
        height: indicatorHeight,
      ),
    );
  }
}

class _ScrollIndicator extends StatelessWidget {
  final int size;

  _ScrollIndicator({this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScrollIndicatorPainter(itemSize: size),
    );
  }
}

class _ScrollIndicatorPainter extends CustomPainter {
  final int itemSize;
  final Paint itemsPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2.0;

  _ScrollIndicatorPainter({this.itemSize});

  @override
  void paint(Canvas canvas, Size size) {
    double startPoint = size.width / 4;
    for (int index = 0; index < itemSize; index++) {
      canvas.drawRect(Rect.fromLTWH(0, 0, 20, indicatorHeight), itemsPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
