import 'package:flutter/material.dart';

class CardData {
  final String id;
  final String holderName;
  final String accountNumber;
  final String expiryDate;
  final String balance;
  final String cardType;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color glowColor;
  final String bankName;
  final IconData networkIcon;

  const CardData({
    required this.id,
    required this.holderName,
    required this.accountNumber,
    required this.expiryDate,
    required this.balance,
    required this.cardType,
    required this.gradientColors,
    required this.accentColor,
    required this.glowColor,
    required this.bankName,
    required this.networkIcon,
  });
}

final List<CardData> sampleCards = [
  CardData(
    id: '1',
    holderName: 'ALEXANDER CHEN',
    accountNumber: '4821 •••• •••• 7392',
    expiryDate: '09 / 28',
    balance: '\$48,291.50',
    cardType: 'PLATINUM',
    gradientColors: [
      const Color(0xFF0F0C29),
      const Color(0xFF302B63),
      const Color(0xFF24243E),
    ],
    accentColor: const Color(0xFF7B61FF),
    glowColor: const Color(0xFF7B61FF),
    bankName: 'NEXUS BANK',
    networkIcon: Icons.credit_card,
  ),
  CardData(
    id: '2',
    holderName: 'SOPHIA WILLIAMS',
    accountNumber: '5512 •••• •••• 8841',
    expiryDate: '03 / 27',
    balance: '\$127,450.00',
    cardType: 'INFINITE',
    gradientColors: [
      const Color(0xFF1A1A2E),
      const Color(0xFF16213E),
      const Color(0xFF0F3460),
    ],
    accentColor: const Color(0xFF00D4FF),
    glowColor: const Color(0xFF00D4FF),
    bankName: 'NEXUS BANK',
    networkIcon: Icons.credit_card,
  ),
  CardData(
    id: '3',
    holderName: 'MARCUS STERLING',
    accountNumber: '3741 •••• •••• 2209',
    expiryDate: '11 / 29',
    balance: '\$9,870.25',
    cardType: 'SIGNATURE',
    gradientColors: [
      const Color(0xFF0D0D0D),
      const Color(0xFF1A0A00),
      const Color(0xFF2D1B00),
    ],
    accentColor: const Color(0xFFFFB347),
    glowColor: const Color(0xFFFF8C00),
    bankName: 'NEXUS BANK',
    networkIcon: Icons.credit_card,
  ),
  CardData(
    id: '4',
    holderName: 'ISABELLA ROSS',
    accountNumber: '6011 •••• •••• 5534',
    expiryDate: '07 / 26',
    balance: '\$34,600.75',
    cardType: 'ELITE',
    gradientColors: [
      const Color(0xFF0A0A1A),
      const Color(0xFF0D1B0D),
      const Color(0xFF001A00),
    ],
    accentColor: const Color(0xFF00FF88),
    glowColor: const Color(0xFF00CC66),
    bankName: 'NEXUS BANK',
    networkIcon: Icons.credit_card,
  ),
  CardData(
    id: '5',
    holderName: 'RYAN BLACKWOOD',
    accountNumber: '4111 •••• •••• 9921',
    expiryDate: '12 / 30',
    balance: '\$253,100.00',
    cardType: 'OBSIDIAN',
    gradientColors: [
      const Color(0xFF1A0020),
      const Color(0xFF0D0015),
      const Color(0xFF200030),
    ],
    accentColor: const Color(0xFFFF00FF),
    glowColor: const Color(0xFFCC00CC),
    bankName: 'NEXUS BANK',
    networkIcon: Icons.credit_card,
  ),
];
