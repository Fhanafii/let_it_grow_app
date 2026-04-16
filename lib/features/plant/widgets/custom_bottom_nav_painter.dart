import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// Return this in your build method or widget tree
Widget customBottomNav() {
  return CustomPaint(
      size: Size(300, (300*0.2087378640776699).toDouble()), //You can Replace [300] with your desired width for Custom Paint and height will be calculated automatically
      painter: RPSCustomPainter(),
  );
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
            
Path path_0 = Path();
    path_0.moveTo(size.width*0.3244320,size.height*0.2383721);
    path_0.cubicTo(size.width*0.1781041,size.height*0.2523256,size.width*0.04717403,size.height*0.08527128,0,0);
    path_0.lineTo(0,size.height*1.232558);
    path_0.lineTo(size.width,size.height*1.232558);
    path_0.lineTo(size.width,0);
    path_0.cubicTo(size.width*0.9279029,size.height*0.2267442,size.width*0.7383180,size.height*0.2325581,size.width*0.6809078,size.height*0.2325581);
    path_0.cubicTo(size.width*0.6234976,size.height*0.2325581,size.width*0.6128180,size.height*0.2674419,size.width*0.6128180,size.height*0.3662791);
    path_0.cubicTo(size.width*0.6128180,size.height*0.4651163,size.width*0.6250267,size.height*0.7346326,size.width*0.5540728,size.height*0.7732558);
    path_0.cubicTo(size.width*0.4152209,size.height*0.8488372,size.width*0.3881068,size.height*0.6453488,size.width*0.3858471,size.height*0.5174419);
    path_0.cubicTo(size.width*0.3831772,size.height*0.3662791,size.width*0.3898544,size.height*0.2383721,size.width*0.3244320,size.height*0.2383721);
    path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Colors.white.withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}