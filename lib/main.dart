import 'package:cred/providers/data.provider.dart';
import 'package:cred/providers/stack_manager.dart';
import 'package:cred/screens/home.screen.dart';
import 'package:cred/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CredDataProvider()),
        ChangeNotifierProvider(create: (_) => StackManager())
      ],
      child: const Cred(),
    ),
  );
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
