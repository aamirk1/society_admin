import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  bool _reloadWidget = false;
  bool get reloadWidget => _reloadWidget;

  void setReloadWidget(bool value) {
    _reloadWidget = value;
    notifyListeners();
  }
}
