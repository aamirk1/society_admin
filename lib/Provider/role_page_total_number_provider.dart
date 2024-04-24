import 'package:flutter/foundation.dart';

class RolePageTotalNumProviderAdmin with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  void reloadTotalNum(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}