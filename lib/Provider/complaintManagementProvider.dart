import 'package:flutter/foundation.dart';

class ComplaintManagementProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  String _selectedComplaint = '';
  String get selectedComplaint => _selectedComplaint;

  Future<dynamic> Function()? _fetchComplaintData;
  Future<dynamic> Function()? get fetchComplaintData => _fetchComplaintData;

  Future getComplaintData() async {
    await fetchComplaintData!();
    print("Get Complaint Data Running");
  }

  void setSelectedComplaint(String value) {
    _selectedComplaint = value;
  }

  void setFetchComplaintFuntion(Future<dynamic> Function()? value) {
    _fetchComplaintData = value;
  }

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
