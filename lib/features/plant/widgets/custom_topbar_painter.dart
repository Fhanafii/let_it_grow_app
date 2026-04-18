import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
Widget customTopBar(){
  return CustomPaint(
    size: Size(421, (421*0.3422330097087379).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
    painter: RPSCustomPainter(),
  );
}

class RPSCustomPainter extends CustomPainter {
  @override
   void paint(Canvas canvas, Size size) {
    // 1. Definisikan Bentuk (Path)
    final Rect rect = Rect.fromLTWH(
      0, 
      -20, // Sedikit offset ke atas agar bagian atas tidak berbayang
      size.width, 
      size.height + 20
    );
    
    final RRect rrect = RRect.fromRectAndCorners(
      rect,
      bottomRight: Radius.circular(size.width * 0.05),
      bottomLeft: Radius.circular(size.width * 0.05),
    );

    final Path path = Path()..addRRect(rrect);

    // 2. Gambar Shadow (Elevation)
    // elevation: 5, color: black, transparentOccluder: true (halus)
    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 6.0, true);

    // 3. Gambar Fill Putih
    Paint paint_0_fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    canvas.drawPath(path, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
