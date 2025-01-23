import 'package:cred/screens/home.screen.dart';
import 'package:cred/screens/intro_screen.dart';

import 'package:flutter/material.dart';

class ScreenTrans {
  static Route homeScreen() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: HomeScreen.routeName),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route introScreen() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: IntroScreen.routeName),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const IntroScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
