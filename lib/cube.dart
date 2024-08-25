import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CubePainter extends CustomPainter {
  final Animation<double> animation;

  static const double _cubeSize = 100.0;
  static final Paint _paint = Paint()..style = PaintingStyle.fill;

  CubePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final rotationX = sin(animation.value);
    final rotationY = cos(animation.value);
    final rotationZ = sin(animation.value * 0.5);

    final rotationMatrix = vector.Matrix4.identity()
      ..rotateX(rotationX)
      ..rotateY(rotationY)
      ..rotateZ(rotationZ);

    final vertices = [
      vector.Vector4(-1, -1, -1, 1),
      vector.Vector4(1, -1, -1, 1),
      vector.Vector4(1, 1, -1, 1),
      vector.Vector4(-1, 1, -1, 1),
      vector.Vector4(-1, -1, 1, 1),
      vector.Vector4(1, -1, 1, 1),
      vector.Vector4(1, 1, 1, 1),
      vector.Vector4(-1, 1, 1, 1),
    ];

    final transformedVertices = vertices.map((v) => rotationMatrix.transform(v)).toList();

    final faces = [
      [0, 1, 2, 3],
      [1, 5, 6, 2],
      [5, 4, 7, 6],
      [4, 0, 3, 7],
      [3, 2, 6, 7],
      [4, 5, 1, 0],
    ];

    final colors = [
      const Color(0xFFFF0000),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
    ];

    for (int i = 0; i < faces.length; i++) {
      final face = faces[i];
      final path = Path();

      path.moveTo(transformedVertices[face[0]].x * _cubeSize, transformedVertices[face[0]].y * _cubeSize);

      for (int j = 1; j < face.length; j++) {
        path.lineTo(transformedVertices[face[j]].x * _cubeSize, transformedVertices[face[j]].y * _cubeSize);
      }

      path.close();

      final shader = LinearGradient(
        colors: [colors[(i + 0) % 3], colors[(i + 1) % 3], colors[(i + 2) % 3]],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(path.getBounds());

      _paint.shader = shader;
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(CubePainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
