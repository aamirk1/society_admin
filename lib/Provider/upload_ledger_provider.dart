import 'package:flutter/foundation.dart';

class UploadLedgerProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  String _selectedMonth = '';
  String get selectedMonth => _selectedMonth;

  final List<dynamic> _columnName = [];
  List get columnName => _columnName;

  void reload(bool value) {
    _loadWidget = value;
    notifyListeners();
  }

  void setMonth(String value) {
    _selectedMonth = value;
  }

 
}
