

class StackPopupModel {
  static int _currentStackPopupIndex = 0;
  static const int screen_1 = 0;
  static const int screen_2 = 1;
  static const int screen_3 = 2;
  

  static int getCurrentStackPopupIndex() => _currentStackPopupIndex;

  static void incCurrentStackPopupIndex() {
     _currentStackPopupIndex++;
  }

  static void decCurrentStackPopupIndex() => _currentStackPopupIndex--;
}
