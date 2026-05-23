import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/card_data.dart';
import '../widgets/interactive_3d_card.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/card_details_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentIndex = 0;
  bool _showDetails = false;

  // Track the key so we can reset card when switching
  Key _cardKey = UniqueKey();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _showDetails = false;
      _cardKey = UniqueKey(); // reset 3D card rotation on swipe
    });
  }

  void _onCardTap() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = sampleCards[_currentIndex];

    return Scaffold(
      body: AnimatedGradientBackground(
        card: currentCard,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hint text
                    _buildSwipeHint(),

                    const SizedBox(height: 20),

                    // Card page view
                    SizedBox(
                      height: 240,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: sampleCards.length,
                        itemBuilder: (context, index) {
                          return AnimatedScale(
                            scale: index == _currentIndex ? 1.0 : 0.88,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: Center(
                              child: Interactive3DCard(
                                key: index == _currentIndex ? _cardKey : Key('card_$index'),
                                card: sampleCards[index],
                                onTap: index == _currentIndex ? _onCardTap : () {},
                                isSelected: index == _currentIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Page indicators
                    _buildIndicators(),

                    // Details panel — appears on tap
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CardDetailsPanel(
                          key: ValueKey('${currentCard.id}_$_showDetails'),
                          card: currentCard,
                          isVisible: _showDetails,
                        ),
                      ),
                    ),

                    if (!_showDetails) const SizedBox(height: 16),

                    // Tap hint
                    if (!_showDetails) _buildTapHint(),
                  ],
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Cards',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${sampleCards.length} active cards',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.38),
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, duration: 600.ms),

          Row(
            children: [
              _TopBarButton(
                icon: Icons.notifications_outlined,
                badge: true,
                color: sampleCards[_currentIndex].accentColor,
              ),
              const SizedBox(width: 12),
              _TopBarButton(
                icon: Icons.person_outline_rounded,
                color: sampleCards[_currentIndex].accentColor,
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildSwipeHint() {
    return Text(
      'SWIPE TO BROWSE',
      style: TextStyle(
        color: Colors.white.withOpacity(0.2),
        fontSize: 9,
        letterSpacing: 3,
        fontWeight: FontWeight.w500,
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 800.ms);
  }

  Widget _buildTapHint() {
    return Text(
      'TAP CARD FOR DETAILS',
      style: TextStyle(
        color: sampleCards[_currentIndex].accentColor.withOpacity(0.5),
        fontSize: 9,
        letterSpacing: 3,
        fontWeight: FontWeight.w500,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 800.ms)
        .then()
        .fadeOut(duration: 800.ms);
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sampleCards.length, (i) {
        final isActive = i == _currentIndex;
        final card = sampleCards[_currentIndex];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 5,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive
                ? card.accentColor
                : Colors.white.withOpacity(0.2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: card.glowColor.withOpacity(0.7),
                      blurRadius: 8,
                    )
                  ]
                : [],
          ),
        );
      }),
    );
  }

  Widget _buildBottomNav() {
    final accent = sampleCards[_currentIndex].accentColor;
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_rounded, label: 'Home', isActive: true, accent: accent),
          _NavItem(icon: Icons.send_rounded, label: 'Transfer', isActive: false, accent: accent),
          _NavItem(icon: Icons.bar_chart_rounded, label: 'Analytics', isActive: false, accent: accent),
          _NavItem(icon: Icons.settings_outlined, label: 'Settings', isActive: false, accent: accent),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideY(begin: 0.4, duration: 600.ms, curve: Curves.easeOutCubic);
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final Color color;

  const _TopBarButton({
    required this.icon,
    this.badge = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        ),
        if (badge)
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.8), blurRadius: 6),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color accent;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? accent : Colors.white.withOpacity(0.3),
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? accent : Colors.white.withOpacity(0.25),
            fontSize: 9,
            letterSpacing: 0.5,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
