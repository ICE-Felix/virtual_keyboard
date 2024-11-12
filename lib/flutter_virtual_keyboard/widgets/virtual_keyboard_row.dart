import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/virtual_keyboard.dart';

class VirtualKeyboardRowWidget extends StatelessWidget {
  final List<VirtualKeyboardKey> keys;
  final VirtualKeyboardController virtualKeyboardController;
  final int maxKeys;
  final VirtualKeyboardStyle style;
  final EdgeInsets padding;

  VirtualKeyboardRowWidget({
    super.key,
    required this.keys,
    required this.virtualKeyboardController,
    required this.style,
    required this.padding,
    this.maxKeys = 11,
  })  : assert(maxKeys > 0, 'Max keys needs to be bigger then 0'),
        assert(keys.isNotEmpty, 'Provide keys to display'),
        assert(
            keys.length <= maxKeys, 'Too many keys were provided for this row');

  int get _paddingFlex => ((maxKeys - keys.length) ~/ 2) * 2;

  bool get _hasExtraPadding => (maxKeys - keys.length).isOdd;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: _paddingFlex, child: Container()),
      if (_hasExtraPadding) Expanded(flex: 1, child: Container()),
      ...List<Widget>.generate(keys.length, (i) {
        return Expanded(
          flex: 2,
          child: Padding(
            padding: padding,
            child: KeyboardKeyWidget(
              style: style,
              virtualKeyboardController: virtualKeyboardController,
              keyboardKey: keys[i],
              onTap: () => virtualKeyboardController.handleKeyTap(
                keys[i],
              ),
              // onDoubleTap: () =>
              //     VirtualKeyboardActionHandler.handleKeyDoubleTap(
              //   virtualKeyboardController,
              //   keys[i],
              // ),
            ),
          ),
        );
      }),
      if (_hasExtraPadding) Expanded(flex: 1, child: Container()),
      Expanded(flex: _paddingFlex, child: Container()),
    ]);
  }
}
