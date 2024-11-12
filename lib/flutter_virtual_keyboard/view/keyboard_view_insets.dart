import 'dart:math';

import 'package:flutter/material.dart';

class KeyboardViewInsets extends StatefulWidget {
  const KeyboardViewInsets({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  KeyboardViewInsetsState createState() => KeyboardViewInsetsState();
}

class KeyboardViewInsetsState extends State<KeyboardViewInsets> {
  static KeyboardViewInsetsState? of(BuildContext context) {
    return context.findAncestorStateOfType<KeyboardViewInsetsState>();
  }

  final Map<ObjectKey, double> _keyboardSizes = {};

  void operator []=(ObjectKey key, double? size) {
    if (!mounted) return;
    if (_keyboardSizes[key] == size) return;

    setState(() {
      if (size == null) {
        _keyboardSizes.remove(key);
      } else {
        _keyboardSizes[key] = size;
      }
    });
  }

  double get _bottomInset {
    return _keyboardSizes.values.fold(0, (previousValue, element) {
      // We only care about the max inset.
      return max(previousValue, element);
    });
  }

  // MediaQueryData get _mediaQueryData => MediaQuery.of(context);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return KeyboardViewInsetsQuery(
      bottomInset: _bottomInset,
      child: MediaQuery(
        data: mediaQueryData.copyWith(
          viewInsets: mediaQueryData.viewInsets.copyWith(
            bottom: max(
              _bottomInset,
              // We want to make sure we respect the default MediaQuery bottom
              // inset.
              // Note that we will experience weird behavior when inserting this
              // below a Scaffold (which will have absorbed the MediaQuery
              // bottom inset but not ours). This is why we recommend inserting
              // it above a Scaffold.
              mediaQueryData.viewInsets.bottom,
            ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class KeyboardViewInsetsQuery extends InheritedWidget {
  const KeyboardViewInsetsQuery({
    super.key,
    required this.bottomInset,
    required super.child,
  });

  /// Depends on and returns an ancestor [KeyboardViewInsetsQuery].
  static KeyboardViewInsetsQuery of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<KeyboardViewInsetsQuery>();
    if (result != null) {
      return result;
    }
    throw FlutterError(
        'MathKeyboardViewInsetsQuery.of() called with a context that does not '
        'contain a MathKeyboardViewInsetsQuery.');
  }

  static bool virtualKeyboardShowingIn(BuildContext context) {
    return of(context).bottomInset > 0;
  }

  static bool keyboardShowingIn(BuildContext context) {
    final maxInset = max(
      of(context).bottomInset,
      View.of(context).viewInsets.bottom /
          // Note that we obviously do not care about the pixel ratio for our
          // > 0 comparison, however, I do want to prevent any future mistake,
          // where someone forgets the pixel ratio on the window.
          View.of(context).devicePixelRatio,
    );

    return maxInset > 0;
  }

  final double bottomInset;

  @override
  bool updateShouldNotify(KeyboardViewInsetsQuery oldWidget) {
    return bottomInset != oldWidget.bottomInset;
  }
}
