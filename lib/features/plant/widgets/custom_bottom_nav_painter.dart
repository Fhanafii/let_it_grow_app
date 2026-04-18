import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// Return this in your build method or widget tree
Widget customBottomNav() {
  return CustomPaint(
    size: Size(300, (300*0.21844660194174756).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
    painter: RPSCustomPainter(),
  );
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
            
      Path path_0 = Path();
          path_0.moveTo(size.width*0.3244320,size.height*0.2722222);
          path_0.cubicTo(size.width*0.1781041,size.height*0.2855556,size.width*0.04717403,size.height*0.1259256,0,size.height*0.04444444);
          path_0.lineTo(0,size.height*1.222222);
          path_0.lineTo(size.width,size.height*1.222222);
          path_0.lineTo(size.width,size.height*0.04444444);
          path_0.cubicTo(size.width*0.9279029,size.height*0.2611111,size.width*0.7383180,size.height*0.2666667,size.width*0.6809078,size.height*0.2666667);
          path_0.cubicTo(size.width*0.6234976,size.height*0.2666667,size.width*0.6128180,size.height*0.3000000,size.width*0.6128180,size.height*0.3944444);
          path_0.cubicTo(size.width*0.6128180,size.height*0.4888889,size.width*0.6250267,size.height*0.7464267,size.width*0.5540728,size.height*0.7833333);
          path_0.cubicTo(size.width*0.4152209,size.height*0.8555556,size.width*0.3881068,size.height*0.6611111,size.width*0.3858471,size.height*0.5388889);
          path_0.cubicTo(size.width*0.3831772,size.height*0.3944444,size.width*0.3898544,size.height*0.2722222,size.width*0.3244320,size.height*0.2722222);
          path_0.close();

      Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15) // Ketebalan bayangan
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4); // Tingkat kehalusan blur

      canvas.drawPath(path_0.shift(const Offset(0, -2)), shadowPaint);
      Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
      paint_0_fill.color = Colors.white.withOpacity(1.0);
      canvas.drawPath(path_0,paint_0_fill);
    }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
      return false;
  }
}