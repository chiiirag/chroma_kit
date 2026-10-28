
# Chroma Kit

A customizable color toolkit for Flutter, with validated color values,
HEX parsing, RGB channels, HSL conversion, and opacity support.

## Features

- Parse shorthand and full-length HEX colors.
- Support RGB and alpha channels.
- Convert between HEX, RGB, Flutter `Color`, and HSL.
- Create colors with validated channel values.
- Adjust opacity and copy individual channels.
- Immutable color values with value equality.
- Designed to support a future customizable color picker UI.

## Installation

Add Chroma Kit to your Flutter project:

```bash
flutter pub add chroma_kit
```

## Usage

```dart
import 'package:chroma_kit/chroma_kit.dart';

void main() {
  final color = ChromaColor.fromHex('#7C4DFF');

  print(color.toHex());
  print(color.toHex(includeAlpha: true));

  print('Red: ${color.red}');
  print('Green: ${color.green}');
  print('Blue: ${color.blue}');

  final hsl = color.hsl;
  print('Hue: ${hsl.hue}');
  print('Saturation: ${hsl.saturation}');
  print('Lightness: ${hsl.lightness}');

  final translucent = color.withOpacity(0.5);
  print(translucent.toHex(includeAlpha: true));
}
```

## Supported HEX formats

| Format | Meaning |
| --- | --- |
| `#RGB` | Shorthand RGB |
| `#ARGB` | Shorthand alpha and RGB |
| `#RRGGBB` | RGB |
| `#AARRGGBB` | Alpha and RGB |

Alpha-first formats follow Flutter's ARGB convention.

## Input validation

Invalid HEX strings throw `FormatException`.
Invalid RGB, alpha, HSL, and opacity values throw `ArgumentError`.

## Development

Run the following commands from the package root:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

## License

MIT
