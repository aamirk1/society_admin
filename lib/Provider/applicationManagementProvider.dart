// ignore: file_names
import 'package:flutter/foundation.dart';

class ApplicationManagementProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get loadWidget => _loadWidget;

  bool _selectedApplication = false;
  bool get selectedApplication => _selectedApplication;

  String _selectedFlatNo = '';
  String get selectedFlatNo => _selectedFlatNo;
  
  String _selectedApplicationType = '';
  String get selectedApplicationType => _selectedApplicationType;

bool? _isApproved;
  bool? get isApproved => _isApproved;

  void setSelectedApplication(bool value) {
    _selectedApplication = value;
    notifyListeners();
  }
  void setIsApproved(bool value) {
    _isApproved = value;
  }

  // Data store start
  void setSelectedFlatNo(String value) {
    _selectedFlatNo = value;
  }

  void setSelectedApplicationType(String value) {
    _selectedApplicationType = value;
  }

 // Data store end
 

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
