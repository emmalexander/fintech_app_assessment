import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/spline_chart.dart';
import '../widgets/svg_icons.dart';

class TotalSpendingCard extends StatelessWidget {
  const TotalSpendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();

    return Container(
      //padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
            child: Column(
              children: [
                Text(
                  'Total Spending',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${provider.activeChartValue.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Weekly', 'Monthly', 'Today', 'Year'].map((f) {
                    final isSelected = provider.chartFilter == f;
                    return GestureDetector(
                      onTap: () =>
                          context.read<BankProvider>().setChartFilter(f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFF2A2A2A),
                          border: isSelected
                              ? Border.all(color: const Color(0xFF0D7BFF))
                              : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: SplineChart(
              data: provider.chartData,
              labels: provider.chartLabels,
              selectedIndex: provider.selectedChartIndex,
              onPointSelected: (index) =>
                  context.read<BankProvider>().selectChartPoint(index),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentTransferCard extends StatelessWidget {
  const RecentTransferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transfer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: Stack(
                  children: [
                    _buildAvatar('https://i.pravatar.cc/150?img=12', 0),
                    _buildAvatar('https://i.pravatar.cc/150?img=20', 30),
                    _buildAvatar('https://i.pravatar.cc/150?img=33', 60),
                    _buildAvatar('https://i.pravatar.cc/150?img=11', 90),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    context.read<BankProvider>().addMockTransfer(150.0),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF272729),
                  ),
                  child: SizedBox(
                    width: 18,
                    child: SvgPicture.asset(SvgPaths.addIcon, width: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url, double leftMargin) {
    return Positioned(
      left: leftMargin,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9E9EA), width: 1.2),
        ),
        child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(url)),
      ),
    );
  }
}
