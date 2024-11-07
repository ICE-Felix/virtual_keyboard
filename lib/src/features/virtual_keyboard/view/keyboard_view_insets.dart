import 'dart:math';

import 'package:flutter/material.dart';

/// Widget for math keyboards ensuring the content is pushed up by the
/// keyboards, connected with [MathField]s.
///
/// It ensures that the **view insets** for the keyboards are properly
/// maintained in the [MediaQuery] in scope.
///
/// Using this scaffold has two requirements:
///
/// * A [WidgetsApp] or [MaterialApp] **above** this widget that inserts a
///   [MediaQuery]. You can alternatively of course manually maintain the
///   [MediaQuery] above this widget, but it is not recommended.
/// * A [Scaffold], [SafeArea], [CupertinoTabScaffold], or
///   [CupertinoPageScaffold] **below** this widget that respond to the *view
///   insets* in the [MediaQueryData]. You can alternatively respond to the
///   view insets yourself using `MediaQuery.of(context).viewInsets`.
///
/// In this context, "above" means as a parent of this widget and "below" means
/// as a child of this widget.
///
/// ### Example
///
/// ```dart
/// void main() {
///   runApp(MaterialApp(
///     // ...
///   ));
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return MathKeyboardViewInsets(
///     child: Scaffold(
///       // ...
///     ),
///   );
/// }
/// ```
///
/// ### Notes
///
/// This widget inserts a [KeyboardViewInsetsQuery] - this is the only
/// functions at the moment.
class KeyboardViewInsets extends StatefulWidget {
  /// Creates a [KeyboardViewInsets] widget around the [child] widget.
  const KeyboardViewInsets({
    super.key,
    required this.child,
  });

  /// The child widget tree that the math keyboard view insets should report to.
  ///
  /// Usually a `Scaffold`. Do note, however, that the `Scaffold`, `SafeArea`,
  /// etc. can be as deep in the tree below the [KeyboardViewInsets] as you
  /// like.
  final Widget child;

  @override
  KeyboardViewInsetsState createState() => KeyboardViewInsetsState();
}

/// State of the [KeyboardViewInsets].
///
/// This takes care of managing the view insets for all child [MathField]
/// keyboards. It provides them by inserting a modified [MediaQuery].
class KeyboardViewInsetsState extends State<KeyboardViewInsets> {
  /// Returns the ancestor [KeyboardViewInsetsState] of the given [context].
  static KeyboardViewInsetsState? of(BuildContext context) {
    return context.findAncestorStateOfType<KeyboardViewInsetsState>();
  }

  final Map<ObjectKey, double> _keyboardSizes = {};

  /// Reports the [size] of the math keyboard (state) with the given [key].
  ///
  /// Pass `null` for [size] to report that a keyboard has been removed from
  /// the scaffold. This is important for preventing memory leaks.
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

  /// The appropriate bottom inset based on the [_keyboardSizes].
  ///
  /// This will simply take the max value from the [_keyboardSizes] and default
  /// to `0` (when there are no active keyboards).
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
    final mathKeyboardBottomInset = _bottomInset;
    return KeyboardViewInsetsQuery(
      bottomInset: mathKeyboardBottomInset,
      child: MediaQuery(
        data: mediaQueryData.copyWith(
          viewInsets: mediaQueryData.viewInsets.copyWith(
            bottom: max(
              mathKeyboardBottomInset,
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

/// Inherited widget, which is purely responsible for notifying about the passed
/// [bottomInset].
///
/// This allows checking whether a math keyboard (or any keyboard really, for
/// convenience) is currently showing. See [].
class KeyboardViewInsetsQuery extends InheritedWidget {
  /// Creates a [KeyboardViewInsetsQuery] that provides the [bottomInset] to
  /// the [child] tree.
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

  /// Returns whether any math keyboard is showing in the given [context] by
  /// depending on a [KeyboardViewInsetsQuery].
  ///
  /// See [keyboardShowingIn] for a convenience method that also reports about
  /// the regular software keyboard on iOS and Android.
  static bool virtualKeyboardShowingIn(BuildContext context) {
    return of(context).bottomInset > 0;
  }

  /// Returns whether any software keyboard is showing in the given [context]
  /// by depending on a [KeyboardViewInsetsQuery] and consulting the
  /// [WidgetsBinding] window.
  ///
  /// This is useful to you when you want to take an action whenever *any*
  /// keyboard is currently opened up. The math keyboard package and sadly
  /// not change the view insets on the [WidgetsBinding] instance's [Window],
  /// which means that you need to use this helper for checking if a math
  /// keyboard is currently opened up.
  ///
  /// Note that we cannot consult the [MediaQuery] for regular software
  /// keyboards as widgets like [Scaffold] consume the bottom inset. We can,
  /// however, safely depend on [KeyboardViewInsetsQuery] as we know that
  /// the bottom inset will not be consumed going down the tree.
  ///
  /// See [virtualKeyboardShowingIn] for a method that reports only whether a
  /// math keyboard is showing, ignoring other software keyboards.
  ///
  /// ### Example
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final isAnyKeyboardShowing =
  ///       MathKeyboardViewInsetsQuery.keyboardShowingIn(context);
  /// }
  /// ```
  ///
  /// `isAnyKeyboardShowing` will now tell you whether there *any* software
  /// keyboard is showing, i.e. the default software keyboard on Android and
  /// iOS *or* a math keyboard.
  ///
  /// Of course, you need to make sure that there is a [KeyboardViewInsets]
  /// widget as a parent of the `content`.
  ///
  /// By default, this will only notify you about changes to the
  /// [KeyboardViewInsetsQuery] and not about changes to the other software
  /// keyboards. If you want to be notified about changes to the other software
  /// keyboards also , you will have to register a [WidgetsBindingObserver] and
  /// set state on [WidgetsBindingObserver.didChangeMetrics].
  /// See [the official `WidgetsBindingObserver` example](https://api.flutter.dev/flutter/widgets/WidgetsBindingObserver-class.html#widgets.WidgetsBindingObserver.1)
  /// and make sure to set state on `didChangeMetrics` instead of
  /// `didChangeAppLifecycleState` :)
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

  /// The inset at the bottom of the screen accounting *only* for math
  /// keyboards.
  ///
  /// This does not yet take the [Window] into account.
  ///
  /// The [KeyboardViewInsets] widget will insert a [MediaQuery] that also
  /// takes into account the window below this widget.
  final double bottomInset;

  @override
  bool updateShouldNotify(KeyboardViewInsetsQuery oldWidget) {
    return bottomInset != oldWidget.bottomInset;
  }
}
