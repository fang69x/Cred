import 'package:cred/model/stack_item_model.dart';

class StackFramework {
  final List<StackItem> stackItems;

  StackFramework({required this.stackItems}) {
    if (stackItems.length < 2 || stackItems.length > 4) {
      throw Exception('Stack must contain between 2 and 4 items.');
    }
  }

  void toggleItem(int index) {
    for (int i = 0; i < stackItems.length; i++) {
      stackItems[i].isExpanded = i == index ? !stackItems[i].isExpanded : false;
    }
  }
}
