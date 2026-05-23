import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../models/card_data.dart';

class Interactive3DCard extends StatefulWidget {
  final CardData card;
  final VoidCallback onTap;
  final bool isSelected;

  const Interactive3DCard({
    super.key,
    required this.card,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard>
    with TickerProviderStateMixin {
  // Current rotation angles (cumulative, free rotation)
  double _rotX = 0.0;
  double _rotY = 0.0;

  // Velocity for inertia
  double _velX = 0.0;
  double _velY = 0.0;

  // Drag tracking
  Offset? _lastDragPos;
  DateTime? _lastDragTime;

  // Inertia animation
  late AnimationController _inertiaController;

  // Glow pulse
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  // Shimmer
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _inertiaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _shimmerAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _inertiaController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _inertiaController.stop();
    _lastDragPos = details.globalPosition;
    _lastDragTime = DateTime.now();
    _velX = 0;
    _velY = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final now = DateTime.now();
    final dt = now.difference(_lastDragTime!).inMilliseconds / 1000.0;

    final dx = details.globalPosition.dx - _lastDragPos!.dx;
    final dy = details.globalPosition.dy - _lastDragPos!.dy;

    if (dt > 0) {
      _velX = dx / dt;
      _velY = dy / dt;
    }

    setState(() {
      // Dragging horizontally rotates around Y axis, vertically around X axis
      _rotY += dx * 0.5;
      _rotX -= dy * 0.5;
    });

    _lastDragPos = details.globalPosition;
    _lastDragTime = now;
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;

    // Apply inertia — smoothly decelerate
    final startRotX = _rotX;
    final startRotY = _rotY;
    final initialVelX = _velX * 0.003;
    final initialVelY = _velY * 0.003;

    double t = 0;
    _inertiaController.reset();

    _inertiaController.addListener(() {
      t = _inertiaController.value;
      // Exponential decay
      final decay = math.exp(-t * 5);
      setState(() {
        _rotY = startRotY + initialVelX * (1 - decay) * 80;
        _rotX = startRotX - initialVelY * (1 - decay) * 80;
      });
    });

    _inertiaController.forward();
  }

  void _onTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final rotXRad = _rotX * math.pi / 180;
    final rotYRad = _rotY * math.pi / 180;

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowAnim, _shimmerAnim]),
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(rotXRad)
              ..rotateY(rotYRad),
            child: _buildCard(),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    final card = widget.card;
    return Container(
      width: 340,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: card.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: card.glowColor.withOpacity(0.15 + _glowAnim.value * 0.2),
            blurRadius: 40 + _glowAnim.value * 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Glass layer
            _buildGlassLayer(),
            // Shimmer sweep
            _buildShimmer(),
            // Mesh circles
            _buildMeshDecor(),
            // Card content
            _buildCardContent(),
            // Top-left lighting
            _buildTopLighting(),
            // Edge border glow
            _buildEdgeBorder(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassLayer() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
              Colors.transparent,
              Colors.white.withOpacity(0.05),
            ],
            stops: const [0, 0.3, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _shimmerAnim,
        builder: (_, __) => Transform.translate(
          offset: Offset(_shimmerAnim.value * 400, 0),
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.06),
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeshDecor() {
    return Positioned(
      right: -30,
      bottom: -30,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.card.accentColor.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildTopLighting() {
    return Positioned(
      top: -60,
      left: -60,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEdgeBorder() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: widget.card.accentColor.withOpacity(0.25 + _glowAnim.value * 0.15),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    final card = widget.card;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: bank name + chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.bankName,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              _buildChip(),
            ],
          ),
          const Spacer(),
          // Card number
          Text(
            card.accountNumber,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 17,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 16),
          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 8,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.holderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 8,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              // Card type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.card.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.card.accentColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  card.cardType,
                  style: TextStyle(
                    color: widget.card.accentColor,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip() {
    return Container(
      width: 38,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.card.accentColor.withOpacity(0.7),
            widget.card.accentColor.withOpacity(0.4),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.card.glowColor.withOpacity(0.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: CustomPaint(painter: _ChipPainter()),
    );
  }
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    // Chip lines
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.75, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
