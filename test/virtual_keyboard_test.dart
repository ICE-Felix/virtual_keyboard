import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_virtual_keyboard/virtual_keyboard.dart';

void main() {
  group('VirtualKeyboardKey', () {
    test('letter keys use their enum name as value', () {
      expect(VirtualKeyboardKey.q.value, 'q');
      expect(VirtualKeyboardKey.m.value, 'm');
    });

    test('digit keys expose their numeric value', () {
      expect(VirtualKeyboardKey.zero.value, '0');
      expect(VirtualKeyboardKey.nine.value, '9');
    });

    test('punctuation and spacebar expose their literal value', () {
      expect(VirtualKeyboardKey.comma.value, ',');
      expect(VirtualKeyboardKey.period.value, '.');
      expect(VirtualKeyboardKey.spacebar.value, ' ');
    });

    test('displayValue prefers an explicit display label', () {
      expect(VirtualKeyboardKey.caps.displayValue, 'CAPS');
      expect(VirtualKeyboardKey.spacebar.displayValue, '␣');
      expect(VirtualKeyboardKey.backspace.displayValue, '⌫');
      expect(VirtualKeyboardKey.enter.displayValue, '⏎');
    });

    test('displayValue falls back to value/name when no label is set', () {
      expect(VirtualKeyboardKey.q.displayValue, 'q');
      expect(VirtualKeyboardKey.zero.displayValue, '0');
    });

    test('text layout has 4 rows and starts with the q..p row', () {
      final rows = VirtualKeyboardKey.textKeyboardKeys;
      expect(rows.length, 4);
      expect(rows.first.length, 10);
      expect(rows.first.first, VirtualKeyboardKey.q);
      expect(rows.first.last, VirtualKeyboardKey.p);
    });

    test('numeric layout has 4 rows', () {
      expect(VirtualKeyboardKey.numericKeyboardKeys.length, 4);
      expect(VirtualKeyboardKey.numericKeyboardKeys.first.first,
          VirtualKeyboardKey.seven);
    });
  });

  group('VirtualKeyboardStyle.backgroundColor', () {
    test('an explicit background color takes precedence over the theme', () {
      final style =
          VirtualKeyboardStyle(backgroundColor: const Color(0xFFABCDEF));
      // No BuildContext needed: the explicit value short-circuits the theme.
      expect(style.backgroundColor, const Color(0xFFABCDEF));
    });

    testWidgets('falls back to the dialog theme background color',
        (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            dialogTheme:
                const DialogThemeData(backgroundColor: Color(0xFF123456)),
          ),
          home: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final style = VirtualKeyboardStyle()..setBuildContext(ctx);
      expect(style.backgroundColor, const Color(0xFF123456));
    });

    testWidgets('falls back to colorScheme.surface when no dialog color is set',
        (tester) async {
      late BuildContext ctx;
      late ThemeData theme;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ctx = context;
              theme = Theme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      final style = VirtualKeyboardStyle()..setBuildContext(ctx);
      expect(style.backgroundColor, theme.colorScheme.surface);
    });
  });
}
