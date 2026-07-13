import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/spline_chart.dart';
import '../widgets/svg_icons.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('My Activity', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Total Spending Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Total Spending', style: TextStyle(fontFamily: 'Arimo', color: Colors.white54, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('\$${provider.activeChartValue.toStringAsFixed(0)}', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Filters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Weekly', 'Monthly', 'Today', 'Year'].map((f) {
                      final isSelected = provider.chartFilter == f;
                      return GestureDetector(
                        onTap: () => context.read<BankProvider>().setChartFilter(f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.transparent : const Color(0xFF2A2A2A),
                            border: isSelected ? Border.all(color: const Color(0xFF0D7BFF)) : null,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(fontFamily: 'Arimo', 
                              color: isSelected ? Colors.white : Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // Spline Chart
                  SizedBox(
                    height: 250,
                    child: SplineChart(
                      data: provider.chartData,
                      labels: provider.chartLabels,
                      selectedIndex: provider.selectedChartIndex,
                      onPointSelected: (index) => context.read<BankProvider>().selectChartPoint(index),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Recent Transfer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Transfer', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Avatars overlapping
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
                      // Add Button
                      GestureDetector(
                        onTap: () => context.read<BankProvider>().addMockTransfer(150.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2A2A2A)),
                          child: const Icon(Icons.add, color: Color(0xFF0D7BFF)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction History', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all', style: TextStyle(fontFamily: 'Arimo', color: const Color(0xFF0D7BFF), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Transactions List
            ...provider.transactions.map((t) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF222222)),
                      child: Center(
                        child: SvgPicture.string(
                           t.iconSvg == 'online_shopping' ? SvgIcons.shop : (t.iconSvg == 'e_wallet' ? SvgIcons.wallet : SvgIcons.settings),
                           width: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title, style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text('${t.time} · ${t.date}', style: TextStyle(fontFamily: 'Arimo', color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      '${t.isIncome ? "+" : "-"} ${t.amount.toStringAsFixed(0)}',
                      style: TextStyle(fontFamily: 'Arimo', 
                        color: t.isIncome ? const Color(0xFF0D7BFF) : const Color(0xFFFF3B30),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String url, double leftMargin) {
    return Positioned(
      left: leftMargin,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF222222), width: 2),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }
}
