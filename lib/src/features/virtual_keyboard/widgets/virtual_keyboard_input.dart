import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_keyboard/src/features/virtual_keyboard/widgets/virtual_keyboard_focusable.dart';

/// A widget that provides a text input field with a custom virtual keyboard.
///
/// This widget is a wrapper around [TextFormField] that integrates with a
/// specialized virtual keyboard. It provides all the functionality of a
/// standard [TextFormField] while offering a custom input experience.
///
/// The virtual keyboard is automatically displayed when this input field
/// gains focus, providing a consistent and controllable input method
/// across different platforms and devices.
///
/// Usage of this widget is similar to [TextFormField], with the added
/// benefit of the custom virtual keyboard integration.
///
/// This widget is particularly useful in scenarios where you want to ensure
/// a consistent keyboard experience across different devices or when you
/// need to provide a specialized input method.
///
/// Most properties of [TextFormField] are available in this widget, allowing
/// for extensive customization of the input field's appearance and behavior.
///
/// See also:
///
///  * [TextFormField], which is the underlying widget being wrapped.
///  * [VirtualKeyboardFocusable], which provides the virtual keyboard functionality.
class VirtualKeyboardInput extends StatelessWidget {
  /// The controller for the text being edited.
  final TextEditingController inputController;

  /// Controls the scrolling of the input field.
  final ScrollController scrollController;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// Defines the strut style used for the vertical layout of the text.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// The configuration of smart dashes.
  final SmartDashesType? smartDashesType;

  /// The configuration of smart quotes.
  final SmartQuotesType? smartQuotesType;

  /// Whether to show input suggestions.
  final bool enableSuggestions;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether the input field can expand to fill its parent.
  final bool expands;

  /// Whether the text can be changed.
  final bool readOnly;

  /// Configuration of toolbar options.
  final ToolbarOptions? toolbarOptions;

  /// Whether to show cursor.
  final bool? showCursor;

  /// The maximum number of characters (Unicode scalar values) to allow in the text field.
  final int? maxLength;

  /// How to enforce the text length limit.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Called when the user initiates a change to the TextField's value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  final VoidCallback? onEditingComplete;

  /// Called when the user indicates that they are done editing the text in the field.
  final ValueChanged<String>? onSubmitted;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// If null, this widget is considered enabled.
  final bool? enabled;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// The color to use when painting the cursor.
  final Color? cursorColor;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// Configures padding to edges of the container while scrolling.
  final EdgeInsets scrollPadding;

  /// Whether to enable user interface affordances for changing the text selection.
  final bool enableInteractiveSelection;

  /// Optional delegate for building the text selection handles and toolbar.
  final TextSelectionControls? selectionControls;

  /// The physics to be used in the scrollable.
  final ScrollPhysics? scrollPhysics;

  /// List of auto fill hints.
  final Iterable<String>? autofillHints;

  /// Used to enable/disable auto validation and to control its behavior.
  final AutovalidateMode? autovalidateMode;

  /// Restoration ID to save and restore the state of the text field.
  final String? restorationId;

  /// Whether to enable updating the text via IME personalized learning.
  final bool enableIMEPersonalizedLearning;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  /// Builds the widget to show under the input for the current character/word count.
  final InputCounterWidgetBuilder? buildCounter;

  /// The initial value of the text field.
  final String? initialValue;

  /// An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
  final FormFieldValidator<String>? validator;

  /// An optional method to call with the final value when the form is saved via FormState.save.
  final FormFieldSetter<String>? onSaved;

  VirtualKeyboardInput({
    super.key,
    TextEditingController? inputController,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.buildCounter,
    ScrollController? scrollController,
    this.initialValue,
    this.validator,
    this.onSaved,
  })  : inputController = inputController ?? TextEditingController(),
        scrollController = scrollController ?? ScrollController();

  @override
  Widget build(BuildContext context) {
    return VirtualKeyboardFocusable(
      textEditingController: inputController,
      scrollController: scrollController,
      builder: (focusNode) {
        return TextFormField(
          controller: inputController,
          focusNode: focusNode,
          decoration: decoration,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textDirection: textDirection,
          readOnly: readOnly,
          toolbarOptions: toolbarOptions,
          showCursor: showCursor,
          autofocus: autofocus,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          enabled: enabled,
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          keyboardAppearance: keyboardAppearance,
          scrollPadding: scrollPadding,
          enableInteractiveSelection: enableInteractiveSelection,
          selectionControls: selectionControls,
          scrollPhysics: scrollPhysics,
          autofillHints: autofillHints,
          autovalidateMode: autovalidateMode,
          restorationId: restorationId,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          mouseCursor: mouseCursor,
          buildCounter: buildCounter,
          scrollController: scrollController,
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          keyboardType: TextInputType.none,
        );
      },
    );
  }
}
