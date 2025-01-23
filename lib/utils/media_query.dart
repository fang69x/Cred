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
  static double DESIGN_HEIGHT = 2560;
  static double DESIGN_WIDTH = 1440;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeWidth = screenWidth - _safeAreaHorizontal;
    safeHeight = screenHeight - _safeAreaVertical;
  }

  static double getDefaultWidthDim(double value) {
    return (value / DESIGN_WIDTH) * safeWidth;
  }

  static double getPaddingTop() {
    return _mediaQueryData.padding.top;
  }

  static double getDefaultHeightDim(double value) {
    return (value / DESIGN_HEIGHT) * safeHeight;
  }

  static double getFontSize(double value) {
    return getValueInPixel(value);
  }

  static double getValueInPixel(double value) {
    return min((value / DESIGN_WIDTH) * safeWidth,
        (value / DESIGN_HEIGHT) * safeHeight);
  }
}
