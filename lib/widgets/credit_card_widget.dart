import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/card_model.dart';
import 'svg_icons.dart';

class CreditCardWidget extends StatelessWidget {
  final CardModel card;

  const CreditCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E1E1E), // Dark matte background
        image: const DecorationImage(
          // Subtle noise/grain texture
          image: AssetImage(ImagePaths.cardTexture), // Subtle texture
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Chip and Contactless
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(ImagePaths.chip, width: 40),
                        const SizedBox(width: 12),
                        if (card.tapPayEnabled)
                          SvgPicture.asset(
                            SvgPaths.nfcIcon,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                      ],
                    ),
                    SvgPicture.asset(SvgPaths.mastercard, width: 50),
                  ],
                ),

                // Middle: Card Number
                Text(
                  card.isRevealed
                      ? card.cardNumber
                      : _maskCardNumber(card.cardNumber),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Bottom Row: Holder, Valid, CVV
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCardInfo('Card Holder', card.cardHolder),
                    _buildCardInfo('Valid', card.validDate),
                    _buildCardInfo('CVV', card.isRevealed ? card.cvv : '***'),
                  ],
                ),
              ],
            ),
          ),

          // Frozen Overlay
          if (card.isFrozen)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.15),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      SvgIcons.snowflake,
                      width: 40,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Frozen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _maskCardNumber(String number) {
    final parts = number.split(' ');
    if (parts.length == 4) {
      return '•••• •••• •••• ${parts[3]}';
    }
    return number; // Fallback
  }

  Widget _buildCardInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
