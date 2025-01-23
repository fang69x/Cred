import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurvedEdgeButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double height;
  final double width;
  final double curveRadius;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final String fontFamily;

  const CurvedEdgeButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.height = 100.0,
    this.width = double.infinity,
    this.curveRadius = 40.0,
    this.backgroundColor = const Color.fromARGB(255, 54, 8, 204),
    this.textColor = const Color.fromARGB(255, 255, 255, 255),
    this.fontWeight = FontWeight.w600,
    this.fontSize = 24.0,
    this.fontFamily = "Inter",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        HapticFeedback.vibrate();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(curveRadius),
          topRight: Radius.circular(curveRadius),
        ),
        child: Container(
          height: height,
          width: width,
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
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
