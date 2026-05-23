import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/card_data.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final CardData card;
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.card,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with TickerProviderStateMixin {
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  late AnimationController _bgController;
  late Animation<Color?> _bgColor1;
  late Animation<Color?> _bgColor2;

  CardData? _prevCard;

  @override
  void initState() {
    super.initState();

    _orb1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _orb2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 11),
    )..repeat(reverse: true);

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _prevCard = widget.card;
    _initBgAnim(widget.card, widget.card);
  }

  void _initBgAnim(CardData from, CardData to) {
    _bgColor1 = ColorTween(
      begin: from.gradientColors.first,
      end: to.gradientColors.first,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));

    _bgColor2 = ColorTween(
      begin: from.gradientColors.last,
      end: to.gradientColors.last,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(AnimatedGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.id != widget.card.id) {
      _initBgAnim(_prevCard!, widget.card);
      _bgController.forward(from: 0);
      _prevCard = widget.card;
    }
  }

  @override
  void dispose() {
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _orb1Controller,
        _orb2Controller,
        _bgController,
      ]),
      builder: (context, _) {
        final orb1Offset = Offset(
          math.sin(_orb1Controller.value * 2 * math.pi) * 80,
          math.cos(_orb1Controller.value * 2 * math.pi) * 60,
        );
        final orb2Offset = Offset(
          math.cos(_orb2Controller.value * 2 * math.pi) * 100,
          math.sin(_orb2Controller.value * 2 * math.pi) * 80,
        );

        return Stack(
          children: [
            // Base gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _bgColor1.value ?? widget.card.gradientColors.first,
                    Colors.black,
                    _bgColor2.value ?? widget.card.gradientColors.last,
                  ],
                ),
              ),
            ),

            // Orb 1 - accent color glow
            Positioned(
              top: 100 + orb1Offset.dy,
              left: 40 + orb1Offset.dx,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.card.glowColor.withOpacity(0.18),
                      widget.card.glowColor.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Orb 2 - subtle complement
            Positioned(
              bottom: 120 + orb2Offset.dy,
              right: 20 + orb2Offset.dx,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.card.accentColor.withOpacity(0.12),
                      widget.card.accentColor.withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Scanline overlay for depth
            Positioned.fill(
              child: CustomPaint(
                painter: _ScanlinePainter(),
              ),
            ),

            // Content
            widget.child,
          ],
        );
      },
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.012)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
