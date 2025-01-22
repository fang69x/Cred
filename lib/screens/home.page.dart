import 'package:cred/framework/stack_framework.dart';
import 'package:cred/model/stack_item_model.dart';
import 'package:cred/service/sheet1.dart';
import 'package:cred/service/sheet2.dart';
import 'package:cred/service/sheet3.dart';
import 'package:cred/service/sheet4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StackScreen extends StatefulWidget {
  const StackScreen({Key? key}) : super(key: key);

  @override
  _StackScreenState createState() => _StackScreenState();
}

class _StackScreenState extends State<StackScreen> {
  late StackFramework stackFramework;

  @override
  void initState() {
    super.initState();
    stackFramework = StackFramework(
      stackItems: [
        StackItem(name: 'Stack 1'),
        StackItem(name: 'Stack 2'),
        StackItem(name: 'Stack 3'),
        StackItem(name: 'Stack 4'),
      ],
    );
  }

  void toggleItem(int index) {
    setState(() {
      stackFramework.toggleItem(index);
    });
  }

  // Function to navigate to the respective page
  void navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StackPage1()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StackPage2()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StackPage3()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StackPage4()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Framework')),
      body: Stack(
        children: List.generate(stackFramework.stackItems.length, (index) {
          final item = stackFramework.stackItems[index];
          return GestureDetector(
            onTap: () {
              toggleItem(index);
              navigateToPage(index);
            },
            child: AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: item.isExpanded ? 0 : 60.0 * index,
              left: 0,
              right: 0,
              child: Container(
                height: item.isExpanded
                    ? MediaQuery.of(context).size.height * 0.8
                    : 100.0,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
