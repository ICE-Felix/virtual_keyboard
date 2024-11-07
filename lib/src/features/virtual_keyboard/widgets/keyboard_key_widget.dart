import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/models/virtual_keyboard_key.dart';

class KeyboardKeyWidget extends StatefulWidget {
  const KeyboardKeyWidget({
    super.key,
    required this.keyboardKey,
    required this.virtualKeyboardController,
    required this.onTap,
    this.onDoubleTap,
  });

  final VirtualKeyboardKey keyboardKey;
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
    widget.virtualKeyboardController.addListener(
      () {
        // Maybe not the best mode to notify?
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: isPressed
                ? Colors.grey[500]
                : isHover
                    ? Colors.grey[400]
                    : Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          duration: const Duration(milliseconds: 100),
          child: Center(
            child: Text(
              widget.virtualKeyboardController
                  .getFormattedDisplayValue(widget.keyboardKey.displayValue),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
