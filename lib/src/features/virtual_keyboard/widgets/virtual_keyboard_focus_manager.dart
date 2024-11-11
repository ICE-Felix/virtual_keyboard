import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/keyboard_config_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/utils/virtual_keyboard_focus_node.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/view/keyboard_view_insets.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/virtual_keyboard.dart';

class VirtualKeyboardFocusManager extends StatefulWidget {
  const VirtualKeyboardFocusManager({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<VirtualKeyboardFocusManager> createState() =>
      _VirtualKeyboardFocusManagerState();
}

class _VirtualKeyboardFocusManagerState
    extends State<VirtualKeyboardFocusManager> {
  KeyboardConfigController? _keyboardController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChanged);
    _closeKeyboard();
    _keyboardController?.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) {
      if (FocusManager.instance.primaryFocus is VirtualKeyboardFocusNode) {

        VirtualKeyboardFocusNode virtualKeyboardFocusedNode =
            FocusManager.instance.primaryFocus! as VirtualKeyboardFocusNode;
        if (_keyboardController == null) {
          _keyboardController = KeyboardConfigController(
            textEditingController:
                virtualKeyboardFocusedNode.textEditingController,
            scrollController: virtualKeyboardFocusedNode.scrollController,
          );
          _openKeyboard(context);
        } else {
          _keyboardController!.changeConfiguration(
            textEditingController:
                virtualKeyboardFocusedNode.textEditingController,
            scrollController: virtualKeyboardFocusedNode.scrollController,
          );
        }
      } else {
        _keyboardController?.dispose();
        _keyboardController = null;
        _closeKeyboard();
      }
    }
  }

  void _openKeyboard(BuildContext parentContext) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Localizations.override(
          // Make sure to inject the same locale the math field uses in order
          // to match the decimal separators.
          context: context,
          locale: Localizations.localeOf(context),
          child: VirtualKeyboard(
            configurationController: _keyboardController!,
            insetsState: KeyboardViewInsetsState.of(parentContext),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeKeyboard() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
