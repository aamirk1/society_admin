import 'package:flutter/foundation.dart';

class ListBuilderProvider extends ChangeNotifier {
  List<dynamic> _list = [];
  List<dynamic> get list => _list;

  void addList(List<dynamic> list) {
    _list = list;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _list = value;
  }

  void addSingleList(Map<String, dynamic> value) {
    _list.add(value);
    notifyListeners();
  }
}
