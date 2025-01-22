import 'package:flutter/material.dart';

class StackPage1 extends StatelessWidget {
  const StackPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of adding some functionality
            print("Functionality for Stack 1");
          },
          child: const Text('Button in Stack 1'),
        ),
      ),
    );
  }
}
