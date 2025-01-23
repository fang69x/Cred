import 'package:cred/utils/common_widgets.dart';
import 'package:cred/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/strings_constants.dart';

class CircularProgressBar extends StatefulWidget {
  final double radius;
  final double strokeWidth;
  final Color progressColor;
  final Color arrowColor;
  final double progress;
  final int startValue;
  final int endValue;
  final Function(double, int) onChanged;

  const CircularProgressBar({
    super.key,
    required this.radius,
    required this.strokeWidth,
    required this.progressColor,
    required this.arrowColor,
    required this.progress,
    required this.onChanged,
    required this.startValue,
    required this.endValue,
  });

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar> {
  final double _startAngle = math.pi * 1.5;
  double _currentAngle = math.pi * 1.5;
  int finalValue = 0;

  @override
  void initState() {
    super.initState();
    _currentAngle = widget.progress * 2 * math.pi + _startAngle;
    finalValue = widget.startValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          ClipPath(
            // Clip touchable area to progress arc and arrow shape
            clipper: _CircularProgressBarClipper(
              startAngle: _startAngle,
              endAngle: _currentAngle,
              strokeWidth: widget.strokeWidth,
            ),
            child: SizedBox(
              width: widget.radius * 2,
              height: widget.radius * 2,
              child: CustomPaint(
                painter: _CircularProgressBarPainter(
                  startAngle: _startAngle,
                  endAngle: _currentAngle,
                  strokeWidth: widget.strokeWidth,
                  progressColor: widget.progressColor,
                  arrowColor: widget.arrowColor,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets.FontWidget(
                    StringConstants.creditAmount,
                    Colors.white.withOpacity(0.7),
                    FontWeight.w400,
                    "Roboto",
                    FontStyle.normal,
                    60,
                    TextAlign.left),
                SizedBox(
                  height: MediaQueryUtil.getValueInPixel(15),
                ),
                // CommonWidgets.FontWidget(NumberFormat.currency(locale: 'en_IN', symbol: '₹ ', decimalDigits: 0).format(finalValue), Colors.white, FontWeight.w700, "Inter", FontStyle.normal, 80, TextAlign.center)
              ],
            )),
          ),
        ],
      ),
      onPanStart: (details) {
        _updateProgress(details.localPosition);
      },
      onPanUpdate: (details) {
        _updateProgress(details.localPosition);
      },
    );
  }

  void _updateProgress(Offset localPosition) {
    double dx = localPosition.dx - widget.radius;
    double dy = localPosition.dy - widget.radius;
    double angle = math.atan2(dy, dx);
    if (angle < 0) {
      angle += 2 * math.pi;
    }
    double initialAngle = widget.progress * 2 * math.pi + _startAngle;
    if (angle > initialAngle) {
      _currentAngle = angle;
    } else {
      _currentAngle = angle + 2 * math.pi;
    }
    setState(() {
      double progress = (_currentAngle - _startAngle) / (2 * math.pi);

      if (progress > 1.0) {
        progress = 1.0;
      }
      finalValue =
          (widget.startValue + (widget.endValue - widget.startValue) * progress)
              .ceil();
      widget.onChanged(progress, finalValue);
    });
  }
}

class _CircularProgressBarPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double strokeWidth;
  final Color progressColor;
  final Color arrowColor;

  _CircularProgressBarPainter({
    required this.startAngle,
    required this.endAngle,
    required this.strokeWidth,
    required this.progressColor,
    required this.arrowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - strokeWidth / 2;

    // Draw progress bar
    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      progressPaint,
    );

    // Draw arrow
    Offset arrowOffset = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );
    Paint arrowPaint = Paint()..color = arrowColor;
    double arrowRadius = strokeWidth / 2;
    canvas.drawCircle(arrowOffset, arrowRadius, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _CircularProgressBarClipper extends CustomClipper<Path> {
  final double startAngle;
  final double endAngle;
  final double strokeWidth;

  _CircularProgressBarClipper({
    required this.startAngle,
    required this.endAngle,
    required this.strokeWidth,
  });

  @override
  Path getClip(Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - strokeWidth / 2;

    double startAngleRadians = startAngle;
    double endAngleRadians = endAngle;

    Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + radius * math.cos(startAngleRadians),
        center.dy + radius * math.sin(startAngleRadians));
    path.arcTo(Rect.fromCircle(center: center, radius: radius),
        startAngleRadians, endAngleRadians - startAngleRadians, false);
    path.lineTo(center.dx, center.dy);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
