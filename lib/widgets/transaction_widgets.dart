import 'package:fintech_app_assessment/providers/bank_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../widgets/svg_icons.dart';

class TransactionHistoryHeader extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const TransactionHistoryHeader({super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (provider.activeCardTransactions.isNotEmpty)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(color: const Color(0xFF0D7BFF), fontSize: 14),
            ),
          ),
      ],
    );
  }
}

class EmptyTransactionState extends StatefulWidget {
  final String title;
  final String subtitle;

  const EmptyTransactionState({
    super.key,
    this.title = 'No Transactions Yet',
    this.subtitle =
        'Your transactions will appear here\nonce you start spending.',
  });

  @override
  State<EmptyTransactionState> createState() => _EmptyTransactionStateState();
}

class _EmptyTransactionStateState extends State<EmptyTransactionState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnim = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnim.value,
                  child: Opacity(opacity: _opacityAnim.value, child: child),
                );
              },
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E1E1E),
                  border: Border.all(color: Colors.white10, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D7BFF).withValues(alpha: 0.12),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFF0D7BFF),
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final bool useAssetIcons;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.useAssetIcons = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaction;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: useAssetIcons
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFF222222),
              border: useAssetIcons
                  ? Border.all(color: Colors.white12, width: 1)
                  : null,
            ),
            child: Center(
              child: useAssetIcons
                  ? SvgPicture.asset(
                      t.iconSvg == 'online_shopping'
                          ? SvgPaths.cardOnlineShopping
                          : (t.iconSvg == 'e_wallet'
                                ? SvgPaths.eWallet
                                : SvgPaths.cardTransactions),
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.string(
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
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${t.time} · ${t.date}',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${t.isIncome ? "+" : "-"} ${t.amount.toStringAsFixed(0)}',
            style: TextStyle(
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
  }
}

class TransactionFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final bool outlined;

  const TransactionFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: filters.map((f) {
        final isSelected = selectedFilter == f;
        return outlined
            ? Expanded(
                child: GestureDetector(
                  onTap: () => onFilterSelected(f),
                  child: Container(
                    margin: EdgeInsets.only(right: f != filters.last ? 16 : 0),
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
                    alignment: Alignment.center,
                    child: Text(
                      f,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => onFilterSelected(f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.1)
                          : const Color(0xFF1E1E1E),
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
                ),
              );
      }).toList(),
    );
  }
}
