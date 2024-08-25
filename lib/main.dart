import 'dart:math';

import 'package:flutter/widgets.dart';

import 'cube.dart';
import 'octahendron.dart';
import 'pentagonal_bypyramid.dart';
import 'triangle.dart';

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
    return WidgetsApp(
      color: const Color(0xFF000000),
      builder: (_, __) => GridView.count(
        crossAxisCount: 3,
        children: [
          CustomPaint(painter: TrianglePainter(animation: controller)),
          CustomPaint(painter: CubePainter(animation: controller)),
          CustomPaint(painter: PentagonalBipyramidPainter(animation: controller)),
          CustomPaint(painter: OctahedronPainter(animation: controller)),
        ],
      ),
    );
  }
}
