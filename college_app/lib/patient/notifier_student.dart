import 'package:flutter/foundation.dart';

class notifier_student extends ChangeNotifier {
  List<bool> isFavorite = List.generate(100, (index) => false);
  List<int> prices = List.generate(100, (index) => 50 + (index * 25));

  void change_state(int index) {
    if (isFavorite[index] == false) {
      isFavorite[index] = true;
    } else {
      isFavorite[index] = false;
    }
    notifyListeners();
  }

  void increasePrice(int index) {
    prices[index] -= 20;
    notifyListeners();
  }
}
