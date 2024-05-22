import 'dart:math';
import 'dart:ui';
import 'dart:typed_data';

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
  late final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000), animationBehavior: AnimationBehavior.preserve, lowerBound: 0.0, upperBound: 2 * pi);
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      color: Colors.black,
      home: Material(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: Painter(
                  angle: controller,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Slider(
                    value: sliderValue,
                    max: 2 * pi,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  Painter({required this.angle}) : super(repaint: angle);

  final Animation<double> angle;

  @override
  void paint(Canvas canvas, Size size) {
    final originalPositions = Float32List(6);
    final positions = Float32List(6);

    const radius = 100;
    originalPositions[0] = size.width  * 0.50;
    originalPositions[1] = size.height * 0.50 - radius;

    originalPositions[2] = size.width  * 0.50 - radius;
    originalPositions[3] = size.height * 0.50 + radius;

    originalPositions[4] = size.width  * 0.50 + radius;
    originalPositions[5] = size.height * 0.50 + radius;

    final centerX = (originalPositions[0] + originalPositions[2] + originalPositions[4]) / 3;
    final centerY = (originalPositions[1] + originalPositions[3] + originalPositions[5]) / 3;

    for (int i = 0; i < 6; i += 2) {
      final x = originalPositions[i] - centerX;
      final y = originalPositions[i + 1] - centerY;

      final rotatedX = x * cos(angle.value) + y * sin(angle.value);
      final rotatedY = x * sin(angle.value) + y * cos(angle.value);

      positions[i + 0] = rotatedX + centerX;
      positions[i + 1] = rotatedY + centerY;
    }

    const value = 0xFF;
    const red   = (0xFF << 8 * 3) | (value << 8 * 2) | (0x00  << 8 * 1) | (0x00  << 8 * 0);
    const green = (0xFF << 8 * 3) | (0x00  << 8 * 2) | (value << 8 * 1) | (0x00  << 8 * 0);
    const blue  = (0xFF << 8 * 3) | (0x00  << 8 * 2) | (0x00  << 8 * 1) | (value << 8 * 0);

    final colors = Int32List.fromList([red, green, blue]);
    final indices = Uint16List.fromList([0, 1, 2]);
    final vertices = Vertices.raw(
      VertexMode.triangles,
      positions,
      indices: indices,
      colors: colors,
    );

    final paint = Paint();
    canvas.drawVertices(
      vertices,
      BlendMode.src,
      paint,
    );
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return oldDelegate.angle.value != angle.value;
  }
}
