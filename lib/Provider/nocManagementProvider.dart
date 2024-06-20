import 'package:flutter/foundation.dart';

class NocManagementProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

   String _selectedNoc = '';
  String get selectedNoc => _selectedNoc;

  Future<dynamic> Function()? _fetchNocData;
  Future<dynamic> Function()? get fetchNocData => _fetchNocData;


 Future getNocData() async {
    await fetchNocData!();
    // print("Get NOC Data Running");
  }

  void setSelectedNoc(String value) {
    _selectedNoc = value;
  }

  void setFetchNocFuntion(Future<dynamic> Function()? value) {
    _fetchNocData = value;
  }

  
  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}