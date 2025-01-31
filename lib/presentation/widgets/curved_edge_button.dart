import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class CurvedEdgeButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double? curveRadius;
  final Gradient? gradient;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double? fontSize;
  final String fontFamily;
  final BorderSide border;
  final bool showShadow;

  const CurvedEdgeButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
    this.curveRadius,
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.fontFamily = "Inter",
    this.gradient,
    this.border = BorderSide.none,
    this.showShadow = true,
  }) : super(key: key);

  @override
  State<CurvedEdgeButton> createState() => _CurvedEdgeButtonState();
}

class _CurvedEdgeButtonState extends State<CurvedEdgeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final calculatedHeight = widget.height ?? screenHeight * 0.08;
    final calculatedWidth = widget.width ?? screenWidth * 0.9;
    final calculatedCurveRadius = widget.curveRadius ?? screenHeight * 0.03;
    final calculatedFontSize = widget.fontSize ?? screenWidth * 0.045;

    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF0A2F4D).withOpacity(0.90),
        const Color(0xFF1A1A2E).withOpacity(0.95)
      ],
    );

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onTap: () {
        widget.onTap();
        HapticFeedback.lightImpact();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: calculatedHeight,
            width: calculatedWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(calculatedCurveRadius),
              gradient: widget.gradient ?? defaultGradient,
              border: Border.all(
                color: Colors.white.withOpacity(_isHovered ? 0.2 : 0.1),
                width: 1,
              ),
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 0, 0)
                            .withOpacity(0.15),
                        blurRadius: _isHovered ? 20 : 15,
                        spreadRadius: _isHovered ? 1 : 0,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(calculatedCurveRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(calculatedCurveRadius),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.textColor,
                          fontWeight: widget.fontWeight,
                          fontSize: calculatedFontSize,
                          fontFamily: widget.fontFamily,
                          letterSpacing: 1.0,
                          shadows: [
                            Shadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
