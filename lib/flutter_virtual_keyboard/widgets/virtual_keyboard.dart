import 'package:flutter/material.dart';
import 'package:flutter_virtual_keyboard/virtual_keyboard.dart';

/// A stateful widget that represents a virtual keyboard.
///
/// The [VirtualKeyboard] widget provides a customizable virtual keyboard interface
/// that can be used in Flutter applications. It allows users to input text using
/// an on-screen keyboard, which can be useful for devices without a physical
/// keyboard or in scenarios where a virtual keyboard is more appropriate.
///
/// The widget is configured using the [KeyboardConfigController] and
/// [KeyboardViewInsetsState] parameters, which control the behavior and appearance
/// of the keyboard. The [decorations] parameter can be used to customize the
/// appearance of the keyboard keys.
///
/// The [maxKeys] parameter sets the maximum number of keys that can be displayed
/// on the keyboard, while the [maxHeight] parameter sets the maximum height of
/// the keyboard. The [keyPadding] and [keyboardPadding] parameters control the
/// padding around the keys and the keyboard, respectively.
class VirtualKeyboard extends StatefulWidget {
  const VirtualKeyboard({
    super.key,
    required this.configurationController,
    required this.insetsState,
    this.decorations,
    this.maxKeys = 10,
    this.maxHeight,
    this.keyPadding = const EdgeInsets.all(8),
    this.keyboardPadding = const EdgeInsets.symmetric(horizontal: 8),
  }) : assert(insetsState != null,
            'The KeyboardViewInsetsState does not exist. Most probably you forgot to initiate KeyboardViewInsets, or the context is from the upper widget tree and does not contain the KeyboardViewInsets widget.');

  final KeyboardConfigController configurationController;
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
      textEditingController:
          widget.configurationController.textEditingController,
      scrollController: widget.configurationController.scrollController,
    );

    decorations = (widget.decorations ?? VirtualKeyboardStyle())
      ..setBuildContext(context);
    widget.configurationController.addListener(_onConfigurationChanged);
  }

  void _onConfigurationChanged() {
    if (mounted) {
      setState(() {
        virtualKeyboardController = VirtualKeyboardController(
          textEditingController:
              widget.configurationController.textEditingController,
          scrollController: widget.configurationController.scrollController,
        );
      });
    }
  }

  @override
  void didUpdateWidget(covariant VirtualKeyboard oldWidget) {
    if (oldWidget.configurationController.textEditingController !=
            widget.configurationController.textEditingController ||
        oldWidget.configurationController != widget.configurationController) {
      // oldWidget.configurationController.removeListener(_onConfigurationChanged);
      virtualKeyboardController.dispose();
      if (mounted) {
        virtualKeyboardController = VirtualKeyboardController(
          textEditingController:
              widget.configurationController.textEditingController,
          scrollController: widget.configurationController.scrollController,
        );
      }
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
              child: TextFieldTapRegion(
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
          ),
        ],
      ),
    );
  }
}
