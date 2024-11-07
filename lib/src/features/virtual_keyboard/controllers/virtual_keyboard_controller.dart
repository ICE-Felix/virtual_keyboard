import 'package:flutter/material.dart';

class VirtualKeyboardController extends ChangeNotifier {
  bool _isShiftPressed = false;
  bool _isCapsOn = false;
  final TextEditingController textEditingController;
  final ScrollController? scrollController;

  VirtualKeyboardController({
    required this.textEditingController,
    this.scrollController,
  });

  bool get isShiftPressed => _isShiftPressed;
  bool get isCapsOn => _isCapsOn;

  void toggleShift() {
    _isShiftPressed = !_isShiftPressed;
    _isCapsOn = false;
    notifyListeners();
  }

  void toggleCaps() {
    _isShiftPressed = false;
    _isCapsOn = !_isCapsOn;
    notifyListeners();
  }

  void resetShift() {
    if (_isShiftPressed) {
      _isShiftPressed = false;
      notifyListeners();
    }
  }

  String getFormattedKeyValue(String value) {
    if (_isShiftPressed || _isCapsOn) {
      return value.toUpperCase();
    }
    return value.toLowerCase();
  }

  String getFormattedDisplayValue(String displayValue) {
    if (_isShiftPressed || _isCapsOn) {
      return displayValue.toUpperCase();
    }
    return displayValue;
  }
}
