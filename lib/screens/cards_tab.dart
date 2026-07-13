import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/bank_provider.dart';
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
    _pageController = PageController(viewportFraction: 0.85, initialPage: provider.selectedCardIndex);
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Card', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 4),
            Text('2 Physical Card, 1 Virtual Card', style: TextStyle(fontFamily: 'Arimo', color: Colors.white54, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          )
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
                  _buildSegmentButton('Physical Card', true, provider.isPhysicalView),
                  const SizedBox(width: 16),
                  _buildSegmentButton('Virtual Card', false, !provider.isPhysicalView),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    color: isSelected ? const Color(0xFF0D7BFF) : Colors.white24,
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
                _buildActionColumn(SvgIcons.snowflake, 'Freeze Card', () => provider.toggleCardFreeze()),
                _buildActionColumn(SvgIcons.eye, 'Reveal', () => provider.toggleCardReveal()),
                _buildActionColumn(SvgIcons.settings, 'Settings', () {}),
              ],
            ),
            
            const SizedBox(height: 40),
            // Card Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card Settings', style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  if (provider.activeCard != null) ...[
                    _buildSettingSwitch('Change Pin', SvgIcons.settings, provider.activeCard!.pinChanged, (val) => provider.updateCardSetting('pinChanged', val)),
                    _buildSettingSwitch('QR Payment', SvgIcons.qr, provider.activeCard!.qrPaymentEnabled, (val) => provider.updateCardSetting('qrPaymentEnabled', val)),
                    _buildSettingSwitch('Online Shopping', SvgIcons.shop, provider.activeCard!.onlineShoppingEnabled, (val) => provider.updateCardSetting('onlineShoppingEnabled', val)),
                    
                    _buildSettingNav('Card Transactions', SvgIcons.wallet, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CardTransactionScreen()));
                    }),
                    
                    _buildSettingSwitch('Tap Pay', SvgIcons.contactless, provider.activeCard!.tapPayEnabled, (val) => provider.updateCardSetting('tapPayEnabled', val)),
                  ]
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String text, bool isPhysical, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<BankProvider>().setPhysicalView(isPhysical);
          _pageController.jumpToPage(0);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : const Color(0xFF222222),
            border: isSelected ? Border.all(color: const Color(0xFF0D7BFF)) : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontFamily: 'Arimo', 
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionColumn(String svgIcon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF222222),
            ),
            child: SvgPicture.string(svgIcon, width: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String svgIcon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SvgPicture.string(svgIcon, width: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 16))),
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF0D7BFF),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingNav(String title, String svgIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            SvgPicture.string(svgIcon, width: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(fontFamily: 'Arimo', color: Colors.white, fontSize: 16))),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
