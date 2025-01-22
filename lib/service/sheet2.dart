import 'package:flutter/material.dart';

class StackPage2 extends StatelessWidget {
  const StackPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of adding some functionality
            print("Functionality for Stack 2");
          },
          child: const Text('Button in Stack 2'),
        ),
      ),
    );
  }
}
