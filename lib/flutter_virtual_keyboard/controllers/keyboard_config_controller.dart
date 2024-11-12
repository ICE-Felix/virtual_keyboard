import 'package:flutter/material.dart';

class KeyboardConfigController extends ChangeNotifier {
  TextEditingController textEditingController;
  ScrollController scrollController;

  KeyboardConfigController({
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
