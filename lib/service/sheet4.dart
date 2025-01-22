import 'package:flutter/material.dart';

class StackPage4 extends StatelessWidget {
  const StackPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack 4')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of adding some functionality
            print("Functionality for Stack 4");
          },
          child: const Text('Button in Stack 4'),
        ),
      ),
    );
  }
}
