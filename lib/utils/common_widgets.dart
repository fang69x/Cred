import 'package:flutter/material.dart';

import 'media_query.dart';

class CommonWidgets {
  static Widget FontWidget(String txt,
      [Color fntColor = Colors.white,
      FontWeight fntW = FontWeight.w400,
      String fntFamily = "Inter",
      FontStyle fntStyle = FontStyle.normal,
      double fntSize = 20,
      TextAlign textAlign = TextAlign.center,
      int? maxlines,
      double letterSpacing = 0]) {
    return Text(
      txt,
      style: TextStyle(
        color: fntColor,
        fontWeight: fntW,
        fontFamily: fntFamily,
        fontStyle: fntStyle,
        fontSize: MediaQueryUtil.getFontSize(fntSize),
        letterSpacing: letterSpacing,
      ),
      maxLines: maxlines,
      textAlign: textAlign,
      textScaleFactor: 1.0,
    );
  }

   static Widget getBackButtonWidget() {
    return const Icon(
      Icons.arrow_back_ios_sharp,
      color: Colors.white,
    );
  }
}
