## 0.1.0

- Replaced the deprecated `ThemeData.dialogBackgroundColor` with
  `DialogThemeData.backgroundColor` (falls back to `colorScheme.surface`),
  fixing compatibility with Flutter 3.27+ and earning pub.dev static-analysis
  50/50.
- Resolved all remaining analyzer issues (`use_super_parameters`,
  `library_private_types_in_public_api`, `prefer_const_constructors`,
  `sized_box_for_whitespace`) and removed unused fields from the example.
- Added a real test suite (key model + style background-color resolution);
  the previous test file was empty.

## 0.0.3

- Migrated the input text removing toolbarOptions field

## 0.0.2

- Small fixes

## 0.0.1

- Initial release
