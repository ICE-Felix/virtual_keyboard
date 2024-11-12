import 'package:flutter/material.dart';

class VirtualKeyboardStyle {
  final Color? _backgroundColor;
  final TextStyle? _keysTextStyle;
  final Color? _keyColor;
  final Color? _keyPressedColor;
  final Color? _keyHoverColor;
  final BoxDecoration? _keyDecorations;
  final BoxDecoration? _keyboardDecorations;
  late BuildContext _context;

  VirtualKeyboardStyle({
    Color? backgroundColor,
    TextStyle? keysTextStyle,
    Color? keyColor,
    Color? keyPressedColor,
    Color? keyHoverColor,
    BoxDecoration? keyDecorations,
    BoxDecoration? keyboardDecorations,
  })  : _backgroundColor = backgroundColor,
        _keysTextStyle = keysTextStyle,
        _keyColor = keyColor,
        _keyPressedColor = keyPressedColor,
        _keyHoverColor = keyHoverColor,
        _keyDecorations = keyDecorations,
        _keyboardDecorations = keyboardDecorations;

  void setBuildContext(BuildContext context) {
    _context = context;
  }

  ThemeData get _theme => Theme.of(_context);

  Color get backgroundColor => _backgroundColor ?? _theme.dialogBackgroundColor;

  TextStyle get keysTextStyle =>
      _keysTextStyle ?? _theme.textTheme.bodyMedium ?? const TextStyle();

  Color get keyColor => _keyColor ?? _theme.colorScheme.primaryFixed;

  Color get keyPressedColor =>
      _keyPressedColor ?? _theme.colorScheme.primaryFixedDim;

  Color get keyHoverColor => _keyHoverColor ?? _theme.hoverColor;

  BoxDecoration? get keyDecorations => _keyDecorations;

  BoxDecoration? get keyboardDecorations => _keyboardDecorations;
}
