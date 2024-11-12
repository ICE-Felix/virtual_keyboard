import 'package:flutter/material.dart';

class VirtualKeyboardFocusNode extends FocusNode {
  VirtualKeyboardFocusNode({
    super.debugLabel,
    super.onKeyEvent,
    super.skipTraversal,
    super.canRequestFocus,
    super.descendantsAreFocusable,
    super.descendantsAreTraversable,
    required this.textEditingController,
    required this.scrollController,
    String? key,
  }) : key = key != null
            ? 'virtual_keyboard_$key'
            : 'virtual_keyboard_${UniqueKey().toString()}';

  final String key;
  final TextEditingController textEditingController;
  final ScrollController scrollController;
}
