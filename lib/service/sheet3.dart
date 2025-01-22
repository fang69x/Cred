import 'package:flutter/material.dart';

class StackPage3 extends StatelessWidget {
  const StackPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack 3')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of adding some functionality
            print("Functionality for Stack 3");
          },
          child: const Text('Button in Stack 3'),
        ),
      ),
    );
  }
}
