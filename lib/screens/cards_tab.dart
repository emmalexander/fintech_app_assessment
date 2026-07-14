import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
import '../widgets/cards_tab_widgets.dart';
import '../widgets/credit_card_widget.dart';
import '../widgets/svg_icons.dart';
import 'card_transaction_screen.dart';

class CardsTab extends StatefulWidget {
  const CardsTab({super.key});

  @override
  State<CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<CardsTab> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<BankProvider>();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: provider.selectedCardIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();
    final cards = provider.filteredCards;

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 22,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Card',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '2 Physical Card, 1 Virtual Card',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Segmented Control
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  CardSegmentButton(
                    text: 'Physical Card',
                    isSelected: provider.isPhysicalView,
                    onTap: () {
                      context.read<BankProvider>().setPhysicalView(true);
                      _pageController.jumpToPage(0);
                    },
                  ),
                  const SizedBox(width: 16),
                  CardSegmentButton(
                    text: 'Virtual Card',
                    isSelected: !provider.isPhysicalView,
                    onTap: () {
                      context.read<BankProvider>().setPhysicalView(false);
                      _pageController.jumpToPage(0);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Card Carousel
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  provider.setActiveCardIndex(index);
                },
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                      } else if (index != provider.selectedCardIndex) {
                        value = 0.8;
                      }

                      return Center(
                        child: SizedBox(
                          height: Curves.easeOut.transform(value) * 220,
                          width: Curves.easeOut.transform(value) * 350,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: CreditCardWidget(card: cards[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cards.length, (index) {
                final isSelected = provider.selectedCardIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: isSelected ? 20 : 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0D7BFF)
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            // Card Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardActionButton(
                  svgIcon: SvgPaths.freezeCard,
                  title: 'Freeze Card',
                  onTap: () => provider.toggleCardFreeze(),
                ),
                CardActionButton(
                  svgIcon: SvgPaths.reveal,
                  title: 'Reveal',
                  onTap: () => provider.toggleCardReveal(),
                ),
                CardActionButton(
                  svgIcon: SvgPaths.freezeCard,
                  title: 'Freeze Card',
                  onTap: () => provider.toggleCardFreeze(),
                ),
              ],
            ),

            const SizedBox(height: 40),
            // Card Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (provider.activeCard != null) ...[
                    CardSettingSwitch(
                      title: 'Change Pin',
                      svgIcon: SvgPaths.changePin,
                      value: provider.activeCard!.pinChanged,
                      onChanged: (val) =>
                          provider.updateCardSetting('pinChanged', val),
                    ),
                    CardSettingSwitch(
                      title: 'QR Payment',
                      svgIcon: SvgPaths.qrPayment,
                      value: provider.activeCard!.qrPaymentEnabled,
                      onChanged: (val) =>
                          provider.updateCardSetting('qrPaymentEnabled', val),
                    ),
                    CardSettingSwitch(
                      title: 'Online Shopping',
                      svgIcon: SvgPaths.cardOnlineShopping,
                      value: provider.activeCard!.onlineShoppingEnabled,
                      onChanged: (val) => provider.updateCardSetting(
                        'onlineShoppingEnabled',
                        val,
                      ),
                    ),
                    CardSettingNavItem(
                      title: 'Card Transactions',
                      svgIcon: SvgPaths.cardTransactions,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CardTransactionScreen(),
                          ),
                        );
                      },
                    ),
                    CardSettingSwitch(
                      title: 'Tap Pay',
                      svgIcon: SvgPaths.tapPay,
                      value: provider.activeCard!.tapPayEnabled,
                      onChanged: (val) =>
                          provider.updateCardSetting('tapPayEnabled', val),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
