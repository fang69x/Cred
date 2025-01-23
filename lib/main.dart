import 'package:cred/screens/home.screen.dart';
import 'package:cred/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const Cred());
}

class Cred extends StatelessWidget {
  const Cred({super.key});

  static var routes = {
    HomeScreen.routeName: (context) => const HomeScreen(),
    IntroScreen.routeName: (context) => const IntroScreen(),
  };

  static const initialRoute = HomeScreen.routeName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
