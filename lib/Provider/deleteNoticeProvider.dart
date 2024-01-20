// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class DeleteNoticeProvider extends ChangeNotifier {
  List<dynamic> _noticeList = [];
  List<dynamic> get noticeList => _noticeList;

  List<dynamic> _noticePdfList = [];
  List<dynamic> get noticePdfList => _noticePdfList;

  void addSingleList(Map<String, dynamic> value) {
    _noticeList.add(value);
    notifyListeners();
  }

  void addSinglePdfList(Map<String, dynamic> value) {
    _noticePdfList.add(value);
    notifyListeners();
  }

  void setBuilderNoticeList(List<dynamic> value) {
    _noticeList = value;
    notifyListeners();
  }

  void setBuilderNoticePdfList(List<dynamic> value) {
    _noticePdfList = value;
    notifyListeners();
  }

  void removeData(int value) {
    _noticeList.removeAt(value);
    notifyListeners();
  }

  void removePdfData(int value) {
    _noticeList.removeAt(value);
    notifyListeners();
  }
}
