import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class PentagonalBipyramidPainter extends CustomPainter {
  final Animation<double> animation;

  static const double _shapeSize = 150.0;
  static final Paint _paint = Paint()..style = PaintingStyle.fill;

  PentagonalBipyramidPainter({required this.animation}) : super(repaint: animation);

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

    final vertices = _generateVertices();
    final transformedVertices = vertices.map((v) => rotationMatrix.transform(v)).toList();

    final faces = _generateFaces();

    final colors = [
      const Color(0xFFFF0000),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
      const Color(0xFFFFFF00),
      const Color(0xFF00FFFF),
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
          colors[i % 5],
          colors[(i + 2) % 5],
        ],
        stops: const [0.0, 1.0],
      ).createShader(path.getBounds());

      _paint.shader = shader;
      canvas.drawPath(path, _paint);
    }
  }

  List<vector.Vector4> _generateVertices() {
    final phi = (1 + sqrt(5)) / 2;
    final radius = sqrt(phi * phi + 1);

    final vertices = <vector.Vector4>[];

    vertices.add(vector.Vector4(0, 1, 0, 1));

    for (int i = 0; i < 5; i++) {
      final angle = 2 * pi * i / 5;
      vertices.add(vector.Vector4(cos(angle) / radius, phi / radius, sin(angle) / radius, 1));
    }

    for (int i = 0; i < 5; i++) {
      final angle = 2 * pi * i / 5 + pi / 5;
      vertices.add(vector.Vector4(cos(angle) / radius, -phi / radius, sin(angle) / radius, 1));
    }

    vertices.add(vector.Vector4(0, -1, 0, 1));

    return vertices;
  }

  List<List<int>> _generateFaces() {
    final faces = <List<int>>[];

    for (int i = 1; i <= 5; i++) {
      faces.add([0, i, i % 5 + 1]);
    }

    for (int i = 6; i <= 10; i++) {
      faces.add([11, i, i % 5 + 6]);
    }

    return faces;
  }

  @override
  bool shouldRepaint(PentagonalBipyramidPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
