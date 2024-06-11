import 'package:flutter/foundation.dart';

class UploadReceiptProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  String _selectedMonth = '';
  String get selectedMonth => _selectedMonth;

  void reload(bool value) {
    _loadWidget = value;
    notifyListeners();
  }

  void setMonth(String value) {
    _selectedMonth = value;
  }
}
