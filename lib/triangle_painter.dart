import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class TrianglePainter extends CustomPainter {
  static final positions = Float32List(6);
  static const radius    = 100;
  static const comp      = 0xFF;
  static final colors    = Int32List(3);
  static final indices   = Uint16List(3);
  static final p         = Paint();

  final Animation<double> angle;

  TrianglePainter({required this.angle}) : super(repaint: angle);

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

    const r = (0xFF << 8 * 3) | (comp << 8 * 2) | (0x00 << 8 * 1) | (0x00 << 8 * 0);
    const g = (0xFF << 8 * 3) | (0x00 << 8 * 2) | (comp << 8 * 1) | (0x00 << 8 * 0);
    const b = (0xFF << 8 * 3) | (0x00 << 8 * 2) | (0x00 << 8 * 1) | (comp << 8 * 0);

    colors[0] = r;
    colors[1] = g;
    colors[2] = b;

    indices[0] = 0;
    indices[1] = 1;
    indices[2] = 2;

    final vertices = Vertices.raw(VertexMode.triangles, positions, indices: indices, colors: colors);
    canvas.drawVertices(vertices, BlendMode.src, p);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.angle.value != angle.value;
  }
}
