import 'package:flutter/foundation.dart';

class ComplaintManagementProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}