import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/virtual_keyboard.dart';

class VirtualKeyboardController extends ChangeNotifier {
  bool _isShiftPressed = false;
  bool _isCapsOn = false;
  VirtualKeyboardType _keyboardType = VirtualKeyboardType.text;

  List<List<VirtualKeyboardKey>> get keys => switch (_keyboardType) {
        VirtualKeyboardType.text => VirtualKeyboardKey.textKeyboardKeys,
        VirtualKeyboardType.numeric => VirtualKeyboardKey.numericKeyboardKeys,
      };

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

  void changeKeyboard() {
    switch (_keyboardType) {
      case VirtualKeyboardType.text:
        _keyboardType = VirtualKeyboardType.numeric;
        break;
      case VirtualKeyboardType.numeric:
        _keyboardType = VirtualKeyboardType.text;
    }

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
