import 'dart:math';
import 'package:flutter/material.dart';

class Starfield extends StatefulWidget {
  const Starfield({super.key});
  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield> {
  final rnd = Random();
  late List<Offset> stars;
  @override
  void initState() {
    super.initState();
    stars = List.generate(
      140,
      (_) => Offset(rnd.nextDouble(), rnd.nextDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    return IgnorePointer(
      child: CustomPaint(
        painter: _StarsPainter(stars: stars),
        size: Size(w, h),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  final List<Offset> stars;
  _StarsPainter({required this.stars});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.8);
    for (final s in stars) {
      final o = Offset(s.dx * size.width, s.dy * size.height);
      canvas.drawCircle(o, 0.8, p);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => false;
}
