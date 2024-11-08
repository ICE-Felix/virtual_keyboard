import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/utils/virtual_keyboard_focus_node.dart';

class VirtualKeyboardFocusable extends StatefulWidget {
  const VirtualKeyboardFocusable({
    super.key,
    // required this.child,
    required this.textEditingController,
    required this.scrollController,
    required this.builder,
  });

  // final Widget child;
  final TextEditingController textEditingController;
  final ScrollController scrollController;
  final Widget Function(VirtualKeyboardFocusNode focusNode) builder;

  @override
  State<VirtualKeyboardFocusable> createState() =>
      _VirtualKeyboardFocusableState();
}

class _VirtualKeyboardFocusableState extends State<VirtualKeyboardFocusable> {
  late final VirtualKeyboardFocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = VirtualKeyboardFocusNode(
      textEditingController: widget.textEditingController,
      scrollController: widget.scrollController,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(_focusNode);
    // return Focus(
    //   focusNode: _focusNode,
    //   child: widget.child,
    // );
  }
}