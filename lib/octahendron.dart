import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class OctahedronPainter extends CustomPainter {
  final Animation<double> animation;

  static const double _shapeSize = 150.0;
  static final Paint _paint = Paint()..style = PaintingStyle.fill;

  OctahedronPainter({required this.animation}) : super(repaint: animation);

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
      vector.Vector4(1, 0, 0, 1),
      vector.Vector4(-1, 0, 0, 1),
      vector.Vector4(0, 1, 0, 1),
      vector.Vector4(0, -1, 0, 1),
      vector.Vector4(0, 0, 1, 1),
      vector.Vector4(0, 0, -1, 1),
    ];

    final transformedVertices = vertices.map((v) => rotationMatrix.transform(v)).toList();

    final faces = [
      [0, 2, 4],
      [0, 4, 3],
      [0, 3, 5],
      [0, 5, 2],
      [1, 2, 4],
      [1, 4, 3],
      [1, 3, 5],
      [1, 5, 2],
    ];

    final colors = [
      const Color(0xFFFF0000),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
      const Color(0xFFFFFF00),
      const Color(0xFF00FFFF),
      const Color(0xFFFF00FF),
    ];

    for (int i = 0; i < faces.length; i++) {
      final face = faces[i];
      final path = Path();

      path.moveTo(transformedVertices[face[0]].x * _shapeSize, transformedVertices[face[0]].y * _shapeSize);

      for (int j = 1; j < face.length; j++) {
        path.lineTo(transformedVertices[face[j]].x * _shapeSize, transformedVertices[face[j]].y * _shapeSize);
      }

      path.close();

      final shader = LinearGradient(
        colors: [
          colors[i % 6],
          colors[(i + 2) % 6],
        ],
        stops: const [0.0, 1.0],
      ).createShader(path.getBounds());

      _paint.shader = shader;
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(OctahedronPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
