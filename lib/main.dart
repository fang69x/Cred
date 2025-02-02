import 'package:cred/presentation/providers/api_data_provider.dart';

import 'package:cred/presentation/pages/home_screen.dart';
import 'package:cred/presentation/pages/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CredDataProvider()),
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
