import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/models/virtual_keyboard_key.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/utils/virtual_keyboard_action_handler.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/keyboard_key_widget.dart';

class VirtualKeyboardRowWidget extends StatelessWidget {
  List<VirtualKeyboardKey> keys;
  VirtualKeyboardController virtualKeyboardController;
  int maxKeys = 10;

  VirtualKeyboardRowWidget({
    super.key,
    required this.keys,
    required this.virtualKeyboardController,
    this.maxKeys = 10,
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
        final isLastKey = i == keys.length - 1;
        return Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(right: isLastKey ? 0 : 10),
            child: KeyboardKeyWidget(
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
