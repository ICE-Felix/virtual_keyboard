import 'package:flutter/material.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_configuration_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/controllers/virtual_keyboard_controller.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/models/virtual_keyboard_key.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/utils/virtual_keyboard_utils.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/view/keyboard_view_insets.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/keyboard_body.dart';

class VirtualKeyboard extends StatefulWidget {
  const VirtualKeyboard({
    super.key,
    // required this.textEditingController,
    // required this.scrollController,
    required this.configurationController,
    this.insetsState,
  });

  /// The text controller to get the input text also used for the initial text
  final VirtualKeyboardConfigurationController configurationController;
  // final TextEditingController textEditingController;
  // final ScrollController scrollController;
  final KeyboardViewInsetsState? insetsState;

  @override
  State<VirtualKeyboard> createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  late VirtualKeyboardController virtualKeyboardController;
  @override
  void initState() {
    super.initState();
    virtualKeyboardController = VirtualKeyboardController(
      textEditingController:
          widget.configurationController.textEditingController,
      scrollController: widget.configurationController.scrollController,
    );
    widget.configurationController.addListener(_onConfigurationChanged);
  }

  void _onConfigurationChanged() {
    virtualKeyboardController = VirtualKeyboardController(
      textEditingController:
          widget.configurationController.textEditingController,
      scrollController: widget.configurationController.scrollController,
    );
  }

  @override
  void didUpdateWidget(covariant VirtualKeyboard oldWidget) {
    if (oldWidget.configurationController != widget.configurationController) {
      // oldWidget.configurationController.removeListener(_onConfigurationChanged);
      virtualKeyboardController = VirtualKeyboardController(
        textEditingController:
            widget.configurationController.textEditingController,
        scrollController: widget.configurationController.scrollController,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.insetsState);
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
                child: TextFieldTapRegion(
                  child: SizedBox(
                    height: 300,
                    child: KeyboardBody(
                      insetsState: widget.insetsState,
                      slideAnimation: curvedSlideAnimation,
                      child: Container(
                        color: Colors.grey[700],
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          child: Column(
                            children: VirtualKeyboardKey.textKeyboardKeys.map(
                              (keys) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: VirtualKeyboardUtils
                                          .getKeyboardRowElements(
                                        keys: keys,
                                        virtualKeyboardController:
                                            virtualKeyboardController,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
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
