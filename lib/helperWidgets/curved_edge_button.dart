import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurvedEdgeButton extends StatelessWidget {
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
    this.backgroundColor = const Color(0xFF4A4A4A),
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.fontFamily = "Inter",
    this.gradient,
    this.border = BorderSide.none,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    final calculatedHeight = height ?? screenHeight * 0.08;
    final calculatedWidth = width ?? screenWidth * 0.9;
    final calculatedCurveRadius = curveRadius ?? screenHeight * 0.03;
    final calculatedFontSize = fontSize ?? screenWidth * 0.045;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: calculatedHeight,
      width: calculatedWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(calculatedCurveRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(calculatedCurveRadius),
          onTap: () {
            onTap();
            HapticFeedback.lightImpact();
          },
          splashColor: textColor.withOpacity(0.1),
          highlightColor: textColor.withOpacity(0.05),
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [backgroundColor, backgroundColor.darken(0.1)],
                  ),
              borderRadius: BorderRadius.circular(calculatedCurveRadius),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: calculatedFontSize,
                    fontFamily: fontFamily,
                    letterSpacing: 0.8,
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

extension ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
