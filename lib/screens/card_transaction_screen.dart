import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/spend_chart_card.dart';
import '../widgets/transaction_widgets.dart';

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
        centerTitle: false,
        title: Text(
          'Card Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            if (card != null) CreditCardWidget(card: card),
            const SizedBox(height: 30),
            const TotalSpendChartCard(),
            const SizedBox(height: 24),
            const TransactionHistoryHeader(),
            const SizedBox(height: 16),
            if (card != null)
              if (provider.activeCardTransactions.isEmpty)
                const EmptyTransactionState(
                  title: 'No Card Transactions',
                  subtitle:
                      'Transactions made with this card\nwill show up here.',
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.activeCardTransactions.length,
                  itemBuilder: (context, index) {
                    return TransactionListItem(
                      transaction: provider.activeCardTransactions[index],
                    );
                  },
                ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
