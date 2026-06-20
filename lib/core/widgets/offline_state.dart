import 'package:flutter/material.dart';

import '../design/app_spacing.dart';
import '../extensions/context_extensions.dart';

class OfflineState extends StatelessWidget {
  const OfflineState({
    this.title = 'No Internet?',
    this.message = 'Blame the rat! He thought the Wi-Fi wire was a snack!',
    this.onRetry,
    this.showRat = true,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final bool showRat;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Offline Icon/Illustration
            if (showRat)
              _buildRatIllustration(context)
            else
              Icon(
                Icons.wifi_off,
                size: 100,
                color: context.colorScheme.error,
              ),
            const SizedBox(height: AppSpacing.xl),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Retry Button
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Retry'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatIllustration(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: CustomPaint(
        painter: _RatPainter(context.colorScheme.primary),
      ),
    );
  }
}

class _RatPainter extends CustomPainter {
  final Color primaryColor;

  _RatPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF7A7A7A);
    final earPaint = Paint()..color = const Color(0xFFD99999);
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final nosePaint = Paint()..color = const Color(0xFFFFB3B3);

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Body
    canvas.drawCircle(Offset(centerX, centerY), 45, paint);

    // Left ear
    canvas.drawCircle(Offset(centerX - 35, centerY - 45), 20, earPaint);
    canvas.drawCircle(Offset(centerX - 35, centerY - 45), 18, paint);

    // Right ear
    canvas.drawCircle(Offset(centerX + 35, centerY - 45), 20, earPaint);
    canvas.drawCircle(Offset(centerX + 35, centerY - 45), 18, paint);

    // Head
    canvas.drawCircle(Offset(centerX, centerY - 30), 35, paint);

    // Left eye
    canvas.drawCircle(Offset(centerX - 15, centerY - 35), 8, eyePaint);
    canvas.drawCircle(Offset(centerX - 15, centerY - 35), 5, pupilPaint);

    // Right eye
    canvas.drawCircle(Offset(centerX + 15, centerY - 35), 8, eyePaint);
    canvas.drawCircle(Offset(centerX + 15, centerY - 35), 5, pupilPaint);

    // Nose
    canvas.drawCircle(Offset(centerX, centerY - 20), 5, nosePaint);

    // Mouth
    final mouthPath = Path();
    mouthPath.moveTo(centerX - 5, centerY - 15);
    mouthPath.quadraticBezierTo(centerX, centerY - 10, centerX + 5, centerY - 15);
    canvas.drawPath(
      mouthPath,
      paint..strokeWidth = 2..style = PaintingStyle.stroke,
    );

    // Tail
    final tailPath = Path();
    tailPath.moveTo(centerX + 45, centerY + 25);
    tailPath.quadraticBezierTo(centerX + 60, centerY + 20, centerX + 70, centerY + 30);
    canvas.drawPath(
      tailPath,
      paint..strokeWidth = 3..style = PaintingStyle.stroke,
    );

    // WiFi icon near rat's paw
    _drawWiFiIcon(canvas, size, Offset(centerX + 60, centerY - 60));
  }

  void _drawWiFiIcon(Canvas canvas, Size size, Offset position) {
    final wifiPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // WiFi arcs
    canvas.drawArc(
      Rect.fromCenter(center: position, width: 8, height: 8),
      0.7853981633974483,
      1.5707963267948966,
      false,
      wifiPaint,
    );

    // WiFi dot
    canvas.drawCircle(position, 1.5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_RatPainter oldDelegate) => false;
}
