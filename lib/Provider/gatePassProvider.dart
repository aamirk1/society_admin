import 'package:flutter/foundation.dart';

class GatePassProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  String _selectedPass = '';
  String get selectedPass => _selectedPass;

  bool? _isApproved;
  bool? get isApproved => _isApproved;

  Future<dynamic> Function()? _fetchDateOfGatePass;
  Future<dynamic> Function()? get fetchDateOfGatePass => _fetchDateOfGatePass;

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }

  void setFetchDateOfGatePass(Future<dynamic> Function()? value) {
    _fetchDateOfGatePass = value;
  }

  Future getFetchDateOfGatePass() async {
    await _fetchDateOfGatePass!();
  }

  void setIsApproved(bool? value) {
    _isApproved = value;
  }

  void setSelectedPass(String value) {
    _selectedPass = value;
    notifyListeners();
  }

}
