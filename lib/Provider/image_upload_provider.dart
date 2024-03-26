import 'package:flutter/foundation.dart';

class ImageUploadProvider extends ChangeNotifier {
  bool _isImageUploaded = false;
  bool get isImageUploaded => _isImageUploaded;

  void reloadImage(bool value) {
    _isImageUploaded = value;
    notifyListeners();
  }
}
