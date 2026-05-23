import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/card_data.dart';

class CardDetailsPanel extends StatelessWidget {
  final CardData card;
  final bool isVisible;

  const CardDetailsPanel({
    super.key,
    required this.card,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 32),
        // Divider line with accent
        _buildDivider(),
        const SizedBox(height: 28),
        // Details grid
        _buildDetailsGrid(),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  card.accentColor.withOpacity(0.4),
                  card.accentColor.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: card.accentColor,
              boxShadow: [
                BoxShadow(
                  color: card.glowColor.withOpacity(0.8),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  card.accentColor.withOpacity(0.7),
                  card.accentColor.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scaleX(begin: 0, curve: Curves.easeOut);
  }

  Widget _buildDetailsGrid() {
    final details = [
      _DetailItem(
        label: 'CARD HOLDER',
        value: card.holderName,
        icon: Icons.person_outline_rounded,
        delay: 0,
      ),
      _DetailItem(
        label: 'ACCOUNT',
        value: card.accountNumber,
        icon: Icons.credit_card_rounded,
        delay: 1,
      ),
      _DetailItem(
        label: 'EXPIRY DATE',
        value: card.expiryDate,
        icon: Icons.calendar_today_outlined,
        delay: 2,
      ),
      _DetailItem(
        label: 'BALANCE',
        value: card.balance,
        icon: Icons.account_balance_wallet_outlined,
        delay: 3,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: details
          .map((d) => _buildDetailCard(d))
          .toList(),
    );
  }

  Widget _buildDetailCard(_DetailItem item) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(
          color: card.accentColor.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: card.glowColor.withOpacity(0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            color: card.accentColor,
            size: 16,
          ),
          const SizedBox(height: 10),
          Text(
            item.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 8,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 100 + item.delay * 120),
          duration: 500.ms,
        )
        .slideY(
          begin: 0.3,
          delay: Duration(milliseconds: 100 + item.delay * 120),
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _DetailItem {
  final String label;
  final String value;
  final IconData icon;
  final int delay;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.delay,
  });
}
