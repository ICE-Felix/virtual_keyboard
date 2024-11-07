import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/models/virtual_keyboard_key.dart';

class VirtualKeyboardActionHandler {
  static void handleKeyTap(
    VirtualKeyboardController controller,
    VirtualKeyboardKey key,
  ) {
    switch (key) {
      case VirtualKeyboardKey.backspace:
        _handleBackspace(controller);
        break;
      case VirtualKeyboardKey.shift:
        controller.toggleShift();
        break;
      case VirtualKeyboardKey.caps:
        controller.toggleCaps();
        break;
      case VirtualKeyboardKey.enter:
        _handleEnter(controller);
        break;
      default:
        _insertText(controller, controller.getFormattedKeyValue(key.value));
        controller.resetShift();
    }
  }

  static void _handleBackspace(VirtualKeyboardController controller) {
    final text = controller.textEditingController.text;
    final selection = controller.textEditingController.selection;
    String newText = text;
    int cursorPosition = selection.start;

    if (selection.baseOffset != selection.extentOffset && selection.isValid) {
      newText = text.replaceRange(selection.start, selection.end, '');
      cursorPosition = selection.start;
    } else if (selection.start > 0) {
      newText = text.substring(0, selection.start - 1) +
          text.substring(selection.start);
      cursorPosition = selection.start - 1;
    }

    _updateTextController(controller, newText, cursorPosition);
  }

  static void _handleEnter(VirtualKeyboardController controller) {
    // Enter key action here
  }

  static void _insertText(VirtualKeyboardController controller, String value) {
    final text = controller.textEditingController.text;
    final selection = controller.textEditingController.selection;
    final newText = text.replaceRange(selection.start, selection.end, value);
    final cursorPosition = selection.start + value.length;

    _updateTextController(controller, newText, cursorPosition);
  }

  static void _updateTextController(
    VirtualKeyboardController controller,
    String text,
    int cursorPosition,
  ) {
    controller.textEditingController.value = TextEditingValue(
      text: text,
      selection:
          TextSelection.collapsed(offset: cursorPosition.clamp(0, text.length)),
    );

    if (controller.scrollController != null) {
      Future.delayed(
        const Duration(
          milliseconds: 5,
        ),
        () {
          controller.scrollController!
              .jumpTo(controller.scrollController!.position.maxScrollExtent);
        },
      );
    }
  }
}
