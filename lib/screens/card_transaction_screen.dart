import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/spline_chart.dart';
import '../widgets/svg_icons.dart';

class CardTransactionScreen extends StatelessWidget {
  const CardTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();
    final card = provider.activeCard;

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Card Transaction',
          style: TextStyle(
            fontFamily: 'Arimo',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Selected Card Preview
            if (card != null) CreditCardWidget(card: card),

            const SizedBox(height: 30),

            // Total Spend and Spline Chart
            Container(
              //padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              'Total Spend ',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${provider.activeChartValue.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        margin: const EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Weekly',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
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
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'See all',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    color: const Color(0xFF0D7BFF),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card Specific Transactions
            if (card != null)
              ...provider.activeCardTransactions.map((t) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF222222),
                        ),
                        child: Center(
                          child: SvgPicture.string(
                            t.iconSvg == 'online_shopping'
                                ? SvgIcons.shop
                                : (t.iconSvg == 'e_wallet'
                                      ? SvgIcons.wallet
                                      : SvgIcons.settings),
                            width: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.title,
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${t.time} · ${t.date}',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${t.isIncome ? "+" : "-"} ${t.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          color: t.isIncome
                              ? const Color(0xFF0D7BFF)
                              : const Color(0xFFFF3B30),
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
}
