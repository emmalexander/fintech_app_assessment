import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/svg_icons.dart';
import '../widgets/home_cards.dart';
import '../widgets/transaction_widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: 'Welcome ',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            children: [
              TextSpan(
                text: 'Tayyab Sohail',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              SvgPaths.notifications,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
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
            const BalanceCard(),
            const SizedBox(height: 24),
            const QuickActionsCard(),
            const SizedBox(height: 32),
            const TransactionHistoryHeader(),
            const SizedBox(height: 16),
            TransactionFilterChips(
              filters: const ['Weekly', 'Monthly', 'Today'],
              selectedFilter: provider.chartFilter,
              onFilterSelected: (f) =>
                  context.read<BankProvider>().setChartFilter(f),
            ),
            const SizedBox(height: 24),
            if (provider.transactions.isEmpty)
              const EmptyTransactionState(
                subtitle:
                    'Your recent transactions will appear\nhere once you start spending.',
              )
            else
              ...provider.transactions.map(
                (t) => TransactionListItem(transaction: t, useAssetIcons: true),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
