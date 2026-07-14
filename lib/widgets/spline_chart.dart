import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox();

    final double maxVal = widget.data.reduce((a, b) => a > b ? a : b) * 1.2;
    final double minVal = 0.0;

    final lineBarData = LineChartBarData(
      spots: widget.data.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList(),
      isCurved: true,
      color: const Color(0xFF0D7BFF),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D7BFF).withValues(alpha: 0.4),
            const Color(0xFF0D7BFF).withValues(alpha: 0.0),
          ],
        ),
      ),
      showingIndicators:
          widget.selectedIndex >= 0 && widget.selectedIndex < widget.data.length
          ? [widget.selectedIndex]
          : [],
    );

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: minVal,
              maxY: maxVal,
              minX: 0,
              maxX: (widget.data.length - 1).toDouble(),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                getTouchLineStart: (barData, spotIndex) =>
                    barData.spots[spotIndex].y,
                getTouchLineEnd: (barData, spotIndex) => minVal,
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          const FlLine(
                            color: Colors.white54,
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 4,
                                strokeColor: const Color(0xFF0D7BFF),
                              );
                            },
                          ),
                        );
                      }).toList();
                    },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => Colors.white,
                  tooltipMargin: 8,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final valueStr =
                          '${widget.selectedValuePrefix}${barSpot.y.toStringAsFixed(0)}';
                      return LineTooltipItem(
                        valueStr,
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? lineTouch) {
                      if (event is FlTapUpEvent || event is FlPanUpdateEvent) {
                        if (lineTouch != null &&
                            lineTouch.lineBarSpots != null &&
                            lineTouch.lineBarSpots!.isNotEmpty) {
                          final index = lineTouch.lineBarSpots!.first.spotIndex;
                          if (index != widget.selectedIndex) {
                            widget.onPointSelected(index);
                          }
                        }
                      }
                    },
              ),
              lineBarsData: [lineBarData],
              showingTooltipIndicators:
                  widget.selectedIndex >= 0 &&
                      widget.selectedIndex < widget.data.length
                  ? [
                      ShowingTooltipIndicators([
                        LineBarSpot(
                          lineBarData,
                          0,
                          lineBarData.spots[widget.selectedIndex],
                        ),
                      ]),
                    ]
                  : [],
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
