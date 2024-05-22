import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this, 
    duration: const Duration(milliseconds: 2000), 
    upperBound: 2 * pi,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      color: Colors.black,
      home: Material(
        color: Colors.black,
        child: CustomPaint(
          painter: Painter(
            angle: controller,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.repeat(reverse: false);
  }
}

class Painter extends CustomPainter {
  static final positions = Float32List(6);

  static const radius = 100;

  static const comp = 0xFF;
  final Animation<double> angle;
  Painter({required this.angle}) : super(repaint: angle);

  @override
  void paint(Canvas canvas, Size size) {
    positions[0] = size.width  * 0.50;
    positions[1] = size.height * 0.50 - radius;

    positions[2] = size.width  * 0.50 - radius;
    positions[3] = size.height * 0.50 + radius;

    positions[4] = size.width  * 0.50 + radius;
    positions[5] = size.height * 0.50 + radius;

    final center_x = (positions[0] + positions[2] + positions[4]) / 3;
    final center_y = (positions[1] + positions[3] + positions[5]) / 3;

    for (int i = 0; i < 6; i += 2) {
      final x = positions[i + 0] - center_x;
      final y = positions[i + 1] - center_y;

      final rotated_x = x * cos(angle.value) + y * sin(angle.value);
      final rotated_y = x * sin(angle.value) + y * cos(angle.value);

      positions[i + 0] = rotated_x + center_x;
      positions[i + 1] = rotated_y + center_y;
    }

    const red   = (0xFF << 8 * 3) | (comp  << 8 * 2) | (0x00  << 8 * 1) | (0x00  << 8 * 0);
    const green = (0xFF << 8 * 3) | (0x00  << 8 * 2) | (comp  << 8 * 1) | (0x00  << 8 * 0);
    const blue  = (0xFF << 8 * 3) | (0x00  << 8 * 2) | (0x00  << 8 * 1) | (comp  << 8 * 0);

    final colors = Int32List.fromList([red, green, blue]);
    final indices = Uint16List.fromList([0, 1, 2]);
    final vertices = Vertices.raw(VertexMode.triangles, positions, indices: indices, colors: colors);

    final paint = Paint();
    canvas.drawVertices(vertices, BlendMode.src, paint);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.angle.value != angle.value;
  }
}
