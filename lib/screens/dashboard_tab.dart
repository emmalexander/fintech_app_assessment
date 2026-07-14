import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/transaction_widgets.dart';

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
        centerTitle: false,
        title: Text(
          'My Activity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 18,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const TotalSpendingCard(),
            const SizedBox(height: 24),
            const RecentTransferCard(),
            const SizedBox(height: 24),
            const TransactionHistoryHeader(),
            const SizedBox(height: 16),
            if (provider.transactions.isEmpty)
              const EmptyTransactionState(
                subtitle:
                    'Your activity will appear here\nonce you start making transactions.',
              )
            else
              ...provider.transactions.map(
                (t) => TransactionListItem(transaction: t),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
