import 'package:flutter/material.dart';

class SplineChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onPointSelected;
  final String selectedValuePrefix;

  const SplineChart({
    super.key,
    required this.data,
    required this.labels,
    required this.selectedIndex,
    required this.onPointSelected,
    this.selectedValuePrefix = '\$',
  });

  @override
  State<SplineChart> createState() => _SplineChartState();
}

class _SplineChartState extends State<SplineChart> {
  void _handleTap(TapUpDetails details, Size size) {
    if (widget.data.isEmpty) return;
    final double stepX = size.width / (widget.data.length - 1);
    final int index = (details.localPosition.dx / stepX).round().clamp(
      0,
      widget.data.length - 1,
    );
    widget.onPointSelected(index);
  }

  void _handlePan(DragUpdateDetails details, Size size) {
    if (widget.data.isEmpty) return;
    final double stepX = size.width / (widget.data.length - 1);
    final int index = (details.localPosition.dx / stepX).round().clamp(
      0,
      widget.data.length - 1,
    );
    if (index != widget.selectedIndex) {
      widget.onPointSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTapUp: (details) =>
                _handleTap(details, context.size ?? Size.zero),
            onPanUpdate: (details) =>
                _handlePan(details, context.size ?? Size.zero),
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _SplineChartPainter(
                data: widget.data,
                selectedIndex: widget.selectedIndex,
                selectedValuePrefix: widget.selectedValuePrefix,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.labels.asMap().entries.map((entry) {
              final isSelected = entry.key == widget.selectedIndex;
              return Text(
                entry.value,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SplineChartPainter extends CustomPainter {
  final List<double> data;
  final int selectedIndex;
  final String selectedValuePrefix;

  _SplineChartPainter({
    required this.data,
    required this.selectedIndex,
    required this.selectedValuePrefix,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxVal =
        data.reduce((a, b) => a > b ? a : b) * 1.2; // Add 20% padding top
    final double minVal = 0.0;

    final double stepX = size.width / (data.length - 1);
    final double rangeY = maxVal - minVal;

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double y =
          size.height - ((data[i] - minVal) / rangeY) * size.height;
      points.add(Offset(x, y));
    }

    // Draw spline path
    final Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final Offset p0 = points[i];
      final Offset p1 = points[i + 1];

      final double controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Fill area below spline
    final Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0D7BFF).withOpacity(0.4),
          const Color(0xFF0D7BFF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw spline stroke
    final Paint strokePaint = Paint()
      ..color = const Color(0xFF0D7BFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Draw selected point details
    if (selectedIndex >= 0 && selectedIndex < points.length) {
      final Offset selectedOffset = points[selectedIndex];

      // Vertical dashed line
      final Paint dashPaint = Paint()
        ..color = Colors.white54
        ..strokeWidth = 1.0;

      double dashY = selectedOffset.dy;
      while (dashY < size.height) {
        canvas.drawLine(
          Offset(selectedOffset.dx, dashY),
          Offset(selectedOffset.dx, dashY + 4),
          dashPaint,
        );
        dashY += 8;
      }

      // Outer circle
      final Paint circleOuterPaint = Paint()..color = const Color(0xFF0D7BFF);
      canvas.drawCircle(selectedOffset, 8, circleOuterPaint);

      // Inner circle
      final Paint circleInnerPaint = Paint()..color = Colors.white;
      canvas.drawCircle(selectedOffset, 4, circleInnerPaint);

      // Value Tooltip
      final String valueStr = '\$${data[selectedIndex].toStringAsFixed(0)}';
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: valueStr,
          style: TextStyle(
            fontFamily: 'Arimo',
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final double tooltipWidth = textPainter.width + 16;
      final double tooltipHeight = textPainter.height + 8;

      double tooltipX = selectedOffset.dx + 12;
      if (tooltipX + tooltipWidth > size.width) {
        tooltipX =
            selectedOffset.dx - tooltipWidth - 12; // Flip to left if overflow
      }

      final double tooltipY = selectedOffset.dy - tooltipHeight / 2;

      final RRect tooltipRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
        const Radius.circular(4),
      );

      canvas.drawRRect(tooltipRect, Paint()..color = Colors.white);
      textPainter.paint(canvas, Offset(tooltipX + 8, tooltipY + 4));
    }
  }

  @override
  bool shouldRepaint(covariant _SplineChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.data != data;
  }
}
