import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/models/virtual_keyboard_key.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/style/virtual_keyboard_style.dart';

class KeyboardKeyWidget extends StatefulWidget {
  const KeyboardKeyWidget({
    super.key,
    required this.keyboardKey,
    required this.virtualKeyboardController,
    required this.onTap,
    this.onDoubleTap,
    required this.style,
  });

  final VirtualKeyboardKey keyboardKey;
  final VirtualKeyboardStyle style;
  final VirtualKeyboardController virtualKeyboardController;
  final void Function() onTap;
  final void Function()? onDoubleTap;

  @override
  State<KeyboardKeyWidget> createState() => _KeyboardKeyWidgetState();
}

class _KeyboardKeyWidgetState extends State<KeyboardKeyWidget> {
  bool isHover = false;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: AnimatedContainer(
          height: double.maxFinite,
          decoration: widget.style.keyDecorations?.copyWith(
            color: isPressed
                ? widget.style.keyPressedColor
                : isHover
                    ? widget.style.keyHoverColor
                    : widget.style.keyColor,
          ),
          duration: const Duration(milliseconds: 100),
          child: Center(
            child: Text(
                widget.virtualKeyboardController
                    .getFormattedDisplayValue(widget.keyboardKey.displayValue),
                style: widget.style.keysTextStyle),
          ),
        ),
      ),
    );
  }
}
