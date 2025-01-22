import 'package:cred/screens/home.page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Cred());
}

class Cred extends StatelessWidget {
  const Cred({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stack Modal Sheets',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StackScreen(),
    );
  }
}
