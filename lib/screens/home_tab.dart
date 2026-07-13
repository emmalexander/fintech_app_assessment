import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/svg_icons.dart';

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
            style: TextStyle(fontFamily: 'Arimo', color: Colors.white70, fontSize: 16),
            children: [
              TextSpan(
                text: 'Tayyab Sohail',
                style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              )
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
            icon: SvgPicture.asset('assets/icons/notifications-icon.svg', width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
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
            
            // Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/card-texture.png'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Balance', style: TextStyle(fontFamily: 'Arimo', color: Colors.white70, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('1200\$', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset('assets/icons/mastercard.svg', width: 40),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset('assets/icons/qrcode-icon.svg', width: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D7BFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.add, size: 20),
                          label: Text('Add Cash', style: TextStyle(fontFamily: 'Arimo', fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D7BFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.arrow_outward, size: 20),
                          label: Text('Send Money', style: TextStyle(fontFamily: 'Arimo', fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction('assets/icons/billpay-icon.svg', 'Bill Pay'),
                  _buildQuickAction('assets/icons/donations-icon.svg', 'Donations'),
                  _buildQuickAction('assets/icons/deposit-icon.svg', 'Deposit'),
                  _buildQuickAction('assets/icons/more-icon.svg', 'More'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Transaction History Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction History', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all', style: TextStyle(fontFamily: 'Arimo', color: const Color(0xFF0D7BFF), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Filters
            Row(
              children: ['Weekly', 'Monthly', 'Today'].map((f) {
                final isSelected = provider.chartFilter == f; // Resuing filter from provider
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () => context.read<BankProvider>().setChartFilter(f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(0.1) : const Color(0xFF1E1E1E),
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
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Transactions List
            ...provider.transactions.map((t) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        color: const Color(0xFF1E1E1E),
                        border: Border.all(color: Colors.white12, width: 1),
                      ),
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

  Widget _buildQuickAction(String svgPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2A2A2A),
          ),
          child: Center(
            child: SvgPicture.asset(svgPath, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
