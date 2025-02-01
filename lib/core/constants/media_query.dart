import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';

class MediaQueryUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeWidth;
  static late double safeHeight;
  static late bool isPortrait;
  static late bool isTablet;

  // Keep your original design values
  static double DESIGN_HEIGHT = 2560;
  static double DESIGN_WIDTH = 1440;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    isPortrait = _mediaQueryData.orientation == Orientation.portrait;
    isTablet = screenWidth > 600;

    // Adjust safe area calculations
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeWidth = screenWidth - _safeAreaHorizontal;
    safeHeight = screenHeight - _safeAreaVertical;
  }

  // Enhanced version of getDefaultWidthDim
  static double getDefaultWidthDim(double value) {
    double scaleFactor = isTablet ? 0.8 : 1.0; // Adjust scale for tablets
    double baseWidth = (value / DESIGN_WIDTH) * safeWidth;
    return baseWidth * scaleFactor;
  }

  // Enhanced version of getDefaultHeightDim
  static double getDefaultHeightDim(double value) {
    double scaleFactor = isTablet ? 0.8 : 1.0; // Adjust scale for tablets
    double baseHeight = (value / DESIGN_HEIGHT) * safeHeight;
    return baseHeight * scaleFactor;
  }

  // Enhanced version of getFontSize
  static double getFontSize(double value) {
    double baseSize = getValueInPixel(value);
    // Adjust font size based on screen width
    if (screenWidth < 360) return baseSize * 0.8; // Small phones
    if (isTablet) return baseSize * 1.1; // Tablets
    return baseSize;
  }

  // Enhanced version of getValueInPixel
  static double getValueInPixel(double value) {
    double widthBasedSize = (value / DESIGN_WIDTH) * safeWidth;
    double heightBasedSize = (value / DESIGN_HEIGHT) * safeHeight;

    // Use orientation to determine which dimension to prioritize
    if (isPortrait) {
      return min(widthBasedSize, heightBasedSize);
    } else {
      // In landscape, we might want to prioritize height-based scaling
      return min(heightBasedSize * 1.2, widthBasedSize);
    }
  }

  // Get padding top with orientation awareness
  static double getPaddingTop() {
    return isPortrait
        ? _mediaQueryData.padding.top
        : _mediaQueryData.padding.top * 0.7;
  }

  // New helper methods for responsive layouts
  static double getResponsiveValue(
      double portraitValue, double landscapeValue) {
    return isPortrait ? portraitValue : landscapeValue;
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal != null ? getDefaultWidthDim(horizontal) : 0,
      vertical: vertical != null ? getDefaultHeightDim(vertical) : 0,
    );
  }

  // Get responsive margin
  static EdgeInsets getResponsiveMargin({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal != null ? getDefaultWidthDim(horizontal) : 0,
      vertical: vertical != null ? getDefaultHeightDim(vertical) : 0,
    );
  }
}
