
import 'package:flutter/material.dart';

class DrawTriangleShape extends CustomPainter {

  Paint painter;

  DrawTriangleShape() {

    painter = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

  }

  @override
  void paint(Canvas canvas, Size size) {

    var path = Path();

//    path.moveTo(size.width/2, 0);
//    path.lineTo(0, size.height);
//    path.lineTo(size.height, size.width);
    path.moveTo(size.width/2, size.height);
    path.lineTo(size.width + 5, size.height - 10);
    path.lineTo(size.width - 5, size.height - 10);
    path.close();


    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
