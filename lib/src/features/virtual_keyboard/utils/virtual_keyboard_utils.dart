import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/models/virtual_keyboard_key.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/utils/virtual_keyboard_action_handler.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/keyboard_key_widget.dart';

class VirtualKeyboardUtils {
  static List<Widget> getKeyboardRowElements({
    required List<VirtualKeyboardKey> keys,
    required VirtualKeyboardController virtualKeyboardController,
    int maxKeys = 10,
  }) {
    if (keys.length > maxKeys) {
      debugPrint('Too many keys were provided for this row');
      return [];
    }

    final paddingFlex = ((maxKeys - keys.length) ~/ 2) * 2;
    final hasExtraPadding = (maxKeys - keys.length).isOdd;

    return [
      // Left padding
      Expanded(flex: paddingFlex, child: Container()),
      if (hasExtraPadding) Expanded(flex: 1, child: Container()),

      // Keys with conditional padding
      ...List<Widget>.generate(keys.length, (i) {
        final isLastKey = i == keys.length - 1;
        return Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(right: isLastKey ? 0 : 10),
            child: KeyboardKeyWidget(
              virtualKeyboardController: virtualKeyboardController,
              keyboardKey: keys[i],
              onTap: () => VirtualKeyboardActionHandler.handleKeyTap(
                virtualKeyboardController,
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

      // Right padding
      if (hasExtraPadding) Expanded(flex: 1, child: Container()),
      Expanded(flex: paddingFlex, child: Container()),
    ];
  }
}
