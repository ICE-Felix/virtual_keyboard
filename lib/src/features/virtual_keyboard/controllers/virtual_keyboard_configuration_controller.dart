import 'package:flutter/material.dart';

class VirtualKeyboardConfigurationController extends ChangeNotifier {
  TextEditingController textEditingController;
  ScrollController scrollController;

  VirtualKeyboardConfigurationController({
    required this.textEditingController,
    required this.scrollController,
  });

  void changeConfiguration({
    required TextEditingController textEditingController,
    required ScrollController scrollController,
  }) {
    this.textEditingController = textEditingController;
    this.scrollController = scrollController;
    notifyListeners();
  }
}
  