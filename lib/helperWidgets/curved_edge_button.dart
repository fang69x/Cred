import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurvedEdgeButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double? curveRadius;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double? fontSize;
  final String fontFamily;

  const CurvedEdgeButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
    this.curveRadius,
    this.backgroundColor = const Color.fromARGB(255, 74, 74, 74),
    this.textColor = const Color.fromARGB(255, 255, 255, 255),
    this.fontWeight = FontWeight.w600,
    this.fontSize,
    this.fontFamily = "Inter",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Use provided values or calculate based on screen dimensions
    final calculatedHeight = height ?? screenHeight * 0.1;
    final calculatedWidth = width ?? screenWidth;
    final calculatedCurveRadius = curveRadius ?? screenHeight * 0.05;
    final calculatedFontSize = fontSize ?? screenWidth * 0.05;

    return GestureDetector(
      onTap: () {
        onTap();
        HapticFeedback.vibrate();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(calculatedCurveRadius),
          topRight: Radius.circular(calculatedCurveRadius),
        ),
        child: Container(
          height: calculatedHeight,
          width: calculatedWidth,
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset:
                    const Offset(0, -4), // Slightly above for bottom bar effect
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: calculatedHeight * 0.2,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: fontWeight,
                  fontSize: calculatedFontSize,
                  fontFamily: fontFamily,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
