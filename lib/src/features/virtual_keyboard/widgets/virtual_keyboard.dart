import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/style/virtual_keyboard_style.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/view/keyboard_view_insets.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/keyboard_body.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/virtual_keyboard_row.dart';

class VirtualKeyboard extends StatefulWidget {
  const VirtualKeyboard({
    super.key,
    required this.textEditingController,
    required this.scrollController,
    required this.insetsState,
    this.decorations,
    this.maxKeys = 10,
    this.maxHeight,
    this.keyPadding = const EdgeInsets.all(8),
    this.keyboardPadding = const EdgeInsets.symmetric(horizontal: 8),
  }) : assert(insetsState != null,
            'The KeyboardViewInsetsState does not exist. Most probably you forgot to initiate KeyboardViewInsets, or the context is from the upper widget tree and does not contain the KeyboardViewInsets widget.');

  /// The text controller to get the input text also used for the initial text
  final TextEditingController textEditingController;
  final ScrollController scrollController;
  final KeyboardViewInsetsState? insetsState;
  final VirtualKeyboardStyle? decorations;
  final int maxKeys;
  final double? maxHeight;
  final EdgeInsets keyPadding;
  final EdgeInsets keyboardPadding;

  @override
  State<VirtualKeyboard> createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  late VirtualKeyboardController virtualKeyboardController;
  late VirtualKeyboardStyle decorations;

  @override
  void initState() {
    super.initState();
    virtualKeyboardController = VirtualKeyboardController(
      textEditingController: widget.textEditingController,
      scrollController: widget.scrollController,
    );
    decorations = (widget.decorations ?? VirtualKeyboardStyle())
      ..setBuildContext(context);
  }

  @override
  void didUpdateWidget(covariant VirtualKeyboard oldWidget) {
    if (oldWidget.textEditingController != widget.textEditingController ||
        oldWidget.scrollController != widget.scrollController) {
      virtualKeyboardController = VirtualKeyboardController(
        textEditingController: widget.textEditingController,
        scrollController: widget.scrollController,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final curvedSlideAnimation = CurvedAnimation(
      parent: AlwaysStoppedAnimation(1),
      curve: Curves.ease,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
      ).animate(curvedSlideAnimation),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              type: MaterialType.transparency,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: widget.maxHeight ??
                      MediaQuery.of(context).size.height * 0.3,
                  child: KeyboardBody(
                    insetsState: widget.insetsState,
                    slideAnimation: curvedSlideAnimation,
                    child: Padding(
                      padding: widget.keyboardPadding,
                      child: Container(
                        decoration: decorations.keyboardDecorations,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          child: ListenableBuilder(
                            listenable: virtualKeyboardController,
                            builder: (context, child) {
                              return Column(
                                children: virtualKeyboardController.keys.map(
                                  (keys) {
                                    return Expanded(
                                      child: VirtualKeyboardRowWidget(
                                        style: decorations,
                                        keys: keys,
                                        padding: widget.keyPadding,
                                        virtualKeyboardController:
                                            virtualKeyboardController,
                                        maxKeys: widget.maxKeys,
                                      ),
                                    );
                                  },
                                ).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
