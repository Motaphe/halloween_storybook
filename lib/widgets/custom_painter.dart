import 'package:flutter/material.dart';
import 'dart:math';

class SpookyBackgroundPainter extends CustomPainter {
  final double animationValue;

  SpookyBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw floating particles
    _drawFloatingParticles(canvas, size, paint);
    
    // Draw spooky mist
    _drawSpookyMist(canvas, size, paint);
    
    // Draw moving shadows
    _drawMovingShadows(canvas, size, paint);
  }

  void _drawFloatingParticles(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withValues(alpha: 0.1);
    paint.style = PaintingStyle.fill;
    
    final random = Random(42); // Fixed seed for consistent particles
    
    for (int i = 0; i < 20; i++) {
      final x = (random.nextDouble() * size.width + 
                sin(animationValue * 2 * pi + i) * 20) % size.width;
      final y = (random.nextDouble() * size.height + 
                cos(animationValue * 2 * pi + i) * 15) % size.height;
      
      canvas.drawCircle(
        Offset(x, y),
        1 + sin(animationValue * 4 * pi + i) * 0.5,
        paint,
      );
    }
  }

  void _drawSpookyMist(Canvas canvas, Size size, Paint paint) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.purple.withValues(alpha: 0.1),
        Colors.blue.withValues(alpha: 0.05),
        Colors.transparent,
      ],
    );
    
    paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    
    for (double x = 0; x <= size.width; x += 10) {
      final y = size.height * 0.3 + 
                sin(x * 0.01 + animationValue * 2 * pi) * 30 +
                cos(x * 0.005 + animationValue * pi) * 20;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawMovingShadows(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.black.withValues(alpha: 0.1);
    paint.style = PaintingStyle.fill;
    
    // Draw moving shadow shapes
    final shadow1X = (size.width * 0.2 + 
                     sin(animationValue * pi) * size.width * 0.1) % size.width;
    final shadow1Y = size.height * 0.4 + 
                     cos(animationValue * pi * 0.5) * size.height * 0.1;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(shadow1X, shadow1Y),
        width: 80,
        height: 40,
      ),
      paint,
    );
    
    final shadow2X = (size.width * 0.7 + 
                     cos(animationValue * pi * 1.5) * size.width * 0.15) % size.width;
    final shadow2Y = size.height * 0.6 + 
                     sin(animationValue * pi * 0.8) * size.height * 0.08;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(shadow2X, shadow2Y),
        width: 60,
        height: 30,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(SpookyBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
