enum VirtualKeyboardKey {
  q,
  w,
  e,
  r,
  t,
  y,
  u,
  i,
  o,
  p,
  a,
  s,
  d,
  f,
  g,
  h,
  j,
  k,
  l,
  z,
  x,
  c,
  v,
  b,
  n,
  m,
  zero(value: '0'),
  one(value: '1'),
  two(value: '2'),
  three(value: '3'),
  four(value: '4'),
  five(value: '5'),
  six(value: '6'),
  seven(value: '7'),
  eight(value: '8'),
  nine(value: '9'),
  comma(value: ','),
  period(value: '.'),
  shift(value: '⇧'),
  caps(displayValue: 'CAPS'),
  spacebar(
    displayValue: '␣',
    value: ' ',
  ),
  backspace(displayValue: '⌫'),
  enter(displayValue: '⏎'),
  smileyFace(value: ':)'),
  ;

  const VirtualKeyboardKey({
    String? value,
    String? displayValue,
  })  : _value = value,
        _displayValue = displayValue;

  final String? _value;
  final String? _displayValue;

  String get value => _value ?? name;
  String get displayValue => _displayValue ?? _value ?? name;

  static List<List<VirtualKeyboardKey>> get textKeyboardKeys => [
        [q, w, e, r, t, y, u, i, o, p],
        [a, s, d, f, g, h, j, k, l],
        [caps, shift, z, x, c, v, b, n, m, backspace],
        [comma, spacebar, period, smileyFace],
      ];

  static List<List<VirtualKeyboardKey>> get numericKeyboardKeys => [
        [seven, eight, nine],
        [four, five, six],
        [one, two, three],
        [zero],
      ];
}
