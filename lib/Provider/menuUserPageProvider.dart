
// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
import 'package:flutter/foundation.dart';

class MenuUserPageProvider with ChangeNotifier {
  bool _loadWidget = false;
  bool get cityName => _loadWidget;

  void setLoadWidget(bool value) {
    _loadWidget = value;
    notifyListeners();
  }
}
