import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB8E6D3), // Light mint green at top
              Color(0xFF7DD3C0), // Medium teal in middle
              Color(0xFF2D9C95), // Deeper teal at bottom
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with title and subtitle
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // App title
                      Text(
                        'FinHabits',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      Text(
                        '"Let AI talk to your money"',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Decorative middle section
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Cloud decorations
                    Positioned(
                      top: 50,
                      right: 40,
                      child: _buildCloud(60, 40),
                    ),
                    Positioned(
                      top: 120,
                      left: 30,
                      child: _buildCloud(45, 30),
                    ),
                    Positioned(
                      top: 200,
                      right: 80,
                      child: _buildCloud(35, 25),
                    ),
                    
                    // Floating particles/bubbles
                    Positioned(
                      top: 80,
                      left: 100,
                      child: _buildFloatingDot(8, Colors.white.withOpacity(0.6)),
                    ),
                    Positioned(
                      top: 160,
                      right: 120,
                      child: _buildFloatingDot(6, Colors.white.withOpacity(0.5)),
                    ),
                    Positioned(
                      top: 240,
                      left: 60,
                      child: _buildFloatingDot(10, Colors.white.withOpacity(0.4)),
                    ),
                    Positioned(
                      bottom: 100,
                      right: 50,
                      child: _buildFloatingDot(7, Colors.white.withOpacity(0.5)),
                    ),
                    
                    // Plant illustration at bottom
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _buildPlantIllustration(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom section with Get Started button
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Get Started button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/main');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E56), // Dark teal
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(width / 2),
      ),
      child: Stack(
        children: [
          Positioned(
            left: width * 0.2,
            top: height * 0.1,
            child: Container(
              width: width * 0.6,
              height: height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(width * 0.3),
              ),
            ),
          ),
          Positioned(
            right: width * 0.1,
            top: height * 0.2,
            child: Container(
              width: width * 0.5,
              height: height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(width * 0.25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPlantIllustration() {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: PlantPainter(),
      ),
    );
  }
}

class PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint stemPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint leafPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double bottomY = size.height;

    // Draw main stem
    canvas.drawLine(
      Offset(centerX, bottomY),
      Offset(centerX, bottomY - size.height * 0.6),
      stemPaint,
    );

    // Draw leaves
    final Path leftLeaf = Path();
    leftLeaf.moveTo(centerX, bottomY - size.height * 0.4);
    leftLeaf.quadraticBezierTo(
      centerX - size.width * 0.3,
      bottomY - size.height * 0.5,
      centerX - size.width * 0.2,
      bottomY - size.height * 0.3,
    );
    leftLeaf.quadraticBezierTo(
      centerX - size.width * 0.1,
      bottomY - size.height * 0.35,
      centerX,
      bottomY - size.height * 0.4,
    );

    final Path rightLeaf = Path();
    rightLeaf.moveTo(centerX, bottomY - size.height * 0.5);
    rightLeaf.quadraticBezierTo(
      centerX + size.width * 0.3,
      bottomY - size.height * 0.6,
      centerX + size.width * 0.2,
      bottomY - size.height * 0.4,
    );
    rightLeaf.quadraticBezierTo(
      centerX + size.width * 0.1,
      bottomY - size.height * 0.45,
      centerX,
      bottomY - size.height * 0.5,
    );

    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);

    // Draw small flower
    final Paint flowerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, bottomY - size.height * 0.6),
      4,
      flowerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
