import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/virtual_keyboard.dart';

extension VirtualKeyboardActionHandler on VirtualKeyboardController {
  void handleKeyTap(
    VirtualKeyboardKey key,
  ) {
    switch (key) {
      case VirtualKeyboardKey.backspace:
        _handleBackspace();
        break;
      case VirtualKeyboardKey.numericKey:
        changeKeyboard();
        break;
      case VirtualKeyboardKey.shift:
        toggleShift();
        break;
      case VirtualKeyboardKey.caps:
        toggleCaps();
        break;
      case VirtualKeyboardKey.enter:
        _handleEnter();
        break;
      default:
        _insertText(getFormattedKeyValue(key.value));
        resetShift();
    }
  }

  void _handleBackspace() {
    final text = textEditingController.text;
    final selection = textEditingController.selection;
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

    _updateTextController(newText, cursorPosition);
  }

  void _handleEnter() {
    // Enter key action here
  }

  void _insertText(String value) {
    final text = textEditingController.text;
    final selection = textEditingController.selection;
    final newText = text.replaceRange(selection.start, selection.end, value);
    final cursorPosition = selection.start + value.length;

    _updateTextController(newText, cursorPosition);
  }

  void _updateTextController(
    String text,
    int cursorPosition,
  ) {
    textEditingController.value = TextEditingValue(
      text: text,
      selection:
          TextSelection.collapsed(offset: cursorPosition.clamp(0, text.length)),
    );

    if (scrollController != null) {
      Future.delayed(
        const Duration(
          milliseconds: 5,
        ),
        () {
          scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
        },
      );
    }
  }
}
